#include "runtime.h"

#ifdef SKIP64
#include <unistd.h>
#endif

/*****************************************************************************/
/* Operations on the runtime representation of skip values. */
/*****************************************************************************/

sk_string_t* get_sk_string(char* obj) {
  return container_of(obj, sk_string_t, data);
}

SKIP_gc_type_t* get_gc_type(char* skip_object) {
  void** vtable_ptr = container_of(skip_object, sk_class_inst_t, data)->vtable;
  // the gc_type of each object is stored in slot 1 of the vtable,
  // see createVTableBuilders in vtable.sk
  SKIP_gc_type_t** slot1 = (SKIP_gc_type_t**)(vtable_ptr + 1);
  return *slot1;
}

void* SKIP_unsafe_cast(void* obj) {
  return obj;
}

/*****************************************************************************/
/* Primitives that are not used in embedded mode. */
/*****************************************************************************/

void SKIP_Regex_initialize() {}

void SKIP_print_stack_trace() {
  todo("Not implemented", "SKIP_print_stack_trace");
}
void SKIP_print_last_exception_stack_trace_and_exit(void*) {
  todo("Not implemented", "SKIP_print_last_exception_stack_trace_and_exit");
}
void SKIP_unreachableMethodCall(void* msg, void*) {
  todo("Unreachable method call", msg);
}
void SKIP_unreachableWithExplanation(void* explanation) {
  todo("Unreachable", explanation);
}

void SKIP_Obstack_vectorUnsafeSet(char** arr, char* x) {
  *arr = x;
}

void SKIP_Obstack_collect(char*, char**, SkipInt) {}

void* SKIP_llvm_memcpy(char* dest, char* val, SkipInt len) {
  return memcpy(dest, val, (size_t)len);
}

/*****************************************************************************/
/* Global context synchronization. */
/*****************************************************************************/

void SKIP_contexts_init(Contexts obj) {
  sk_global_lock();
  Contexts contexts = SKIP_intern_shared(obj);
  sk_contexts_set_unsafe(contexts);
  sk_global_unlock();
}

void SKIP_contexts_replace_unsafe(Contexts new_contexts, uint32_t sync) {
  Contexts contexts = SKIP_contexts_get_unsafe();
  sk_commit(SKIP_intern_shared(new_contexts), sync);
  // free current reference
  sk_free_root(contexts);
  // free global reference
  sk_free_root(contexts);
}

void SKIP_unsafe_contexts_incr_ref_count(Contexts obj) {
  sk_incr_ref_count(obj);
}

void SKIP_unsafe_free(Contexts contexts) {
  sk_global_lock();
  sk_free_root(contexts);
  sk_global_unlock();
}

void SKIP_global_lock() {
#ifdef SKIP64
  sk_global_lock();
#endif
}

#ifdef SKIP64
extern int sk_is_locked;
#endif

uint32_t SKIP_global_has_lock() {
#ifdef SKIP64
  return (uint32_t)sk_is_locked;
#endif
#ifdef SKIP32
  return 1;
#endif
}

void SKIP_global_unlock() {
#ifdef SKIP64
  sk_global_unlock();
#endif
}

sk_contexts_with_actions_t SKIP_context_sync_no_lock(
    uint64_t txTime, Contexts old_contexts, Context delta, char* synchronizer,
    uint32_t sync, char* lockF, Fork fork) {
  Contexts contexts = SKIP_contexts_get_unsafe();
  if (contexts == NULL) {
#ifdef SKIP64
    fprintf(stderr, "Internal error: you forgot to initialize the context");
#endif
    SKIP_throw_cruntime(ERROR_CONTEXT_NOT_INITIALIZED);
  }
  Context root = SKIP_get_fork_context(contexts, fork);
  Context old_root = SKIP_get_fork_context(old_contexts, fork);

  if (root == delta || old_root == delta) {
// INVALID use of sync, the root should be different
#ifdef SKIP64
    fprintf(stderr, "Internal error: tried to sync with the same context");
#endif
    SKIP_throw_cruntime(ERROR_SYNC_SAME_CONTEXT);
  }
  char* rtmp = SKIP_resolve_context(txTime, root, delta, synchronizer, lockF);
  sk_contexts_with_actions_t res =
      SKIP_check_fork_context(contexts, fork, rtmp);
  Contexts new_contexts = SKIP_intern_shared(res.contexts);
  sk_commit(new_contexts, sync);
  sk_free_root(old_contexts);
  // free current reference
  sk_free_root(contexts);
  // free global reference
  sk_free_root(contexts);
  sk_free_external_pointers();
#ifdef CTX_TABLE
  sk_print_ctx_table();
#endif
  sk_incr_ref_count(new_contexts);
  res.contexts = new_contexts;
  return res;
}

sk_contexts_with_actions_t SKIP_context_sync(uint64_t txTime,
                                             Contexts old_contexts,
                                             Context delta, char* synchronizer,
                                             uint32_t sync, char* lockF,
                                             Fork fork) {
  sk_global_lock();
  sk_contexts_with_actions_t new_root = SKIP_context_sync_no_lock(
      txTime, old_contexts, delta, synchronizer, sync, lockF, fork);
  sk_global_unlock();
  SKIP_call_after_unlock(synchronizer, delta);
  return new_root;
}

int64_t SKIP_Unsafe_Ptr__toInt(char* ptr) {
  return (int64_t)ptr;
}

void* SKIP_Unsafe_array_ptr(char* arr, SkipInt byte_offset) {
  return arr + byte_offset;
}

int64_t SKIP_Unsafe_array_byte_size(char* arr) {
  SKIP_gc_type_t* ty = get_gc_type(arr);
  size_t len = skip_array_len(arr);

  return ty->m_userByteSize * len;
}

uint8_t SKIP_Unsafe_array_get_byte(uint8_t* arr, SkipInt index) {
  return arr[index];
}

void SKIP_Unsafe_array_set_byte(uint8_t* arr, SkipInt index, uint8_t value) {
  arr[index] = value;
}
