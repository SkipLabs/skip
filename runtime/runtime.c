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
  uint32_t* obj = (uint32_t*)malloc(sizeof(uint32_t));
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

static char* context = NULL;

void SKIP_context_init(char* obj) {
  context = obj;
}

char* SKIP_context_get() {
  return context;
}

void SKIP_context_sync(char* new) {
  char* new_obj = SKIP_intern(new);
  stack_t st_holder;
  stack_t* st = &st_holder;

  SKIP_stack_init(st, 1024);
  SKIP_free(st, context);

  while(st->head > 0) {
    value_t delayed = SKIP_stack_pop(st);
    void* toFree = delayed.value;
    SKIP_free(st, toFree);
  }

  SKIP_stack_free(st);
  context = new_obj;
}
