#include "runtime.h"

/*****************************************************************************/
/* Copying primitives. */
/*****************************************************************************/

extern size_t total_palloc_size;

static char* shallow_copy(char* obj, size_t memsize, size_t leftsize) {
  memsize += leftsize;
  size_t alloc_size = memsize;
  char* mem = SKIP_Obstack_alloc(alloc_size);
  memcpy(mem, obj - leftsize, memsize);
  mem = mem + leftsize;
  return mem;
}

static char* SKIP_copy_class(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  void** result = (void**)shallow_copy(obj, memsize, leftsize);

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
          if(*ptr != NULL) {
            sk_stack_push(st, ptr, slot);
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

  return (char*)result;
}

static char* SKIP_copy_array(stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t len = *(uint32_t*)(obj-sizeof(char*)-sizeof(uint32_t));
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  void** result = (void**)shallow_copy(obj, memsize, leftsize);
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
            if(*ptr != NULL) {
              sk_stack_push(st, ptr, slot);
            }
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

static char* SKIP_copy_string(char* obj) {
  size_t len = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
  char* result = shallow_copy(obj, len, 2 * sizeof(uint32_t));
  return result;
}

static char* SKIP_copy_obj(stack_t* st, char* obj) {

  char* result;

  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  switch(ty->m_kind) {
  case 0:
    result = SKIP_copy_class(st, obj);
    break;
  case 1:
    result = SKIP_copy_array(st, obj);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }

  return (char*)result;
}

void* SKIP_copy_with_pages(void* obj, size_t page_size, sk_cell_t* pages) {
  if(obj == NULL) {
    return NULL;
  }

  stack_t st_holder;
  stack_t* st = &st_holder;
  stack3_t st3_holder;
  stack3_t* st3 = &st3_holder;

  sk_stack_init(st, 1024);
  sk_stack3_init(st3, 1024);

  void* result = obj;
  sk_stack_push(st, &obj, &result);

  while(st->head > 0) {
    value_t delayed = sk_stack_pop(st);
    void* toCopy = *delayed.value;

    int in_obstack = is_in_obstack(toCopy, pages, page_size);

    if(!in_obstack) {
      continue;
    }

    void* copied_ptr;

    if(SKIP_is_string(toCopy)) {
      sk_string_t* str = (sk_string_t*)((char*)toCopy-sizeof(uint32_t)*2);
      if(str->size != -1 && str->size < sizeof(void*)) {
        void* copied_ptr = SKIP_copy_string(toCopy);
        *delayed.slot = copied_ptr;
        continue;
      }

      if(str->size == (uint32_t)-1) {
        void* copied_ptr = *(void**)toCopy;
        *delayed.slot = copied_ptr;
        continue;
      }
      void* copied_ptr = SKIP_copy_string(toCopy);
      sk_stack3_push(st3, (void**)toCopy, *(void**)toCopy, (void*)(uintptr_t)(str->size));
      str->size = (uint32_t)-1;
      *(void**)toCopy = copied_ptr;
      *delayed.slot = copied_ptr;
      continue;
    }

    if(((uintptr_t)*((void**)toCopy-1) & 1) == 0) {
      copied_ptr = SKIP_copy_obj(st, toCopy);
      sk_stack3_push(st3, ((void**)toCopy-1), *((void**)toCopy-1), NULL);
      *((void**)toCopy-1) = (void*)((uintptr_t)copied_ptr | 1);
    }
    else {
      copied_ptr = (void*)((uintptr_t)*((void**)toCopy-1) & ~1);
    }

    *delayed.slot = copied_ptr;
  }

  while(st3->head > 0) {
    value3_t cell = sk_stack3_pop(st3);
    void** toClean = cell.value1;
    *toClean = cell.value2;
    if(cell.value3 != NULL) {
      sk_string_t* str = (sk_string_t*)((char*)cell.value1-sizeof(uint32_t)*2);
      str->size = (uint32_t)(uintptr_t)cell.value3;
    }
  }

  sk_free_size(pages, sizeof(sk_cell_t) * page_size);
  sk_stack_free(st);
  sk_stack3_free(st3);

  return result;
}
