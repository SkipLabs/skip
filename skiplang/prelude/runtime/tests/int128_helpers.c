// Unit/differential test harness for the wasm32 128-bit compiler-rt helpers
// (__multi3, __ashlti3, __lshrti3, __ashrti3, __udivti3, __umodti3, __divti3,
// __modti3) in runtime32_specific.c. Compiled for wasm32 and driven by
// int128_helpers.mjs against JS BigInt reference arithmetic.
#define SKIP32 1
#include "../runtime.h"

// Declarations of the helpers defined in runtime32_specific.c (linked
// separately).
typedef __int128 ti_int;
typedef unsigned __int128 tu_int;

extern tu_int __multi3(tu_int a, tu_int b);
extern tu_int __ashlti3(tu_int a, int32_t b);
extern tu_int __lshrti3(tu_int a, int32_t b);
extern ti_int __ashrti3(ti_int a, int32_t b);
extern tu_int __udivti3(tu_int a, tu_int b);
extern tu_int __umodti3(tu_int a, tu_int b);
extern ti_int __divti3(ti_int a, ti_int b);
extern ti_int __modti3(ti_int a, ti_int b);

// Shared 16-byte result buffer so JS can read back (lo, hi) cleanly without
// depending on wasm32 i128 multi-value/sret ABI details.
static uint64_t out_buf[2];

uint64_t* result_buf(void) {
  return out_buf;
}

static tu_int make_u128(uint64_t lo, uint64_t hi) {
  return ((tu_int)hi << 64) | lo;
}

static void store_u128(tu_int v) {
  out_buf[0] = (uint64_t)v;
  out_buf[1] = (uint64_t)(v >> 64);
}

void test_mul(uint64_t a_lo, uint64_t a_hi, uint64_t b_lo, uint64_t b_hi) {
  store_u128(__multi3(make_u128(a_lo, a_hi), make_u128(b_lo, b_hi)));
}

void test_ashl(uint64_t a_lo, uint64_t a_hi, int32_t s) {
  store_u128(__ashlti3(make_u128(a_lo, a_hi), s));
}

void test_lshr(uint64_t a_lo, uint64_t a_hi, int32_t s) {
  store_u128(__lshrti3(make_u128(a_lo, a_hi), s));
}

void test_ashr(uint64_t a_lo, uint64_t a_hi, int32_t s) {
  store_u128((tu_int)__ashrti3((ti_int)make_u128(a_lo, a_hi), s));
}

void test_udiv(uint64_t a_lo, uint64_t a_hi, uint64_t b_lo, uint64_t b_hi) {
  store_u128(__udivti3(make_u128(a_lo, a_hi), make_u128(b_lo, b_hi)));
}

void test_umod(uint64_t a_lo, uint64_t a_hi, uint64_t b_lo, uint64_t b_hi) {
  store_u128(__umodti3(make_u128(a_lo, a_hi), make_u128(b_lo, b_hi)));
}

void test_div(uint64_t a_lo, uint64_t a_hi, uint64_t b_lo, uint64_t b_hi) {
  store_u128((tu_int)__divti3((ti_int)make_u128(a_lo, a_hi),
                              (ti_int)make_u128(b_lo, b_hi)));
}

void test_mod(uint64_t a_lo, uint64_t a_hi, uint64_t b_lo, uint64_t b_hi) {
  store_u128((tu_int)__modti3((ti_int)make_u128(a_lo, a_hi),
                              (ti_int)make_u128(b_lo, b_hi)));
}
