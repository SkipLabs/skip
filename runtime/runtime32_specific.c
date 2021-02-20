void __cxa_throw(void*, void*, void*);

void* exn = (void*)0;

void SKIP_throw(char* exc) {
  exn = exc;
  __cxa_throw(0, 0, 0);
}

void* SKIP_getExn() {
  return exn;
}

char* end_of_static;
extern unsigned char* bump_pointer;

void SKIP_skfs_init() {
  end_of_static = (char*)bump_pointer;
}

extern char __heap_base;

int sk_is_static(void* ptr) {
  return (char*)ptr < end_of_static;
}
