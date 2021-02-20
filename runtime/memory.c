#include "runtime.h"

#ifdef SKIP64

#ifdef MEMORY_CHECK
char sk_init_over = 0;
sk_htbl_t sk_malloc_table_holder;
sk_htbl_t* sk_malloc_table = &sk_malloc_table_holder;
#endif

void* malloc(size_t);
void free(void*);
#endif

/*****************************************************************************/
/* Common primitives . */
/*****************************************************************************/

#ifdef MEMORY_CHECK
void free_size(void* ptr, size_t size) {
  free(ptr);
}
#endif

void sk_memory_check_init() {
  #ifdef MEMORY_CHECK
  sk_htbl_init(sk_malloc_table, 20);
  #endif
}

void sk_memory_check_init_over() {
  #ifdef MEMORY_CHECK
  sk_init_over = 1;
  #endif
}

/*****************************************************************************/
/* 32bits Memory allocation. */
/*****************************************************************************/

#ifdef SKIP32
extern unsigned char __heap_base;

unsigned char* bump_pointer = &__heap_base;

void* SKIP_get_free(size_t);
void SKIP_add_free(void*, size_t);

void* sk_malloc(size_t size) {
  size = (size + (sizeof(void*) - 1)) & ~(sizeof(void*)-1);
  void* res = SKIP_get_free(size);
  if(res != NULL) {
    return res;
  }
  void* result = bump_pointer;
  bump_pointer += size;
  return result;
}

void sk_free_size(void* ptr, size_t size) {
  size = (size + (sizeof(void*) - 1)) & ~(sizeof(void*)-1);
  SKIP_add_free(ptr, size);
}

void* sk_alloc(size_t size) {
  return sk_malloc(size);
}

void sk_sk_free_size(void* ptr, size_t size) {
  sk_free_size(ptr, size);
}

void SKIP_memory_init() {
}

void SKIP_load_context() {
}

int memcmp(const void * ptr1, const void * ptr2, size_t num) {
  unsigned char* str1 = (unsigned char*)ptr1;
  unsigned char* str2 = (unsigned char*)ptr2;
  unsigned char* end1 = str1 + num;
  unsigned char* end2 = str2 + num;

  while(1) {
    if(str1 == end1 && str2 == end2) {
      return 0;
    }
    if(str1 == end1) {
      return -1;
    }
    if(str2 == end2) {
      return 1;
    }
    unsigned char c1 = *str1;
    unsigned char c2 = *str2;
    SkipInt diff = c1 - c2;
    if(diff != 0) return diff;
    str1++;
    str2++;
  }
}

#endif


/*****************************************************************************/
/* 64 bits Memory allocation. */
/*****************************************************************************/

#ifdef SKIP64
size_t sk_pow2_size(size_t);

void* sk_malloc(size_t size) {
  void* result = malloc(size);
  if(result == NULL) {
    fprintf(stderr, "Out of memory\n");
    SKIP_throw(NULL);
  }
  #ifdef MEMORY_CHECK
  static size_t alloc_count = 0;
  if(sk_init_over) {
    size_t capacity = 1 << sk_malloc_table->bitcapacity;

    if(sk_malloc_table->size >= capacity/2) {
      fprintf(stderr, "MEMORY CHECK TABLE SIZE TO SMALL\n");
      exit(88);
    }

    sk_htbl_add(sk_malloc_table, result, (uint64_t)alloc_count);
    alloc_count++;
  }
  #endif
  return result;
}

void sk_free_size(void* ptr, size_t size) {
  #ifdef MEMORY_CHECK
  sk_htbl_remove(sk_malloc_table, ptr);
  #endif
  free(ptr);
}
#endif

void SKIP_check_memory() {
  #ifdef MEMORY_CHECK
  size_t capacity = 1 << sk_malloc_table->bitcapacity;
  size_t i;

  for(i = 0; i < capacity; i++) {
    if(sk_malloc_table->data[i].key != 0) {
      if(sk_malloc_table->data[i].value != TOMB) {
        fprintf(stderr, "FOUND A LEAK! %p %ld\n",
                sk_malloc_table->data[i].key,
                (size_t)sk_malloc_table->data[i].value);
      }
      sk_malloc_table->data[i].key = 0;
    }
  }
  #endif
}
