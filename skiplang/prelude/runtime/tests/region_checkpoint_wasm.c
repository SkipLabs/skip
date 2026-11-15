// Exercise the real collector with four-byte pointers. Array and string data
// need not be eight-byte aligned, even though allocations have eight-byte
// sizes.
#define SKIP32 1
#define PAGE_SIZE 4096
#include "../copy.c"
#include "../memory.c"
#include "../obstack.c"
#include "../runtime.c"
#include "../stack.c"
#include "../stdlib.c"
#include "../string.c"

__attribute__((noreturn)) void SKIP_throw_cruntime(int32_t code) {
  (void)code;
  __builtin_trap();
}

static unsigned char* test_heap_end;
void reset_heap_end(void) {
  test_heap_end = (unsigned char*)(__builtin_wasm_memory_size(0) * 65536);
}
unsigned char* decr_heap_end(size_t size) {
  if (test_heap_end == NULL) reset_heap_end();
  test_heap_end -= size;
  if (test_heap_end <= bump_pointer) __builtin_trap();
  return test_heap_end;
}

typedef struct Node {
  struct Node* left;
  struct Node* right;
  size_t value;
} Node;
static struct {
  SKIP_gc_type_t type;
  SkipInt mask;
} node_type, array_type;
static void* node_vtable[2] = {NULL, &node_type};
static void* array_vtable[2] = {NULL, &array_type};

static Node* node(Node* left, Node* right, size_t value) {
  char* storage = SKIP_Obstack_alloc(sizeof(void*) + sizeof(Node));
  *(void***)storage = node_vtable;
  Node* result = (Node*)(storage + sizeof(void*));
  *result = (Node){left, right, value};
  return result;
}

int check_regions(void) {
  node_type.type.m_userByteSize = sizeof(Node);
  node_type.type.m_refsHintMask = 1;
  node_type.type.m_kind = kSkipGcKindClass;
  node_type.mask = 3;
  array_type.type = node_type.type;
  array_type.type.m_kind = kSkipGcKindArray;
  array_type.mask = 3;
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 37);
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  Node* root = parent;
  for (size_t i = 0; i < 12; i++) {
    sk_new_page();
    sk_array_t* storage =
        (sk_array_t*)SKIP_Obstack_alloc(sizeof(sk_array_t) + 4 * sizeof(Node));
    storage->length = 4;
    storage->vtable = array_vtable;
    Node* array = (Node*)storage->data;
    for (size_t j = 0; j < 4; j++) array[j] = (Node){root, parent, i};
    array[3].left = array;
    char* string = sk_string_alloc(5);
    memcpy(string, "hello", 6);
    sk_string_set_hash(string);
    root = node(array, (Node*)string, i);
  }
  for (size_t pass = 0; pass < 3; pass++) {
    root = SKIP_collect_Obstack_with_value(region, root);
    Node* cursor = root;
    for (size_t i = 12; i != 0; i--) {
      if (cursor->value != i - 1) return 1;
      if (memcmp(cursor->right, "hello", 6)) return 2;
      Node* array = cursor->left;
      if (skip_array_len((char*)array) != 4) return 3;
      if (array[3].left != array || array[0].right != parent) return 4;
      if (array[0].left != array[1].left) return 5;
      cursor = array[0].left;
    }
    if (cursor != parent || parent->value != 37) return 6;
  }
  SKIP_destroy_Obstack(region);
  SKIP_destroy_Obstack(outer);
  return total_size == 0 ? 0 : 7;
}
