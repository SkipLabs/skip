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

void sk_new_page(size_t size) {
  size_t block_size = PAGE_SIZE;
  if(size + sizeof(char*) + sizeof(size_t) > block_size) {
    block_size = size + sizeof(char*) + sizeof(size_t);
  }
  head = (char*)sk_malloc(block_size);
  end = head + block_size;
  *(char**)head = page;
  page = head;
  head += sizeof(char*);
  *(size_t*)head = block_size;
  head += sizeof(size_t);
}

char* SKIP_Obstack_alloc(size_t size) {
  size = (size + (sizeof(void*) - 1)) & ~(sizeof(void*) - 1);
  if (head + size > end) {
    sk_new_page(size);
  }
  char* result = head;
  head += size;
  return result;
}

void* SKIP_Obstack_calloc(size_t size) {
  size = (size + (sizeof(void*) - 1)) & ~(sizeof(void*) - 1);
  if (head + size > end) {
    sk_new_page(size);
  }
  char* result = head;
  head += size;
  int i;
  for(i = 0; i < size; i++) {
    result[i] = 0;
  }
  return result;
}

char* SKIP_Obstack_shallowClone(size_t size, char* obj) {
  size = size + sizeof(void*);
  char* mem = SKIP_Obstack_alloc(size);
  memcpy(mem, obj-sizeof(void*), size);
  return mem+sizeof(void*);
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
  sk_saved_obstack_t* saved = sk_malloc(sizeof(sk_saved_obstack_t));
  saved->head = head;
  saved->page = page;
  saved->end = end;
  head = NULL;
  page = NULL;
  end = NULL;
  return saved;
}

void SKIP_destroy_Obstack(sk_saved_obstack_t* saved) {
  while(saved->head < page || saved->head > end) {
    char* tofree = page;
    size_t tosk_free_size = *(size_t*)(page + sizeof(char*));
    page = *(char**)page;
    sk_free_size(tofree, tosk_free_size);
    if(page == NULL) {
      head = saved->head;
      page = saved->page;
      end = saved->end;
      sk_free_size(saved, sizeof(sk_saved_obstack_t));
      return;
    }
    size_t size = *(size_t*)(page + sizeof(char*));
    end = page + size;
  }
  head = saved->head;
  page = saved->page;
  end = saved->end;
  sk_free_size(saved, sizeof(sk_saved_obstack_t));
}

void* SKIP_destroy_Obstack_with_value(sk_saved_obstack_t* saved, void* toCopy) {
  size_t page_size = nbr_pages();
  sk_cell_t* pages = get_pages(page_size);
  char* head_copy = head;
  char* page_copy = page;
  char* end_copy = end;
  head = saved->head;
  page = saved->page;
  end = saved->end;
  void* result = SKIP_copy_with_pages(toCopy, page_size, pages);
  head = head_copy;
  page = page_copy;
  end = end_copy;
  SKIP_destroy_Obstack(saved);
  return result;
}


/*****************************************************************************/
/* Collection primitive (disabled). */
/*****************************************************************************/

void SKIP_Obstack_auto_collect() {
}

/*****************************************************************************/
/* Search. */
/*****************************************************************************/

size_t nbr_pages() {
  size_t nbr_page = 0;
  void* cursor = page;
  while(cursor != NULL) {
    cursor = *(char**)cursor;
    nbr_page++;
  }
  return nbr_page;
}

void quicksort(sk_cell_t* arr,int first,int last){
  int i, j, pivot;
  sk_cell_t temp;

  if(first < last){
    pivot = first;
    i = first;
    j = last;

    while(i < j){
      while(arr[i].key <= arr[pivot].key && i<last) {
        i++;
      }
      while(arr[j].key > arr[pivot].key) {
        j--;
      }
      if(i < j){
        temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }

    temp = arr[pivot];
    arr[pivot] = arr[j];
    arr[j] = temp;
    quicksort(arr, first, j-1);
    quicksort(arr, j+1, last);
  }
}

sk_cell_t* get_pages(size_t size) {
  sk_cell_t* result = (sk_cell_t*)sk_malloc(sizeof(sk_cell_t) * size);
  int i = 0;
  void* cursor = page;
  while(cursor != NULL) {
    result[i].key = cursor;
    result[i].value = (uint64_t)(cursor + *(size_t*)(cursor + sizeof(char*)));
    cursor = *(char**)cursor;
    i++;
  }
  quicksort(result, 0, size-1);
  return result;
}

int binarySearch(sk_cell_t* arr, size_t l, size_t r, void* x) {
  if (r >= l) {
    size_t mid = (l + r) / 2;

    if (arr[mid].key <= x && x < (void*)(arr[mid].value)) {
      return 1;
    }

    if (x < arr[mid].key)  {
      if(mid == 0) return 0;
      return binarySearch(arr, l, mid - 1, x);
    }

    return binarySearch(arr, mid + 1, r, x);
  }

  return 0;
}


int is_in_obstack(void* ptr, sk_cell_t* pages, size_t size) {
  if(size == 0) {
    return 0;
  }
  int result = binarySearch(pages, 0, size-1, ptr);
  return result;
}
