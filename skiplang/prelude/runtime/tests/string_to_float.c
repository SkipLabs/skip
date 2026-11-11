// Build Ryu's s2d the way the Wasm runtime does (SKIP32, -nostdlibinc), so that
// string_to_float.mjs can compare it with JavaScript's correctly-rounded
// Number(). Linking without --allow-undefined also rejects compiler-rt calls
// such as __multi3 that the Wasm runtime cannot resolve.
#include "../ryu/s2d.c"

static char input[64];
static double output;

char* input_buffer(void) {
  return input;
}

int parse(int len) {
  return s2d_n(input, len, &output);
}

double result(void) {
  return output;
}
