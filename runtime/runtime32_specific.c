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
extern SKIP_gc_type_t* epointer_ty;

void SKIP_skfs_init() {
  end_of_static = (char*)bump_pointer;
  sk_ftable = sk_ftable_holder;
  char* obj = sk_get_external_pointer();
  epointer_ty = *(*(((SKIP_gc_type_t***)obj)-1)+1);
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

void sk_commit(char* new_root, uint32_t sync) {
  sk_context_set_unsafe(new_root);
}

char* SKIP_read_file(char* filename_obj) {
  SKIP_throw((void*)0);
  return (void*)0;
}

void* context;

void sk_global_lock() {
}

void sk_global_unlock() {
}

uint32_t SKIP_has_context() {
  return (uint32_t)(context != NULL);
}

char* SKIP_context_get_unsafe() {
  if(context != NULL) {
    sk_incr_ref_count(context);
  }
  return context;
}

char* SKIP_context_get() {
  return SKIP_context_get_unsafe();
}

void sk_context_set(char* obj) {
  context = obj;
}

void sk_context_set_unsafe(char* obj) {
  context = obj;
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

int SKIP_isatty() {
  return 0;
}

void* SKIP_exec(char* cmd) {
  // Not implemented
  return NULL;
}

void SKIP_write_to_proc(void* proc, char* str) {
  // Not implemented.
}

void SKIP_wait_for_proc(void* proc) {
  // Not implemented
}

void sk_check_has_lock() {
  // always true in wasm mode.
}

void SKIP_print_persistent_size() {
  // Not implemented
}

uint32_t SKIP_get_persistent_size() {
  return (uint32_t)bump_pointer;
}

int SKIP_unix_close(int fd) {
  return 0;
}

void SKIP_mktime_utc() {
  // Not implemented
}

void SKIP_mktime_local() {
  // Not implemented
}

void SKIP_unix_strftime() {
  // Not implemented
}

void SKIP_gmtime() {
  // Not implemented
}

void SKIP_localtime() {
  // Not implemented
}

void SKIP_time() {
  // Not implemented
}

void SKIP_flush_stdout() {
  // Not implemented
}

uint64_t SKIP_notify(char* filename_obj, uint64_t tick) {
  // Not implemented
  return 0;
}

void SKIP_exit(uint64_t code) {
  SKIP_throw(NULL);
}

void* SKIP_freeze_lock(void* x) {
  return x;
}

void* SKIP_unfreeze_lock(void* x) {
  return x;
}

void* SKIP_freeze_cond(void* x) {
  return x;
}

void* SKIP_unfreeze_cond(void* x) {
  return x;
}

void SKIP_mutex_init(void* lock) {
}

void SKIP_mutex_lock(void* lock) {
}

void SKIP_mutex_unlock(void* lock) {
}

void SKIP_cond_init(void* cond) {
}

void SKIP_cond_wait(void* x, void* y) {
}

void SKIP_cond_broadcast(void* c) {
}

int SKIP_stdin_has_data() {
  return 1;
}

void SKIP_unix_die_on_EOF() {
}
