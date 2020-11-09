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

static void new_page(size_t size) {
  size_t block_size = PAGE_SIZE;
  if(size + sizeof(char*) + sizeof(size_t) > block_size) {
    block_size = size + sizeof(char*) + sizeof(size_t);
  }
  head = (char*)malloc(block_size);
  end = head + block_size;
  *(char**)head = page;
  page = head;
  head += sizeof(char*);
  *(size_t*)head = block_size;
  head += sizeof(size_t);
}

char* SKIP_Obstack_alloc(size_t size) {
  if (head + size > end) {
    new_page(size);
  }
  char* result = head;
  head += size;
  return result;
}

void* SKIP_Obstack_calloc(size_t size) {
  unsigned char* result = (unsigned char*)SKIP_Obstack_alloc(size);
  SkipInt i;
  for(i = 0; i < size; i++) {
    result[i] = 0;
  }
  return result;
}

char* SKIP_new_Obstack() {
  char* saved = head;
  return saved;
}

void SKIP_destroy_Obstack(char* saved) {
  while(saved < page || saved >= end) {
    char* tofree = page;
    size_t tofree_size = *(size_t*)(page + sizeof(char*));
    page = *(char**)page;
    size_t size = *(size_t*)(page + sizeof(char*));
    end = page + size;
    free_size(tofree, tofree_size);
  }
  head = saved;
}

char* SKIP_Obstack_shallowClone(size_t size, char* obj) {
  size = size + sizeof(void*);
  char* mem = SKIP_Obstack_alloc(size);
  memcpy(mem, obj-sizeof(void*), size);
  return mem+sizeof(void*);
}

void SKIP_Obstack_auto_collect() {
}
