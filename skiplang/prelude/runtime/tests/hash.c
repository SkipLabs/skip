// Standalone native and Wasm regression tests for SKIP_hash and
// SKIP_hash_combine (rapidhash primitive, stack-local inline traversal buffer
// and heap spill, NULL ref-slot disambiguation, array length and nominal type
// identity, and string hashing across all rapidhash length branches).
#ifdef SKIP32
#define HASH_TEST_WASM 1
#else
#define SKIP64 1
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#endif

#include "../hash.c"
#include "../stack.c"

#ifdef HASH_TEST_WASM
#define check(cond)               \
  do {                            \
    if (!(cond)) return __LINE__; \
  } while (0)
static char wasm_heap[65536];
static size_t wasm_heap_pos = 0;
static size_t malloc_calls = 0;
static size_t free_calls = 0;

void* sk_malloc(size_t size) {
  malloc_calls++;
  size = (size + 7) & ~(size_t)7;
  if (wasm_heap_pos + size > sizeof(wasm_heap)) __builtin_trap();
  void* p = wasm_heap + wasm_heap_pos;
  wasm_heap_pos += size;
  return p;
}

void sk_free_size(void* p, size_t size) {
  (void)p;
  (void)size;
  free_calls++;
}

void* memcpy(void* restrict dst, const void* restrict src, size_t n) {
  unsigned char* d = (unsigned char*)dst;
  const unsigned char* s = (const unsigned char*)src;
  for (size_t i = 0; i < n; i++) d[i] = s[i];
  return dst;
}

void* memset(void* b, int c, size_t len) {
  unsigned char* d = (unsigned char*)b;
  for (size_t i = 0; i < len; i++) d[i] = (unsigned char)c;
  return b;
}
#else
#define check(cond) assert(cond)
static size_t malloc_calls = 0;
static size_t free_calls = 0;

void* sk_malloc(size_t size) {
  malloc_calls++;
  void* p = malloc(size);
  assert(p != NULL);
  return p;
}

void sk_free_size(void* p, size_t size) {
  (void)size;
  free_calls++;
  free(p);
}
#endif

sk_string_t* get_sk_string(char* obj) {
  return container_of(obj, sk_string_t, data);
}

uint32_t SKIP_is_string(char* obj) {
  void** vtable_ptr = container_of(obj, sk_class_inst_t, data)->vtable;
  return (uintptr_t)vtable_ptr & 0x2;
}

SKIP_gc_type_t* get_gc_type(char* skip_object) {
  void** vtable_ptr = container_of(skip_object, sk_class_inst_t, data)->vtable;
  return *((SKIP_gc_type_t**)(vtable_ptr + 1));
}

// Synthetic string helper (tagged with bit 1 in hash so SKIP_is_string is
// true).
typedef struct {
  sk_string_t header;
  char data[512];
} test_string_t;

static char* make_string(test_string_t* s, const char* bytes, uint32_t len) {
  s->header.size = len;
  s->header.hash = 0x2;  // bit 1 tags strings
  if (len > 0) memcpy(s->data, bytes, len);
  s->data[len] = '\0';
  return s->data;
}

// Synthetic class with 2 reference fields: Pair(a: ?Obj, b: ?Obj).
static struct {
  SKIP_gc_type_t type;
  SkipInt mask[1];
} pair_ref_gc = {
    .type =
        {
            .m_refsHintMask = 1,
            .m_kind = kSkipGcKindClass,
            .m_userByteSize = 2 * sizeof(void*),
            .m_typeIdentity = 101,
        },
    .mask = {UINT64_C(0x3)},
};
static void* pair_ref_vtable[2] = {NULL, &pair_ref_gc.type};

typedef struct {
  void** vtable;
  void* first;
  void* second;
} test_pair_t;

static char* make_pair(test_pair_t* p, void* a, void* b) {
  p->vtable = pair_ref_vtable;
  p->first = a;
  p->second = b;
  return (char*)&p->first;
}

// Synthetic scalar-only class (1 uint64_t field) with two distinct type ids
// and a second GC type with the SAME m_typeIdentity at a different address.
static SKIP_gc_type_t box_a_gc = {
    .m_refsHintMask = 0,
    .m_kind = kSkipGcKindClass,
    .m_userByteSize = sizeof(uint64_t),
    .m_typeIdentity = 201,
};
static SKIP_gc_type_t box_a_copy_gc = {
    .m_refsHintMask = 0,
    .m_kind = kSkipGcKindClass,
    .m_userByteSize = sizeof(uint64_t),
    .m_typeIdentity = 201,
};
static SKIP_gc_type_t box_b_gc = {
    .m_refsHintMask = 0,
    .m_kind = kSkipGcKindClass,
    .m_userByteSize = sizeof(uint64_t),
    .m_typeIdentity = 202,
};
static void* box_a_vtable[2] = {NULL, &box_a_gc};
static void* box_a_copy_vtable[2] = {NULL, &box_a_copy_gc};
static void* box_b_vtable[2] = {NULL, &box_b_gc};

typedef struct {
  sk_class_inst_t header;
  char payload[sizeof(uint64_t)];
} test_box_t;

static char* make_box(test_box_t* b, void** vt, uint64_t v) {
  b->header.vtable = vt;
  memcpy(b->payload, &v, sizeof(v));
  return b->header.data;
}

// Synthetic reference-array GC type for testing heap spill (> 64 refs) and
// empty vs non-empty arrays.
static struct {
  SKIP_gc_type_t type;
  SkipInt mask[1];
} ref_array_gc = {
    .type =
        {
            .m_refsHintMask = 1,
            .m_kind = kSkipGcKindArray,
            .m_userByteSize = sizeof(void*),
            .m_typeIdentity = 301,
        },
    .mask = {UINT64_C(0x1)},
};
static void* ref_array_vtable[2] = {NULL, &ref_array_gc.type};

#define SPILL_LEN 100
typedef struct {
  sk_array_t header;
  void* elems[SPILL_LEN];
} test_ref_array_t;

static char* make_ref_array(test_ref_array_t* arr, uint32_t len) {
  arr->header.length = len;
  arr->header.vtable = ref_array_vtable;
  return (char*)&arr->elems[0];
}

int run_hash_tests(void) {
  // 1. Determinism and length coverage across rapidhash branches (0, 1..3,
  // 4..16, 17..32, 33..48, >48, >128 bytes).
  test_string_t s1, s2;
  char buf[256];
  for (size_t i = 0; i < sizeof(buf); i++) buf[i] = (char)(i * 31 + 7);

  const uint32_t lengths[] = {0,  1,  2,  3,  4,  7,  8,  15,  16, 17,
                              24, 32, 33, 48, 49, 64, 96, 128, 200};
  uint64_t prev_hashes[sizeof(lengths) / sizeof(lengths[0])];
  for (size_t li = 0; li < sizeof(lengths) / sizeof(lengths[0]); li++) {
    uint32_t len = lengths[li];
    char* a = make_string(&s1, buf, len);
    char* b = make_string(&s2, buf, len);
    size_t before = malloc_calls;
    uint64_t ha = SKIP_hash(a);
    uint64_t hb = SKIP_hash(b);
    // Inline stack: zero heap allocations for small objects / strings.
    check(malloc_calls == before);
    check(ha == hb);
    for (size_t lj = 0; lj < li; lj++) {
      check(ha != prev_hashes[lj]);
    }
    prev_hashes[li] = ha;
    if (len > 0) {
      // Single-bit flip must change the hash.
      buf[len - 1] ^= 1;
      char* c = make_string(&s2, buf, len);
      uint64_t hc = SKIP_hash(c);
      buf[len - 1] ^= 1;
      check(ha != hc);
    }
  }

  // 2. NULL ref-slot disambiguation: Pair(NULL, x) != Pair(x, NULL),
  // Pair(NULL, NULL) != Pair(NULL, x), and identical pairs hash equal.
  test_box_t leaf;
  char* leaf_obj = make_box(&leaf, box_a_vtable, 42);
  test_pair_t p_null_x, p_x_null, p_null_null, p_x_x, p_null_x2;
  size_t before_pairs = malloc_calls;
  uint64_t h_null_x = SKIP_hash(make_pair(&p_null_x, NULL, leaf_obj));
  uint64_t h_x_null = SKIP_hash(make_pair(&p_x_null, leaf_obj, NULL));
  uint64_t h_null_null = SKIP_hash(make_pair(&p_null_null, NULL, NULL));
  uint64_t h_x_x = SKIP_hash(make_pair(&p_x_x, leaf_obj, leaf_obj));
  uint64_t h_null_x2 = SKIP_hash(make_pair(&p_null_x2, NULL, leaf_obj));
  check(malloc_calls == before_pairs);
  check(h_null_x == h_null_x2);
  check(h_null_x != h_x_null);
  check(h_null_x != h_null_null);
  check(h_x_null != h_null_null);
  check(h_null_x != h_x_x);
  check(h_x_null != h_x_x);

  // 3. Nested objects preserve structure: Pair(Pair(x, NULL), NULL) vs
  // Pair(NULL, Pair(x, NULL)) vs Pair(Pair(NULL, x), NULL).
  test_pair_t inner1, inner2, outer1, outer2, outer3;
  uint64_t hn1 =
      SKIP_hash(make_pair(&outer1, make_pair(&inner1, leaf_obj, NULL), NULL));
  uint64_t hn2 =
      SKIP_hash(make_pair(&outer2, NULL, make_pair(&inner2, leaf_obj, NULL)));
  uint64_t hn3 =
      SKIP_hash(make_pair(&outer3, make_pair(&inner1, NULL, leaf_obj), NULL));
  check(hn1 != hn2);
  check(hn1 != hn3);
  check(hn2 != hn3);

  // 4. Nominal type identity: distinct m_typeIdentity produces distinct hashes
  // for identical payload bytes; same m_typeIdentity at a different GC type
  // address produces the exact same hash (ASLR / pointer independence).
  test_box_t ba1, ba2, bb;
  uint64_t h_ba1 = SKIP_hash(make_box(&ba1, box_a_vtable, 12345));
  uint64_t h_ba2 = SKIP_hash(make_box(&ba2, box_a_copy_vtable, 12345));
  uint64_t h_bb = SKIP_hash(make_box(&bb, box_b_vtable, 12345));
  check(h_ba1 == h_ba2);
  check(h_ba1 != h_bb);

  // 5. Empty vs non-empty reference arrays with NULL elements must differ.
  test_ref_array_t arr0, arr1, arr2;
  arr1.elems[0] = NULL;
  arr2.elems[0] = NULL;
  arr2.elems[1] = NULL;
  uint64_t ha0 = SKIP_hash(make_ref_array(&arr0, 0));
  uint64_t ha1 = SKIP_hash(make_ref_array(&arr1, 1));
  uint64_t ha2 = SKIP_hash(make_ref_array(&arr2, 2));
  check(ha0 != ha1);
  check(ha1 != ha2);
  check(ha0 != ha2);

  // 6. Stack spill (> 64 pushed references) succeeds, frees its heap buffer,
  // and remains sensitive to every element.
  test_box_t elems_storage[SPILL_LEN];
  test_ref_array_t big_arr;
  for (uint32_t i = 0; i < SPILL_LEN; i++) {
    big_arr.elems[i] = make_box(&elems_storage[i], box_a_vtable, i);
  }
  size_t malloc_before = malloc_calls;
  size_t free_before = free_calls;
  uint64_t h_big1 = SKIP_hash(make_ref_array(&big_arr, SPILL_LEN));
  check(malloc_calls > malloc_before);
  check(free_calls - free_before == malloc_calls - malloc_before);

  uint64_t h_big2 = SKIP_hash(make_ref_array(&big_arr, SPILL_LEN));
  check(h_big1 == h_big2);

  uint64_t mutated = 9999;
  memcpy(elems_storage[SPILL_LEN - 1].payload, &mutated, sizeof(mutated));
  uint64_t h_big3 = SKIP_hash(make_ref_array(&big_arr, SPILL_LEN));
  check(h_big1 != h_big3);

  // 7. SKIP_hash_combine: non-commutative, deterministic, distinct from inputs.
  SkipInt c12 = SKIP_hash_combine(1, 2);
  SkipInt c21 = SKIP_hash_combine(2, 1);
  SkipInt c12_again = SKIP_hash_combine(1, 2);
  check(c12 == c12_again);
  check(c12 != c21);
  check(c12 != 1 && c12 != 2);

  return 0;
}

#ifndef HASH_TEST_WASM
int main(void) {
  int rc = run_hash_tests();
  assert(rc == 0);
  printf("SKIP_hash native checks: OK\n");
  return 0;
}
#endif
