#include "runtime.h"

#ifdef SKIP64
#include <unistd.h>
#endif

/*****************************************************************************/
/* Saving/restoring context to thread locals.
 *
 * These primitives are very dangerous to use unless you really know what you
 * are doing. The GC does not keep track of the local context, so saving a
 * local context without a good understanding of how the memory model works
 * will probably lead to memory corruption.
 *
 * You have been warned ...
 */
/*****************************************************************************/

#ifdef SKIP32
char* lcontext = NULL;
#endif
#ifdef SKIP64
__thread char* lcontext = NULL;
#endif

int32_t SKIP_has_local_context() {
  return (int32_t)(lcontext != NULL);
}

void SKIP_set_local_context(char* context) {
  lcontext = context;
}

void SKIP_remove_local_context() {
  lcontext = NULL;
}

char* SKIP_get_local_context() {
  return lcontext;
}

/*****************************************************************************/
/* Primitives that are not used in embedded mode. */
/*****************************************************************************/

void SKIP_Regex_initialize() {
}

void SKIP_internalExit(uint64_t code) {
  SKIP_exit(code);
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

#ifdef SKIP32
static char* local_ctx = NULL;
#endif

#ifdef SKIP64
static __thread char* local_ctx = NULL;
#endif

void SKIP_unsafe_set_local_context(char* obj) {
  local_ctx = obj;
}

void SKIP_unsafe_remove_local_context(char* obj) {
  local_ctx = NULL;
}

char* SKIP_unsafe_get_local_context() {
  if(local_ctx == NULL) {
#ifdef SKIP64
    fprintf(stderr, "Error: local context is not set");
#endif
    SKIP_throw(NULL);
  }
  return local_ctx;
}

void SKIP_context_init(char* obj) {
  sk_global_lock();
  char* context = SKIP_intern_shared(obj);
  sk_decr_ref_count(context);
  sk_context_set_unsafe(context);
  sk_global_unlock();
}

void SKIP_unsafe_free(char* context) {
  sk_global_lock();
  sk_decr_ref_count(context);
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

void* SKIP_context_sync_no_lock(
  uint64_t txTime,
  char* old_root,
  char* delta,
  char* synchronizer,
  uint32_t sync,
  char* lockF
) {
  char* root = SKIP_context_get_unsafe();
  if(root == NULL) {
    #ifdef SKIP64
    fprintf(stderr, "Internal error: you forgot to initialize the context");
    #endif
    SKIP_throw(NULL);
  }
  if(root == delta || old_root == delta) {
    // INVALID use of sync, the root should be different
    #ifdef SKIP64
    fprintf(stderr, "Internal error: tried to sync with the same context");
    #endif
    SKIP_throw(NULL);
  }
  char* rtmp = SKIP_resolve_context(txTime, root, delta, synchronizer, lockF);
  char* new_root = SKIP_intern_shared(rtmp);
  sk_commit(new_root, sync);
  sk_free_root(old_root);
  sk_free_root(root);
  sk_free_external_pointers();
  return new_root;
}

void* SKIP_context_sync(
  uint64_t txTime,
  char* old_root,
  char* delta,
  char* synchronizer,
  uint32_t sync,
  char* lockF
) {
  sk_global_lock();
  char* new_root =
    SKIP_context_sync_no_lock(
      txTime,
      old_root,
      delta,
      synchronizer,
      sync,
      lockF
   );
  sk_global_unlock();
  SKIP_call_after_unlock(synchronizer, delta);
  return new_root;
}
