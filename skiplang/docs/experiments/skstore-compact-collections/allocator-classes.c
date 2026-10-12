#include <assert.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
extern size_t sk_slot_of_size(size_t);
extern size_t sk_size_of_slot(size_t);
int main(void) {
  for (size_t n = 0; n < 1048576; ++n) {
    size_t slot = sk_slot_of_size(n);
    size_t rounded = sk_size_of_slot(slot);
    assert(slot < 96);
    assert(rounded >= n && rounded >= sizeof(void*));
    assert(rounded % sizeof(void*) == 0);
    assert(sk_slot_of_size(rounded) == slot);
    if (n <= 256) assert(rounded - n < sizeof(void*) || n == 0);
  }
  puts("allocator classes: PASS");
}
