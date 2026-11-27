#include "runtime.h"

/*****************************************************************************/
/* Stack implementation. */
/*****************************************************************************/

// The MSB of `capacity` marks a caller-owned inline buffer (e.g. stack-local)
// that must not be freed by `sk_stack_free` or `sk_stack_grow`.
#define SK_STACK_INLINE_BIT ((size_t)1 << (sizeof(size_t) * 8 - 1))

static inline size_t sk_stack_capacity(const sk_stack_t* st) {
  return st->capacity & ~SK_STACK_INLINE_BIT;
}

static inline int sk_stack_is_inline(const sk_stack_t* st) {
  return (st->capacity & SK_STACK_INLINE_BIT) != 0;
}

void sk_stack_init(sk_stack_t* st, size_t capacity) {
  st->head = 0;
  st->capacity = capacity;
  st->values = (sk_value_t*)sk_malloc(sizeof(sk_value_t) * capacity);
}

void sk_stack_init_inline(sk_stack_t* st, sk_value_t* buf, size_t capacity) {
  st->head = 0;
  st->capacity = capacity | SK_STACK_INLINE_BIT;
  st->values = buf;
}

void sk_stack_free(sk_stack_t* st) {
  if (!sk_stack_is_inline(st)) {
    sk_free_size(st->values, sizeof(sk_value_t) * sk_stack_capacity(st));
  }
}

void sk_stack_grow(sk_stack_t* st) {
  size_t cap = sk_stack_capacity(st);
  sk_stack_t new_st;
  new_st.head = 0;
  new_st.capacity = cap * 2;
  new_st.values = (sk_value_t*)sk_malloc(sizeof(sk_value_t) * new_st.capacity);
  for (; new_st.head < cap; new_st.head++) {
    new_st.values[new_st.head] = st->values[new_st.head];
  }
  if (!sk_stack_is_inline(st)) {
    sk_free_size(st->values, sizeof(sk_value_t) * cap);
  }
  st->head = new_st.head;
  st->capacity = new_st.capacity;
  st->values = new_st.values;
}

void sk_stack_push(sk_stack_t* st, void** value, void** slot) {
  st->values[st->head].value = value;
  st->values[st->head].slot = slot;
  st->head++;
  if (st->head >= sk_stack_capacity(st)) {
    sk_stack_grow(st);
  }
}

sk_value_t sk_stack_pop(sk_stack_t* st) {
  st->head--;
  return st->values[st->head];
}

/*****************************************************************************/
/* Stack with 3 values implementation. */
/*****************************************************************************/

void sk_stack3_init(sk_stack3_t* st, size_t capacity) {
  st->head = 0;
  st->capacity = capacity;
  st->values = (sk_value3_t*)sk_malloc(sizeof(sk_value3_t) * capacity);
}

void sk_stack3_free(sk_stack3_t* st) {
  sk_free_size(st->values, sizeof(sk_value3_t) * st->capacity);
}

void sk_stack3_grow(sk_stack3_t* st) {
  sk_stack3_t new_st;
  new_st.head = 0;
  new_st.capacity = st->capacity * 2;
  new_st.values =
      (sk_value3_t*)sk_malloc(sizeof(sk_value3_t) * new_st.capacity);
  for (; new_st.head < st->capacity; new_st.head++) {
    new_st.values[new_st.head] = st->values[new_st.head];
  }
  sk_free_size(st->values, sizeof(sk_value3_t) * st->capacity);
  st->head = new_st.head;
  st->capacity = new_st.capacity;
  st->values = new_st.values;
}

void sk_stack3_push(sk_stack3_t* st, void* value1, void* value2, void* value3) {
  st->values[st->head].value1 = value1;
  st->values[st->head].value2 = value2;
  st->values[st->head].value3 = value3;
  st->head++;
  if (st->head >= st->capacity) {
    sk_stack3_grow(st);
  }
}

sk_value3_t sk_stack3_pop(sk_stack3_t* st) {
  st->head--;
  return st->values[st->head];
}
