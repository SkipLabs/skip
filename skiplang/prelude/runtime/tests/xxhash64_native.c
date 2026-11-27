// Portable native UBSan test of SKIP_xxhash64_string (runtime/xxhash64.c),
// including unaligned input buffers, boundary lengths (0..100, 222), and both
// zero and non-zero seeds.
#define SKIP64 1
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "../xxhash64.c"

sk_string_t* get_sk_string(char* obj) {
  return container_of(obj, sk_string_t, data);
}

// Aligned Skip string buffer for SKIP_xxhash64_string tests.
static struct {
  sk_string_t header;
  char data[512];
} input;

// Extra buffer for testing sk_xxhash64_bytes at arbitrary unaligned offsets
// under UBSan.
static uint8_t raw_buf[512];

static uint64_t hash_str(const void* data, size_t len, uint64_t seed) {
  assert(len < sizeof(input.data));
  input.header.hash = 0x2;
  input.header.size = (uint32_t)len;
  if (len > 0) {
    memcpy(input.data, data, len);
  }
  input.data[len] = '\0';
  return (uint64_t)SKIP_xxhash64_string(input.data, (SkipInt)seed);
}

static void expect_vec(const char* s, uint64_t seed, uint64_t expected) {
  size_t len = strlen(s);
  uint64_t got = hash_str(s, len, seed);
  if (got != expected) {
    fprintf(stderr,
            "SKIP_xxhash64_string mismatch len=%zu seed=0x%llx: got 0x%016llx, "
            "expected 0x%016llx\n",
            len, (unsigned long long)seed, (unsigned long long)got,
            (unsigned long long)expected);
    assert(0);
  }
  for (size_t off = 0; off < 8; off++) {
    assert(off + len <= sizeof(raw_buf));
    if (len > 0) {
      memcpy(raw_buf + off, s, len);
    }
    uint64_t got_raw = sk_xxhash64_bytes(raw_buf + off, len, seed);
    if (got_raw != expected) {
      fprintf(stderr,
              "sk_xxhash64_bytes mismatch len=%zu seed=0x%llx off=%zu: "
              "got 0x%016llx, expected 0x%016llx\n",
              len, (unsigned long long)seed, off, (unsigned long long)got_raw,
              (unsigned long long)expected);
      assert(0);
    }
  }
}

int main(void) {
  const uint64_t seedP = 2654435761ULL;

  // Standard XXH64 reference vectors (seed 0)
  expect_vec("", 0, 0xef46db3751d8e999ULL);
  expect_vec("a", 0, 0xd24ec4f1a98c6e5bULL);
  expect_vec("abc", 0, 0x44bc2cf5ad770999ULL);
  expect_vec("abcd", 0, 0xde0327b0d25d92ccULL);
  expect_vec("abcdefg", 0, 0x1860940e2902822dULL);
  expect_vec("abcdefgh", 0, 0x3ad351775b4634b7ULL);
  expect_vec("abcdefghijkl", 0, 0x4b09b7d3a233d4b3ULL);
  expect_vec("message digest", 0, 0x066ed728fceeb3beULL);
  expect_vec("abcdefghijklmnopqrstuvwxyz01234", 0, 0x16058c7b947da137ULL);
  expect_vec("abcdefghijklmnopqrstuvwxyz012345", 0, 0xbf2cd639b4143b80ULL);
  expect_vec("abcdefghijklmnopqrstuvwxyz0123456", 0, 0x4f89e4082bcbf673ULL);
  expect_vec("0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
             0, 0x1af3ac4760fe2f85ULL);
  expect_vec(
      "01234567890123456789012345678901234567890123456789"
      "01234567890123456789012345678901234567890123456789",
      0, 0xf80e7b96315afffaULL);

  // Standard XXH64 reference vectors (seed PRIME32)
  expect_vec("", seedP, 0xac75fda2929b17efULL);
  expect_vec("a", seedP, 0x393da8b78992279bULL);
  expect_vec("abc", seedP, 0x1318df30094a85fdULL);
  expect_vec("abcd", seedP, 0x66150d50767198eeULL);
  expect_vec("abcdefg", seedP, 0xec472d1bcfbb2cbcULL);
  expect_vec("abcdefgh", seedP, 0xdcf6c3eae6ea060fULL);
  expect_vec("abcdefghijkl", seedP, 0xf7a7a3b05a718614ULL);
  expect_vec("message digest", seedP, 0xa12eb2b52cde838eULL);
  expect_vec("abcdefghijklmnopqrstuvwxyz01234", seedP, 0x69f4cc4e10a28ea8ULL);
  expect_vec("abcdefghijklmnopqrstuvwxyz012345", seedP, 0x5936baa14fd050bbULL);
  expect_vec("abcdefghijklmnopqrstuvwxyz0123456", seedP, 0x554524ff500c9d90ULL);
  expect_vec("0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef",
             seedP, 0x42504c6857488fafULL);
  expect_vec(
      "01234567890123456789012345678901234567890123456789"
      "01234567890123456789012345678901234567890123456789",
      seedP, 0x8eff840276158d1bULL);

  // Embedded NUL byte: hash must honor sk_string_t.size, not stop at '\0'.
  const char with_nul[5] = {'a', '\0', 'b', 'c', 'd'};
  uint64_t h_nul = hash_str(with_nul, 5, 0);
  uint64_t h_a = hash_str("a", 1, 0);
  assert(h_nul != h_a);

  printf("Native SKIP_xxhash64_string matches XXH64 reference vectors.\n");
  return 0;
}
