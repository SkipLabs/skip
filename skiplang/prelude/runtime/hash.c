#include "runtime.h"

/*****************************************************************************/
/* Fast non-linear 64-bit hashing primitive (rapidhash, MIT-licensed).
 *
 * Adapted from rapidhash by Nicolas De Carli
 * (https://github.com/Nicoshev/rapidhash), derived from wyhash by Wang Yi
 * (public domain / Unlicense).
 *
 * Copyright (C) 2024 Nicolas De Carli
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
/*****************************************************************************/

#define SK_HASH_SEED UINT64_C(0xbdd89aa982704029)

static const uint64_t sk_rapid_secret[3] = {
    UINT64_C(0x2d358dccaa6c78a5),
    UINT64_C(0x8bb84b93962eacc9),
    UINT64_C(0x4b33a62ed433d4a3),
};

static inline void sk_rapid_mum(uint64_t* a, uint64_t* b) {
#if defined(__SIZEOF_INT128__) && !defined(__wasm__) && !defined(SKIP32)
  __uint128_t r = *a;
  r *= *b;
  *a = (uint64_t)r;
  *b = (uint64_t)(r >> 64);
#else
  // wasm32 defines __SIZEOF_INT128__, but 128-bit multiplies lower to
  // compiler-rt's __multi3 which is unavailable under -nostdlibinc.
  uint64_t ha = *a >> 32;
  uint64_t hb = *b >> 32;
  uint64_t la = (uint32_t)*a;
  uint64_t lb = (uint32_t)*b;
  uint64_t rh = ha * hb;
  uint64_t rm0 = ha * lb;
  uint64_t rm1 = hb * la;
  uint64_t rl = la * lb;
  uint64_t t = rl + (rm0 << 32);
  uint64_t c = t < rl;
  uint64_t lo = t + (rm1 << 32);
  c += lo < t;
  uint64_t hi = rh + (rm0 >> 32) + (rm1 >> 32) + c;
  *a = lo;
  *b = hi;
#endif
}

static inline uint64_t sk_rapid_mix(uint64_t a, uint64_t b) {
  sk_rapid_mum(&a, &b);
  return a ^ b;
}

static inline uint64_t sk_rapid_read64(const uint8_t* p) {
  uint64_t v;
  memcpy(&v, p, sizeof(uint64_t));
  return v;
}

static inline uint64_t sk_rapid_read32(const uint8_t* p) {
  uint32_t v;
  memcpy(&v, p, sizeof(uint32_t));
  return v;
}

static inline uint64_t sk_rapid_read_small(const uint8_t* p, size_t k) {
  return (((uint64_t)p[0]) << 56) | (((uint64_t)p[k >> 1]) << 32) | p[k - 1];
}

static uint64_t sk_rapidhash_bytes(const void* key, size_t len, uint64_t seed) {
  const uint8_t* p = (const uint8_t*)key;
  seed ^= sk_rapid_mix(seed ^ sk_rapid_secret[0], sk_rapid_secret[1]) ^ len;
  uint64_t a, b;

  if (len <= 16) {
    if (len >= 4) {
      const uint8_t* plast = p + len - 4;
      a = (sk_rapid_read32(p) << 32) | sk_rapid_read32(plast);
      uint64_t delta = ((len & 24) >> (len >> 3));
      b = (sk_rapid_read32(p + delta) << 32) | sk_rapid_read32(plast - delta);
    } else if (len > 0) {
      a = sk_rapid_read_small(p, len);
      b = 0;
    } else {
      a = 0;
      b = 0;
    }
  } else {
    size_t i = len;
    if (i > 48) {
      uint64_t see1 = seed;
      uint64_t see2 = seed;
      do {
        seed = sk_rapid_mix(sk_rapid_read64(p) ^ sk_rapid_secret[0],
                            sk_rapid_read64(p + 8) ^ seed);
        see1 = sk_rapid_mix(sk_rapid_read64(p + 16) ^ sk_rapid_secret[1],
                            sk_rapid_read64(p + 24) ^ see1);
        see2 = sk_rapid_mix(sk_rapid_read64(p + 32) ^ sk_rapid_secret[2],
                            sk_rapid_read64(p + 40) ^ see2);
        p += 48;
        i -= 48;
      } while (i >= 48);
      seed ^= see1 ^ see2;
    }
    if (i > 16) {
      seed = sk_rapid_mix(sk_rapid_read64(p) ^ sk_rapid_secret[2],
                          sk_rapid_read64(p + 8) ^ seed ^ sk_rapid_secret[1]);
      if (i > 32) {
        seed = sk_rapid_mix(sk_rapid_read64(p + 16) ^ sk_rapid_secret[2],
                            sk_rapid_read64(p + 24) ^ seed);
      }
    }
    a = sk_rapid_read64(p + i - 16);
    b = sk_rapid_read64(p + i - 8);
  }
  a ^= sk_rapid_secret[1];
  b ^= seed;
  sk_rapid_mum(&a, &b);
  return sk_rapid_mix(a ^ sk_rapid_secret[0] ^ len, b ^ sk_rapid_secret[1]);
}

static inline uint64_t sk_hash_u64(uint64_t state, uint64_t value) {
  return sk_rapid_mix(state ^ sk_rapid_secret[0], value ^ sk_rapid_secret[1]);
}

static inline uint64_t sk_hash_word(uint64_t state, const void* p) {
  uintptr_t w;
  memcpy(&w, p, sizeof(uintptr_t));
  return sk_hash_u64(state, (uint64_t)w);
}

SkipInt SKIP_hash_combine(SkipInt h1, SkipInt h2) {
  return (SkipInt)sk_hash_u64((uint64_t)h1, (uint64_t)h2);
}

/*****************************************************************************/
/* Hashing of SKIP objects. */
/*****************************************************************************/

static uint64_t sk_hash_string(char* obj) {
  size_t size = get_sk_string(obj)->size;  // don't need to hash nul terminator
  return sk_rapidhash_bytes(obj, size, SK_HASH_SEED);
}

static uint64_t sk_hash_obj(sk_stack_t* st, char* obj) {
  if (obj < (char*)64) {
    return (uint64_t)(uintptr_t)obj;
  }

  // Check if we are dealing with a string
  if (SKIP_is_string(obj)) {
    return sk_hash_string(obj);
  }

  uint64_t h = SK_HASH_SEED;
  SKIP_gc_type_t* ty = get_gc_type(obj);

  size_t len = skip_object_len(ty, obj);
  size_t memsize = ty->m_userByteSize * len;

  if ((ty->m_refsHintMask & 1) == 0) {
    h = sk_rapidhash_bytes(obj, memsize, h);
  } else {
    const size_t refMaskWordBitSize = sizeof(ty->m_refMask[0]) * 8;
    char* ohead = obj;
    char* end = obj + memsize;

    while (ohead < end) {
      size_t size = ty->m_userByteSize;
      size_t mask_slot = 0;
      while (size > 0) {
        unsigned int i;
        for (i = 0; i < refMaskWordBitSize && size > 0; i++) {
          if ((ty->m_refMask[mask_slot] >> i) & 1) {
            void** ptr = (void**)ohead;
            if (*ptr != NULL) {
              // Mix a distinct non-NULL marker so ref-slot presence/position
              // is preserved when NULL and non-NULL slots are swapped (e.g.
              // Foo(None(), Some(x)) vs Foo(Some(x), None())).
              h = sk_hash_u64(h, UINT64_C(1));
              sk_stack_push(st, ptr, ptr);
            } else {
              h = sk_hash_u64(h, UINT64_C(0));
            }
          } else {
            h = sk_hash_word(h, ohead);
          }
          ohead += sizeof(void*);
          size -= sizeof(void*);
        }
        mask_slot++;
      }
    }
  }

  // Mix element length so empty vs non-empty arrays and different array shapes
  // with identical concatenated fields remain distinct.
  h = sk_hash_u64(h, (uint64_t)len);
  // Hash the compiler-assigned nominal type identity (deterministic across
  // runs/ASLR in both debug and release builds, unlike the raw `ty` pointer).
  // Fall back to `ty` only for synthetic C test structs that leave
  // m_typeIdentity zeroed.
  uint64_t type_tag = ty->m_typeIdentity != 0 ? (uint64_t)ty->m_typeIdentity
                                              : (uint64_t)(uintptr_t)ty;
  h = sk_hash_u64(h, type_tag);

  return h;
}

#define HASH_INLINE_STACK_CAPACITY 64

uint64_t SKIP_hash(void* obj) {
  sk_value_t inline_buf[HASH_INLINE_STACK_CAPACITY];
  sk_stack_t st_holder;
  sk_stack_t* st = &st_holder;
  uint64_t h = SK_HASH_SEED;

  sk_stack_init_inline(st, inline_buf, HASH_INLINE_STACK_CAPACITY);
  sk_stack_push(st, &obj, 0);

  while (st->head > 0) {
    sk_value_t delayed = sk_stack_pop(st);
    void* toHash = *delayed.value;
    uint64_t obj_hash = sk_hash_obj(st, toHash);
    h = sk_hash_u64(h, obj_hash);
  }

  sk_stack_free(st);

  return h;
}
