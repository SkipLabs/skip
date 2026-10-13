#ifndef SKIP_ALLOC_SIZE_CLASSES_H
#define SKIP_ALLOC_SIZE_CLASSES_H

#include "runtime.h"

typedef size_t slot_t;

static inline size_t sk_alloc_bit_width(size_t size) {
#if defined(__has_builtin) && __has_builtin(__builtin_stdc_bit_width)
  return __builtin_stdc_bit_width(size);
#else
  return size ? (size_t)(sizeof(size_t) * 8UL - __builtin_clzl(size)) : 0;
#endif
}

// Exact word-sized classes through 256 bytes; eight classes per doubling above.
// Native persisted free lists require a format change if class numbering
// changes.
#define SMALL_ALLOC_LIMIT 256
#define SMALL_ALLOC_SLOTS (SMALL_ALLOC_LIMIT / sizeof(void*))

static inline slot_t sk_slot_of_size(size_t size) {
  if (size <= SMALL_ALLOC_LIMIT) {
    if (size < sizeof(void*)) size = sizeof(void*);
    return (size + sizeof(void*) - 1) / sizeof(void*) - 1;
  }
  size_t exponent = sk_alloc_bit_width(size - 1) - 1;
  size_t base = (size_t)1 << exponent;
  size_t step = base >> 3;
  size_t part = (size - base - 1) / step + 1;
  // The final class of the largest octave would round to SIZE_MAX + 1.
  if (exponent == sizeof(size_t) * 8 - 1 && part == 8) {
    SKIP_throw_cruntime(ERROR_OUT_OF_MEMORY);
  }
  return SMALL_ALLOC_SLOTS + (exponent - 8) * 8 + part - 1;
}

static inline size_t sk_size_of_slot(slot_t slot) {
  if (slot < SMALL_ALLOC_SLOTS) return (slot + 1) * sizeof(void*);
  size_t index = slot - SMALL_ALLOC_SLOTS;
  size_t base = (size_t)1 << (8 + index / 8);
  return base + (index % 8 + 1) * (base >> 3);
}

#define SK_ALLOC_SLOT_COUNT (SMALL_ALLOC_SLOTS + (sizeof(size_t) * 8 - 8) * 8)

#endif
