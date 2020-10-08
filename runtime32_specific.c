#define NULL ((void*)0)

typedef long long uint64_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;
typedef uint64_t SkipInt;

void SKIP_add_free(void* ptr, uint32_t size);
void* SKIP_get_free(uint32_t size);

extern unsigned char __heap_base;

unsigned char* bump_pointer = &__heap_base;

void* malloc(size_t size) {
  void* res = SKIP_get_free(size);
  if(res != NULL) {
    return res;
  }
  uint32_t* r = (uint32_t*)bump_pointer;
  bump_pointer += size + sizeof(uint32_t);
  *r = size;
  r++;
  return (void*)r;
}

void free(uint32_t* ptr) {
  uint32_t size = *(ptr-1);
  SKIP_add_free(ptr, size);
}

char* SKIP_Obstack_alloc(size_t size) {
  return (char*)malloc(size);
}

void* exn = NULL;

void __cxa_throw(void*, void*, void*);

void SKIP_throw(char* exc) {
  exn = exc;
  __cxa_throw(0, 0, 0);
}

void* SKIP_getExn() {
  return exn;
}
