#include "runtime.h"

/*****************************************************************************/
/* Native equality implementation.
 * => May return true when two objects are equal.
 * => Always returns false when two objects are not equal.
 *
 * This function cannot be used to replace equality in general. Because it may
 * return false when two objects are actually equal.
 *
 * When does this happen?
 * Consider the following object:
 * class MyObj(Int16, String)
 *
 * Now let's imagine that the layout is done in such a way that the Int16 is
 * "padded" with 16 bits. These 16 bits may contain random garbage (this is
 * only true in embedded32 mode, in normal and embedded64 mode that space is
 * actually filled with zeros, but still). If we want our algorithm to work,
 * we need to take into account the fact that because of padding, two objects
 * can be considered different, when they are in fact equal.
 *
 * Because this function is used to decide if we need to invalide a cache or
 * not: this ends not being a problem. We might recompute a little bit too
 * much on the rare occasions where this padding problem occurs ... which is
 * ok!
 */
/*****************************************************************************/

SkipInt SKIP_native_eq_class(sk_stack_t* st, char* obj1, char* obj2) {
  if(obj1 == obj2) return 0;

  SKIP_gc_type_t* ty1 = *(*(((SKIP_gc_type_t***)obj1)-1)+1);
  SKIP_gc_type_t* ty2 = *(*(((SKIP_gc_type_t***)obj2)-1)+1);

  if(ty1 != ty2) {
    return 1;
  }

  if((ty1->m_refsHintMask & 1) == 0) {
    return memcmp(obj1, obj2, ty1->m_userByteSize);
  }

  size_t size = ty1->m_userByteSize / sizeof(void*);
  size_t bitsize = sizeof(void*) * 8;
  size_t slot = 0;
  size_t mask_slot = 0;
  int i;
  while(size > 0) {
    for(i = 0; i < bitsize && i < size; i++) {
      void* ptr1 = *(((void**)obj1)+(mask_slot * bitsize)+i);
      void* ptr2 = *(((void**)obj2)+(mask_slot * bitsize)+i);

      if(ty1->m_refMask[mask_slot] & (1 << i) && ptr1 != ptr2) {
        sk_stack_push(st, ptr1, ptr2);
      }
      else {
        if(ptr1 != ptr2) {
          return 1;
        }
      }
    };
    if(size < bitsize) {
      break;
    }
    size -= bitsize;
    mask_slot++;
  }

  return 0;
}

SkipInt SKIP_native_eq_array(sk_stack_t* st, char* obj1, char* obj2) {
  SKIP_gc_type_t* ty1 = *(*(((SKIP_gc_type_t***)obj1)-1)+1);
  SKIP_gc_type_t* ty2 = *(*(((SKIP_gc_type_t***)obj2)-1)+1);

  if(ty1 != ty2) {
    return 1;
  }

  size_t len1 = *(uint32_t*)(obj1-sizeof(char*)-sizeof(uint32_t));
  size_t len2 = *(uint32_t*)(obj2-sizeof(char*)-sizeof(uint32_t));

  if(len1 != len2) {
    return 1;
  }

  size_t memsize = ty1->m_userByteSize * len1;

  size_t bitsize = sizeof(void*) * 8;

  if((ty1->m_refsHintMask & 1) == 0) {
    return memcmp(obj1, obj2, memsize);
  }

  char* ohead1 = obj1;
  char* ohead2 = obj2;
  char* end = obj1 + memsize;

  while(ohead1 < end) {
    size_t size = ty1->m_userByteSize;
    size_t slot = 0;
    size_t mask_slot = 0;
    while(size > 0) {
      int i;
      for(i = 0; i < bitsize && size > 0; i++) {
        void* ptr1 = *((void**)ohead1);
        void* ptr2 = *((void**)ohead2);

        if(ty1->m_refMask[mask_slot] & (1 << i) && ptr1 != ptr2) {
          sk_stack_push(st, ptr1, ptr2);
        }
        else {
          if(ptr1 != ptr2) {
            return 1;
          }
        }

        ohead1 += sizeof(void*);
        ohead2 += sizeof(void*);
        size -= sizeof(void*);
      };
      mask_slot++;
    }
  }

  return 0;
}

SkipInt SKIP_native_eq_helper(sk_stack_t* st, char* obj1, char* obj2) {
  if(obj1 == obj2) {
    return 0;
  }

  if(obj1 == NULL || obj2 == NULL) {
    return 1;
  }

  int isString1 = SKIP_is_string(obj1);
  int isString2 = SKIP_is_string(obj2);

  if(isString1 && isString2) {
    return SKIP_String_cmp((unsigned char*)obj1, (unsigned char*)obj2);
  }

  if(isString1 || isString2) {
    return 1;
  }

  SKIP_gc_type_t* ty1 = *(*(((SKIP_gc_type_t***)obj1)-1)+1);
  SKIP_gc_type_t* ty2 = *(*(((SKIP_gc_type_t***)obj2)-1)+1);

  if(ty1 != ty2) {
    return 1;
  }

  switch(ty1->m_kind) {
  case 0:
    return SKIP_native_eq_class(st, obj1, obj2);
    break;
  case 1:
    return SKIP_native_eq_array(st, obj1, obj2);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }

  return 0;
}

SkipInt SKIP_isEq(char* obj1, char* obj2) {
  sk_stack_t st_holder;
  sk_stack_t* st = &st_holder;
  sk_stack_init(st, STACK_INIT_CAPACITY);
  SkipInt cmp = SKIP_native_eq_helper(st, obj1, obj2);
  if(cmp != 0) {
    sk_stack_free(st);
    return !!cmp;
  }
  while(st->head > 0) {
    sk_value_t delayed = sk_stack_pop(st);
    void* obj1 = delayed.value;
    void* obj2 = delayed.slot;
    SkipInt cmp = SKIP_native_eq_helper(st, obj1, obj2);
    if(cmp != 0) {
      sk_stack_free(st);
      return !!cmp;
    }
  }
  sk_stack_free(st);
  return 0;
}

uint32_t SKIP_unsafe_compare_sets(char* obj1, char* obj2) {
  return (obj1 == obj2);
}
