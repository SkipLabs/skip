#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern size_t sk_slot_of_size(size_t);
extern size_t sk_size_of_slot(size_t);
extern void sk_create_mapping(char*, size_t);
extern void* sk_palloc(size_t);
extern void sk_pfree_size(void*, size_t);
int SKIP_get_version(void) { return 1234; }
void SKIP_throw_cruntime(int code) { (void)code; abort(); }
int main(void) {
  for (size_t n = 0; n < 1048576; ++n) {
    size_t slot = sk_slot_of_size(n);
    size_t rounded = sk_size_of_slot(slot);
    assert(slot < 512);
    if (n > 256) assert(rounded - n < rounded / 8);
    assert(rounded >= n && rounded >= sizeof(void*));
    assert(rounded % sizeof(void*) == 0);
    assert(sk_slot_of_size(rounded) == slot);
    if (n <= 256) assert(rounded - n < sizeof(void*) || n == 0);
  }
  assert(sk_size_of_slot(sk_slot_of_size(520)) == 576);
  for (size_t bit = 8; bit < sizeof(size_t) * 8; ++bit) {
    size_t base = (size_t)1 << bit;
    size_t step = base >> 3;
    for (size_t part = 1; part <= 8; ++part) {
      if (bit == sizeof(size_t) * 8 - 1 && part == 8) continue;
      size_t boundary = base + part * step;
      assert(sk_size_of_slot(sk_slot_of_size(boundary)) == boundary);
      assert(sk_size_of_slot(sk_slot_of_size(boundary - 1)) == boundary);
      assert(sk_slot_of_size(boundary) < 512);
      if (part < 8 && !(bit == sizeof(size_t) * 8 - 1 && part == 7)) {
        assert(sk_size_of_slot(sk_slot_of_size(boundary + 1)) == boundary + step);
      }
    }
  }
  sk_create_mapping(NULL, 16 * 1024 * 1024);
  for (size_t n = 1; n <= 4096; ++n) {
    void* block = sk_palloc(n);
    memset(block, 0x5a, n);
    size_t rounded = sk_size_of_slot(sk_slot_of_size(n));
    sk_pfree_size(block, n);
    void* reused = sk_palloc(rounded);
    assert(reused == block);
    memset(reused, 0xa5, rounded);
    sk_pfree_size(reused, rounded);
  }
  puts("allocator classes and free-list reuse: PASS");
}
