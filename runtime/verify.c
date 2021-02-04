#include "runtime.h"

/*****************************************************************************/
/* Verifying a property on an object */
/*****************************************************************************/
void sk_show_ref_count(void* obj) {
  uintptr_t* count = obj;
  if(SKIP_is_string(obj)) {
    #ifdef SKIP64
    count -= 2;
    #endif
    #ifdef SKIP32
    count -= 3;
    #endif
  }
  else {
    SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

    switch(ty->m_kind) {
    case 0:
      count -= 2;
      break;
    case 1:
      count -= 3;
      break;
    default:
      SKIP_internalExit();
    }
  }
/*
  if(*count > 1000) {
    printf("FOUND SUSPICIOUS COUNT %ld %p\n", *count, obj);
  }
*/
}

void sk_verify_class(stack_t* st, char* obj) {
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
          void** ptr = ((void**)obj)+(mask_slot * bitsize)+i;
          if(*ptr != NULL) {
            sk_stack_push(st, ptr, (void*)1);
          }
        }
      };
      if(size < bitsize) {
        break;
      }
      size -= bitsize;
      mask_slot++;
    }
  }
}

void sk_verify_array(stack_t* st, char* obj) {
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
            void** ptr = (void**)ohead;
            if(*ptr != NULL) {
              sk_stack_push(st, ptr, (void*)1);
            }
          }
          ohead += sizeof(void*);
          size -= sizeof(void*);
        };
        mask_slot++;
      }
    }
  }
}

void sk_verify_string(char* obj) {
  size_t len = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
}

void sk_verify_obj(stack_t* st, char* obj) {
  char* result;

  // Check if we are dealing with a string
  if(SKIP_is_string(obj)) {
    sk_verify_string(obj);
    return;
  }

  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  switch(ty->m_kind) {
  case 0:
    sk_verify_class(st, obj);
    break;
  case 1:
    sk_verify_array(st, obj);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }
}

void sk_verify_shared(void* obj) {
  return;
  if(obj == NULL) {
    return;
  }

  stack_t st_holder;
  stack_t* st = &st_holder;

  sk_stack_init(st, 1024);

  void* result = obj;
  sk_stack_push(st, &obj, &result);

//  printf("----------------------- %p\n", obj);
  while(st->head > 0) {
    value_t delayed = sk_stack_pop(st);
    void* toCopy = *delayed.value;
    int is_const = sk_is_const(toCopy);
    if(!sk_is_static(toCopy) && !is_const) {
      sk_show_ref_count(toCopy);
    }
    sk_verify_obj(st, toCopy);
  }

  sk_stack_free(st);
}
