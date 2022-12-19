#include "runtime.h"

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

// page: The beginning of the current obstack page
// head: The current position in the page.
// end: The end of the page.

#ifdef SKIP32
char* page = NULL;
char* head = NULL;
char* end = NULL;
#endif

// In 32bits mode there are no threads, so the obstack does not have to be
// thread local. This is because wasm doesn't support threads (at least not
// well).

#ifdef SKIP64
__thread char* page = NULL;
__thread char* head = NULL;
__thread char* end = NULL;
#endif

/*****************************************************************************/
/* Obstack allocation. */
/*****************************************************************************/

size_t sk_page_size(char* page) {
  return *(size_t*)(page + sizeof(char*));
}

int sk_is_large_page(char* page) {
  return sk_page_size(page) > PAGE_SIZE;
}

void sk_obstack_attach_page(char* lpage) {
  *(char**)lpage = *(char**)page;
  *(char**)page = lpage;
}

char* sk_large_page(size_t size) {
  size_t block_size = size + sizeof(char*) + sizeof(size_t);
  block_size += 64;
  char* lpage = (char*)sk_malloc(block_size);
  if(lpage == NULL) {
    #ifdef SKIP64
    fprintf(stderr, "Out of memory\n");
    #endif
    SKIP_throw(NULL);
  }
  sk_obstack_attach_page(lpage);
  lpage += sizeof(char*);
  *(size_t*)lpage = block_size;
  lpage += sizeof(size_t);
  // This space is needed in case the page gets interned.
  lpage += 64;
  return lpage;
}

void sk_new_page() {
  size_t block_size = PAGE_SIZE;
#ifdef SKIP32
  head = (char*)sk_malloc_end(block_size);
#endif
#ifdef SKIP64
  head = (char*)sk_malloc(block_size);
#endif
  if(head == NULL) {
    #ifdef SKIP64
    fprintf(stderr, "Out of memory\n");
    #endif
    SKIP_throw(NULL);
  }
  end = head + block_size;
  *(char**)head = page;
  page = head;
  head += sizeof(char*);
  *(size_t*)head = block_size;
  head += sizeof(size_t);
}

char* SKIP_Obstack_alloc(size_t size) {
  char* result;
  size += 8;
  size = (size + 7) & ~7;

  if (head + size >= end) {
    if(size + sizeof(char*) + sizeof(size_t) > PAGE_SIZE) {
      result = sk_large_page(size);
      result += 8;
      return result;
    }
    else {
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

char* SKIP_Obstack_shallowClone(size_t _size, char* obj) {
  SKIP_gc_type_t* ty = *(*(((SKIP_gc_type_t***)obj)-1)+1);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  size_t size = memsize + leftsize;

  char* mem = SKIP_Obstack_alloc(size);
  memcpy(mem, obj-leftsize, size);
  return mem+leftsize;
}

/*****************************************************************************/
/* Obstack creation/destruction. */
/*****************************************************************************/

typedef struct {
  char* head;
  char* page;
  char* end;
} sk_saved_obstack_t;

sk_saved_obstack_t* SKIP_new_Obstack() {
  sk_saved_obstack_t* saved =
    (sk_saved_obstack_t*)SKIP_Obstack_alloc(sizeof(sk_saved_obstack_t));
  saved->head = head;
  saved->page = page;
  saved->end = end;

  sk_new_page();

  return saved;
}

void SKIP_destroy_Obstack(sk_saved_obstack_t* saved) {
  char* saved_page;
  char* saved_head;
  char* saved_end;
  if(saved == NULL) {
    saved_page = NULL;
    saved_head = NULL;
    saved_end = NULL;
  }
  else {
    saved_page = saved->page;
    saved_head = saved->head;
    saved_end = saved->end;
  }
  while(saved_head < page || saved_head > end) {
    char* tofree = page;
    size_t tosk_free_size = sk_page_size(page);
    page = *(char**)page;
    sk_free_size(tofree, tosk_free_size);
    if(page == NULL) {
      head = NULL;
      page = NULL;
      end = NULL;
      return;
    }
    size_t size = *(size_t*)(page + sizeof(char*));
    end = page + size;
  }
  head = saved_head;
  page = saved_page;
  end = saved_end;
}

void* SKIP_destroy_Obstack_with_value(sk_saved_obstack_t* saved, void* toCopy) {
  size_t nbr_pages = sk_get_nbr_pages(saved->page);
  sk_cell_t* pages = sk_get_pages(nbr_pages);

  page = saved->page;
  head = saved->head;
  end = saved->end;

  void* result = SKIP_copy_with_pages(toCopy, nbr_pages, pages);

  int i;
  for(i = 0; i < nbr_pages; i++) {
    if((uint64_t)pages[i].key != pages[i].value) {
      char* fpage = (char*)(pages[i].key);
      size_t fnbr_pages = *(size_t*)(fpage + sizeof(char*));
      sk_free_size(fpage, fnbr_pages);
    }
  }

  sk_free_size(pages, sizeof(sk_cell_t) * nbr_pages);

  return result;
}

static int sk_gc_enabled = 1;

void SKIP_disable_GC() {
  sk_gc_enabled = 0;
}

void SKIP_enable_GC() {
  sk_gc_enabled = 1;
}

uint32_t SKIP_should_GC(sk_saved_obstack_t* saved) {
  return
    sk_gc_enabled &&
    ((head < saved->page && head >= saved->end) ||
    (head >= (saved->head + PAGE_SIZE / 2)));
}

/*****************************************************************************/
/* Collection primitive (disabled). */
/*****************************************************************************/

void SKIP_Obstack_auto_collect() {
}

void* SKIP_Obstack_collect1(void* note, void* obj) {
  return obj;
}

/*****************************************************************************/
/* Sort used to sort the pages. */
/*****************************************************************************/

static void heapify(sk_cell_t* arr, int n, int i) {
  int largest = i;
  int l = 2 * i + 1;
  int r = 2 * i + 2;

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

void sk_heap_sort(sk_cell_t* arr, int n) {
  for (int i = n / 2 - 1; i >= 0; i--) {
    heapify(arr, n, i);
  }

  for (int i = n - 1; i > 0; i--) {
    sk_cell_t tmp = arr[0];
    arr[0] = arr[i];
    arr[i] = tmp;
    heapify(arr, i, 0);
  }
}

/*****************************************************************************/
/* Search. */
/*****************************************************************************/

size_t sk_get_nbr_pages(void *saved_page) {
  size_t nbr_page = 0;
  void* cursor = page;
  while(cursor != NULL && cursor != saved_page) {
    cursor = *(char**)cursor;
    nbr_page++;
  }
  return nbr_page;
}

sk_cell_t* sk_get_pages(size_t size) {
  sk_cell_t* result = (sk_cell_t*)sk_malloc(sizeof(sk_cell_t) * size);
  int i = 0;
  void* cursor = page;
  for(i = 0; i < size; i++) {
    result[i].key = cursor;
    result[i].value = (uint64_t)(cursor + *(size_t*)(cursor + sizeof(char*)));
    cursor = *(char**)cursor;
  }
  sk_heap_sort(result, size);
  return result;
}

size_t binarySearch(sk_cell_t* arr, int l, int r, char* x) {
  if(l >= r) {
    if(((char*)arr[l].key <= x && x < (char*)(arr[l].value))) {
      return l;
    }
    else {
      return -1;
    }
  }

  int mid = (l + r) / 2;

  if (x < (char*)arr[mid].key)  {
    return binarySearch(arr, l, mid - 1, x);
  }
  else if(x >= (char*)(arr[mid].value)) {
    return binarySearch(arr, mid + 1, r, x);
  }
  else {
    return mid;
  }
}


size_t sk_get_obstack_idx(char* ptr, sk_cell_t* pages, size_t size) {
  if(size == 0 || pages == NULL) {
    return -1;
  }
  int result = binarySearch(pages, 0, size-1, ptr);
  return result;
}
