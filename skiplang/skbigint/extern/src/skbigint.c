/*
 * skbigint: Skip runtime bindings for arbitrary-precision integers.
 *
 * Wraps the vendored libtommath (extern/libtommath, public domain, pinned in
 * .gitmodules). A big integer crosses the boundary as an "encoded" skip
 * String:
 *
 *   byte 0    : sign (0 = non-negative, 1 = negative)
 *   bytes 1.. : magnitude as little-endian 64-bit words, least significant
 *               word first, no trailing zero words (zero => empty magnitude,
 *               i.e. the encoding is the single byte 0x00)
 *
 * Arithmetic functions take and return encoded strings, so each call costs
 * only O(n) marshalling (mp_unpack/mp_pack); decimal conversion happens
 * exclusively in SKBIGINT_from_decimal/SKBIGINT_to_decimal. All memory is
 * either stack, transient malloc/free within one call, or owned by the Skip
 * GC (the returned strings), so there is nothing for the caller to free.
 */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "tommath.h"

uint32_t SKIP_String_byteSize(char*);
char* sk_string_create(const char* buffer, uint32_t size);

#define SKB_WORD_SIZE 8u

/* Copy a skip string into a NUL-terminated heap buffer. */
static char* dup_skip_string(char* s) {
  uint32_t n = SKIP_String_byteSize(s);
  char* buf = (char*)malloc((size_t)n + 1);
  if (buf == NULL) {
    return NULL;
  }
  memcpy(buf, s, n);
  buf[n] = '\0';
  return buf;
}

/* Decode an encoded string into a fresh mp_int. */
static mp_int* decode(char* enc) {
  uint32_t n = SKIP_String_byteSize(enc);
  mp_int* r;
  if (n == 0 || ((n - 1) % SKB_WORD_SIZE) != 0) {
    return NULL;
  }
  r = (mp_int*)malloc(sizeof(mp_int));
  if (r == NULL) {
    return NULL;
  }
  if (mp_init(r) != MP_OKAY) {
    free(r);
    return NULL;
  }
  if (n > 1) {
    if (mp_unpack(r, (n - 1) / SKB_WORD_SIZE, MP_LSB_FIRST, SKB_WORD_SIZE,
                  MP_LITTLE_ENDIAN, 0, enc + 1) != MP_OKAY) {
      mp_clear(r);
      free(r);
      return NULL;
    }
    if (enc[0] != 0 && !mp_iszero(r)) {
      r->sign = MP_NEG;
    }
  }
  return r;
}

/* Encode an mp_int as a freshly allocated skip string. */
static char* encode(mp_int* v) {
  size_t count;
  size_t total;
  size_t written = 0;
  char* buf;
  char* res;
  mp_clamp(v);
  count = mp_pack_count(v, 0, SKB_WORD_SIZE);
  total = 1 + count * SKB_WORD_SIZE;
  buf = (char*)malloc(total);
  if (buf == NULL) {
    return NULL;
  }
  buf[0] = (mp_isneg(v) && !mp_iszero(v)) ? 1 : 0;
  if (count > 0 && mp_pack(buf + 1, count, &written, MP_LSB_FIRST,
                           SKB_WORD_SIZE, MP_LITTLE_ENDIAN, 0, v) != MP_OKAY) {
    free(buf);
    return NULL;
  }
  res = sk_string_create(buf, (uint32_t)total);
  free(buf);
  return res;
}

static void free_mp(mp_int* v) {
  mp_clear(v);
  free(v);
}

/* Strictly validate a decimal integer string: optional '-', then one or
 * more ASCII digits, nothing else. */
int64_t SKBIGINT_check_decimal(char* s) {
  uint32_t n = SKIP_String_byteSize(s);
  uint32_t i = 0;
  if (n == 0) {
    return 0;
  }
  if (s[0] == '-') {
    i = 1;
    if (n == 1) {
      return 0;
    }
  }
  for (; i < n; i++) {
    if (s[i] < '0' || s[i] > '9') {
      return 0;
    }
  }
  return 1;
}

/* Canonical decimal string -> encoded. The input must pass
 * SKBIGINT_check_decimal; the result is normalized ("-0" -> zero). */
char* SKBIGINT_from_decimal(char* dec) {
  char* buf = dup_skip_string(dec);
  mp_int r;
  char* res;
  if (buf == NULL) {
    return NULL;
  }
  if (mp_init(&r) != MP_OKAY) {
    free(buf);
    return NULL;
  }
  if (mp_read_radix(&r, buf, 10) != MP_OKAY) {
    mp_clear(&r);
    free(buf);
    return NULL;
  }
  free(buf);
  res = encode(&r);
  mp_clear(&r);
  return res;
}

char* SKBIGINT_from_i64(int64_t v) {
  mp_int r;
  char* res;
  if (mp_init(&r) != MP_OKAY) {
    return NULL;
  }
  mp_set_i64(&r, v);
  res = encode(&r);
  mp_clear(&r);
  return res;
}

/* Encoded -> canonical decimal string. */
char* SKBIGINT_to_decimal(char* enc) {
  mp_int* v = decode(enc);
  int size = 0;
  char* buf;
  size_t written = 0;
  char* res;
  if (v == NULL) {
    return NULL;
  }
  if (mp_radix_size(v, 10, &size) != MP_OKAY) {
    free_mp(v);
    return NULL;
  }
  /* mp_radix_size counts the NUL terminator. */
  buf = (char*)malloc((size_t)size);
  if (buf == NULL) {
    free_mp(v);
    return NULL;
  }
  if (mp_to_radix(v, buf, (size_t)size, &written, 10) != MP_OKAY) {
    free(buf);
    free_mp(v);
    return NULL;
  }
  /* mp_to_radix's `written` counts the NUL terminator. */
  res = sk_string_create(buf, (uint32_t)(written - 1));
  free(buf);
  free_mp(v);
  return res;
}

typedef mp_err (*binop_fn)(const mp_int*, const mp_int*, mp_int*);

static char* compute_binop(char* a, char* b, binop_fn f) {
  mp_int* x = decode(a);
  mp_int* y;
  mp_int r;
  char* res;
  if (x == NULL) {
    return NULL;
  }
  y = decode(b);
  if (y == NULL) {
    free_mp(x);
    return NULL;
  }
  if (mp_init(&r) != MP_OKAY) {
    free_mp(y);
    free_mp(x);
    return NULL;
  }
  if (f(x, y, &r) != MP_OKAY) {
    mp_clear(&r);
    free_mp(y);
    free_mp(x);
    return NULL;
  }
  res = encode(&r);
  mp_clear(&r);
  free_mp(y);
  free_mp(x);
  return res;
}

char* SKBIGINT_add(char* a, char* b) {
  return compute_binop(a, b, mp_add);
}

char* SKBIGINT_sub(char* a, char* b) {
  return compute_binop(a, b, mp_sub);
}

char* SKBIGINT_mul(char* a, char* b) {
  return compute_binop(a, b, mp_mul);
}

/* Truncated division; the skiplang side rejects a zero divisor. */
char* SKBIGINT_div(char* a, char* b) {
  mp_int* x = decode(a);
  mp_int* y;
  mp_int q;
  char* res;
  if (x == NULL) {
    return NULL;
  }
  y = decode(b);
  if (y == NULL) {
    free_mp(x);
    return NULL;
  }
  if (mp_init(&q) != MP_OKAY) {
    free_mp(y);
    free_mp(x);
    return NULL;
  }
  if (mp_div(x, y, &q, NULL) != MP_OKAY) {
    mp_clear(&q);
    free_mp(y);
    free_mp(x);
    return NULL;
  }
  res = encode(&q);
  mp_clear(&q);
  free_mp(y);
  free_mp(x);
  return res;
}

/* Floored modulo (result takes the sign of the divisor); the skiplang side
 * rejects a zero divisor. */
char* SKBIGINT_mod(char* a, char* b) {
  return compute_binop(a, b, mp_mod);
}

/* a^e for e >= 0; the skiplang side rejects a negative exponent. */
char* SKBIGINT_pow(char* a, int64_t e) {
  mp_int* x = decode(a);
  mp_int r;
  char* res;
  if (x == NULL) {
    return NULL;
  }
  if (mp_init(&r) != MP_OKAY) {
    free_mp(x);
    return NULL;
  }
  if (mp_expt_n(x, (int)e, &r) != MP_OKAY) {
    mp_clear(&r);
    free_mp(x);
    return NULL;
  }
  res = encode(&r);
  mp_clear(&r);
  free_mp(x);
  return res;
}

char* SKBIGINT_gcd(char* a, char* b) {
  return compute_binop(a, b, mp_gcd);
}

static char* compute_unop(char* a, mp_err (*f)(const mp_int*, mp_int*)) {
  mp_int* x = decode(a);
  mp_int r;
  char* res;
  if (x == NULL) {
    return NULL;
  }
  if (mp_init(&r) != MP_OKAY) {
    free_mp(x);
    return NULL;
  }
  if (f(x, &r) != MP_OKAY) {
    mp_clear(&r);
    free_mp(x);
    return NULL;
  }
  res = encode(&r);
  mp_clear(&r);
  free_mp(x);
  return res;
}

char* SKBIGINT_abs(char* a) {
  return compute_unop(a, mp_abs);
}

char* SKBIGINT_neg(char* a) {
  return compute_unop(a, mp_neg);
}

int64_t SKBIGINT_cmp(char* a, char* b) {
  mp_int* x = decode(a);
  mp_int* y;
  int64_t res;
  if (x == NULL) {
    return 0;
  }
  y = decode(b);
  if (y == NULL) {
    free_mp(x);
    return 0;
  }
  res = (int64_t)mp_cmp(x, y);
  free_mp(y);
  free_mp(x);
  return res;
}

int64_t SKBIGINT_is_zero(char* a) {
  mp_int* x = decode(a);
  int64_t res;
  if (x == NULL) {
    return 0;
  }
  res = mp_iszero(x) ? 1 : 0;
  free_mp(x);
  return res;
}
