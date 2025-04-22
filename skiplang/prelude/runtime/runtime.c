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

void SKIP_context_init(char* obj) {
  sk_global_lock();
  char* context = SKIP_intern_shared(obj);
  sk_context_set_unsafe(context);
  sk_global_unlock();
}

void SKIP_unsafe_context_incr_ref_count(char* obj) {
  sk_incr_ref_count(obj);
}

void SKIP_unsafe_free(char* context) {
  sk_global_lock();
  sk_free_root(context);
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

void* SKIP_context_sync_no_lock(uint64_t txTime, char* old_root, char* delta,
                                char* synchronizer, uint32_t sync,
                                char* lockF) {
  char* root = SKIP_context_get_unsafe();
  if (root == NULL) {
#ifdef SKIP64
    fprintf(stderr, "Internal error: you forgot to initialize the context");
#endif
    SKIP_throw_cruntime(ERROR_CONTEXT_NOT_INITIALIZED);
  }
  if (root == delta || old_root == delta) {
// INVALID use of sync, the root should be different
#ifdef SKIP64
    fprintf(stderr, "Internal error: tried to sync with the same context");
#endif
    SKIP_throw_cruntime(ERROR_SYNC_SAME_CONTEXT);
  }
  char* rtmp = SKIP_resolve_context(txTime, root, delta, synchronizer, lockF);
  char* new_root = SKIP_intern_shared(rtmp);
  sk_commit(new_root, sync);
  sk_free_root(old_root);
  sk_free_root(root);
  sk_free_root(root);
  sk_free_external_pointers();
#ifdef CTX_TABLE
  sk_print_ctx_table();
#endif
  sk_incr_ref_count(new_root);
  return new_root;
}

void* SKIP_context_sync(uint64_t txTime, char* old_root, char* delta,
                        char* synchronizer, uint32_t sync, char* lockF) {
  sk_global_lock();
  char* new_root = SKIP_context_sync_no_lock(txTime, old_root, delta,
                                             synchronizer, sync, lockF);
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
