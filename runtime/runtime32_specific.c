#define NULL ((void*)0)

typedef long long uint64_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;
typedef uint64_t SkipInt;

void SKIP_add_free(void* ptr, uint32_t size);
void* SKIP_get_free(uint32_t size);
void __cxa_throw(void*, void*, void*);
void print_int(uint64_t);

extern unsigned char __heap_base;

unsigned char* bump_pointer = &__heap_base;

void* malloc(size_t size) {
  size = (size + (sizeof(long) - 1)) & ~(sizeof(long)-1);
  void* res = SKIP_get_free(size);
  if(res != NULL) {
    return res;
  }
  void* result = bump_pointer;
  bump_pointer += size;
  return result;
}

void free_size(uint32_t* ptr, size_t size) {
  size = (size + (sizeof(long) - 1)) & ~(sizeof(long)-1);
  SKIP_add_free(ptr, size);
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


void* exn = NULL;

void SKIP_throw(char* exc) {
  exn = exc;
  __cxa_throw(0, 0, 0);
}

void* SKIP_getExn() {
  return exn;
}
