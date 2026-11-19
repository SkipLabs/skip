// Native end-to-end test of SKIP_String__toFloat_raw: Ryu s2d as the primary
// path (same as Wasm), the strtod fallback for inputs with more than 17
// non-zero digits, and independence from the process locale.
#define SKIP64 1
#include <assert.h>
#include <locale.h>
#include <math.h>
#include <stdio.h>
#include <string.h>

#include "../ryu/d2s.c"
#include "../ryu/s2d.c"
#include "../string.c"

sk_string_t* get_sk_string(char* obj) {
  return container_of(obj, sk_string_t, data);
}

__attribute__((noreturn)) void SKIP_throw_cruntime(int32_t code) {
  (void)code;
  __builtin_trap();
}

char* SKIP_Obstack_alloc(size_t size) {
  (void)size;
  __builtin_trap();
}

uint32_t SKIP_getArraySize(char* obj) {
  (void)obj;
  __builtin_trap();
}

void SKIP_invalid_utf8(void) {
  __builtin_trap();
}

char* SKIP_floatToString(double f) {
  (void)f;
  __builtin_trap();
}

// One Skip string: header, then up to 255 bytes plus a terminator.
static struct {
  sk_string_t header;
  char data[256];
} input;

static double parse(const char* str) {
  size_t size = strlen(str);
  assert(size < 255);
  memcpy(input.data, str, size);
  input.header.size = (uint32_t)size;
  input.data[size] = '\0';
  return SKIP_String__toFloat_raw(input.data);
}

// Bit-for-bit comparison, so -0.0 is told apart from 0.0.
static void expect(const char* str, double expected) {
  double got = parse(str);
  if (memcmp(&got, &expected, sizeof(double)) != 0) {
    fprintf(stderr, "%s: got %.17g, expected %.17g\n", str, got, expected);
    assert(0);
  }
}

int main(void) {
  // s2d path (up to 17 significant digits).
  expect("0.1", 0.1);
  expect("0.30000000000000004", 0.30000000000000004);
  expect("5.", 5.0);
  expect("0e0", 0.0);
  expect("1e0", 1.0);
  expect("10e-1", 1.0);
  expect("1E5", 100000.0);
  // Correctly rounds to the largest subnormal, not the smallest normal.
  expect("2.2250738585072011e-308", 2.2250738585072009e-308);
  expect("1.7976931348623157e308", 1.7976931348623157e308);
  expect("1.8e308", HUGE_VAL);  // overflows to infinity
  expect("1e-400", 0.0);        // underflows to zero
  expect("5e-324", 5e-324);     // smallest subnormal
  double neg_zero = -0.0;
  expect("-0.0e0", neg_zero);

  // Fallback path (more than 17 non-zero digits): strtod, correctly rounded.
  expect("123456789012345678", 123456789012345680.0);
  expect("0.1000000000000000000000000000001", 0.1);
  expect("99999999999999999999", 1e20);

  // strtod is locale-dependent; the input uses '.' so the runtime must still
  // parse "1.5" as 1.5 (not 1) under a comma-decimal locale, when installed.
  if (setlocale(LC_ALL, "de_DE.UTF-8") != NULL) {
    expect("1.5", 1.5);
    expect("0.1000000000000000000000000000001", 0.1);
  }

  printf("Native String.toFloat_raw matches expected doubles.\n");
  return 0;
}
