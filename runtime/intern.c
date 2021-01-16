#include "runtime.h"

/*****************************************************************************/
/* Interning primitives. */
/*****************************************************************************/

sk_htbl_t itable_holder;
sk_htbl_t *itable = NULL;

static void add_itable(char* mem) {
  if(itable == NULL) {
    itable = &itable_holder;
    sk_htbl_init(itable, 10);
  }
  sk_htbl_add(itable, mem, (void*)1);
}

sk_cell_t* find_itable(char* mem) {
  if(itable == NULL) {
    itable = &itable_holder;
    sk_htbl_init(itable, 10);
  }
  return sk_htbl_find(itable, mem);
}

static char* shallow_intern(char* obj, size_t memsize, size_t leftsize) {
  memsize += leftsize;
  size_t alloc_size = memsize;
  char* mem = malloc(alloc_size);
  memcpy(mem, obj - leftsize, memsize);
  mem = mem + leftsize;
  add_itable(mem);
  return mem;
}

void free_intern(char* obj, size_t memsize, size_t leftsize) {
  sk_cell_t* cell = find_itable(obj);
  if(cell == NULL || cell->value == NULL) {
    return;
  }
  cell->value = (void*)(((uintptr_t)cell->value)-1);
  memsize += leftsize;

  if(cell->value == NULL) {
    itable->rsize--;
    free_size(obj-leftsize, memsize);
  }
}

char* SKIP_intern_class(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  void** result = (void**)shallow_intern(obj, memsize, leftsize);

  if((ty->m_refsHintMask & 1) != 0) {
    size_t size = ty->m_userByteSize / sizeof(void*);
    size_t bitsize = sizeof(void*) * 8;
    size_t slot = 0;
    size_t mask_slot = 0;
    int i;
    while(size > 0) {
      for(i = 0; i < bitsize && i < size; i++) {
        if(ty->m_refMask[mask_slot] & (1 << i)) {
          void** ptr = ((void**)obj)+(mask_slot * bitsize)+i;
          void** slot = result+(mask_slot * bitsize)+i;
          SKIP_stack_push(st, ptr, slot);
        }
      };
      if(size < bitsize) {
        break;
      }
      size -= bitsize;
      mask_slot++;
    }
  }

  return (char*)result;
}

char* SKIP_intern_array(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t len = *(uint32_t*)(obj-sizeof(char*)-sizeof(uint32_t));
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  void** result = (void**)shallow_intern(obj, memsize, leftsize);
  size_t bitsize = sizeof(void*) * 8;

  if((ty->m_refsHintMask & 1) != 0) {
    char* rhead = (char*)result;
    char* ohead = obj;
    char* end = obj + memsize;

    while(ohead < end) {
      size_t size = ty->m_userByteSize;
      size_t slot = 0;
      size_t mask_slot = 0;
      while(size > 0) {
        int i;
        for(i = 0; i < bitsize && size > 0; i++) {
          if(ty->m_refMask[mask_slot] & (1 << i)) {
            void** ptr = (void**)ohead;
            void** slot = (void**)rhead;
            SKIP_stack_push(st, ptr, slot);
          }
          ohead += sizeof(void*);
          rhead += sizeof(void*);
          size -= sizeof(void*);
        };
        mask_slot++;
      }
    }
  }

  return (char*)result;
}

char* SKIP_intern_string(char* obj) {
  size_t len = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
  char* result = shallow_intern(obj, len, 2 * sizeof(uint32_t));
  return result;
}

uint32_t SKIP_is_string(char* obj) {
  return *(((uint32_t*)obj)-1) & 0x80000000;
}

char* SKIP_intern_obj(stack_t* st, sk_cell_t* pages, size_t page_size, char* obj) {

  if(obj == NULL) {
    return NULL;
  }

  int in_obstack = is_in_obstack(obj, pages, page_size);

  if(!in_obstack) {

    sk_cell_t* icell = find_itable(obj);

    if(icell != NULL && icell->value != NULL) {
      icell->value = (void*)(((uintptr_t)icell->value) + 1);
      return obj;
    }

    return obj;
  }

  char* result;

  // Check if we are dealing with a string
  if(SKIP_is_string(obj)) {
    result = SKIP_intern_string(obj);
    return result;
  }

  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  switch(ty->m_kind) {
  case 0:
    result = SKIP_intern_class(st, obj);
    break;
  case 1:
    result = SKIP_intern_array(st, obj);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }

  return (char*)result;
}

char* SKIP_intern(char* obj) {
  stack_t st_holder;
  stack_t* st = &st_holder;
  size_t page_size = nbr_pages();
  sk_cell_t* pages = get_pages(page_size);

  SKIP_stack_init(st, 1024);

  char* result = SKIP_intern_obj(st, pages, page_size, obj);

  while(st->head > 0) {
    value_t delayed = SKIP_stack_pop(st);
    void* toCopy = *delayed.value;
    *delayed.slot = SKIP_intern_obj(st, pages, page_size, toCopy);
  }

  free_size(pages, sizeof(sk_cell_t*) * page_size);
  SKIP_stack_free(st);

  return result;
}
