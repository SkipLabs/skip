#include "runtime.h"

#ifdef SKIP64
#include <unistd.h>
#endif

/*****************************************************************************/
/* Primitives that are not used in embedded mode. */
/*****************************************************************************/

void SKIP_Regex_initialize() {
}

void SKIP_internalExit(uint64_t code) {
  #ifdef SKIP64
  _exit(code);
  #endif
}

void SKIP_print_last_exception_stack_trace_and_exit() {
  todo();
}
void SKIP_unreachableMethodCall() {
  todo();
}
void SKIP_unreachableWithExplanation() {
  todo();
}

void SKIP_Obstack_vectorUnsafeSet(char** arr, char* x) {
  *arr = x;
}

void SKIP_Obstack_collect(char* dumb1, char** dumb2, SkipInt dumb3) {
}

void* SKIP_llvm_memcpy(char* dest, char* val, SkipInt len) {
  return memcpy(dest, val, (size_t)len);
}

/*****************************************************************************/
/* Global context synchronization. */
/*****************************************************************************/

void* SKIP_context_init(char* obj) {
  void* context = SKIP_context_get();
  if(context == NULL) {
    sk_global_lock();
    context = SKIP_intern_shared(obj);
    SKIP_context_set_unsafe(context);
    sk_global_unlock();
  }
  return context;
}

void* SKIP_context_sync(uint64_t txTime, char* old_context, char* obj) {
  sk_staging();
  char* context = SKIP_context_get_unsafe();
  SKIP_syncContext(txTime, context, obj);
  char* new_obj = SKIP_intern_shared(obj);
  SKIP_context_set_unsafe(new_obj);
  SKIP_free(old_context);
  SKIP_free(context);
  sk_commit();
  return new_obj;
}
