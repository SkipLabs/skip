#include "runtime.h"

/*****************************************************************************/
/* Freeing primitive. */
/*****************************************************************************/

void free_intern(char* obj, size_t memsize, size_t leftsize) {
  memsize += leftsize;
  sk_sk_free_size(obj-leftsize-sizeof(uintptr_t), memsize+sizeof(uintptr_t));
}

void SKIP_free_class(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;

  if((ty->m_refsHintMask & 1) != 0) {
    size_t size = ty->m_userByteSize / sizeof(void*);
    size_t bitsize = sizeof(void*) * 8;
    size_t slot = 0;
    size_t mask_slot = 0;
    int i;
    while(size > 0) {
      for(i = 0; i < bitsize && i < size; i++) {
        if(ty->m_refMask[mask_slot] & (1 << i)) {
          void* ptr = *(((void**)obj)+(mask_slot * bitsize)+i);
          SKIP_stack_push(st, ptr, ptr);
        }
      };
      if(size < bitsize) {
        break;
      }
      size -= bitsize;
      mask_slot++;
    }
  }

  free_intern(obj, memsize, leftsize);

  return;
}

void SKIP_free_array(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t len = *(uint32_t*)(obj-sizeof(char*)-sizeof(uint32_t));
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  size_t bitsize = sizeof(void*) * 8;

  if((ty->m_refsHintMask & 1) != 0) {
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
            void* ptr = *((void**)ohead);
            SKIP_stack_push(st, ptr, ptr);
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

void SKIP_free_obj(stack_t* st, char* obj) {

  if(obj == NULL) {
    return;
  }

  // Check if we are dealing with a string
  if(SKIP_is_string(obj)) {
    size_t memsize = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
    size_t leftsize = 2 * sizeof(uint32_t);
    free_intern(obj, memsize, leftsize);
    return;
  }

  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  switch(ty->m_kind) {
  case 0:
    SKIP_free_class(st, obj);
    break;
  case 1:
    SKIP_free_array(st, obj);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }

  return;
}

void SKIP_free(char* obj) {
  stack_t st_holder;
  stack_t* st = &st_holder;

  SKIP_stack_init(st, 1024);
  SKIP_stack_push(st, (void**)obj, NULL);

  while(st->head > 0) {
    value_t delayed = SKIP_stack_pop(st);
    void* toFree = delayed.value;
    if(sk_is_static(toFree)) {
      continue;
    }
    uintptr_t count = sk_decr_ref_count(toFree);
    if(count == 0) {
      SKIP_free_obj(st, toFree);
    }
  }

  SKIP_stack_free(st);
}
