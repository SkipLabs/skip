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
#include <pthread.h>
#include <errno.h>
#include "runtime.h"

#define DEFAULT_CAPACITY (1024L * 1024L * 1024L * 16L)
#define BOTTOM_ADDR ((void*)0x0000001000000000)
#define FTABLE_SIZE 64

/*****************************************************************************/
/* Persistent constants. */
/*****************************************************************************/

void*** pconsts = NULL;

void* program_break = NULL;

/*****************************************************************************/
/* Database capacity. */
/*****************************************************************************/

size_t *capacity = NULL;

/*****************************************************************************/
/* Gensym. */
/*****************************************************************************/

uint64_t* gid;

uint64_t SKIP_genSym(uint64_t largerThan) {
  uint64_t n = 1;
  uint64_t gid_value = __atomic_load_n(gid, __ATOMIC_RELAXED);

  if(largerThan > 1024L * 1024L * 1024L) {
    fprintf(stderr, "ID too large: %lld\n", largerThan);
    exit(2);
  }

  if(largerThan > gid_value) {
    n += largerThan - gid_value;
  };

  return __atomic_fetch_add(gid, n, __ATOMIC_RELAXED);
}

/*****************************************************************************/
/* Global locking. */
/*****************************************************************************/

pthread_mutexattr_t* gmutex_attr;
pthread_mutex_t* gmutex = (void*)1234;

// This is only used for debugging purposes
int sk_is_locked = 0;

void sk_check_has_lock() {
  if((gmutex != NULL) && !sk_is_locked) {
    fprintf(stderr, "INTERNAL ERROR: unsafe operation\n");
    SKIP_throw(NULL);
  }
}

void sk_global_lock_init() {
  pthread_mutexattr_init(gmutex_attr);
  pthread_mutexattr_setpshared(gmutex_attr, PTHREAD_PROCESS_SHARED);
  pthread_mutexattr_setrobust(gmutex_attr, PTHREAD_MUTEX_ROBUST);
  pthread_mutex_init(gmutex, gmutex_attr);
}

void sk_global_lock() {
  if(gmutex == NULL) {
    return;
  }

  int code = pthread_mutex_lock(gmutex);
  sk_is_locked = 1;

  if(code == 0) {
    return;
  }

  if(code == EOWNERDEAD) {
    pthread_mutex_consistent(gmutex);
    return;
  }

  fprintf(stderr, "Internal error: locking failed\n");
  exit(44);
}

void sk_global_unlock() {
  if(gmutex == NULL) {
    return;
  }

  int code = pthread_mutex_unlock(gmutex);
  sk_is_locked = 0;

  if(code == 0) {
    return;
  }

  fprintf(stderr, "Internal error: global unlocking failed, %s\n", strerror(errno));
  exit(44);
}

/*****************************************************************************/
/* Mutexes/Condition variables. */
/*****************************************************************************/

void SKIP_mutex_init(pthread_mutex_t* lock) {
  if(sizeof(pthread_mutex_t) > 48) {
    fprintf(stderr, "Internal error: mutex object too large for this arch\n");
  }
  pthread_mutexattr_t mutex_attr_holder;
  pthread_mutexattr_t* mutex_attr = &mutex_attr_holder;
  pthread_mutexattr_init(mutex_attr);
  pthread_mutexattr_setpshared(mutex_attr, PTHREAD_PROCESS_SHARED);
  pthread_mutexattr_setrobust(mutex_attr, PTHREAD_MUTEX_ROBUST);
  pthread_mutex_init(lock, mutex_attr);
}

void SKIP_mutex_lock(pthread_mutex_t* lock) {
  int code = pthread_mutex_lock(lock);

  if(code == 0) {
    return;
  }

  if(code == EOWNERDEAD) {
    pthread_mutex_consistent(lock);
    return;
  }

  fprintf(stderr, "Internal error: locking failed\n");
  exit(44);
}

void SKIP_mutex_unlock(pthread_mutex_t* lock) {
  int code = pthread_mutex_unlock(lock);

  if(code == 0) {
    return;
  }

  fprintf(stderr, "Internal error: unlocking failed, %d\n", code);
  exit(44);
}

void SKIP_cond_init(pthread_cond_t* cond) {
  if(sizeof(pthread_mutex_t) > 48) {
    fprintf(stderr, "Internal error: mutex object too large for this arch\n");
  }
  pthread_condattr_t cond_attr_value;
  pthread_condattr_t* cond_attr = &cond_attr_value;
  pthread_condattr_init(cond_attr);
  pthread_condattr_setpshared(cond_attr, PTHREAD_PROCESS_SHARED);
  pthread_cond_init(cond, cond_attr);
}

void* SKIP_freeze_lock(void* x) {
  return x;
}

void* SKIP_unfreeze_lock(void* x) {
  return x;
}

void* SKIP_freeze_cond(void* x) {
  return x;
}

void* SKIP_unfreeze_cond(void* x) {
  return x;
}

void SKIP_cond_wait(pthread_cond_t* x, pthread_mutex_t* y) {
  pthread_cond_wait(x, y);
}

void SKIP_cond_broadcast(void* c) {
  pthread_cond_broadcast(c);
}

/*****************************************************************************/
/* The global information structure. */
/*****************************************************************************/

typedef struct {
  void* ginfo_array;
  void* ftable[FTABLE_SIZE];
  void* context;
  char* begin;
  char* head;
  char* end;
  char* fileName;
  char* break_ptr;
  size_t total_palloc_size;
} ginfo_t;

ginfo_t **ginfo_root = NULL;
ginfo_t **ginfo = NULL;

/*****************************************************************************/
/* Global context access primitives. */
/*****************************************************************************/

char* SKIP_context_get_unsafe() {
  char* context = (*ginfo)->context;

  if(context != NULL) {
    sk_incr_ref_count(context);
    if((*ginfo)->fileName == NULL && sk_get_ref_count(context) > 2) {
      SKIP_throwInvalidSynchronization();
    }
  }

  return context;
}

uint32_t SKIP_has_context() {
  sk_global_lock();
  char* context = (*ginfo)->context;
  uint32_t result = context != NULL;
  sk_global_unlock();
  return result;
}


SkipInt SKIP_context_ref_count() {
  char* context = (*ginfo)->context;

  if(context == NULL) {
    return (SkipInt)0;
  }
  else {
    return sk_get_ref_count(context);
  }
}

char* SKIP_context_get() {
  sk_global_lock();
  char* context = SKIP_context_get_unsafe();
  sk_global_unlock();

  return context;
}

void sk_context_set(char* obj) {
  sk_global_lock();
  (*ginfo)->context = obj;
  sk_global_unlock();
}

void sk_context_set_unsafe(char* obj) {
  void* vobj = (void*)obj;
  __atomic_store(&(*ginfo)->context, &vobj, __ATOMIC_RELAXED);
}

/*****************************************************************************/
/* File name parser (from the command line arguments). */
/*****************************************************************************/

static char* parse_args(int argc, char** argv, int* is_init) {
  int i;
  int idx = -1;

  for(i = 1; i < argc; i++) {
    if(strcmp(argv[i], "--data") == 0 || strcmp(argv[i], "--init") == 0) {
      if(strcmp(argv[i], "--init") == 0) {
        *is_init = 1;
      }
      if(i + 1 >= argc) {
        fprintf(stderr, "Error: --data/--init expects a file name");
        exit(102);
      }
      if(idx != -1) {
        fprintf(stderr, "Error: incompatible --data/--init options");
        exit(103);
      }
      idx = i+1;
    }
  }

  if(idx == -1) {
    return NULL;
  }
  else {
    return argv[idx];
  }
}

size_t parse_capacity(int argc, char** argv) {
  int i;
  int idx = -1;

  for(i = 1; i < argc; i++) {
    if(strcmp(argv[i], "--capacity") == 0) {
      if(i + 1 < argc) {
        if(argv[i+1][0] >= '0' && argv[i+1][0] <= '9') {
          int j = 0;

          while(argv[i+1][j] != 0) {
            if(argv[i+1][j] >= '0' && argv[i+1][j] <= '9') {
              j++;
              continue;
            };
            fprintf(stderr, "--capacity expects an integer\n");
            exit(2);
          }
          return atol(argv[i+1]);
        }
        else if(argv[i+1][0] == '-') {
          return DEFAULT_CAPACITY;
        }
        else {
          fprintf(stderr, "--capacity expects an integer\n");
          exit(2);
        }
      }
    }
  }
  return DEFAULT_CAPACITY;
}

/*****************************************************************************/
/* Staging/commit. */
/*****************************************************************************/

void sk_commit(char* new_root, uint32_t sync) {
  if((*ginfo)->fileName == NULL) {
    sk_context_set_unsafe(new_root);
    return;
  }

  __sync_synchronize();
  if(sync) {
    msync(BOTTOM_ADDR, *capacity, MS_SYNC);
  }
  sk_context_set_unsafe(new_root);
  if(sync) {
    msync(BOTTOM_ADDR, *capacity, MS_SYNC);
  }
}

/*****************************************************************************/
/* Creates a new file mapping. */
/*****************************************************************************/

void sk_create_mapping(char* fileName, char* static_limit, size_t icapacity) {
  if(access(fileName, F_OK) == 0) {
    fprintf(stderr, "ERROR: File %s already exists!\n", fileName);
    exit(21);
  }
  int fd = open(fileName, O_RDWR | O_CREAT, 0600);
  lseek(fd, icapacity, SEEK_SET);
  write(fd, "", 1);
  int prot = PROT_READ | PROT_WRITE;
  char* begin = mmap(BOTTOM_ADDR, icapacity, prot, MAP_SHARED | MAP_FIXED, fd, 0);
  char* end = begin + icapacity;

  if(begin == (void*)-1) {
    perror("ERROR (MMAP FAILED)");
    exit(23);
  }

  close(fd);

  char* head = begin;

  *(uint64_t*)head = SKIP_get_version();
  head += sizeof(uint64_t);

  *(void**)head = begin;
  head += sizeof(void*);

  gmutex_attr = (pthread_mutexattr_t*)head;
  head += sizeof(pthread_mutexattr_t);

  gmutex = (pthread_mutex_t*)head;
  head += sizeof(pthread_mutex_t);

  ginfo_t* ginfo_data = (ginfo_t*)head;
  head += 2 * sizeof(ginfo_t);

  ginfo = (ginfo_t**)head;
  head += sizeof(ginfo_t*);

  gid = (uint64_t*)head;
  head += sizeof(uint64_t);

  capacity = (size_t*)head;
  head += sizeof(size_t);

  pconsts = (void***)head;
  head += sizeof(void**);

  size_t fileName_length = strlen(fileName)+1;
  char* persistent_fileName = head;
  head += fileName_length;

  memcpy(persistent_fileName, fileName, fileName_length);

  *ginfo = ginfo_data;

  (*ginfo)->ginfo_array = ginfo_data;

  int i;
  for(i = 0; i < FTABLE_SIZE; i++) {
    (*ginfo)->ftable[i] = NULL;
  }

  if(head >= end) {
    fprintf(stderr, "Could not initialize memory\n");
    exit(31);
  }

  (*ginfo)->break_ptr = static_limit;
  (*ginfo)->total_palloc_size = 0;

  // The head must be aligned!
  head = (char*)(((uintptr_t)head + (uintptr_t)(15)) & ~((uintptr_t)(15)));

  (*ginfo)->begin = begin;
  (*ginfo)->head = head;
  (*ginfo)->end = end;
  (*ginfo)->fileName = persistent_fileName;
  *gid = 1;
  if(icapacity != DEFAULT_CAPACITY) {
    printf("CAPACITY SET TO: %ld\n", icapacity);
  }
  *capacity = icapacity;
  *pconsts = NULL;

  sk_global_lock_init();
}

/*****************************************************************************/
/* Loads an existing mapping. */
/*****************************************************************************/

void sk_load_mapping(char* fileName) {
  int fd = open(fileName, O_RDWR, 0600);

  if(fd == -1) {
    fprintf(stderr, "Error: could not open file (did you run --init?)\n");
    exit(25);
  }

  void* addr;
  uint64_t magic;
  lseek(fd, 0L, SEEK_SET);
  int magic_size = read(fd, &magic, sizeof(uint64_t));

  if(magic_size != sizeof(uint64_t) || magic != SKIP_get_version()) {
    fprintf(stderr, "Error: wrong file format\n");
    exit(23);
  }

  int bytes = read(fd, &addr, sizeof(void*));
  if(bytes != sizeof(void*)) {
    fprintf(stderr, "Error: could not read heap address\n");
    exit(24);
  }

  lseek(fd, 0L, SEEK_SET);

  int prot = PROT_READ | PROT_WRITE;
  lseek(fd, 0L, SEEK_END);
  size_t fsize = lseek(fd, 0, SEEK_CUR) - 1;
  char* begin = mmap(addr, fsize, prot, MAP_SHARED | MAP_FIXED, fd, 0);
  close(fd);

  if(begin == (void*)-1) {
    perror("ERROR (MMAP FAILED)");
    exit(23);
  }

  char* head = begin;
  head += sizeof(uint64_t);
  head += sizeof(void*);
  head += sizeof(pthread_mutexattr_t);
  gmutex = (pthread_mutex_t*)head;
  head += sizeof(pthread_mutex_t);
  head += 2 * sizeof(ginfo_t);
  ginfo = (ginfo_t**)head;
  head += sizeof(ginfo_t*);
  gid = (uint64_t*)head;
  head += sizeof(uint64_t);
  capacity = (size_t*)head;
  head += sizeof(size_t);
  pconsts = (void***)head;
  head += sizeof(void**);
}

/*****************************************************************************/
/* Detects pointers that come from the binary. */
/*****************************************************************************/

int sk_is_static(void* ptr) {
  return (char*)ptr <= (*ginfo)->break_ptr;
}

void sk_lower_static(void* ptr) {
  if((char*)ptr < (*ginfo)->break_ptr) {
    (*ginfo)->break_ptr = ptr;
  }
}

/*****************************************************************************/
/* Free table. */
/*****************************************************************************/

size_t sk_bit_size(size_t size) {
  return (size_t)(sizeof(size_t) * 8 - __builtin_clzl(size - 1));
}

size_t sk_pow2_size(size_t size) {
  size = (size + (sizeof(void*) - 1)) & ~(sizeof(void*)-1);
  return (1 << sk_bit_size(size));
}

void sk_add_ftable(void* ptr, size_t size) {
  int slot = sk_bit_size(size);
  *(void**)ptr = (*ginfo)->ftable[slot];
  (*ginfo)->ftable[slot] = ptr;
}

void* sk_get_ftable(size_t size) {
  int slot = sk_bit_size(size);
  void** ptr = (*ginfo)->ftable[slot];
  if(ptr == NULL) {
    return ptr;
  }
  (*ginfo)->ftable[slot] = *(void**)(*ginfo)->ftable[slot];
  return ptr;
}

/*****************************************************************************/
/* No file initialization (the memory is not backed by a file). */
/*****************************************************************************/

static void sk_init_no_file(char* static_limit) {
  ginfo = malloc(sizeof(ginfo_t*));
  *ginfo = malloc(sizeof(ginfo_t));
  (*ginfo)->break_ptr = static_limit;
  (*ginfo)->total_palloc_size = 0;
  (*ginfo)->fileName = NULL;
  gmutex = NULL;
  gid = malloc(sizeof(uint64_t));
  pconsts = malloc(sizeof(void**));
  *gid = 1;
  *pconsts = NULL;
}

int sk_is_nofile_mode() {
  return ((*ginfo)->fileName == NULL);
}

/*****************************************************************************/
/* Memory initialization. */
/*****************************************************************************/

extern SKIP_gc_type_t* epointer_ty;

void SKIP_memory_init(int argc, char** argv) {
  int is_create = 0;
  char* fileName = parse_args(argc, argv, &is_create);

  if(fileName == NULL) {
    sk_init_no_file(program_break);
  }
  else if(is_create) {
    size_t capacity = DEFAULT_CAPACITY;
    capacity = parse_capacity(argc, argv);
    sk_create_mapping(fileName, program_break, capacity);
  }
  else {
    sk_load_mapping(fileName);
  }

  char* obj = sk_get_external_pointer();
  epointer_ty = *(*(((SKIP_gc_type_t***)obj)-1)+1);
}

/*****************************************************************************/
/* Persistent alloc/free primitives. */
/*****************************************************************************/

void SKIP_print_persistent_size() {
  printf("%ld\n", (*ginfo)->total_palloc_size);
}

void* sk_palloc(size_t size) {
  if((*ginfo)->fileName == NULL) {
    return malloc(size);
  }
  sk_check_has_lock();
  size = sk_pow2_size(size);
  (*ginfo)->total_palloc_size += size;
  sk_cell_t* ptr = sk_get_ftable(size);
  if(ptr != NULL) {
    return ptr;
  }
  if((*ginfo)->head + size >= (*ginfo)->end) {
    fprintf(stderr, "Error: out of persistent memory.\n");
    exit(45);
  }
  void* result = (*ginfo)->head;
  (*ginfo)->head += size;
  return result;
}

void sk_pfree_size(void* chunk, size_t size) {
  if((*ginfo)->fileName == NULL) {
    free(chunk);
    return;
  }
  sk_check_has_lock();
  size = sk_pow2_size(size);
  (*ginfo)->total_palloc_size -= size;
  sk_add_ftable(chunk, size);
}
