#include "runtime.h"

#if defined(SKIP64) && defined(__GLIBC__)
#include <malloc.h>
#endif

/*****************************************************************************/
/* Obstack. */
/*****************************************************************************/

// The obstack is structured as a linked list of pages. The size of the page is
// determined by PAGE_SIZE. If an Obstack_alloc attempts to allocate something
// larger than an obstack page, then the size of the page will the exactly
// the size of the allocation (plus meta-data). Every time a page runs out of
// space, we allocate a new page, and we maintain a pointer to the old page.

/* The linked list of pages used by the obstack.

     ------------
    | PAGE 1     |
    |------------|
  ->| NULL       |
  | | SIZE       |
  | |------------|
  | | USER DATA  |
  | | ...        |
  |  ------------
  |
  |  -------------
  | | PAGE 2      |
  | |-------------|
  --| ADDR PAGE 1 |
    | SIZE        |
    |-------------|
    | USER DATA   |
    | ...         |
     -------------
*/

#ifdef SKIP32
// In 32bits mode there are no threads, so the obstack does not have to be
// thread local. This is because wasm doesn't support threads (at least not
// well).
#define __thread
#endif

// page: The beginning of the current obstack page
// head: The current position in the page.
// end: The end of the page.
static __thread struct sk_obstack* page = NULL;
static __thread char* head = NULL;
static __thread char* end = NULL;

#ifdef SKIP32
static struct sk_obstack* free_list = NULL;

unsigned char* decr_heap_end(size_t size);
void reset_heap_end();
#endif

/*****************************************************************************/
/* Obstack allocation. */
/*****************************************************************************/

typedef struct {
  char* head;
  struct sk_obstack* page;
  char* end;
} sk_saved_obstack_t;

typedef struct sk_obstack {
  struct sk_obstack* previous;
  size_t size;
  sk_saved_obstack_t saved;
  char user_data[0];
} sk_obstack_t;

static __thread sk_saved_obstack_t init_saved = {NULL, NULL, NULL};

size_t sk_page_size(sk_obstack_t* page) {
  return page->size;
}

int sk_is_large_page(sk_obstack_t* page) {
  return sk_page_size(page) > PAGE_SIZE;
}

void sk_free_page(sk_obstack_t* page) {
#ifdef SKIP32
  if (sk_is_large_page(page)) {
    sk_free_size(page, page->size);
  } else {
    page->previous = free_list;
    free_list = page;
  }
#else
  sk_free_size(page, page->size);
#endif
}

sk_obstack_t* sk_malloc_page(size_t block_size) {
#ifdef SKIP32
  if (free_list != NULL) {
    sk_obstack_t* newpage = free_list;
    free_list = newpage->previous;
    return newpage;
  }
  return (sk_obstack_t*)decr_heap_end(block_size);
#else
  return (sk_obstack_t*)sk_malloc(block_size);
#endif
}

void sk_obstack_attach_page(sk_obstack_t* lpage, sk_obstack_t* next) {
  if (next != NULL) {
    next->previous = lpage->previous;
  }
  lpage->previous = page->previous;
  page->previous = lpage;
}

// Keep predecessor descriptors current as source pages are removed. A saved
// predecessor may otherwise already belong to the destination heap, so
// unlinking through that stale pointer can create a cycle in the destination's
// page chain.
void sk_obstack_unlink_page(sk_cell_t* entry, sk_cell_t* pages, size_t count) {
  sk_obstack_t* source = entry->key;
  sk_obstack_t* previous = source->previous;
  if (entry->next != NULL) {
    ((sk_obstack_t*)entry->next)->previous = previous;
  }
  size_t index = sk_get_obstack_idx((char*)previous, pages, count);
  if (index < count) pages[index].next = entry->next;
}

char* sk_large_page(size_t size) {
  size_t block_size = size + sizeof(sk_obstack_t);
  // SKIP32
  // large pages are create directly on persistence side memory
  // to prevent persistence copy
  sk_obstack_t* lpage = (sk_obstack_t*)sk_malloc(block_size);
  sk_obstack_attach_page(lpage, NULL);

  lpage->size = block_size;
  sk_saved_obstack_t* saved = &lpage->saved;
  saved->head = NULL;
  saved->end = NULL;
  saved->page = NULL;
  return lpage->user_data;
}

void sk_new_page() {
  size_t block_size = PAGE_SIZE;
  sk_obstack_t* previous_page = page;
  page = sk_malloc_page(block_size);
  page->previous = previous_page;
  page->size = block_size;
  sk_saved_obstack_t* saved = &page->saved;
  saved->head = NULL;
  saved->end = NULL;
  saved->page = NULL;
  end = (char*)page + block_size;
  head = page->user_data;
}

char* SKIP_Obstack_alloc(size_t size) {
  char* result;
  size += 8;
  size = (size + 7) & ~7;

  if (head + size >= end) {
    if (size + sizeof(sk_obstack_t) > PAGE_SIZE) {
      result = sk_large_page(size);
      result += 8;
      return result;
    } else {
      sk_new_page();
    }
  }

  result = head;
  head += size;

  result += 8;
  return result;
}

void* SKIP_Obstack_calloc(size_t size) {
  char* result = SKIP_Obstack_alloc(size);
  memset(result, 0, size);
  return result;
}

char* SKIP_Obstack_shallowClone(size_t /* size */, char* obj) {
  SKIP_gc_type_t* ty = get_gc_type(obj);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = uninterned_metadata_byte_size(ty);
  size_t size = memsize + leftsize;

  char* mem = SKIP_Obstack_alloc(size);
  memcpy(mem, obj - leftsize, size);
  return mem + leftsize;
}

/*****************************************************************************/
/* Obstack creation/destruction. */
/*****************************************************************************/

sk_saved_obstack_t* sk_saved_obstack(sk_obstack_t* page) {
  return &page->saved;
}

sk_saved_obstack_t* SKIP_new_Obstack() {
  sk_saved_obstack_t* saved;
  if (head == NULL && page == NULL && end == NULL) {
    saved = &init_saved;
  } else {
    saved = sk_saved_obstack(page);
  }

  saved->head = head;
  saved->page = page;
  saved->end = end;

  sk_new_page();

  return saved;
}

void SKIP_destroy_Obstack(sk_saved_obstack_t* saved) {
  sk_obstack_t* saved_page;
  char* saved_head;
  char* saved_end;
  if (saved == NULL) {
    saved_page = NULL;
    saved_head = NULL;
    saved_end = NULL;
  } else {
    saved_page = saved->page;
    saved_head = saved->head;
    saved_end = saved->end;
  }

  sk_obstack_t* tofree;
  sk_obstack_t* current = page;
  while (current != NULL && current != saved_page) {
    tofree = current;
    current = current->previous;
    sk_free_page(tofree);
  }
  head = saved_head;
  page = saved_page;
  end = saved_end;

  if (saved != NULL) {
    saved->page = NULL;
    saved->head = NULL;
    saved->end = NULL;
  }
#ifdef SKIP32
  if (page == NULL && head == NULL && end == NULL) {
    free_list = NULL;
    reset_heap_end();
  }
#endif
}

void* SKIP_copy_value_to_Obstack(sk_obstack_t* from_page, void* toCopy) {
  size_t nbr_pages = sk_get_nbr_pages(from_page, page);
  sk_cell_t* pages = sk_get_pages(from_page, nbr_pages);
  void* result = SKIP_copy_with_pages(toCopy, nbr_pages, pages);
  sk_free_size(pages, sizeof(sk_cell_t) * nbr_pages);
  return result;
}

void* SKIP_destroy_Obstack_with_value(sk_saved_obstack_t* saved, void* toCopy) {
  size_t nbr_pages = sk_get_nbr_pages(page, saved->page);
  sk_cell_t* pages = sk_get_pages(page, nbr_pages);

  page = saved->page;
  head = saved->head;
  end = saved->end;

  saved->page = NULL;
  saved->head = NULL;
  saved->end = NULL;

  void* result = SKIP_copy_with_pages(toCopy, nbr_pages, pages);

  unsigned int i;
  for (i = 0; i < nbr_pages; i++) {
    if ((uint64_t)pages[i].key != pages[i].value) {
      sk_obstack_t* fpage = (sk_obstack_t*)(pages[i].key);
      sk_free_page(fpage);
    }
  }

  sk_free_size(pages, sizeof(sk_cell_t) * nbr_pages);

  return result;
}

typedef struct {
  unsigned char* seen;
  size_t live;
  void* large_object;
  uint32_t* prefixes;
  void** relocated;
  size_t objects;
} sk_region_page_t;

// Mark in a bitmap, without modifying objects or retaining a second copy of
// the live graph. One bit per pointer-aligned address costs 1/64 on 64-bit;
// large pages contain just one allocation and need only one byte.
static void sk_mark_region(void* root, sk_cell_t* pages, size_t count,
                           sk_region_page_t* stats) {
  sk_stack_t stack;
  sk_stack_init(&stack, STACK_INIT_CAPACITY);
  sk_stack_push(&stack, &root, NULL);
  while (stack.head != 0) {
    char* obj = *sk_stack_pop(&stack).value;
    size_t index = sk_get_obstack_idx(obj, pages, count);
    if (index >= count) continue;
    sk_obstack_t* source = pages[index].key;
    size_t bit =
        sk_is_large_page(source) ? 0 : (obj - (char*)source) / sizeof(void*);
    unsigned char mask = (unsigned char)(1u << (bit % 8));
    if (stats[index].seen[bit / 8] & mask) continue;
    stats[index].seen[bit / 8] |= mask;
    if (sk_is_large_page(source)) stats[index].large_object = obj;
    if (SKIP_is_string(obj)) {
      size_t bytes = sk_string_header_size + get_sk_string(obj)->size + 1;
      stats[index].live += (bytes + 8 + 7) & ~(size_t)7;
      continue;
    }
    SKIP_gc_type_t* ty = get_gc_type(obj);
    size_t bytes = ty->m_userByteSize * skip_object_len(ty, obj);
    stats[index].live +=
        (bytes + uninterned_metadata_byte_size(ty) + 8 + 7) & ~(size_t)7;
    if ((ty->m_refsHintMask & 1) == 0) continue;
    const size_t mask_bits = sizeof(ty->m_refMask[0]) * 8;
    char* cursor = obj;
    char* limit = obj + bytes;
    while (cursor < limit) {
      size_t remaining = ty->m_userByteSize;
      size_t slot = 0;
      while (remaining != 0) {
        for (size_t bit = 0; bit < mask_bits && remaining != 0; bit++) {
          if ((ty->m_refMask[slot] >> bit) & 1) {
            void** child = (void**)cursor;
            if (*child != NULL) sk_stack_push(&stack, child, NULL);
          }
          cursor += sizeof(void*);
          remaining -= sizeof(void*);
        }
        slot++;
      }
    }
  }
  sk_stack_free(&stack);
}

// Ordinary pages have one mark bit per pointer-sized word. Prefix counts make
// an object's rank in that bitmap an O(1) lookup into a compact forwarding
// array. This table survives freeing the source page; no forwarding pointer
// needs to be stored in an old object. Bitmap slices may be unaligned after
// large pages.
#define SK_REGION_BITMAP_WORDS \
  ((PAGE_SIZE + sizeof(void*) * 64 - 1) / (sizeof(void*) * 64))
static uint64_t sk_region_bits(sk_region_page_t* stats, size_t word) {
  uint64_t bits;
  memcpy(&bits, stats->seen + word * sizeof(bits), sizeof(bits));
  return bits;
}

static void* sk_region_forward(void* value, sk_cell_t* pages, size_t count,
                               sk_region_page_t* stats) {
  if (value == NULL) return NULL;
  size_t index = sk_get_obstack_idx(value, pages, count);
  if (index >= count || stats[index].relocated == NULL) return value;
  size_t bit = ((uintptr_t)value - (uintptr_t)pages[index].key) / sizeof(void*);
  size_t word = bit / 64;
  uint64_t preceding =
      sk_region_bits(&stats[index], word) & ((UINT64_C(1) << (bit % 64)) - 1);
  size_t rank = stats[index].prefixes[word] + __builtin_popcountll(preceding);
  return stats[index].relocated[rank];
}

static void sk_region_rewrite(char* obj, sk_cell_t* pages, size_t count,
                              sk_region_page_t* stats) {
  if (SKIP_is_string(obj)) return;
  SKIP_gc_type_t* ty = get_gc_type(obj);
  if ((ty->m_refsHintMask & 1) == 0) return;
  char* limit = obj + ty->m_userByteSize * skip_object_len(ty, obj);
  const size_t mask_bits = sizeof(ty->m_refMask[0]) * 8;
  for (char* cursor = obj; cursor < limit;) {
    size_t remaining = ty->m_userByteSize;
    size_t slot = 0;
    while (remaining != 0) {
      for (size_t bit = 0; bit < mask_bits && remaining != 0; bit++) {
        if ((ty->m_refMask[slot] >> bit) & 1) {
          void** field = (void**)cursor;
          *field = sk_region_forward(*field, pages, count, stats);
        }
        cursor += sizeof(void*);
        remaining -= sizeof(void*);
      }
      slot++;
    }
  }
}

// Evacuate sparse pages one at a time, freeing each immediately. Copying the
// entire live graph before freeing its old pages would raise the very peak
// this collector is meant to reduce. Dense and large pages keep their address.
static void* sk_compact_region(sk_saved_obstack_t* saved, void* root,
                               sk_cell_t* pages, size_t count,
                               sk_region_page_t* stats) {
  page = saved->page;
  head = saved->head;
  end = saved->end;
  sk_new_page();
  const size_t prefix_bytes = SK_REGION_BITMAP_WORDS * sizeof(uint32_t);
  for (size_t i = 0; i < count; i++) {
    sk_region_page_t* info = &stats[i];
    if (info->live == 0) continue;
    if (info->large_object != NULL || info->live >= PAGE_SIZE / 2) {
      sk_obstack_attach_page(pages[i].key, NULL);
      continue;
    }
    info->prefixes = sk_malloc(prefix_bytes);
    for (size_t word = 0; word < SK_REGION_BITMAP_WORDS; word++) {
      info->prefixes[word] = info->objects;
      info->objects += __builtin_popcountll(sk_region_bits(info, word));
    }
    info->relocated = sk_malloc(info->objects * sizeof(void*));
    size_t ordinal = 0;
    for (size_t word = 0; word < SK_REGION_BITMAP_WORDS; word++) {
      uint64_t bits = sk_region_bits(info, word);
      while (bits != 0) {
        size_t bit = word * 64 + __builtin_ctzll(bits);
        char* obj = (char*)pages[i].key + bit * sizeof(void*);
        size_t left;
        size_t bytes;
        if (SKIP_is_string(obj)) {
          left = sk_string_header_size;
          bytes = get_sk_string(obj)->size + 1;
        } else {
          SKIP_gc_type_t* ty = get_gc_type(obj);
          left = uninterned_metadata_byte_size(ty);
          bytes = ty->m_userByteSize * skip_object_len(ty, obj);
        }
        char* copy = SKIP_Obstack_alloc(left + bytes);
        memcpy(copy, obj - left, left + bytes);
        info->relocated[ordinal++] = copy + left;
        bits &= bits - 1;
      }
    }
    sk_free_page(pages[i].key);
  }

  // All object fields still contain their original addresses. Rewrite each
  // exactly once, including fields in pages retained in place. A new page may
  // reuse an old address, so do not follow rewritten pointers while walking.
  root = sk_region_forward(root, pages, count, stats);
  for (size_t i = 0; i < count; i++) {
    sk_region_page_t* info = &stats[i];
    if (info->live == 0) continue;
    if (info->large_object != NULL) {
      sk_region_rewrite(info->large_object, pages, count, stats);
      continue;
    }
    size_t ordinal = 0;
    for (size_t word = 0; word < SK_REGION_BITMAP_WORDS; word++) {
      uint64_t bits = sk_region_bits(info, word);
      while (bits != 0) {
        size_t bit = word * 64 + __builtin_ctzll(bits);
        char* obj = info->relocated != NULL
                        ? info->relocated[ordinal++]
                        : (char*)pages[i].key + bit * sizeof(void*);
        sk_region_rewrite(obj, pages, count, stats);
        bits &= bits - 1;
      }
    }
  }
  // Keep every forwarding table until all retained objects have been fixed.
  for (size_t i = 0; i < count; i++) {
    if (stats[i].relocated != NULL) {
      sk_free_size(stats[i].relocated, stats[i].objects * sizeof(void*));
      sk_free_size(stats[i].prefixes, prefix_bytes);
    }
  }
  return root;
}

// Replace the current region with its live graph. Dense pages stay in place:
// copying a large, mostly live compiler phase would itself double its peak.
// Reclaim dead pages before compacting sparse survivors. The caller must pass
// every live region pointer through root, retaining no other region pointers.
void* SKIP_collect_Obstack_with_value(sk_saved_obstack_t* saved, void* root) {
  size_t count = sk_get_nbr_pages(page, saved->page);
  sk_cell_t* pages = sk_get_pages(page, count);
  sk_region_page_t* stats = sk_malloc(count * sizeof(sk_region_page_t));
  size_t bitmap_size = 0;
  for (size_t i = 0; i < count; i++) {
    bitmap_size += sk_is_large_page(pages[i].key)
                       ? 1
                       : SK_REGION_BITMAP_WORDS * sizeof(uint64_t);
  }
  unsigned char* bitmap = sk_malloc(bitmap_size);
  memset(bitmap, 0, bitmap_size);
  size_t offset = 0;
  for (size_t i = 0; i < count; i++) {
    stats[i] = (sk_region_page_t){.seen = bitmap + offset};
    offset += sk_is_large_page(pages[i].key)
                  ? 1
                  : SK_REGION_BITMAP_WORDS * sizeof(uint64_t);
  }
  sk_mark_region(root, pages, count, stats);

  sk_obstack_t* original = page;
  sk_obstack_t* first = NULL;
  sk_obstack_t* last = NULL;
  size_t retained = 0;
  size_t live = 0;
  for (sk_obstack_t* cursor = page; cursor != saved->page;) {
    sk_obstack_t* previous = cursor->previous;
    size_t index = sk_get_obstack_idx((char*)cursor, pages, count);
    if (stats[index].live != 0) {
      if (last != NULL)
        last->previous = cursor;
      else
        first = cursor;
      last = cursor;
      retained += cursor->size;
      live += stats[index].live;
    } else {
      sk_free_page(cursor);
    }
    cursor = previous;
  }
  if (last != NULL) last->previous = saved->page;
  page = first != NULL ? first : saved->page;

  // Bound fragmentation without copying full, long-lived input graphs on
  // every checkpoint. One partially occupied allocation page is unavoidable.
  if (retained > PAGE_SIZE && live < retained / 2) {
    root = sk_compact_region(saved, root, pages, count, stats);
  } else if (count != 0 && first != original) {
    // The head page was reclaimed, so head/end no longer name live memory and
    // a fresh page is required. An empty region (count == 0) already has
    // valid head/end on the saved page: allocate nothing.
    sk_new_page();
  }
  sk_free_size(bitmap, bitmap_size);
  sk_free_size(stats, count * sizeof(sk_region_page_t));
  sk_free_size(pages, count * sizeof(sk_cell_t));
#if defined(SKIP64) && defined(__GLIBC__)
  // glibc may keep freed 8 MiB pages in its arena after adapting its mmap
  // threshold. Return that physical memory before the next compiler phase.
  malloc_trim(0);
#endif
  return root;
}

SkipInt SKIP_Obstack_allocated_bytes(void) {
  SkipInt bytes = 0;
  for (sk_obstack_t* cursor = page; cursor != NULL; cursor = cursor->previous) {
    bytes += cursor->size;
  }
  return bytes;
}

sk_obstack_t* SKIP_switch_to_parent(sk_saved_obstack_t* saved) {
  // Gather current obstack data
  sk_obstack_t* first = page;
  while (first != NULL && first->previous != saved->page) {
    first = first->previous;
  }

  sk_obstack_t* saved_page = page;
  char* saved_head = head;
  char* saved_end = end;

  // Switch to parent obstack
  page = saved->page;
  head = saved->head;
  end = saved->end;

  // Store obstack dat for restauration
  saved->head = saved_head;
  saved->page = first;
  saved->end = saved_end;

  return saved_page;
}

void SKIP_restore_from_parent(sk_saved_obstack_t* saved,
                              sk_obstack_t* leading) {
  // Save the obstack restauration data
  sk_obstack_t* first_page = saved->page;
  char* saved_head = saved->head;
  char* saved_end = saved->end;

  // Update the sub obstack with new parent obstack positions
  first_page->previous = page;
  saved->page = page;
  saved->head = head;
  saved->end = end;

  // Switch to sub obstack
  page = leading;
  head = saved_head;
  end = saved_end;
}
uint32_t SKIP_should_GC(sk_saved_obstack_t* saved) {
  size_t nbr_page = 0;
  sk_obstack_t* cursor = page;
  while (cursor != NULL && cursor != saved->page) {
    cursor = cursor->previous;
    nbr_page++;
    if (nbr_page > 3 ||
        (nbr_page > 1 && (head - page->user_data > (2 * PAGE_SIZE / 3)))) {
      return 1;
    }
  }
  return 0;
}

/*****************************************************************************/
/* Collection primitive (disabled). */
/*****************************************************************************/

void SKIP_Obstack_auto_collect() {}

void SKIP_Obstack_collect0(void* /* note */) {}

void* SKIP_Obstack_collect1(void* /* note */, void* obj) {
  return obj;
}

/*****************************************************************************/
/* Sort used to sort the pages. */
/*****************************************************************************/

static void heapify(sk_cell_t* arr, size_t n, size_t i) {
  size_t largest = i;
  size_t l = 2 * i + 1;
  size_t r = 2 * i + 2;

  if (l < n && arr[l].key > arr[largest].key) {
    largest = l;
  }

  if (r < n && arr[r].key > arr[largest].key) {
    largest = r;
  }

  if (largest != i) {
    sk_cell_t tmp = arr[i];
    arr[i] = arr[largest];
    arr[largest] = tmp;
    heapify(arr, n, largest);
  }
}

void sk_heap_sort(sk_cell_t* arr, size_t n) {
  if (n <= 1) return;

  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(arr, n, i);
  }

  for (size_t i = n - 1; i > 0; i--) {
    sk_cell_t tmp = arr[0];
    arr[0] = arr[i];
    arr[i] = tmp;
    heapify(arr, i, 0);
  }
}

/*****************************************************************************/
/* Search. */
/*****************************************************************************/

size_t sk_get_nbr_pages(sk_obstack_t* from_page, sk_obstack_t* to_page) {
  size_t nbr_page = 0;
  sk_obstack_t* cursor = from_page != NULL ? from_page : page;
  while (cursor != NULL && cursor != to_page) {
    cursor = cursor->previous;
    nbr_page++;
  }
  return nbr_page;
}

sk_cell_t* sk_get_pages(sk_obstack_t* from_page, size_t nbr_pages) {
  sk_cell_t* result = (sk_cell_t*)sk_malloc(sizeof(sk_cell_t) * nbr_pages);
  unsigned int i = 0;
  sk_obstack_t* cursor = from_page != NULL ? from_page : page;
  sk_obstack_t* next = NULL;
  for (i = 0; i < nbr_pages; i++) {
    result[i].key = cursor;
    result[i].value = (uint64_t)cursor + cursor->size;
    result[i].next = next;
    next = cursor;
    cursor = cursor->previous;
  }
  sk_heap_sort(result, nbr_pages);
  return result;
}

size_t binarySearch(sk_cell_t* arr, size_t l, size_t r, char* x) {
  if (l >= r) {
    if ((char*)arr[l].key <= x && x < (char*)(arr[l].value)) {
      return l;
    } else {
      return (size_t)-1;
    }
  }

  size_t mid = l + (r - l) / 2;

  if (x < (char*)arr[mid].key) {
    if (mid <= l) {
      // this happens when r = l + 1
      return (size_t)-1;
    } else {
      return binarySearch(arr, l, mid - 1, x);
    }
  } else if (x >= (char*)(arr[mid].value)) {
    return binarySearch(arr, mid + 1, r, x);
  } else {
    return mid;
  }
}

size_t sk_get_obstack_idx(char* ptr, sk_cell_t* pages, size_t nbr_pages) {
  if (nbr_pages == 0 || pages == NULL) {
    return (size_t)-1;
  }
  size_t result = binarySearch(pages, 0, nbr_pages - 1, ptr);
  return result;
}

#ifdef SKIP64
// Worker heaps outlive their TLS. Page sets also track large-page adoption.
typedef struct {
  size_t count;
  sk_cell_t* pages;
} sk_detached_arena_t;

void* SKIP_detach_Obstack(void) {
  sk_detached_arena_t* arena = sk_malloc(sizeof(sk_detached_arena_t));
  arena->count = sk_get_nbr_pages(page, NULL);
  arena->pages = arena->count ? sk_get_pages(page, arena->count) : NULL;
  page = NULL;
  head = NULL;
  end = NULL;
  init_saved = (sk_saved_obstack_t){NULL, NULL, NULL};
  return arena;
}

void* SKIP_transfer_Obstack(void* detached, void* root) {
  sk_detached_arena_t* arena = detached;
  if (!arena->count) return root;
  return SKIP_copy_with_pages(root, arena->count, arena->pages);
}

// After all readers have joined, move ownership of every worker page into the
// caller's current region. Objects keep their addresses. The enclosing region
// must outlive all published results; its ordinary collection/destruction owns
// these pages from here on, including pages containing only worker scratch.
void SKIP_adopt_Obstack(void* detached) {
  sk_detached_arena_t* arena = detached;
  for (size_t i = 0; i < arena->count; i++) {
    if ((uint64_t)arena->pages[i].key != arena->pages[i].value) {
      sk_obstack_attach_page(arena->pages[i].key, NULL);
      arena->pages[i].value = (uint64_t)arena->pages[i].key;
    }
  }
}

void SKIP_release_Obstack(void* detached) {
  sk_detached_arena_t* arena = detached;
  if (arena == NULL) return;
  for (size_t i = 0; i < arena->count; i++) {
    if ((uint64_t)arena->pages[i].key != arena->pages[i].value) {
      sk_free_page(arena->pages[i].key);
    }
  }
  if (arena->pages)
    sk_free_size(arena->pages, sizeof(sk_cell_t) * arena->count);
  sk_free_size(arena, sizeof(sk_detached_arena_t));
}
#endif
