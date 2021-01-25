#include "runtime.h"

/*****************************************************************************/
/* Primitives that are not used in embedded mode. */
/*****************************************************************************/

void SKIP_Regex_initialize() {
}

void SKIP_internalExit() {
  todo();
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
/* Primite used for testing purposes. */
/*****************************************************************************/
#define MAGIC_NUMBER 232131

void* SKIP_make_C_object() {
  uint32_t* obj = (uint32_t*)sk_malloc(sizeof(uint32_t));
  *obj = MAGIC_NUMBER;
  return (void*)obj;
}

uint32_t SKIP_is_C_object(uint32_t* obj) {
  return (*obj == MAGIC_NUMBER);
}

extern void skip_main(void);

/*****************************************************************************/
/* Global context synchronization. */
/*****************************************************************************/

void** context;

void SKIP_context_init(char* obj) {
  *context = obj;
}

char* SKIP_context_get() {
  return *context;
}

extern size_t total_palloc_size;

void SKIP_context_sync(char* obj) {
  char* new_obj = SKIP_intern_shared(obj);
  SKIP_free(*context);
  *context = new_obj;
}
