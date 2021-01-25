#include "runtime.h"

/*****************************************************************************/
/* Stack implementation. */
/*****************************************************************************/

void SKIP_stack_init(stack_t* st, size_t capacity) {
  st->head = 0;
  st->capacity = capacity;
  st->values = (value_t*)sk_malloc(sizeof(value_t) * capacity);
}

void SKIP_stack_free(stack_t* st) {
  sk_free_size(st->values, sizeof(value_t) * st->capacity);
}

void SKIP_stack_grow(stack_t* st) {
  stack_t new_st;
  new_st.head = 0;
  new_st.capacity = st->capacity * 2;
  new_st.values = (value_t*)sk_malloc(sizeof(value_t) * new_st.capacity);
  for(; new_st.head < st->capacity; new_st.head++) {
    new_st.values[new_st.head] = st->values[new_st.head];
  }
  sk_free_size(st->values, sizeof(value_t) * st->capacity);
  st->head = new_st.head;
  st->capacity = new_st.capacity;
  st->values = new_st.values;
}

void SKIP_stack_push(stack_t* st, void** value, void** slot) {
  st->values[st->head].value = value;
  st->values[st->head].slot = slot;
  st->head++;
  if(st->head >= st->capacity) {
    SKIP_stack_grow(st);
  }
}

value_t SKIP_stack_pop(stack_t* st) {
  st->head--;
  return st->values[st->head];
}
