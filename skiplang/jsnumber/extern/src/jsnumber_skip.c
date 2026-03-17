/**
 * C glue between Ryu and Skip for JavaScript Number.toString() formatting.
 *
 * Calls Ryu's d2s_buffered_n() to get the shortest decimal representation,
 * then reformats the output to match JavaScript's Number.prototype.toString():
 *
 *   Ryu format:    "1E0", "1E-1", "3.14E0", "1.23E2"
 *   JS format:     "1",   "0.1",  "3.14",   "123"
 *
 * JS rules:
 *   - Fixed notation when decimal exponent is in [-6, 20]
 *   - Exponential notation otherwise (lowercase 'e', explicit '+' sign)
 *   - No trailing zeros after decimal point
 *   - Integer values have no decimal point
 *   - -0 → "0"
 *   - NaN → "NaN", +Infinity → "Infinity", -Infinity → "-Infinity"
 */

#include <math.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "ryu.h"

uint32_t SKIP_String_byteSize(char*);
char* sk_string_create(const char* buffer, uint32_t size);

/**
 * Format a double as JavaScript's Number.prototype.toString() would.
 *
 * Strategy: call Ryu to get shortest-representation in scientific notation,
 * parse the mantissa digits and exponent, then reformat per JS rules.
 */
char* SKIP_JSNumber_toString(double value) {
  /* Ryu handles NaN, Infinity, -Infinity with the right strings already. */
  if (isnan(value)) {
    return sk_string_create("NaN", 3);
  }
  if (isinf(value)) {
    if (value > 0) return sk_string_create("Infinity", 8);
    return sk_string_create("-Infinity", 9);
  }
  /* JS: -0 → "0" */
  if (value == 0.0) {
    return sk_string_create("0", 1);
  }

  /* Get Ryu's shortest representation.
   * Format: ['-'] digit ['.' digits] 'E' ['-'] digits
   * Examples: "1E0", "-1E0", "1E-1", "3.14E0", "1.23E2", "1E21"
   */
  char ryu_buf[32];
  int ryu_len = d2s_buffered_n(value, ryu_buf);
  ryu_buf[ryu_len] = '\0';

  /* Parse the Ryu output. */
  int pos = 0;
  int is_neg = 0;
  if (ryu_buf[pos] == '-') {
    is_neg = 1;
    pos++;
  }

  /* Collect mantissa digits (without the decimal point). */
  char digits[20]; /* max 17 significant digits */
  int ndigits = 0;

  while (ryu_buf[pos] != 'E') {
    if (ryu_buf[pos] != '.') {
      digits[ndigits++] = ryu_buf[pos];
    }
    pos++;
  }
  pos++; /* skip 'E' */

  /* Parse exponent. */
  int exp_neg = 0;
  if (ryu_buf[pos] == '-') {
    exp_neg = 1;
    pos++;
  }
  int ryu_exp = 0;
  while (pos < ryu_len) {
    ryu_exp = ryu_exp * 10 + (ryu_buf[pos] - '0');
    pos++;
  }
  if (exp_neg) ryu_exp = -ryu_exp;

  /* ryu_exp is the exponent in Ryu's scientific notation: value = d.ddd *
   * 10^ryu_exp In terms of our digits array, the decimal point is after
   * digits[0], so the value is: 0.digits * 10^(ryu_exp+1) Or equivalently: the
   * first digit has place value 10^ryu_exp.
   *
   * dot_pos = ryu_exp + 1 is the number of digits before the decimal point.
   * For example:
   *   "1E0"     → digits="1", ryu_exp=0,  dot_pos=1  → "1"
   *   "1E-1"    → digits="1", ryu_exp=-1, dot_pos=0  → "0.1"
   *   "1.23E2"  → digits="123", ryu_exp=2, dot_pos=3 → "123"
   *   "3.14E0"  → digits="314", ryu_exp=0, dot_pos=1 → "3.14"
   *   "1E21"    → digits="1", ryu_exp=21, dot_pos=22 → "1e+21"
   */
  int dot_pos = ryu_exp + 1; /* digits before decimal point */

  char out[350];
  int out_len = 0;

  if (is_neg) {
    out[out_len++] = '-';
  }

  if (dot_pos >= 1 && dot_pos <= 21) {
    /* Fixed notation, value >= 1 (or at least the integer part is non-empty).
     * dot_pos digits before the point, rest after. */
    if (dot_pos <= ndigits) {
      /* There are digits on both sides of the decimal point. */
      memcpy(out + out_len, digits, dot_pos);
      out_len += dot_pos;
      if (dot_pos < ndigits) {
        out[out_len++] = '.';
        memcpy(out + out_len, digits + dot_pos, ndigits - dot_pos);
        out_len += ndigits - dot_pos;
      }
    } else {
      /* All digits are before the decimal point, pad with zeros. */
      memcpy(out + out_len, digits, ndigits);
      out_len += ndigits;
      int zeros = dot_pos - ndigits;
      memset(out + out_len, '0', zeros);
      out_len += zeros;
    }
  } else if (dot_pos <= 0 && dot_pos >= -5) {
    /* Fixed notation, value < 1: "0." + leading zeros + digits.
     * dot_pos <= 0 means -dot_pos leading zeros after "0." */
    out[out_len++] = '0';
    out[out_len++] = '.';
    int leading_zeros = -dot_pos;
    memset(out + out_len, '0', leading_zeros);
    out_len += leading_zeros;
    memcpy(out + out_len, digits, ndigits);
    out_len += ndigits;
  } else {
    /* Exponential notation. */
    out[out_len++] = digits[0];
    if (ndigits > 1) {
      out[out_len++] = '.';
      memcpy(out + out_len, digits + 1, ndigits - 1);
      out_len += ndigits - 1;
    }
    out[out_len++] = 'e';
    int js_exp = ryu_exp; /* = dot_pos - 1 */
    if (js_exp >= 0) {
      out[out_len++] = '+';
    } else {
      out[out_len++] = '-';
      js_exp = -js_exp;
    }
    /* Write exponent digits (no leading zeros). */
    if (js_exp >= 100) {
      out[out_len++] = (char)('0' + js_exp / 100);
      js_exp %= 100;
      out[out_len++] = (char)('0' + js_exp / 10);
      out[out_len++] = (char)('0' + js_exp % 10);
    } else if (js_exp >= 10) {
      out[out_len++] = (char)('0' + js_exp / 10);
      out[out_len++] = (char)('0' + js_exp % 10);
    } else {
      out[out_len++] = (char)('0' + js_exp);
    }
  }

  return sk_string_create(out, (uint32_t)out_len);
}

double SKIP_JSNumber_toFloat(char* str) {
  uint32_t size = SKIP_String_byteSize(str);
  /* Copy to null-terminated buffer for strtod. */
  char buf[330]; /* max double string ~325 chars */
  if (size >= sizeof(buf)) size = sizeof(buf) - 1;
  memcpy(buf, str, size);
  buf[size] = '\0';
  return strtod(buf, NULL);
}

double SKIP_JSNumber_fromBits(int64_t bits) {
  double result;
  memcpy(&result, &bits, sizeof(double));
  return result;
}
