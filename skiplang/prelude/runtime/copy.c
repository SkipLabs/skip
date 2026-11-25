#include "runtime.h"

/*****************************************************************************/
/* Copying primitives. */
/*****************************************************************************/

extern size_t total_palloc_size;

void sk_stack_grow(sk_stack_t* st);

// sk_stack_push / sk_stack_pop (stack.c), inlined: the copy loop does one
// push and one pop per object and per child.
static inline void copy_push(sk_stack_t* st, void** value, void** slot) {
  st->values[st->head].value = value;
  st->values[st->head].slot = slot;
  st->head++;
  if (st->head >= st->capacity) {
    sk_stack_grow(st);
  }
}

static inline sk_value_t copy_pop(sk_stack_t* st) {
  st->head--;
  return st->values[st->head];
}

static char* shallow_copy(char* obj, size_t memsize, size_t leftsize,
                          sk_cell_t* large_page) {
  if (large_page != NULL) {
    sk_obstack_attach_page(large_page->key, NULL);
    return obj;
  }

  memsize += leftsize;
  size_t alloc_size = memsize;
  char* mem = SKIP_Obstack_alloc(alloc_size);
  memcpy(mem, obj - leftsize, memsize);
  mem = mem + leftsize;
  return mem;
}

// Only children in [low, high), the address range of the pages being copied
// out, are pushed: anything else is older data, which the copy keeps as is
// (shallow_copy already wrote its address).
static char* SKIP_copy_obj(sk_stack_t* st, char* obj, sk_cell_t* large_page,
                           char* low, char* high) {
  SKIP_gc_type_t* ty = get_gc_type(obj);

  size_t len = skip_object_len(ty, obj);
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = uninterned_metadata_byte_size(ty);
  char* result = shallow_copy(obj, memsize, leftsize, large_page);

  if ((ty->m_refsHintMask & 1) != 0) {
    // The reference slots of each element: the set bits of its mask, one bit
    // per word of the element, 64 to a mask word.
    size_t words = (size_t)ty->m_userByteSize / sizeof(void*);
    void** ohead = (void**)obj;
    void** rhead = (void**)result;
    size_t e;
    for (e = 0; e < len; e++, ohead += words, rhead += words) {
      size_t w;
      for (w = 0; w * 64 < words; w++) {
        uint64_t bits = (uint64_t)ty->m_refMask[w];
        size_t rest = words - w * 64;
        if (rest < 64) bits &= ((uint64_t)1 << rest) - 1;
        while (bits != 0) {
          size_t k = w * 64 + (size_t)__builtin_ctzll(bits);
          bits &= bits - 1;
          char* child = (char*)ohead[k];
          if (child >= low && child < high) {
            copy_push(st, ohead + k, rhead + k);
          }
        }
      }
    }
  }

  return result;
}

static char* SKIP_copy_string(char* obj, sk_cell_t* large_page) {
  size_t memsize = get_sk_string(obj)->size + 1;
  char* result = shallow_copy(obj, memsize, sk_string_header_size, large_page);
  return result;
}

void* SKIP_copy_with_pages(void* obj, size_t nbr_pages, sk_cell_t* pages) {
  if (obj == NULL) {
    return NULL;
  }

  sk_stack_t st_holder;
  sk_stack_t* st = &st_holder;
  sk_stack_t restore_holder;
  sk_stack_t* restore = &restore_holder;
  sk_stack3_t st3_holder;
  sk_stack3_t* st3 = &st3_holder;

  sk_stack_init(st, STACK_INIT_CAPACITY);
  sk_stack_init(restore, STACK_INIT_CAPACITY);
  sk_stack3_init(st3, STACK_INIT_CAPACITY);

  void* result = obj;
  char* low = nbr_pages == 0 ? NULL : (char*)pages[0].key;
  char* high = nbr_pages == 0 ? NULL : (char*)pages[nbr_pages - 1].value;
  copy_push(st, &obj, &result);
  sk_cell_t* large_page = NULL;
  size_t last_idx = (size_t)-1;

  while (st->head > 0) {
    sk_value_t delayed = copy_pop(st);
    void* toCopy = *delayed.value;

    // Consecutive objects are usually on the same page: try the last one hit
    // before searching.
    size_t obstack_idx = last_idx;
    if (last_idx >= nbr_pages || (char*)toCopy < (char*)pages[last_idx].key ||
        (char*)toCopy >= (char*)pages[last_idx].value) {
      obstack_idx = sk_get_obstack_idx(toCopy, pages, nbr_pages);
      if (obstack_idx >= nbr_pages) {
        continue;
      }
      last_idx = obstack_idx;
    }

    large_page = NULL;

    if (sk_is_large_page(pages[obstack_idx].key)) {
      large_page = &pages[obstack_idx];
      sk_obstack_unlink_page(large_page, pages, nbr_pages);
      pages[obstack_idx].value = (uint64_t)pages[obstack_idx].key;
    }

    void* copied_ptr;

    if (SKIP_is_string(toCopy)) {
      sk_string_t* str = get_sk_string(toCopy);
      // mark already-copied strings by setting size to -1
      if (str->size == (uint32_t)-1) {
        void* copied_ptr = *(void**)toCopy;
        *delayed.slot = copied_ptr;
        continue;
      }
      void* copied_ptr = SKIP_copy_string(toCopy, large_page);
      sk_stack3_push(st3, (void**)toCopy, *(void**)toCopy,
                     (void*)(uintptr_t)(str->size));
      str->size = (uint32_t)-1;
      *(void**)toCopy = copied_ptr;
      *delayed.slot = copied_ptr;
      continue;
    }

    void*** addr_vtable_ptr =
        &(container_of(toCopy, sk_class_inst_t, data)->vtable);
    void** vtable_ptr = *addr_vtable_ptr;
    // mark already-copied objects by replacing their vtable pointer with a
    // forwarding pointer to the copied object, with the lsb set to
    // distinguish it from vtable pointers
    if (((uintptr_t)vtable_ptr & 1) == 0) {
      copied_ptr = SKIP_copy_obj(st, toCopy, large_page, low, high);
      copy_push(restore, (void**)addr_vtable_ptr, vtable_ptr);
      *addr_vtable_ptr = (void*)((uintptr_t)copied_ptr | 1);
    } else {
      copied_ptr = (void*)((uintptr_t)vtable_ptr & ~1);
    }

    *delayed.slot = copied_ptr;
  }

  while (restore->head > 0) {
    sk_value_t cell = copy_pop(restore);
    *cell.value = cell.slot;
  }

  while (st3->head > 0) {
    sk_value3_t cell = sk_stack3_pop(st3);
    void** toClean = cell.value1;
    *toClean = cell.value2;
    {
      sk_string_t* str = get_sk_string(cell.value1);
      str->size = (uint32_t)(uintptr_t)cell.value3;
    }
  }

  sk_stack_free(st);
  sk_stack_free(restore);
  sk_stack3_free(st3);

  return result;
}
