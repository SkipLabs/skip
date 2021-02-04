#include "runtime.h"

/*****************************************************************************/
/* Computes the size of an object we wish to move. */
/*****************************************************************************/

size_t shallow_size(size_t memsize, size_t leftsize) {
  memsize += leftsize;
  return memsize;
}

size_t SKIP_size_class(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  size_t result = shallow_size(memsize, leftsize);

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
          sk_stack_push(st, ptr, (void*)1);
        }
      };
      if(size < bitsize) {
        break;
      }
      size -= bitsize;
      mask_slot++;
    }
  }

  return result;
}

size_t SKIP_size_array(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t len = *(uint32_t*)(obj-sizeof(char*)-sizeof(uint32_t));
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  size_t result = shallow_size(memsize, leftsize);
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
            sk_stack_push(st, ptr, (void*)1);
          }
          ohead += sizeof(void*);
          size -= sizeof(void*);
        };
        mask_slot++;
      }
    }
  }

  return result;
}

size_t SKIP_size_string(char* obj) {
  size_t len = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
  size_t result = shallow_size(len, 2 * sizeof(uint32_t));
  return result;
}

size_t SKIP_size_obj(stack_t* st, sk_cell_t* pages, size_t page_size, char* obj) {

  if(obj == NULL) {
    return 0;
  }

  size_t result;

  // Check if we are dealing with a string
  if(SKIP_is_string(obj)) {
    result = SKIP_size_string(obj);
    return result;
  }

  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  switch(ty->m_kind) {
  case 0:
    result = SKIP_size_class(st, obj);
    break;
  case 1:
    result = SKIP_size_array(st, obj);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }

  return result;
}

size_t SKIP_size(void* obj) {
  stack_t st_holder;
  stack_t* st = &st_holder;
  size_t page_size = nbr_pages();
  sk_cell_t* pages = get_pages(page_size);

  sk_stack_init(st, 1024);
  size_t result = 0;
  sk_stack_push(st, &obj, (void*)1);

  while(st->head > 0) {
    value_t delayed = sk_stack_pop(st);
    void* toCopy = *delayed.value;
    int in_obstack = is_in_obstack(toCopy, pages, page_size);

    if(!in_obstack) {
      continue;
    }

    result += SKIP_size_obj(st, pages, page_size, toCopy);
  }

  sk_free_size(pages, sizeof(sk_cell_t*) * page_size);
  sk_stack_free(st);

  return result;
}


/*****************************************************************************/
/* Arena objects. */
/*****************************************************************************/
