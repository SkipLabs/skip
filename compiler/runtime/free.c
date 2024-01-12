#include "runtime.h"

#ifdef SKIP64
#include <stdlib.h>
#include <unistd.h>
#endif

extern SKIP_gc_type_t* epointer_ty;
extern sk_list_t* sk_external_pointers;

/*****************************************************************************/
/* Primitive used to test that external pointers are freed properly. */
/*****************************************************************************/

static SkipInt test_counter = 0;

void SKIP_test_free_external_pointer(SkipInt n) {
  test_counter++;
}

SkipInt SKIP_get_free_test_counter() {
  return test_counter;
}

/*****************************************************************************/
/* Freeing primitive. */
/*****************************************************************************/

void free_intern(char* obj, size_t memsize, size_t leftsize) {
  memsize += leftsize;
  void* addr = obj - leftsize - sizeof(uintptr_t);
  sk_pfree_size(addr, memsize + sizeof(uintptr_t));
}

void sk_free_class(sk_stack_t* st, char* obj) {
  SKIP_gc_type_t* ty = get_gc_type(obj);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;

  if (ty == epointer_ty) {
#ifdef SKIP64
    if (!sk_is_nofile_mode()) {
      fprintf(stderr, "You cannot use external pointers in persistent mode.\n");
      exit(ERROR_INVALID_EXTERNAL_POINTER);
    }
#endif
    char* destructor = sk_get_external_pointer_destructor(obj);
    uint32_t value = sk_get_external_pointer_value(obj);
    uint32_t magic = sk_get_magic_number(obj);
    if (magic != 234566 && magic != 234567) {
#ifdef SKIP64
      fprintf(stderr, "Invalid external pointer found\n");
      exit(ERROR_INVALID_EXTERNAL_POINTER);
#endif
      SKIP_throw_cruntime(ERROR_INVALID_EXTERNAL_POINTER);
    }
    sk_call_external_pointer_descructor(destructor, value);
  } else if ((ty->m_refsHintMask & 1) != 0) {
    size_t size = ty->m_userByteSize / sizeof(void*);
    size_t bitsize = sizeof(void*) * 8;
    size_t slot = 0;
    size_t mask_slot = 0;
    int i;
    while (size > 0) {
      for (i = 0; i < bitsize && i < size; i++) {
        if (ty->m_refMask[mask_slot] & (1 << i)) {
          void* ptr = *(((void**)obj) + (mask_slot * bitsize) + i);
          sk_stack_push(st, ptr, ptr);
        }
      };
      if (size < bitsize) {
        break;
      }
      size -= bitsize;
      mask_slot++;
    }
  }

  free_intern(obj, memsize, leftsize);

  return;
}

void sk_free_array(sk_stack_t* st, char* obj) {
  SKIP_gc_type_t* ty = get_gc_type(obj);

  size_t len = *(uint32_t*)(obj - sizeof(char*) - sizeof(uint32_t));
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  size_t bitsize = sizeof(void*) * 8;

  if ((ty->m_refsHintMask & 1) != 0) {
    char* ohead = obj;
    char* end = obj + memsize;

    while (ohead < end) {
      size_t size = ty->m_userByteSize;
      size_t slot = 0;
      size_t mask_slot = 0;
      while (size > 0) {
        int i;
        for (i = 0; i < bitsize && size > 0; i++) {
          if (ty->m_refMask[mask_slot] & (1 << i)) {
            void* ptr = *((void**)ohead);
            sk_stack_push(st, ptr, ptr);
          }
          ohead += sizeof(void*);
          size -= sizeof(void*);
        };
        mask_slot++;
      }
    }
  }

  free_intern(obj, memsize, leftsize);

  return;
}

void sk_free_obj(sk_stack_t* st, char* obj) {
  if (obj == NULL) {
    return;
  }

  // Check if we are dealing with a string
  if (SKIP_is_string(obj)) {
    size_t memsize = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
    size_t leftsize = 2 * sizeof(uint32_t);
    free_intern(obj, memsize, leftsize);
    return;
  }

  SKIP_gc_type_t* ty = get_gc_type(obj);

  switch (ty->m_kind) {
    case 0:
      sk_free_class(st, obj);
      break;
    case 1:
      sk_free_array(st, obj);
      break;
    default:
      // NOT SUPPORTED
      SKIP_exit(-1);
  }

  return;
}

void sk_free_root(char* obj) {
  sk_stack_t st_holder;
  sk_stack_t* st = &st_holder;

  sk_stack_init(st, STACK_INIT_CAPACITY);
  sk_stack_push(st, (void**)obj, NULL);

  while (st->head > 0) {
    sk_value_t delayed = sk_stack_pop(st);
    void* toFree = delayed.value;

    if (sk_is_static(toFree)) {
      continue;
    }

    uintptr_t count = sk_decr_ref_count(toFree);
    if (count == 0) {
      sk_free_obj(st, toFree);
    }
  }

  sk_stack_free(st);
#ifdef CTX_TABLE
  sk_clean_ctx_table();
#endif
}

void sk_free_external_pointers() {
  sk_check_has_lock();

  sk_stack_t st_holder;
  sk_stack_t* st = &st_holder;

  sk_stack_init(st, STACK_INIT_CAPACITY);
  sk_list_t* cursor = sk_external_pointers;

  while (cursor != NULL) {
    sk_list_t* l = cursor;
    uintptr_t count = sk_decr_ref_count(l->head);
    if (count == 0) {
      sk_free_obj(st, l->head);
    }
    cursor = l->tail;
    sk_free_size(l, sizeof(sk_list_t));
  }

  sk_external_pointers = NULL;

  while (st->head > 0) {
    sk_value_t delayed = sk_stack_pop(st);
    void* toFree = delayed.value;

    if (sk_is_static(toFree)) {
      continue;
    }

    uintptr_t count = sk_decr_ref_count(toFree);
    if (count == 0) {
      sk_free_obj(st, toFree);
    }
  }

  sk_stack_free(st);
}
