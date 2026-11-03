// Exercise the actual object traversals with references above bit 31 and in a
// second mask word. Stack entries are inspected before following their targets.
// Compile with function/data sections and --gc-sections (see README.md).
#define SKIP64 1
#include <assert.h>
#include <stdlib.h>
#include "../copy.c"
#include "../intern.c"
#include "../free.c"
#include "../hash.c"
#include "../native_eq.c"
#include "../runtime.c"
#include "../string.c"
#include "../stack.c"

static void *last_allocation;
void *sk_malloc(size_t size) {
  void *p = malloc(size);
  assert(p);
  return p;
}
void sk_free_size(void *p, size_t size) { (void)size; free(p); }
void *sk_palloc(size_t size) { return last_allocation = sk_malloc(size); }
char *SKIP_Obstack_alloc(size_t size) { return sk_palloc(size); }
void sk_pfree_size(void *p, size_t size) { (void)p; (void)size; }
void sk_obstack_attach_page(sk_obstack_t *p, sk_obstack_t *next) {
  (void)p; (void)next; abort();
}
int sk_is_nofile_mode(void) { return 1; }
char *sk_get_external_pointer_destructor(char *p) { (void)p; abort(); }
uint32_t sk_get_external_pointer_value(char *p) { (void)p; abort(); }
uint32_t sk_get_magic_number(char *p) { (void)p; abort(); }
void sk_call_external_pointer_destructor(char *p, uint32_t n) {
  (void)p; (void)n; abort();
}
void SKIP_throw_cruntime(int32_t code) { (void)code; abort(); }

enum { WORDS = 72, REFERENCES = 6 };
static const size_t slots[REFERENCES] = {0, 31, 32, 63, 64, 70};
static struct {
  SKIP_gc_type_t type;
  SkipInt masks[2];
} metadata;
static void *vtable[2] = {NULL, &metadata};

static void check_stack(sk_stack_t *stack, char *object, size_t length,
                        int indirect) {
  assert(stack->head == length * REFERENCES);
  for (size_t element = 0; element < length; element++) {
    for (size_t i = 0; i < REFERENCES; i++) {
      void **field = (void **)object + element * WORDS + slots[i];
      void *actual = stack->values[element * REFERENCES + i].value;
      assert(actual == (indirect ? (void *)field : *field));
    }
  }
  stack->head = 0;
}

static void check_kind(int array) {
  size_t length = array ? 2 : 1;
  size_t prefix = array ? 24 : 16;  // Includes the persistent refcount.
  char *storage = calloc(1, prefix + length * WORDS * sizeof(void *));
  char *object = storage + prefix;
  assert(storage);
  *(void ***)(object - sizeof(void *)) = vtable;
  if (array) *(uint32_t *)(object - 12) = (uint32_t)length;
  metadata.type.m_refsHintMask = 1;
  metadata.type.m_kind = array ? kSkipGcKindArray : kSkipGcKindClass;
  metadata.type.m_userByteSize = WORDS * sizeof(void *);
  metadata.masks[0] = UINT64_C(1) | (UINT64_C(1) << 31) |
                      (UINT64_C(1) << 32) | (UINT64_C(1) << 63);
  metadata.masks[1] = UINT64_C(1) | (UINT64_C(1) << 6);
  for (size_t i = 0; i < length * WORDS; i++)
    ((uintptr_t *)object)[i] = 0x1000 + i * 16;
  sk_stack_t stack;
  sk_stack_init(&stack, 64);

  puts("copy"); fflush(stdout);
  char *copy = SKIP_copy_obj(&stack, object, NULL);
  assert(!memcmp(copy, object, length * WORDS * sizeof(void *)));
  check_stack(&stack, object, length, 1);
  free(last_allocation);
  puts("intern"); fflush(stdout);
  char *interned = SKIP_intern_obj(&stack, object);
  assert(!memcmp(interned, object, length * WORDS * sizeof(void *)));
  check_stack(&stack, object, length, 1);
  free(last_allocation);
  puts("free"); fflush(stdout);
  sk_free_obj(&stack, object);
  check_stack(&stack, object, length, 0);
  puts("hash"); fflush(stdout);
  (void)sk_hash_obj(&stack, object);
  check_stack(&stack, object, length, 1);

  // Distinct reference pointers must be compared through the recursive stack;
  // differing scalar data must be detected directly, including above bit 31.
  char *other_storage = sk_malloc(prefix + length * WORDS * sizeof(void *));
  memcpy(other_storage, storage, prefix + length * WORDS * sizeof(void *));
  char *other = other_storage + prefix;
  for (size_t element = 0; element < length; element++)
    for (size_t i = 0; i < REFERENCES; i++)
      ((uintptr_t *)other)[element * WORDS + slots[i]] += 8;
  puts("equality"); fflush(stdout);
  assert(SKIP_native_eq_obj(&stack, object, other) == 0);
  check_stack(&stack, object, length, 0);
  ((uintptr_t *)other)[33] += 8;
  assert(SKIP_native_eq_obj(&stack, object, other) != 0);
  sk_stack_free(&stack);
  free(other_storage);
  free(storage);
}

int main(void) {
  check_kind(0);
  check_kind(1);
  puts("reference masks: OK");
  return 0;
}
