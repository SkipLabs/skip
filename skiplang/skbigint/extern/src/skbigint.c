/*
 * skbigint: Skip runtime bindings for arbitrary-precision integers.
 *
 * Wraps the vendored libtommath (extern/libtommath, public domain) so that
 * skiplang code can compute with big integers through plain decimal strings:
 * a skip `String` maps to `char*` here, and every SKBIGINT_* function takes
 * and/or returns such strings. Inputs to the arithmetic functions must be in
 * canonical form (as produced by SKBIGINT_normalize/SKBIGINT_from_i64), which
 * the skiplang BigInt class guarantees by construction.
 */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "tommath.h"

uint32_t SKIP_String_byteSize(char*);
char* sk_string_create(const char* buffer, uint32_t size);

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

/* Parse a (canonical) decimal string into a fresh mp_int. */
static mp_int* parse_decimal(char* s) {
  char* buf = dup_skip_string(s);
  mp_int* r;
  if (buf == NULL) {
    return NULL;
  }
  r = (mp_int*)malloc(sizeof(mp_int));
  if (r == NULL) {
    free(buf);
    return NULL;
  }
  if (mp_init(r) != MP_OKAY) {
    free(r);
    free(buf);
    return NULL;
  }
  if (mp_read_radix(r, buf, 10) != MP_OKAY) {
    mp_clear(r);
    free(r);
    free(buf);
    return NULL;
  }
  free(buf);
  return r;
}

/* Render an mp_int as a freshly allocated skip string (canonical decimal). */
static char* emit_decimal(mp_int* v) {
  int size = 0;
  char* buf;
  size_t written = 0;
  char* res;
  if (mp_radix_size(v, 10, &size) != MP_OKAY) {
    return NULL;
  }
  /* mp_radix_size counts the NUL terminator. */
  buf = (char*)malloc((size_t)size);
  if (buf == NULL) {
    return NULL;
  }
  if (mp_to_radix(v, buf, (size_t)size, &written, 10) != MP_OKAY) {
    free(buf);
    return NULL;
  }
  /* mp_to_radix's `written` counts the NUL terminator. */
  res = sk_string_create(buf, (uint32_t)(written - 1));
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

/* Canonicalize a valid decimal string ("007" -> "7", "-0" -> "0"). */
char* SKBIGINT_normalize(char* s) {
  mp_int* v = parse_decimal(s);
  char* res;
  if (v == NULL) {
    return NULL;
  }
  res = emit_decimal(v);
  free_mp(v);
  return res;
}

char* SKBIGINT_from_i64(int64_t v) {
  mp_int r;
  char* res;
  if (mp_init(&r) != MP_OKAY) {
    return NULL;
  }
  mp_set_i64(&r, v);
  res = emit_decimal(&r);
  mp_clear(&r);
  return res;
}

typedef mp_err (*binop_fn)(const mp_int*, const mp_int*, mp_int*);

static char* compute_binop(char* a, char* b, binop_fn f) {
  mp_int* x = parse_decimal(a);
  mp_int* y;
  mp_int r;
  char* res;
  if (x == NULL) {
    return NULL;
  }
  y = parse_decimal(b);
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
  res = emit_decimal(&r);
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
  mp_int* x = parse_decimal(a);
  mp_int* y;
  mp_int q;
  char* res;
  if (x == NULL) {
    return NULL;
  }
  y = parse_decimal(b);
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
  res = emit_decimal(&q);
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
  mp_int* x = parse_decimal(a);
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
  res = emit_decimal(&r);
  mp_clear(&r);
  free_mp(x);
  return res;
}

char* SKBIGINT_gcd(char* a, char* b) {
  return compute_binop(a, b, mp_gcd);
}

static char* compute_unop(char* a, mp_err (*f)(const mp_int*, mp_int*)) {
  mp_int* x = parse_decimal(a);
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
  res = emit_decimal(&r);
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
  mp_int* x = parse_decimal(a);
  mp_int* y;
  int64_t res;
  if (x == NULL) {
    return 0;
  }
  y = parse_decimal(b);
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
  mp_int* x = parse_decimal(a);
  int64_t res;
  if (x == NULL) {
    return 0;
  }
  res = mp_iszero(x) ? 1 : 0;
  free_mp(x);
  return res;
}
