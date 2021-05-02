#include "runtime.h"

void __cxa_throw(void*, void*, void*);

void* exn = (void*)0;

void SKIP_throw(void* exc) {
  exn = exc;
  __cxa_throw(0, 0, 0);
}

void* SKIP_getExn() {
  return exn;
}

char* end_of_static;
extern unsigned char* bump_pointer;
void* sk_ftable_holder[SK_FTABLE_SIZE];
extern void** sk_ftable;

void SKIP_skfs_init() {
  end_of_static = (char*)bump_pointer;
  sk_ftable = sk_ftable_holder;
}

void SKIP_destroy_Obstack(void*);

void SKIP_skfs_end_of_init() {
  if((char*)bump_pointer != (char*)0) {
    SKIP_destroy_Obstack((char*)0);
  }
}

extern char __heap_base;

int sk_is_static(void* ptr) {
  return (char*)ptr < end_of_static;
}

void sk_staging() {
}

void sk_commit() {
}

char* SKIP_read_file(char* filename_obj) {
  SKIP_throw((void*)0);
  return (void*)0;
}

void** context;

char* SKIP_context_get() {
  return *context;
}

void SKIP_context_set(char* obj) {
  *context = obj;
}

char* SKIP_context_get_unsafe() {
  return *context;
}

void SKIP_context_set_unsafe(char* obj) {
  *context = obj;
}

SkipInt SKIP_genSym(SkipInt n) {
  static SkipInt x = 1;
  x++;
  return x;
}

char* sk_new_const(char* cst) {
  return SKIP_intern_shared(cst);
}

void SKIP_throw_EndOfFile();

int SKIP_getchar() {
  SKIP_throw_EndOfFile();
  return 0;
}

int SKIP_isatty() {
  return 0;
}
