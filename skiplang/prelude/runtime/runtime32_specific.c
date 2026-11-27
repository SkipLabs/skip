#include <stdbool.h>

#include "runtime.h"
#include "xoroshiro128plus.h"

void js_throw(void*, uint32_t);

void* exn = (void*)0;

void SKIP_throw(void* exc) {
  uint32_t rethow = exn == exc;
  exn = exc;
  js_throw(exc, rethow);
}

void SKIP_saveExn(void* exc) {
  exn = exc;
}

void js_replace_exn(void* old, void* new);

void SKIP_replaceExn(void* exc) {
  js_replace_exn(exn, exc);
  exn = exc;
}

void* SKIP_getExn() {
  return exn;
}

char* end_of_static;
extern unsigned char* bump_pointer;
unsigned char* real_heap_end;
unsigned char* heap_end;
extern SKIP_gc_type_t* epointer_ty;

void reset_heap_end() {
  heap_end = real_heap_end;
}

unsigned char* decr_heap_end(size_t size) {
  heap_end -= size;
  return heap_end;
}

void SKIP_skstore_init(uint32_t size) {
  real_heap_end = bump_pointer + size;
  heap_end = real_heap_end;
  end_of_static = (char*)bump_pointer;
  char* obj = sk_get_external_pointer();
  epointer_ty = get_gc_type(obj);
}

void SKIP_destroy_Obstack(void*);

void SKIP_skstore_end_of_init() {
  if ((char*)bump_pointer != (char*)0) {
    SKIP_destroy_Obstack((char*)0);
  }
}

int sk_is_static(void* ptr) {
  return (char*)ptr < end_of_static;
}

void sk_staging() {}

void sk_commit(char* new_root, uint32_t /* sync */) {
  sk_contexts_set_unsafe(new_root);
}

char* SKIP_read_file(char* /* filename_obj */) {
  SKIP_throw_cruntime(ERROR_NOT_IMPLEMENTED);
  return (void*)0;
}

void* contexts;

void sk_global_lock() {}

void sk_global_unlock() {}

uint32_t SKIP_has_context(Fork fork) {
  return (uint32_t)(contexts != NULL ? SKIP_has_fork_context(contexts, fork)
                                     : 0);
}

Contexts SKIP_contexts_get_unsafe() {
  if (contexts != NULL) {
    sk_incr_ref_count(contexts);
  }
  return contexts;
}

Contexts SKIP_contexts_get() {
  return SKIP_contexts_get_unsafe();
}

void sk_contexts_set(Contexts obj) {
  contexts = obj;
}

void sk_contexts_set_unsafe(Contexts obj) {
  contexts = obj;
}

SkipInt SKIP_genSym(SkipInt /* n */) {
  static SkipInt x = 1;
  x++;
  return x;
}

char* sk_new_const(char* cst) {
  return SKIP_intern_shared(cst);
}

void SKIP_throw_EndOfFile();

int64_t SKIP_posix_isatty(int64_t /* fd */) {
  return 0;
}

void* SKIP_exec(char* /* cmd */) {
  // Not implemented
  return NULL;
}

void SKIP_write_to_proc(void* /* proc */, char* /* str */) {
  // Not implemented.
}

void SKIP_wait_for_proc(void* /* proc */) {
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

void SKIP_time() {
  // Not implemented
}

uint32_t SKIP_js_time_ms_lo();
uint32_t SKIP_js_time_ms_hi();

uint64_t SKIP_time_ms() {
  uint32_t lo = SKIP_js_time_ms_lo();
  uint32_t hi = SKIP_js_time_ms_hi();
  return (((uint64_t)hi) << 32) | ((uint64_t)lo);
}

uint64_t SKIP_time_ns() {
  // No nanosecond precision on 32-bit/WASM; fall back to milliseconds * 1e6.
  return SKIP_time_ms() * 1000000;
}

void SKIP_sleep_ms(uint64_t ms) {
  // Not implemented on 32-bit/WASM.
  (void)ms;
}

void SKIP_flush_stdout() {
  // Not implemented
}

int32_t SKIP_notify(char* /* filename_obj */, int32_t /* tick */) {
  // Not implemented
  return 0;
}

uint32_t SKIP_js_get_entropy();

void SKIP_random_init() {
  uint32_t lo = SKIP_js_get_entropy();
  uint32_t hi = SKIP_js_get_entropy();
  uint64_t seed = (((uint64_t)hi) << 32) | ((uint64_t)lo);
  xoroshiro128plus_init(seed);
}

uint64_t SKIP_random_next() {
  return xoroshiro128plus_next();
}

__attribute__((noreturn)) void SKIP_exit(uint64_t code) {
  SKIP_throw_cruntime((int32_t)code);
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

void SKIP_mutex_init(void* /* lock */) {}

void SKIP_mutex_lock(void* /* lock */) {}

void SKIP_mutex_unlock(void* /* lock */) {}

void SKIP_cond_init(void* /* cond */) {}

void SKIP_cond_wait(void* /* x */, void* /* y */) {}

int32_t SKIP_cond_timedwait(void* /* x */, void* /* y */, uint32_t /* secs */) {
  return 0;
}

int32_t SKIP_cond_broadcast(void* /* c */) {
  return 0;
}

int SKIP_stdin_has_data() {
  return 1;
}

void SKIP_unix_die_on_EOF() {}

int32_t SKIP_js_open_flags(bool read, bool write, bool append, bool truncate,
                           bool create, bool create_new);

int64_t SKIP_posix_open_flags(int64_t read, int64_t write, int64_t append,
                              int64_t truncate, int64_t create,
                              int64_t create_new) {
  return SKIP_js_open_flags((bool)read, (bool)write, (bool)append,
                            (bool)truncate, (bool)create, (bool)create_new);
}

int32_t SKIP_js_open(char* path, int32_t oflag, int32_t mode);

int64_t SKIP_posix_open(char* path, int64_t oflag, int64_t mode) {
  return (int64_t)SKIP_js_open(path, (int32_t)oflag, (int32_t)mode);
}

void SKIP_js_close(int32_t fd);

void SKIP_posix_close(int64_t fd) {
  SKIP_js_close((int32_t)fd);
}

uint32_t SKIP_js_write(uint32_t fd, char* buf, uint32_t len);

int64_t SKIP_posix_write(int64_t fd, char* buf, int64_t len) {
  return (int64_t)SKIP_js_write((uint32_t)fd, buf, (uint32_t)len);
}

int32_t SKIP_js_read(uint32_t fd, char* buf, uint32_t len);

int64_t SKIP_posix_read(int64_t fd, char* buf, int64_t len) {
  return (int64_t)SKIP_js_read((uint32_t)fd, buf, (uint32_t)len);
}

int32_t SKIP_js_get_argc();

int64_t SKIP_getArgc() {
  return (int64_t)SKIP_js_get_argc();
}

char* SKIP_js_get_argn(int32_t n);

char* SKIP_getArgN(int64_t n) {
  return SKIP_js_get_argn((int32_t)n);
}

uint32_t SKIP_js_get_envc();

int64_t SKIP_get_envc() {
  return (int64_t)SKIP_js_get_envc();
}

char* SKIP_js_get_envn(uint32_t n);

char* SKIP_get_envN(int64_t n) {
  return SKIP_js_get_envn((uint32_t)n);
}

char* SKIP_js_pipe();

char* SKIP_posix_pipe() {
  return SKIP_js_pipe();
}

char* SKIP_posix_pipe_cloexec() {
  // Wasm has no native descriptor inheritance. Keep the existing pipe bridge.
  return SKIP_posix_pipe();
}

uint32_t SKIP_js_fork();

int64_t SKIP_posix_fork() {
  return (int64_t)SKIP_js_fork();
}

void SKIP_js_dup2(uint32_t oldfd, uint32_t newfd);

void SKIP_posix_dup2(int64_t oldfd, int64_t newfd) {
  SKIP_js_dup2((uint32_t)oldfd, (uint32_t)newfd);
}

void SKIP_js_execvp(char* args_obj);

void SKIP_posix_execvp(char* args_obj) {
  SKIP_js_execvp(args_obj);
}

// Serial counterpart of the native threaded SKStore batch evaluator.
void* sk_parallel_map_evaluate(void*, int64_t, int64_t);
void* SKIP_skstore_parallel_map(void* job, int64_t count, int64_t workers,
                                _Bool retain_arenas) {
  (void)workers;
  (void)retain_arenas;
  return sk_parallel_map_evaluate(job, 0, count);
}
int64_t SKIP_parallel_map_worker_id(void) {
  return 0;
}
_Bool SKIP_parallel_map_native(void) {
  return 0;
}

// 128-bit integer compiler-rt helpers for wasm32 (built with -nostdlibinc and
// linked without libclang_rt.builtins). LLVM lowers `mul`, `sdiv`, `udiv`,
// `srem`, `urem`, and variable shifts on `i128` to calls to these symbols on
// wasm32. Marked `used` so LLVM LTO does not dead-strip them before llc
// codegen introduces the libcalls.
typedef __int128 ti_int;
typedef unsigned __int128 tu_int;

static uint64_t skip_u128_lo(tu_int x) {
  return (uint64_t)x;
}
static uint64_t skip_u128_hi(tu_int x) {
  return (uint64_t)(x >> 64);
}
static tu_int skip_make_u128(uint64_t lo, uint64_t hi) {
  return ((tu_int)hi << 64) | lo;
}

__attribute__((used)) tu_int __multi3(tu_int a, tu_int b) {
  uint64_t a_lo = skip_u128_lo(a);
  uint64_t a_hi = skip_u128_hi(a);
  uint64_t b_lo = skip_u128_lo(b);
  uint64_t b_hi = skip_u128_hi(b);

  uint64_t a0 = a_lo & 0xFFFFFFFFULL;
  uint64_t a1 = a_lo >> 32;
  uint64_t b0 = b_lo & 0xFFFFFFFFULL;
  uint64_t b1 = b_lo >> 32;

  uint64_t p00 = a0 * b0;
  uint64_t p01 = a0 * b1;
  uint64_t p10 = a1 * b0;
  uint64_t p11 = a1 * b1;

  uint64_t mid = (p00 >> 32) + (p01 & 0xFFFFFFFFULL) + (p10 & 0xFFFFFFFFULL);
  uint64_t lo = (p00 & 0xFFFFFFFFULL) | (mid << 32);
  uint64_t hi =
      p11 + (p01 >> 32) + (p10 >> 32) + (mid >> 32) + a_lo * b_hi + a_hi * b_lo;
  return skip_make_u128(lo, hi);
}

__attribute__((used)) tu_int __ashlti3(tu_int a, int b) {
  uint32_t s = (uint32_t)b & 127U;
  if (s == 0) {
    return a;
  }
  uint64_t lo = skip_u128_lo(a);
  uint64_t hi = skip_u128_hi(a);
  if (s >= 64) {
    return skip_make_u128(0, lo << (s - 64));
  }
  return skip_make_u128(lo << s, (hi << s) | (lo >> (64 - s)));
}

__attribute__((used)) tu_int __lshrti3(tu_int a, int b) {
  uint32_t s = (uint32_t)b & 127U;
  if (s == 0) {
    return a;
  }
  uint64_t lo = skip_u128_lo(a);
  uint64_t hi = skip_u128_hi(a);
  if (s >= 64) {
    return skip_make_u128(hi >> (s - 64), 0);
  }
  return skip_make_u128((lo >> s) | (hi << (64 - s)), hi >> s);
}

__attribute__((used)) ti_int __ashrti3(ti_int a, int b) {
  uint32_t s = (uint32_t)b & 127U;
  if (s == 0) {
    return a;
  }
  uint64_t lo = skip_u128_lo((tu_int)a);
  int64_t hi = (int64_t)skip_u128_hi((tu_int)a);
  if (s >= 64) {
    return (ti_int)skip_make_u128((uint64_t)(hi >> (s - 64)),
                                  (uint64_t)(hi >> 63));
  }
  return (ti_int)skip_make_u128((lo >> s) | ((uint64_t)hi << (64 - s)),
                                (uint64_t)(hi >> s));
}

static tu_int skip_udivmodti4(tu_int a, tu_int b, tu_int* rem) {
  if (b > a) {
    if (rem) {
      *rem = a;
    }
    return 0;
  }
  uint64_t a_hi = skip_u128_hi(a);
  uint64_t b_hi = skip_u128_hi(b);
  uint64_t a_lo = skip_u128_lo(a);
  uint64_t b_lo = skip_u128_lo(b);
  if (b_hi == 0 && a_hi == 0) {
    if (rem) {
      *rem = (tu_int)(a_lo % b_lo);
    }
    return (tu_int)(a_lo / b_lo);
  }
  int lz_a =
      a_hi ? __builtin_clzll(a_hi) : (64 + (a_lo ? __builtin_clzll(a_lo) : 64));
  int lz_b =
      b_hi ? __builtin_clzll(b_hi) : (64 + (b_lo ? __builtin_clzll(b_lo) : 64));
  int shift = lz_b - lz_a;
  tu_int q = 0;
  tu_int r = a;
  tu_int d = __ashlti3(b, shift);
  for (int i = shift; i >= 0; --i) {
    q = q << 1;
    if (r >= d) {
      r -= d;
      q |= 1;
    }
    d = d >> 1;
  }
  if (rem) {
    *rem = r;
  }
  return q;
}

__attribute__((used)) tu_int __udivti3(tu_int a, tu_int b) {
  return skip_udivmodti4(a, b, (tu_int*)0);
}

__attribute__((used)) tu_int __umodti3(tu_int a, tu_int b) {
  tu_int r = 0;
  skip_udivmodti4(a, b, &r);
  return r;
}

__attribute__((used)) ti_int __divti3(ti_int a, ti_int b) {
  int neg_a = a < 0;
  int neg_b = b < 0;
  tu_int ua = neg_a ? -(tu_int)a : (tu_int)a;
  tu_int ub = neg_b ? -(tu_int)b : (tu_int)b;
  tu_int q = skip_udivmodti4(ua, ub, (tu_int*)0);
  return (neg_a != neg_b) ? (ti_int)(-q) : (ti_int)q;
}

__attribute__((used)) ti_int __modti3(ti_int a, ti_int b) {
  int neg_a = a < 0;
  int neg_b = b < 0;
  tu_int ua = neg_a ? -(tu_int)a : (tu_int)a;
  tu_int ub = neg_b ? -(tu_int)b : (tu_int)b;
  tu_int r = 0;
  skip_udivmodti4(ua, ub, &r);
  return neg_a ? (ti_int)(-r) : (ti_int)r;
}
