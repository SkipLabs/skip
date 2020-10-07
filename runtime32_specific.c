#define NULL ((void*)0)

typedef long long uint64_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;
typedef uint64_t SkipInt;

extern unsigned char __heap_base;

unsigned char* bump_pointer = &__heap_base;

void* malloc(size_t size) {
  unsigned char* r = bump_pointer;
  bump_pointer += size;
  return (void*)r;
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
