// Compile natively to check size classes, or with SKIP32 to exercise the Wasm
// allocator too. Wasm exports check_size_classes and check_overflow for Node.
#include "../alloc_size_classes.h"
#ifdef SKIP32
#include "../memory.c"
#endif

__attribute__((noreturn)) void SKIP_throw_cruntime(int32_t code) {
  (void)code;
  __builtin_trap();
}

int check_size_classes(void) {
  size_t last = 0;
  for (size_t size = 0; size <= 1048576; size++) {
    slot_t slot = sk_slot_of_size(size);
    size_t rounded = sk_size_of_slot(slot);
    if (slot >= SK_ALLOC_SLOT_COUNT || rounded < size || rounded < last ||
        rounded % sizeof(void*) || sk_slot_of_size(rounded) != slot)
      return 1;
    if (slot && sk_size_of_slot(slot - 1) >= size) return 2;
    if (size <= 256 && rounded != (size ? (size + sizeof(void*) - 1) /
                                              sizeof(void*) * sizeof(void*)
                                        : sizeof(void*)))
      return 3;
    if (size > 256 && rounded - size > (rounded >> 3)) return 4;
    last = rounded;
  }
  // Exercise every class boundary, including the largest representable class.
  for (slot_t slot = 0; slot + 1 < SK_ALLOC_SLOT_COUNT; slot++) {
    size_t rounded = sk_size_of_slot(slot);
    if (sk_slot_of_size(rounded) != slot) return 5;
    if (slot && sk_slot_of_size(sk_size_of_slot(slot - 1) + 1) != slot)
      return 6;
  }
#ifdef SKIP32
  for (size_t size = 0; size <= 8192; size++) {
    void* first = sk_palloc(size);
    sk_pfree_size(first, size);
    void* second = sk_palloc(size);
    if (first != second) return 7;
    sk_pfree_size(second, size);
  }
  if (total_size != 0) return 8;
#endif
  return 0;
}

void check_overflow(void) {
  (void)sk_slot_of_size(SIZE_MAX);
}
#ifndef SKIP32
int main(void) {
  return check_size_classes();
}
#endif
