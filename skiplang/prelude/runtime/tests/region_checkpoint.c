// Exercise real copying, sharing, cycles, parent references and large-page
// adoption while proving that repeated checkpoints keep allocation bounded.
#define SKIP64 1
#include <assert.h>
#include <stdlib.h>

#include "../copy.c"
#include "../obstack.c"
#include "../runtime.c"
#include "../stack.c"
#include "../string.c"

static size_t live_bytes;
static size_t peak_bytes;
void* sk_malloc(size_t size) {
  void* result = malloc(size);
  assert(result);
  live_bytes += size;
  if (live_bytes > peak_bytes) peak_bytes = live_bytes;
  return result;
}
void sk_free_size(void* value, size_t size) {
  assert(live_bytes >= size);
  live_bytes -= size;
  free(value);
}

typedef struct Node {
  struct Node* left;
  struct Node* right;
  size_t value;
} Node;

static struct {
  SKIP_gc_type_t type;
  SkipInt mask;
} node_type;
static void* node_vtable[2] = {NULL, &node_type};
static struct {
  SKIP_gc_type_t type;
  SkipInt mask;
} array_type;
static void* array_vtable[2] = {NULL, &array_type};

static Node* node(Node* left, Node* right, size_t value) {
  char* storage = SKIP_Obstack_alloc(sizeof(void*) + sizeof(Node));
  *(void***)storage = node_vtable;
  Node* result = (Node*)(storage + sizeof(void*));
  *result = (Node){left, right, value};
  return result;
}

static void check_regions(void) {
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 17);
  size_t parent_bytes = live_bytes;
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  Node* root = node(parent, NULL, 0);
  root->right = root;
  for (size_t i = 0; i < 200; i++) {
    // Discard both large pages and ordinary pages from preceding steps.
    memset(SKIP_Obstack_alloc(PAGE_SIZE + 256), 0x42, PAGE_SIZE + 256);
    for (size_t j = 0; j < 10000; j++) (void)node(NULL, NULL, j);
    Node* next = node(parent, root->right, i);
    next->right = next;
    root = SKIP_collect_Obstack_with_value(region, next);
    assert(root->left == parent && parent->value == 17);
    assert(root->right == root && root->value == i);
    assert(live_bytes == parent_bytes + PAGE_SIZE);
    assert(SKIP_Obstack_allocated_bytes() == live_bytes);
  }
  root = SKIP_destroy_Obstack_with_value(region, root);
  assert(root->right == root && root->left == parent && root->value == 199);
  assert(live_bytes == parent_bytes);
  SKIP_destroy_Obstack(outer);
  assert(live_bytes == 0);
  assert(SKIP_Obstack_allocated_bytes() == 0);
}

static void check_large_pages(void) {
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 23);
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  size_t count = PAGE_SIZE / sizeof(Node) + 100;
  sk_array_t* storage = (sk_array_t*)SKIP_Obstack_alloc(sizeof(sk_array_t) +
                                                        count * sizeof(Node));
  storage->length = count;
  storage->vtable = array_vtable;
  Node* array = (Node*)storage->data;
  Node* shared = node(parent, parent, 42);
  for (size_t i = 0; i < count; i++) array[i] = (Node){shared, shared, i};
  Node* root = node(array, array, 0);
  size_t bytes = live_bytes;
  for (size_t i = 0; i < 8; i++) {
    root = SKIP_collect_Obstack_with_value(region, root);
    // Large objects transfer their pages; both aliases still name that page.
    assert(root->left == array && root->right == array);
    assert(array[0].left == array[count - 1].right);
    assert(array[0].left->left == parent);
    assert(array[0].left->value == 42 && array[count - 1].value == count - 1);
    assert(live_bytes == bytes);
  }
  SKIP_destroy_Obstack(region);
  SKIP_destroy_Obstack(outer);
  assert(live_bytes == 0);
}

static Node* node_array(size_t count) {
  sk_array_t* storage = (sk_array_t*)SKIP_Obstack_alloc(sizeof(sk_array_t) +
                                                        count * sizeof(Node));
  storage->length = count;
  storage->vtable = array_vtable;
  memset(storage->data, 0, count * sizeof(Node));
  return (Node*)storage->data;
}

static void check_dense_pages(void) {
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 19);
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  size_t count = PAGE_SIZE * 3 / 4 / sizeof(Node);
  Node* left = node_array(count);
  Node* right = node_array(count);
  left[count - 1].left = parent;
  right[count - 1].value = 29;
  Node* root = node(left, right, 0);
  size_t before = live_bytes;
  peak_bytes = before;
  for (size_t i = 0; i < 10; i++) {
    assert(SKIP_collect_Obstack_with_value(region, root) == root);
    assert(root->left == left && root->right == right);
    assert(left[count - 1].left == parent);
    assert(right[count - 1].value == 29);
    assert(live_bytes == before);
  }
  // Dense graphs require only marking metadata, not another copy of the data.
  assert(peak_bytes < before + PAGE_SIZE / 8);
  SKIP_destroy_Obstack(region);
  SKIP_destroy_Obstack(outer);
  assert(live_bytes == 0);
}

static void check_sparse_pages(void) {
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 31);
  size_t parent_bytes = live_bytes;
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  Node* root = parent;
  for (size_t i = 0; i < 10; i++) {
    memset(SKIP_Obstack_alloc(PAGE_SIZE / 2), 0x42, PAGE_SIZE / 2);
    root = node(root, parent, i);
  }
  assert(live_bytes > parent_bytes + 4 * PAGE_SIZE);
  root = SKIP_collect_Obstack_with_value(region, root);
  assert(live_bytes == parent_bytes + PAGE_SIZE);
  for (size_t i = 10; i != 0; i--) {
    assert(root->value == i - 1 && root->right == parent);
    root = root->left;
  }
  assert(root == parent && parent->value == 31);
  SKIP_destroy_Obstack(region);
  SKIP_destroy_Obstack(outer);
  assert(live_bytes == 0);
}

static void check_wide_masks_and_strings(void) {
  static struct {
    SKIP_gc_type_t type;
    SkipInt masks[2];
  } wide_type;
  static void* wide_vtable[2] = {NULL, &wide_type};
  const size_t slots[] = {0, 31, 32, 63, 64, 70};
  wide_type.type.m_userByteSize = 72 * sizeof(void*);
  wide_type.type.m_refsHintMask = 1;
  wide_type.type.m_kind = kSkipGcKindArray;
  wide_type.masks[0] = UINT64_C(1) | (UINT64_C(1) << 31) | (UINT64_C(1) << 32) |
                       (UINT64_C(1) << 63);
  wide_type.masks[1] = UINT64_C(1) | (UINT64_C(1) << 6);
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 41);
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  // Each referenced child lives on a separate page; an omitted reference
  // would let the marker release that child's page before compaction.
  Node* children[6];
  for (size_t i = 0; i < 6; i++) {
    sk_new_page();
    children[i] = node(parent, NULL, i);
  }
  sk_array_t* storage =
      (sk_array_t*)SKIP_Obstack_alloc(sizeof(sk_array_t) + 144 * sizeof(void*));
  storage->length = 2;
  storage->vtable = wide_vtable;
  void** fields = (void**)storage->data;
  for (size_t i = 0; i < 144; i++) fields[i] = (void*)(uintptr_t)(i * 16 + 64);
  for (size_t i = 0; i < 6; i++) {
    fields[slots[i]] = children[i];
    fields[72 + slots[i]] = children[i];
  }
  char* string = sk_string_alloc(5);
  memcpy(string, "hello", 6);
  sk_string_set_hash(string);
  Node* root = node((Node*)fields, (Node*)string, 0);
  for (size_t pass = 0; pass < 8; pass++) {
    root = SKIP_collect_Obstack_with_value(region, root);
    fields = (void**)root->left;
    for (size_t i = 0; i < 6; i++) {
      Node* child = fields[slots[i]];
      assert(child == fields[72 + slots[i]]);
      assert(child->value == i && child->left == parent);
    }
    assert(get_sk_string((char*)root->right)->size == 5);
    assert(!memcmp(root->right, "hello", 6));
    assert(fields[33] == (void*)(uintptr_t)(33 * 16 + 64));
  }
  SKIP_destroy_Obstack(region);
  SKIP_destroy_Obstack(outer);
  assert(live_bytes == 0);
}

static void check_bounded_evacuation(void) {
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 43);
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  Node* root = parent;
  size_t count = PAGE_SIZE / 4 / sizeof(Node);
  for (size_t i = 0; i < 12; i++) {
    sk_new_page();
    Node* values = node_array(count);
    values[0].left = root;
    values[0].right = parent;
    values[0].value = i;
    values[count - 1].left = values;
    root = values;
  }
  size_t before = live_bytes;
  peak_bytes = before;
  root = SKIP_collect_Obstack_with_value(region, root);
  // Whole-graph copying would add at least three pages before freeing any.
  // Page evacuation needs at most one new allocation page plus its metadata.
  assert(peak_bytes < before + 2 * PAGE_SIZE);
  assert(live_bytes < before / 2);
  for (size_t i = 12; i != 0; i--) {
    assert(root[0].value == i - 1 && root[0].right == parent);
    assert(root[count - 1].left == root);
    root = root[0].left;
  }
  assert(root == parent);
  SKIP_destroy_Obstack(region);
  SKIP_destroy_Obstack(outer);
  assert(live_bytes == 0);
}

static void check_retained_page_references(void) {
  sk_saved_obstack_t* outer = SKIP_new_Obstack();
  Node* parent = node(NULL, NULL, 47);
  sk_saved_obstack_t* region = SKIP_new_Obstack();
  Node* children[12];
  for (size_t i = 0; i < 12; i++) {
    sk_new_page();
    children[i] = node(parent, NULL, i);
    children[i]->right = children[i];
  }
  sk_new_page();
  size_t count = PAGE_SIZE * 3 / 4 / sizeof(Node);
  Node* dense = node_array(count);
  for (size_t i = 0; i < 12; i++) {
    dense[i] = (Node){children[i], children[i], i};
    // Exercise references from moved objects back into the retained page.
    children[i]->left = dense;
  }
  size_t large_count = PAGE_SIZE / sizeof(Node) + 100;
  Node* large = node_array(large_count);
  dense[12].left = large;
  large[0].left = dense;
  large[large_count - 1].left = children[11];
  Node* root = node(dense, parent, 0);
  Node* original_root = root;
  size_t before = live_bytes;
  root = SKIP_collect_Obstack_with_value(region, root);
  assert(root == original_root && root->left == dense && root->right == parent);
  assert(live_bytes < before / 2);
  for (size_t i = 0; i < 12; i++) {
    assert(dense[i].left == dense[i].right);
    assert(dense[i].left->value == i);
    assert(dense[i].left->right == dense[i].left);
    assert(dense[i].left->left == dense);
  }
  assert(dense[12].left == large && large[0].left == dense);
  assert(large[large_count - 1].left == dense[11].left);
  // A second collection must interpret rewritten fields as current addresses.
  root = SKIP_collect_Obstack_with_value(region, root);
  assert(root->left == dense);
  assert(dense[11].left->value == 11);
  SKIP_destroy_Obstack(region);
  SKIP_destroy_Obstack(outer);
  assert(live_bytes == 0);
}

int main(void) {
  node_type.type.m_userByteSize = sizeof(Node);
  node_type.type.m_refsHintMask = 1;
  node_type.type.m_kind = kSkipGcKindClass;
  node_type.mask = 3;
  array_type.type = node_type.type;
  array_type.mask = node_type.mask;
  array_type.type.m_kind = kSkipGcKindArray;
  check_regions();
  check_large_pages();
  check_dense_pages();
  check_sparse_pages();
  check_wide_masks_and_strings();
  check_bounded_evacuation();
  check_retained_page_references();
  puts("region checkpoints: OK");
  return 0;
}
