// Build the Wasm runtime's SKIP_Float_toStringShortest (string.c with Ryu's
// d2s) so that float_to_string.mjs can check its output against JS. Stubs
// stand in for the runtime pieces string.c needs.
#define SKIP32 1
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

// One string at a time: each call reuses the buffer.
static char obstack[256];

char* SKIP_Obstack_alloc(size_t size) {
  if (size > sizeof(obstack)) __builtin_trap();
  return obstack;
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

double SKIP_js_parse_float(char* str) {
  (void)str;
  __builtin_trap();
}
