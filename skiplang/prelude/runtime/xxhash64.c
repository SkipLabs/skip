#include "runtime.h"

#define XXH64_PRIME1 0x9E3779B185EBCA87ULL
#define XXH64_PRIME2 0xC2B2AE3D27D4EB4FULL
#define XXH64_PRIME3 0x165667B19E3779F9ULL
#define XXH64_PRIME4 0x85EBCA77C2B2AE63ULL
#define XXH64_PRIME5 0x27D4EB2F165667C5ULL

static inline uint64_t xxh64_rotl(uint64_t x, unsigned int r) {
  return (x << r) | (x >> (64 - r));
}

static inline uint64_t xxh64_read64le(const uint8_t* p) {
  uint64_t v;
  memcpy(&v, p, sizeof(v));
  return v;
}

static inline uint32_t xxh64_read32le(const uint8_t* p) {
  uint32_t v;
  memcpy(&v, p, sizeof(v));
  return v;
}

static inline uint64_t xxh64_round(uint64_t acc, uint64_t input) {
  acc += input * XXH64_PRIME2;
  acc = xxh64_rotl(acc, 31);
  acc *= XXH64_PRIME1;
  return acc;
}

static inline uint64_t xxh64_merge_round(uint64_t acc, uint64_t val) {
  val = xxh64_round(0, val);
  acc ^= val;
  acc = acc * XXH64_PRIME1 + XXH64_PRIME4;
  return acc;
}

static inline uint64_t xxh64_avalanche(uint64_t h) {
  h ^= h >> 33;
  h *= XXH64_PRIME2;
  h ^= h >> 29;
  h *= XXH64_PRIME3;
  h ^= h >> 32;
  return h;
}

static uint64_t sk_xxhash64_bytes(const uint8_t* data, size_t len,
                                  uint64_t seed) {
  const uint8_t* p = data;
  const uint8_t* const end = data + len;
  uint64_t h;

  if (len >= 32) {
    const uint8_t* const limit = end - 32;
    uint64_t v1 = seed + XXH64_PRIME1 + XXH64_PRIME2;
    uint64_t v2 = seed + XXH64_PRIME2;
    uint64_t v3 = seed;
    uint64_t v4 = seed - XXH64_PRIME1;

    do {
      v1 = xxh64_round(v1, xxh64_read64le(p));
      p += 8;
      v2 = xxh64_round(v2, xxh64_read64le(p));
      p += 8;
      v3 = xxh64_round(v3, xxh64_read64le(p));
      p += 8;
      v4 = xxh64_round(v4, xxh64_read64le(p));
      p += 8;
    } while (p <= limit);

    h = xxh64_rotl(v1, 1) + xxh64_rotl(v2, 7) + xxh64_rotl(v3, 12) +
        xxh64_rotl(v4, 18);
    h = xxh64_merge_round(h, v1);
    h = xxh64_merge_round(h, v2);
    h = xxh64_merge_round(h, v3);
    h = xxh64_merge_round(h, v4);
  } else {
    h = seed + XXH64_PRIME5;
  }

  h += (uint64_t)len;

  while (p + 8 <= end) {
    uint64_t k1 = xxh64_round(0, xxh64_read64le(p));
    h ^= k1;
    h = xxh64_rotl(h, 27) * XXH64_PRIME1 + XXH64_PRIME4;
    p += 8;
  }

  if (p + 4 <= end) {
    h ^= (uint64_t)xxh64_read32le(p) * XXH64_PRIME1;
    h = xxh64_rotl(h, 23) * XXH64_PRIME2 + XXH64_PRIME3;
    p += 4;
  }

  while (p < end) {
    h ^= (uint64_t)(*p) * XXH64_PRIME5;
    h = xxh64_rotl(h, 11) * XXH64_PRIME1;
    p++;
  }

  return xxh64_avalanche(h);
}

SkipInt SKIP_xxhash64_string(char* obj, SkipInt seed) {
  sk_string_t* str = get_sk_string(obj);
  return (SkipInt)sk_xxhash64_bytes((const uint8_t*)obj, (size_t)str->size,
                                    (uint64_t)seed);
}
