// Build the Wasm runtime's SKIP_String__toFloat_raw (string.c with Ryu's s2d)
// so that to_float_raw.mjs can check it end to end, with the JS host providing
// SKIP_js_parse_float. Stubs stand in for the runtime pieces string.c needs.
#define SKIP32 1
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

char* input_string(uint32_t size) {
  input.header.size = size;
  input.data[size] = '\0';
  return input.data;
}
