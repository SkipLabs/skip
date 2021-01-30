/*****************************************************************************/
/* Persistent memory storage. */
/*****************************************************************************/

#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include "runtime.h"

#define PERSISTENT_PAGE_SIZE (16 * 1024 * 1024)
#define MAX_STRING_SIZE 1024

/*****************************************************************************/
/* Detects pointers that come from the binary. */
/*****************************************************************************/

__thread char* break_ptr = NULL;

int sk_is_static(void* ptr) {
  if(break_ptr == NULL) {
    break_ptr = sbrk(0);
  }
  return (char*)ptr < break_ptr;
}

/*****************************************************************************/
/* Returns the directory where persistent objects are stored. */
/*****************************************************************************/

char skfs_dir[] = "/tmp/skfs";

void mkdir_SKFS() {

  struct stat st = {0};

  if (stat(skfs_dir, &st) == -1) {
    if(mkdir(skfs_dir, 0700) == -1) {
      perror("ERROR (Could not create directory /tmp/skfs)");
      exit(23);
    }
  }
}

static size_t sk_ppage_nbr = 0;
static char** sk_phead = NULL;
static char** sk_pend = NULL;

static size_t sk_get_nbr_pages() {
  char filename[MAX_STRING_SIZE];
  strcpy(filename, skfs_dir);
  strcat(filename, "/info");

  int fd = open(filename, O_RDWR | O_CREAT, 0600);

  if(fd == -1) {
    perror("ERROR (OPEN NBR PAGE FAILED)");
    exit(22);
  }

  size_t nbr_pages;
  int n = read(fd, &nbr_pages, sizeof(size_t));
  if(n != sizeof(size_t)) {
    fprintf(stderr, "ERROR: could not read number of pages\n");
    exit(28);
  }
  close(fd);

  return nbr_pages;
}

static void sk_update_nbr_pages(size_t nbr) {
  char filename[MAX_STRING_SIZE];
  strcpy(filename, skfs_dir);
  strcat(filename, "/info");

  int fd = open(filename, O_RDWR | O_CREAT, 0600);

  if(fd == -1) {
    perror("ERROR (OPEN NBR PAGE FAILED)");
    exit(22);
  }

  size_t n = write(fd, &nbr, sizeof(size_t));

  if(n != sizeof(size_t)) {
    fprintf(stderr, "ERROR: could not write nbr pages\n");
    exit(27);
  }

  lseek(fd, 0, SEEK_SET);
  close(fd);
}

void sk_make_page_name(char* page_name, size_t page_nbr) {
  char page_nbr_str[MAX_STRING_SIZE];
  strcpy(page_name, skfs_dir);
  strcat(page_name, "/data");
  sprintf(page_nbr_str, "%ld", page_nbr);
  strcat(page_name, page_nbr_str);
}

void sk_make_page_info_name(char* page_name, size_t page_nbr) {
  char page_nbr_str[MAX_STRING_SIZE];
  strcpy(page_name, skfs_dir);
  strcat(page_name, "/pinfo");
  sprintf(page_nbr_str, "%ld", page_nbr);
  strcat(page_name, page_nbr_str);
}

size_t sk_round_page_size(size_t size) {
  size_t sys_pagesize = getpagesize();
  if(size % sys_pagesize != 0) {
    size = (size + (sys_pagesize - 1)) & ~(sys_pagesize-1);
  }
  return size;
}

void sk_save_page_info(size_t page_nbr, void* addr, size_t size) {
  char filename[MAX_STRING_SIZE];
  sk_make_page_info_name(filename, page_nbr);

  int fd = open(filename, O_RDWR | O_CREAT, 0600);

  if(fd == -1) {
    perror("ERROR (OPEN FAILED)");
    exit(22);
  }

  size_t n1 = write(fd, &addr, sizeof(void*));
  size_t n2 = write(fd, &size, sizeof(size_t));
  if(n1 != sizeof(void*) || n2 != sizeof(size_t)) {
    fprintf(stderr, "Could not save page info\n");
    exit(29);
  }

  close(fd);
}

void sk_load_page_info(size_t page_nbr, void** addr, size_t* size) {
  char filename[MAX_STRING_SIZE];
  sk_make_page_info_name(filename, page_nbr);

  int fd = open(filename, O_RDONLY, 0600);

  if(fd == -1) {
    perror("ERROR (OPEN PAGE INFO FAILED)");
    exit(22);
  }

  size_t n1 = read(fd, addr, sizeof(void*));
  size_t n2 = read(fd, size, sizeof(size_t));
  if(n1 != sizeof(void*) || n2 != sizeof(size_t)) {
    fprintf(stderr, "Could not load page info\n");
    exit(30);
  }

  close(fd);
}

size_t sk_alloc_page(size_t size, char** heap) {
  void* result;
  mkdir_SKFS();
  size = sk_round_page_size(size);

  char page_name[MAX_STRING_SIZE];
  sk_make_page_name(page_name, sk_ppage_nbr);

  int fd = open(page_name, O_RDWR | O_CREAT, 0600);
  if(fd == -1) {
    perror("ERROR (OPEN FAILED)");
    exit(22);
  }
  lseek(fd, size-1, SEEK_SET);
  write(fd, "", 1);

  *heap = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

  if(*heap == (void*)-1) {
    perror("ERROR (MMAP FAILED)");
    exit(23);
  }

  close(fd);
  return size;
}

void sk_new_ppage(size_t size) {
  size_t real_size = sk_alloc_page(size, sk_phead);
  sk_save_page_info(sk_ppage_nbr, *sk_phead, real_size);
  sk_ppage_nbr++;
  sk_update_nbr_pages(sk_ppage_nbr);
  *sk_pend = *sk_phead + real_size;
}

/*****************************************************************************/
/* Free table. */
/*****************************************************************************/

void** sk_ftable;

size_t sk_bit_size(size_t size) {
  return (size_t)(sizeof(size_t) * 8 - __builtin_clzl(size - 1));
}

size_t sk_pow2_size(size_t size) {
  size = (size + (sizeof(void*) - 1)) & ~(sizeof(void*)-1);
  return (1 << sk_bit_size(size));
}

void sk_add_ftable(void* ptr, size_t size) {
  int slot = sk_bit_size(size);
  *(void**)ptr = sk_ftable[slot];
  sk_ftable[slot] = ptr;
}

void* sk_get_ftable(size_t size) {
  int slot = sk_bit_size(size);
  void** ptr = sk_ftable[slot];
  if(ptr == NULL) {
    return ptr;
  }
  sk_ftable[slot] = *(void**)sk_ftable[slot];
  return ptr;
}

extern void** context;

void SKIP_memory_init() {
  char* init_heap;
  size_t size = sk_alloc_page(PERSISTENT_PAGE_SIZE, &init_heap);
  char* heap = init_heap;
  char* heap_end = heap + size;

  sk_ftable = (void**)heap;
  int i;
  for(i = 0; i < 64; i++) {
    sk_ftable[i] = NULL;
  }
  heap += (sizeof(void*) * 64);

  context = (void**)heap;
  heap += sizeof(void**);

  sk_phead = (char**)heap;
  heap += sizeof(char**);

  sk_pend = (char**)heap;
  heap += sizeof(char**);

  if(heap >= heap_end) {
    fprintf(stderr, "Could not initialize memory\n");
    exit(31);
  }

  *sk_phead = heap;
  *sk_pend = heap_end;

  sk_save_page_info(sk_ppage_nbr, init_heap, size);
  sk_ppage_nbr++;
  sk_update_nbr_pages(sk_ppage_nbr);
}

static size_t sk_round_size(size_t size) {
  if(size > sizeof(void*)) {
    size = (size + (sizeof(void*) - 1)) & ~(sizeof(void*)-1);
  }
  if(size < sizeof(void*) * 2) {
    size = 2 * sizeof(void*);
  }
  return size;
}

size_t total_palloc_size = 0;

void* sk_alloc(size_t size) {
  size = sk_pow2_size(size);
  total_palloc_size += size;
  sk_cell_t* ptr = sk_get_ftable(size);
  if(ptr != NULL) {
    return ptr;
  }
  if(*sk_phead + size >= *sk_pend) {
    sk_new_ppage((size > PERSISTENT_PAGE_SIZE)? size : PERSISTENT_PAGE_SIZE);
  }
  void* result = *sk_phead;
  *sk_phead += size;
  return result;
}

void sk_sk_free_size(void* chunk, size_t size) {
  size = sk_pow2_size(size);
  total_palloc_size -= size;
  sk_add_ftable(chunk, size);
}

void SKIP_load_context() {
  sk_ppage_nbr = sk_get_nbr_pages();
  int i;

  for(i = 0; i < sk_ppage_nbr; i++) {
    char page_name[MAX_STRING_SIZE];
    sk_make_page_name(page_name, i);

    void* page_addr;
    size_t page_size;
    sk_load_page_info(i, &page_addr, &page_size);


    int fd = open(page_name, O_RDWR, 0600);

    if(fd == -1) {
      perror("ERROR (OPEN FAILED)");
      exit(22);
    }

    void* mmpage_addr = mmap(page_addr, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);

    if(mmpage_addr != page_addr) {
      fprintf(stderr, "Could not load page %p %p\n", mmpage_addr, page_addr);
      exit(33);
    }

    close(fd);

    if(i == 0) {
      sk_ftable = (void**)page_addr;
      page_addr += (sizeof(void*) * 64);

      context = (void**)page_addr;
      page_addr += sizeof(void**);

      sk_phead = (char**)page_addr;
      page_addr += sizeof(char**);

      sk_pend = (char**)page_addr;
      page_addr += sizeof(char**);

      if(*context == NULL) {
        fprintf(stderr, "Could not load context\n");
        exit(32);
      }
    }
  }
}
