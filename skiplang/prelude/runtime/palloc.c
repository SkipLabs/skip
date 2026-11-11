/*****************************************************************************/
/* Persistent memory storage. */
/*****************************************************************************/

#ifdef __ELF__
#include <elf.h>
#endif
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <unistd.h>
#ifdef __APPLE__
#include <limits.h>
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <spawn.h>
#endif

#include "alloc_size_classes.h"
#include "runtime.h"

#define DEFAULT_CAPACITY (1024L * 1024L * 1024L * 64L)
#ifdef __APPLE__
// macOS refuses fixed mappings below 0x7000000000 with EPERM.
#define BOTTOM_ADDR ((void*)0x0000010000000000)
#else
#define BOTTOM_ADDR ((void*)0x0000001000000000)
#endif
#define FTABLE_SIZE 512
_Static_assert(SK_ALLOC_SLOT_COUNT <= FTABLE_SIZE,
               "persistent free table too small");

/*****************************************************************************/
/* Persistent constants. */
/*****************************************************************************/

void*** pconsts = NULL;

/*****************************************************************************/
/* Database capacity. */
/*****************************************************************************/

size_t* capacity = NULL;

/*****************************************************************************/
/* Gensym. */
/*****************************************************************************/

uint64_t* gid;

uint64_t SKIP_genSym(uint64_t largerThan) {
  uint64_t n = 1;
  uint64_t gid_value = __atomic_load_n(gid, __ATOMIC_RELAXED);

  if (largerThan > 1024L * 1024L * 1024L) {
    fprintf(stderr, "ID too large: %" PRIu64 "\n", largerThan);
    exit(2);
  }

  if (largerThan > gid_value) {
    n += largerThan - gid_value;
  }

  return __atomic_fetch_add(gid, n, __ATOMIC_RELAXED);
}

/*****************************************************************************/
/* The global information structure. */
/*****************************************************************************/

typedef struct ginfo {
  void* ftable[FTABLE_SIZE];
  Contexts contexts;
  char* head;
  char* end;
  char* fileName;
  size_t total_palloc_size;
} ginfo_t;

ginfo_t* ginfo = NULL;

/*****************************************************************************/
/* Global locking. */
/*****************************************************************************/

pthread_mutexattr_t* gmutex_attr;
pthread_mutex_t* gmutex = (void*)1234;

// This is only used for debugging purposes
int sk_is_locked = 0;

void sk_check_has_lock() {
  if ((ginfo->fileName != NULL) && !sk_is_locked) {
    fprintf(stderr, "INTERNAL ERROR: unsafe operation\n");
    SKIP_throw_cruntime(ERROR_INTERNAL_LOCK);
  }
}

#ifdef __APPLE__
// macOS has no robust process-shared mutexes: a process dying while holding
// the global lock would block every other user of the file forever. Instead,
// every user flocks a sidecar "<file>.lock", which the kernel releases when
// its holder dies. It cannot be the mapping itself, whose flock is the users'
// lease (see sk_load_mapping). An flock belongs to the open file description,
// shared by all threads, so a process-local mutex serializes threads first.
static int sk_global_lock_fd = -1;
static pthread_mutex_t sk_global_thread_lock = PTHREAD_MUTEX_INITIALIZER;

static int sk_flock(int fd, int operation);

// The mutex in the mapping is unused on macOS.
void sk_global_lock_init() {}

static void sk_global_lock_open(const char* fileName) {
  size_t length = strlen(fileName);
  char* lockName = malloc(length + sizeof(".lock"));
  if (lockName == NULL) {
    perror("malloc");
    exit(ERROR_LOCKING);
  }
  memcpy(lockName, fileName, length);
  memcpy(lockName + length, ".lock", sizeof(".lock"));
  sk_global_lock_fd = open(lockName, O_RDWR | O_CREAT | O_CLOEXEC, 0600);
  if (sk_global_lock_fd == -1) {
    perror("ERROR: could not open persistent lock file");
    exit(ERROR_LOCKING);
  }
  free(lockName);
}

void sk_global_lock() {
  if (ginfo->fileName == NULL) {
    return;
  }

  if (pthread_mutex_lock(&sk_global_thread_lock) != 0 ||
      sk_flock(sk_global_lock_fd, LOCK_EX) != 0) {
    perror("Internal error: locking failed");
    exit(ERROR_LOCKING);
  }
  sk_is_locked = 1;
}

void sk_global_unlock() {
  if (ginfo->fileName == NULL) {
    return;
  }

  sk_is_locked = 0;
  if (sk_flock(sk_global_lock_fd, LOCK_UN) != 0 ||
      pthread_mutex_unlock(&sk_global_thread_lock) != 0) {
    perror("Internal error: global unlocking failed");
    exit(ERROR_LOCKING);
  }
}

#else  // __APPLE__

void sk_global_lock_init() {
  memset(gmutex, 0, sizeof(*gmutex));
  pthread_mutexattr_init(gmutex_attr);
  pthread_mutexattr_setpshared(gmutex_attr, PTHREAD_PROCESS_SHARED);
#ifndef __APPLE__
  pthread_mutexattr_setrobust(gmutex_attr, PTHREAD_MUTEX_ROBUST);
#endif
  pthread_mutex_init(gmutex, gmutex_attr);
}

void sk_global_lock() {
  if (ginfo->fileName == NULL) {
    return;
  }

  int code = pthread_mutex_lock(gmutex);
  sk_is_locked = 1;

  if (code == 0) {
    return;
  }

#ifndef __APPLE__
  if (code == EOWNERDEAD) {
    pthread_mutex_consistent(gmutex);
    return;
  }
#endif

  perror("Internal error: locking failed");
  exit(ERROR_LOCKING);
}

void sk_global_unlock() {
  if (ginfo->fileName == NULL) {
    return;
  }

  int code = pthread_mutex_unlock(gmutex);
  sk_is_locked = 0;

  if (code == 0) {
    return;
  }

  perror("Internal error: global unlocking failed");
  exit(ERROR_LOCKING);
}
#endif  // __APPLE__

/*****************************************************************************/
/* Mutexes/Condition variables. */
/*****************************************************************************/

void SKIP_mutex_init(pthread_mutex_t* lock) {
  if (sizeof(pthread_mutex_t) > 48) {
    fprintf(stderr, "Internal error: mutex object too large for this arch\n");
  }
  pthread_mutexattr_t mutex_attr_holder;
  pthread_mutexattr_t* mutex_attr = &mutex_attr_holder;
  pthread_mutexattr_init(mutex_attr);
  pthread_mutexattr_setpshared(mutex_attr, PTHREAD_PROCESS_SHARED);
#ifndef __APPLE__
  pthread_mutexattr_setrobust(mutex_attr, PTHREAD_MUTEX_ROBUST);
#endif
  pthread_mutex_init(lock, mutex_attr);
}

void SKIP_mutex_lock(pthread_mutex_t* lock) {
  int code = pthread_mutex_lock(lock);

  if (code == 0) {
    return;
  }

#ifndef __APPLE__
  if (code == EOWNERDEAD) {
    pthread_mutex_consistent(lock);
    return;
  }
#endif

  fprintf(stderr, "Internal error: locking failed\n");
  exit(ERROR_LOCKING);
}

void SKIP_mutex_unlock(pthread_mutex_t* lock) {
  int code = pthread_mutex_unlock(lock);

  if (code == 0) {
    return;
  }

  fprintf(stderr, "Internal error: unlocking failed, %d\n", code);
  exit(ERROR_LOCKING);
}

void SKIP_cond_init(pthread_cond_t* cond) {
  if (sizeof(pthread_mutex_t) > 48) {
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

int32_t SKIP_cond_timedwait(pthread_cond_t* x, pthread_mutex_t* y,
                            uint32_t secs) {
  struct timeval tv;
  struct timespec ts;
  gettimeofday(&tv, NULL);
  ts.tv_sec = tv.tv_sec + secs;
  ts.tv_nsec = 0;
  return (int32_t)pthread_cond_timedwait(x, y, &ts);
}

int32_t SKIP_cond_broadcast(void* c) {
  return (int32_t)pthread_cond_broadcast(c);
}

/*****************************************************************************/
/* Debugging support for contexts. Set CTX_TABLE to 1 to use. */
/*****************************************************************************/

#ifdef CTX_TABLE
char* ctx_table[CTX_TABLE_CAPACITY];
size_t ctx_table_size = 0;

int sk_find_ctx(char* context) {
  int i;
  for (i = 0; i < ctx_table_size; i++) {
    if (context == ctx_table[i]) {
      return i;
    }
  }
  return -1;
}

void sk_clean_ctx_table() {
  int i = 0;
  int j = 0;
  for (; j < ctx_table_size; j++) {
    int rcount = sk_get_ref_count(ctx_table[j]);
    if (rcount < 0) {
      fprintf(stderr, "Error: CTX_TABLE found negative ref count");
      exit(ERROR_CONTEXT_CHECK);
    }
    if (rcount == 0) {
      continue;
    }
    if (i != j) {
      ctx_table[i] = ctx_table[j];
    }
    i++;
  }
  ctx_table_size = i;
}

void sk_print_ctx_table() {
  int i = 0;
  fprintf(stderr, "---- CTX TABLE BEGIN -----\n");
  for (; i < ctx_table_size; i++) {
    fprintf(stderr, "%p, REF_COUNT: %lu\n", ctx_table[i],
            sk_get_ref_count(ctx_table[i]));
  }
  fprintf(stderr, "---- CTX TABLE END -------\n");
}

void sk_add_ctx(char* context) {
  int i = sk_find_ctx(context);
  if (i < 0) {
    if (ctx_table_size >= CTX_TABLE_CAPACITY) {
      fprintf(stderr, "Error: CTX_TABLE reached maximum capacity");
      exit(ERROR_CONTEXT_CHECK);
    }
    ctx_table[ctx_table_size] = context;
    ctx_table_size++;
  }
}

#endif

/*****************************************************************************/
/* Global context access primitives. */
/*****************************************************************************/

Contexts SKIP_contexts_get_unsafe() {
  Contexts contexts = ginfo->contexts;

  if (contexts != NULL) {
    sk_incr_ref_count(contexts);
  }

  return contexts;
}

uint32_t SKIP_has_context(Fork fork) {
  sk_global_lock();
  Contexts contexts = ginfo->contexts;
  uint32_t result =
      contexts != NULL ? SKIP_has_fork_context(contexts, fork) : 0;
  sk_global_unlock();
  return result;
}

SkipInt SKIP_context_ref_count() {
  char* context = ginfo->contexts;

  if (context == NULL) {
    return (SkipInt)0;
  } else {
    return sk_get_ref_count(context);
  }
}

Contexts SKIP_contexts_get() {
  sk_global_lock();
  Contexts context = SKIP_contexts_get_unsafe();
  sk_global_unlock();

  return context;
}

void sk_contexts_set_unsafe(Contexts obj) {
  ginfo->contexts = obj;
#ifdef CTX_TABLE
  sk_add_ctx(obj);
#endif
}

void sk_contexts_set(Contexts obj) {
  sk_global_lock();
  ginfo->contexts = obj;
  sk_global_unlock();
}

/*****************************************************************************/
/* File name parser (from the command line arguments). */
/*****************************************************************************/

static char* parse_args(int argc, char** argv, int* is_init) {
  // FIXME
  if (argc > 0 && strcmp(argv[0], "skargo") == 0) {
    return NULL;
  }

  int i;
  int idx = -1;

  for (i = 1; i < argc; i++) {
    if (strcmp(argv[i], "--data") == 0 || strcmp(argv[i], "--init") == 0) {
      if (strcmp(argv[i], "--init") == 0) {
        *is_init = 1;
      }
      if (i + 1 >= argc) {
        fprintf(stderr, "Error: --data/--init expects a file name");
        exit(ERROR_ARG_PARSE);
      }
      if (idx != -1) {
        fprintf(stderr, "Error: incompatible --data/--init options");
        exit(ERROR_ARG_PARSE);
      }
      idx = i + 1;
    }
  }

  if (idx == -1) {
    return NULL;
  } else {
    return argv[idx];
  }
}

// Parse a byte count, optionally suffixed with K/M/G (case-insensitive,
// multipliers 1024, 1024^2, 1024^3). On malformed input or size_t overflow,
// writes to stderr citing `source` and exits with code 2.
static size_t parse_capacity_value(const char* str, const char* source) {
  if (str[0] < '0' || str[0] > '9') {
    fprintf(stderr,
            "%s expects an integer (optionally suffixed with K, M, or G)\n",
            source);
    exit(2);
  }
  size_t value = 0;
  int j = 0;
  while (str[j] >= '0' && str[j] <= '9') {
    size_t digit = (size_t)(str[j] - '0');
    if (value > (SIZE_MAX - digit) / 10) {
      fprintf(stderr, "%s: value out of range\n", source);
      exit(2);
    }
    value = value * 10 + digit;
    j++;
  }
  size_t multiplier = 1;
  if (str[j] != 0) {
    char c = str[j];
    if (c >= 'a' && c <= 'z') c = (char)(c - 'a' + 'A');
    if (c == 'K') {
      multiplier = 1024L;
    } else if (c == 'M') {
      multiplier = 1024L * 1024L;
    } else if (c == 'G') {
      multiplier = 1024L * 1024L * 1024L;
    } else {
      fprintf(stderr,
              "%s expects an integer (optionally suffixed with K, M, or G)\n",
              source);
      exit(2);
    }
    if (str[j + 1] != 0) {
      fprintf(stderr,
              "%s expects an integer (optionally suffixed with K, M, or G)\n",
              source);
      exit(2);
    }
  }
  if (multiplier > 1 && value > SIZE_MAX / multiplier) {
    fprintf(stderr, "%s: value out of range\n", source);
    exit(2);
  }
  return value * multiplier;
}

size_t parse_capacity(int argc, char** argv) {
  int i;

  for (i = 1; i < argc; i++) {
    if (strcmp(argv[i], "--capacity") == 0) {
      if (i + 1 < argc) {
        // Preserve the existing quirk: `--capacity -<something>` silently
        // falls back to the default.
        if (argv[i + 1][0] == '-') {
          return DEFAULT_CAPACITY;
        }
        return parse_capacity_value(argv[i + 1], "--capacity");
      }
    }
  }

  const char* env = getenv("SKIP_CAPACITY");
  if (env != NULL && env[0] != '\0') {
    return parse_capacity_value(env, "SKIP_CAPACITY");
  }

  return DEFAULT_CAPACITY;
}

/*****************************************************************************/
/* Staging/commit. */
/*****************************************************************************/

void sk_commit(Contexts new_root, uint32_t sync) {
  if (ginfo->fileName == NULL) {
    sk_contexts_set_unsafe(new_root);
    return;
  }

  __sync_synchronize();
  if (sync) {
    msync(BOTTOM_ADDR, *capacity, MS_SYNC);
  }
  sk_contexts_set_unsafe(new_root);
  if (sync) {
    msync(BOTTOM_ADDR, *capacity, MS_SYNC);
  }
}

/*****************************************************************************/
/* Disk-persisted state, a.k.a. file mapping. */
/*****************************************************************************/

typedef struct file_mapping file_mapping_t;

// A persistent heap holds absolute pointers into the executable that wrote it
// (vtables, type descriptors, constants), so only that exact executable may
// reopen it. The header records the executable's GNU build-id: the linker
// derives it from the linked contents, so it is stable when the same inputs
// are rebuilt (e.g. in a fresh checkout) and changes with any change to code,
// runtime, layouts, flags or toolchain (#1606).
#define SK_MAPPING_MAGIC 0x31504d4e504b53ULL  // "SKPNMP1" (little-endian)
#define SK_BUILD_ID_MAX 64

typedef struct {
  uint64_t magic;
  file_mapping_t* bottom_addr;
  uint32_t build_id_size;
  unsigned char build_id[SK_BUILD_ID_MAX];
} file_mapping_header_t;

struct file_mapping {
  file_mapping_header_t header;
  pthread_mutexattr_t gmutex_attr;
  pthread_mutex_t gmutex;
  ginfo_t ginfo_data;
  uint64_t gid;
  size_t capacity;
  void** pconsts;
  char persistent_fileName[1];
};

/*****************************************************************************/
/* File locks on persistent mappings. */
/*****************************************************************************/

// A blocking flock can fail with EINTR when a signal handler installed without
// SA_RESTART runs while waiting; retry instead of treating that as an error.
static int sk_flock(int fd, int operation) {
  int rv;
  while ((rv = flock(fd, operation)) != 0 && errno == EINTR) {
  }
  return rv;
}

/*****************************************************************************/
/* Identity of the running executable. */
/*****************************************************************************/

#ifdef __ELF__
// Defined by the linker at the start of the executable's ELF header. Weak, so
// a link without it yields NULL instead of failing.
extern const Elf64_Ehdr __ehdr_start
    __attribute__((weak, visibility("hidden")));

// Copies the NT_GNU_BUILD_ID note of the object containing this code into
// `out` and returns its size, or 0 when it has none.
static uint32_t sk_read_build_id(unsigned char* out, uint32_t max) {
  const Elf64_Ehdr* eh = &__ehdr_start;
  if (eh == NULL || memcmp(eh->e_ident, ELFMAG, SELFMAG) != 0) {
    return 0;
  }
  const Elf64_Phdr* ph = (const Elf64_Phdr*)((const char*)eh + eh->e_phoff);
  // The ELF header is mapped by the load segment at file offset 0; its
  // address gives the load bias (0 for the non-PIE executables skc links).
  uintptr_t bias = 0;
  int found = 0;
  for (int i = 0; i < eh->e_phnum; i++) {
    if (ph[i].p_type == PT_LOAD && ph[i].p_offset == 0) {
      bias = (uintptr_t)eh - ph[i].p_vaddr;
      found = 1;
      break;
    }
  }
  if (!found) {
    return 0;
  }
  for (int i = 0; i < eh->e_phnum; i++) {
    if (ph[i].p_type != PT_NOTE) {
      continue;
    }
    const char* note = (const char*)(bias + ph[i].p_vaddr);
    const char* end = note + ph[i].p_memsz;
    while (note + sizeof(Elf64_Nhdr) <= end) {
      const Elf64_Nhdr* nhdr = (const Elf64_Nhdr*)note;
      const char* name = note + sizeof(*nhdr);
      const unsigned char* desc =
          (const unsigned char*)(name + ((nhdr->n_namesz + 3) & ~3u));
      if (nhdr->n_type == NT_GNU_BUILD_ID && nhdr->n_namesz == 4 &&
          memcmp(name, "GNU", 4) == 0) {
        if (nhdr->n_descsz == 0 || nhdr->n_descsz > max) {
          return 0;
        }
        memcpy(out, desc, nhdr->n_descsz);
        return nhdr->n_descsz;
      }
      note = (const char*)desc + ((nhdr->n_descsz + 3) & ~3u);
    }
  }
  return 0;
}
#elif defined(__APPLE__)
// Mach-O has no GNU build-id; ld64 always records an LC_UUID derived from the
// linked contents, which plays the same role.
static uint32_t sk_read_build_id(unsigned char* out, uint32_t max) {
  const struct mach_header_64* mh =
      (const struct mach_header_64*)_dyld_get_image_header(0);
  if (mh == NULL || mh->magic != MH_MAGIC_64) {
    return 0;
  }
  const struct load_command* lc = (const struct load_command*)(mh + 1);
  for (uint32_t i = 0; i < mh->ncmds; i++) {
    if (lc->cmd == LC_UUID) {
      const struct uuid_command* uc = (const struct uuid_command*)lc;
      if (sizeof(uc->uuid) > max) {
        return 0;
      }
      memcpy(out, uc->uuid, sizeof(uc->uuid));
      return sizeof(uc->uuid);
    }
    lc = (const struct load_command*)((const char*)lc + lc->cmdsize);
  }
  return 0;
}
#else
static uint32_t sk_read_build_id(unsigned char* out, uint32_t max) {
  (void)out;
  (void)max;
  return 0;
}
#endif

// Fills `header` with this executable's identity. A persistent heap cannot be
// checked without one, so refuse to create or load it.
static void sk_mapping_identity(file_mapping_header_t* header) {
  memset(header, 0, sizeof(*header));
  header->magic = SK_MAPPING_MAGIC;
  header->build_id_size = sk_read_build_id(header->build_id, SK_BUILD_ID_MAX);
  if (header->build_id_size == 0) {
    fprintf(stderr,
            "Error: this executable has no GNU build-id, which persistent "
            "files require (link with -Wl,--build-id)\n");
    exit(ERROR_MAPPING_VERSION);
  }
}

/*****************************************************************************/
/* Creates a new file mapping. */
/*****************************************************************************/

void sk_create_mapping(char* fileName, size_t icapacity) {
  file_mapping_t* mapping;
  file_mapping_header_t identity;
  memset(&identity, 0, sizeof(identity));
  int fd = -1;
  int prot = PROT_READ | PROT_WRITE;
  if (fileName == NULL) {
    // The capacity is a sparse upper bound (64 GiB by default), not memory to
    // commit up front. Without MAP_NORESERVE, heuristic overcommit refuses a
    // private writable mapping larger than RAM plus swap.
    mapping = mmap(NULL, icapacity, prot,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
  } else {
    sk_mapping_identity(&identity);
    fd = open(fileName, O_RDWR | O_CREAT | O_EXCL | O_CLOEXEC, 0600);
    if (fd == -1) {
      // perror may change errno (glibc sets EINVAL when stderr is not a tty).
      int open_errno = errno;
      perror("ERROR: could not create persistent mapping");
      exit(open_errno == EEXIST ? ERROR_MAPPING_EXISTS : ERROR_FILE_IO);
    }
    if (sk_flock(fd, LOCK_EX) != 0) {
      perror("ERROR: could not lock persistent mapping");
      exit(ERROR_LOCKING);
    }
    lseek(fd, icapacity, SEEK_SET);
    (void)write(fd, "", 1);
    mapping = mmap(BOTTOM_ADDR, icapacity, prot, MAP_SHARED | MAP_FIXED, fd, 0);
  }

  if (mapping == MAP_FAILED) {
    perror("ERROR (MAP FAILED)");
    exit(ERROR_MAPPING_FAILED);
  }

  mapping->header = identity;
  mapping->header.bottom_addr = mapping;

  gmutex_attr = &mapping->gmutex_attr;
  gmutex = &mapping->gmutex;
  ginfo = &mapping->ginfo_data;
  gid = &mapping->gid;
  capacity = &mapping->capacity;
  pconsts = &mapping->pconsts;

  size_t fileName_length = (fileName != NULL) ? strlen(fileName) + 1 : 0;
  char* persistent_fileName = mapping->persistent_fileName;

  char* head = persistent_fileName + fileName_length;
  char* end = (char*)mapping + icapacity;

  if (head >= end) {
    fprintf(stderr, "Could not initialize memory\n");
    exit(ERROR_MAPPING_MEMORY);
  }

  if (fileName != NULL) {
    memcpy(persistent_fileName, fileName, fileName_length);
  } else {
    persistent_fileName = "";
  }

  int i;
  for (i = 0; i < FTABLE_SIZE; i++) {
    ginfo->ftable[i] = NULL;
  }

  ginfo->total_palloc_size = 0;

  // The head must be aligned!
  head = (char*)(((uintptr_t)head + (uintptr_t)(15)) & ~((uintptr_t)(15)));

  ginfo->head = head;
  ginfo->end = end;
  ginfo->fileName = (fileName != NULL) ? persistent_fileName : NULL;
  ginfo->contexts = NULL;
  *gid = 1;
  *capacity = icapacity;
  *pconsts = NULL;

  if (ginfo->fileName != NULL) {
    sk_global_lock_init();
    // Keep fd open with a shared lock until exit. A later process can acquire
    // an exclusive lock only after all users of this mapping have exited.
    if (sk_flock(fd, LOCK_SH) != 0) {
      perror("ERROR: could not share persistent mapping lock");
      exit(ERROR_LOCKING);
    }
  }
}

/*****************************************************************************/
/* Loads an existing mapping. */
/*****************************************************************************/

void sk_load_mapping(char* fileName) {
  int fd = open(fileName, O_RDWR | O_CLOEXEC, 0600);

  if (fd == -1) {
    fprintf(stderr, "Error: could not open file (did you run --init?)\n");
    exit(ERROR_FILE_IO);
  }

  // A mutex stored in the file can retain an owner from a previous process
  // namespace. The first user in this runtime epoch resets it under an
  // exclusive file lock. Other live users hold a shared lock until exit.
  int first_user = sk_flock(fd, LOCK_EX | LOCK_NB) == 0;
  if (!first_user) {
    if (errno != EWOULDBLOCK || sk_flock(fd, LOCK_SH) != 0) {
      perror("ERROR: could not lock persistent mapping");
      exit(ERROR_LOCKING);
    }
  }

  file_mapping_header_t header;
  lseek(fd, 0L, SEEK_SET);
  int bytes = read(fd, &header, sizeof(file_mapping_header_t));

  if (bytes != sizeof(file_mapping_header_t)) {
    fprintf(stderr, "Error: could not read header\n");
    exit(ERROR_MAPPING_MEMORY);
  }

  file_mapping_header_t identity;
  sk_mapping_identity(&identity);
  if (header.magic != SK_MAPPING_MAGIC ||
      header.build_id_size != identity.build_id_size ||
      memcmp(header.build_id, identity.build_id, identity.build_id_size) != 0) {
    fprintf(stderr,
            "Error: wrong file format: %s was written by a different "
            "executable (build-id mismatch); delete it and rerun with "
            "--init\n",
            fileName);
    exit(ERROR_MAPPING_VERSION);
  }

  size_t fsize = lseek(fd, 0, SEEK_END) - 1;
  int prot = PROT_READ | PROT_WRITE;
  file_mapping_t* mapping =
      mmap(header.bottom_addr, fsize, prot, MAP_SHARED | MAP_FIXED, fd, 0);

  if (mapping == MAP_FAILED) {
    perror("ERROR (MAP FAILED)");
    exit(ERROR_MAPPING_FAILED);
  }

  gmutex = &mapping->gmutex;
  gmutex_attr = &mapping->gmutex_attr;
  ginfo = &mapping->ginfo_data;
  gid = &mapping->gid;
  capacity = &mapping->capacity;
  pconsts = &mapping->pconsts;
  if (first_user) {
    sk_global_lock_init();
    if (sk_flock(fd, LOCK_SH) != 0) {
      perror("ERROR: could not share persistent mapping lock");
      exit(ERROR_LOCKING);
    }
  }
}

/*****************************************************************************/
/* Detects pointers that come from the binary. */
/*****************************************************************************/

int obstack_intervals_contains(void*);

int sk_is_static(void* ptr) {
  return !((char*)ginfo <= (char*)ptr && (char*)ptr < ginfo->end);
}

/*****************************************************************************/
/* Free table. */
/*****************************************************************************/

void sk_add_ftable(void* ptr, slot_t slot) {
  *(void**)ptr = ginfo->ftable[slot];
  ginfo->ftable[slot] = ptr;
}

void* sk_get_ftable(slot_t slot) {
  void** ptr = ginfo->ftable[slot];
  if (ptr == NULL) {
    return ptr;
  }
  ginfo->ftable[slot] = *ptr;
  return ptr;
}

/*****************************************************************************/
/* No file initialization (the memory is not backed by a file). */
/*****************************************************************************/

#ifdef __APPLE__
// A persistent heap holds absolute pointers into the executable, so it must
// be loaded at the same address in every run. arm64 macOS cannot link
// non-PIE executables, so when ASLR slid the executable, re-execute it in
// place with ASLR disabled (the private posix_spawn flag lldb uses). The
// environment variable stops a loop if the kernel ignores the flag; it is
// removed so that subprocesses (e.g. skc run by skargo) re-execute too.
#define SK_POSIX_SPAWN_DISABLE_ASLR 0x0100
#define SK_NO_ASLR_ENV "SKIP_RUNTIME_NO_ASLR"

extern char** environ;

static void sk_disable_aslr(char** argv) {
  int relaunched = getenv(SK_NO_ASLR_ENV) != NULL;
  if (relaunched) {
    unsetenv(SK_NO_ASLR_ENV);
  }
  if (_dyld_get_image_vmaddr_slide(0) == 0) {
    return;
  }
  if (relaunched) {
    fprintf(stderr,
            "Error: could not disable ASLR, which persistent files require\n");
    exit(ERROR_MAPPING_FAILED);
  }

  char path[PATH_MAX];
  uint32_t size = sizeof(path);
  if (_NSGetExecutablePath(path, &size) != 0) {
    fprintf(stderr, "Error: executable path too long\n");
    exit(ERROR_MAPPING_FAILED);
  }
  posix_spawnattr_t attr;
  int rv = posix_spawnattr_init(&attr);
  if (rv == 0) {
    rv = posix_spawnattr_setflags(
        &attr, POSIX_SPAWN_SETEXEC | SK_POSIX_SPAWN_DISABLE_ASLR);
  }
  if (rv == 0 && setenv(SK_NO_ASLR_ENV, "1", 1) != 0) {
    rv = errno;
  }
  if (rv == 0) {
    // Only returns on failure.
    rv = posix_spawn(NULL, path, NULL, &attr, argv, environ);
  }
  fprintf(stderr, "Error: could not re-execute %s without ASLR: %s\n", path,
          strerror(rv));
  exit(ERROR_MAPPING_FAILED);
}
#endif  // __APPLE__

int sk_is_nofile_mode() {
  return (ginfo->fileName == NULL);
}

/*****************************************************************************/
/* Memory initialization. */
/*****************************************************************************/

extern SKIP_gc_type_t* epointer_ty;

void SKIP_memory_init(int argc, char** argv) {
  int is_create = 0;
  char* fileName = parse_args(argc, argv, &is_create);

#ifdef __APPLE__
  if (fileName != NULL) {
    sk_disable_aslr(argv);
  }
#endif

  if (is_create || fileName == NULL) {
    size_t capacity = DEFAULT_CAPACITY;
    capacity = parse_capacity(argc, argv);
    sk_create_mapping(fileName, capacity);
  } else {
    sk_load_mapping(fileName);
  }

#ifdef __APPLE__
  if (fileName != NULL) {
    sk_global_lock_open(fileName);
  }
#endif

  char* obj = sk_get_external_pointer();
  epointer_ty = get_gc_type(obj);
}

/*****************************************************************************/
/* Persistent alloc/free primitives. */
/*****************************************************************************/

void SKIP_print_persistent_size() {
  printf("%ld\n", ginfo->total_palloc_size);
}

void* sk_palloc(size_t size) {
  sk_check_has_lock();
  slot_t slot = sk_slot_of_size(size);
  size = sk_size_of_slot(slot);
  ginfo->total_palloc_size += size;
  sk_cell_t* ptr = sk_get_ftable(slot);
  if (ptr != NULL) {
    return ptr;
  }
  if (ginfo->head + size >= ginfo->end) {
    fprintf(stderr, "Error: out of persistent memory.\n");
    exit(ERROR_OUT_OF_MEMORY);
  }
  void* result = ginfo->head;
  ginfo->head += size;
  return result;
}

void sk_pfree_size(void* chunk, size_t size) {
  sk_check_has_lock();
  slot_t slot = sk_slot_of_size(size);
  size = sk_size_of_slot(slot);
  ginfo->total_palloc_size -= size;
  sk_add_ftable(chunk, slot);
}
