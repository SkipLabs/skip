// Regression test: a persistent file starts at INITIAL_CAPACITY and grows on
// demand via ftruncate up to the capacity bound (DEFAULT_CAPACITY, raised by
// SKIP_CAPACITY or --capacity; the flag wins over the env var), while the VA
// mapping spans the full capacity up front so peers see newly grown pages
// immediately without remapping. Existing contents must survive a growth, and
// hitting the bound is a clean out-of-memory exit. The anonymous heap is
// mapped at its full capacity up front. Build with section GC so only the
// exercised parts of palloc.c need runtime definitions.
#define _DEFAULT_SOURCE
#define SKIP64 1
#include <sys/stat.h>
#include <sys/wait.h>

#include "../palloc.c"

// Stub for the error path pulled in by sk_check_has_lock / sk_slot_of_size.
void SKIP_throw_cruntime(int32_t code) {
  fprintf(stderr, "SKIP_throw_cruntime(%" PRId32 ")\n", code);
  exit(code);
}

int main(void) {
  char* argv_default[] = {"test", NULL};
  char* argv_flag[] = {"test", "--capacity", "2G", NULL};
  unsetenv("SKIP_CAPACITY");
  // --capacity > SKIP_CAPACITY > default bound of 64 GiB.
  if (parse_capacity(1, argv_default) != DEFAULT_CAPACITY) return 1;
  if (DEFAULT_CAPACITY != 64L * 1024L * 1024L * 1024L) return 2;
  setenv("SKIP_CAPACITY", "12G", 1);
  if (parse_capacity(1, argv_default) != 12L * 1024L * 1024L * 1024L) return 3;
  if (parse_capacity(3, argv_flag) != 2L * 1024L * 1024L * 1024L) return 4;
  unsetenv("SKIP_CAPACITY");

  // Anonymous heap: mapped at its full capacity up front (sparse).
  sk_create_mapping(NULL, DEFAULT_CAPACITY);
  if (ginfo->end <= ginfo->head ||
      (size_t)(ginfo->end - ginfo->head) <
          DEFAULT_CAPACITY - 2 * sizeof(file_mapping_t))
    return 6;

  // File-backed heap: the VA mapping spans the full capacity up front, while
  // the backing file starts at INITIAL_CAPACITY (64 MiB) and grows via
  // ftruncate on demand, never past the bound; the header keeps the capacity
  // bound. Contents survive the growth.
  char dir[] = "/tmp/skip-mapping-growth-XXXXXX";
  if (mkdtemp(dir) == NULL) return 7;
  char path[sizeof(dir) + 4];
  strcpy(path, dir);
  strcat(path, "/db");
  size_t cap = 3 * INITIAL_CAPACITY;
  sk_create_mapping(path, cap);
  char* base = (char*)BOTTOM_ADDR;
  if (ginfo->end != base + INITIAL_CAPACITY) return 8;
  if (*capacity != cap) return 9;
  struct stat st;
  if (fstat(sk_data_fd, &st) != 0 || (size_t)st.st_size != INITIAL_CAPACITY + 1)
    return 10;
#ifdef __APPLE__
  sk_global_lock_open(path);
#endif
  sk_global_lock();
  size_t chunk = sk_size_of_slot(sk_slot_of_size(64 * 1024));
  void* first = sk_palloc(64 * 1024);
  if (first == NULL) {
    sk_global_unlock();
    return 11;
  }
  memset(first, 0x5A, 64 * 1024);
  size_t count = INITIAL_CAPACITY / chunk + 4;
  for (size_t i = 1; i < count; i++) {
    if (sk_palloc(64 * 1024) == NULL) {
      sk_global_unlock();
      return 12;
    }
  }
  sk_global_unlock();
  size_t grown = (size_t)(ginfo->end - base);
  if (grown <= INITIAL_CAPACITY) return 13;  // it grew
  if (grown > cap) return 14;                // but not past the bound
  if (fstat(sk_data_fd, &st) != 0 || (size_t)st.st_size != grown + 1) return 16;
  if (((unsigned char*)first)[0] != 0x5A ||
      ((unsigned char*)first)[64 * 1024 - 1] != 0x5A)
    return 17;
  // Reloading maps the full capacity up front and preserves the grown file
  // size and bound.
  sk_load_mapping(path);
  if ((size_t)(ginfo->end - base) != grown) return 18;
  if (*capacity != cap) return 19;

  // Cross-process visibility: a second process grows the file past `grown`
  // via ftruncate. Because both processes already mapped the full capacity
  // with MAP_SHARED, the parent sees the updated ginfo->end and reads the
  // newly grown pages directly with no remap or lock-time sync.
  pid_t grower = fork();
  if (grower == 0) {
#ifdef __APPLE__
    // Re-open the lock fd so the child has its own open file description
    // (flock is per open file description, not per process).
    sk_global_lock_open(path);
#endif
    sk_global_lock();
    size_t more = (grown - (size_t)(ginfo->head - base)) / chunk + 4;
    void* last = NULL;
    for (size_t i = 0; i < more; i++) {
      last = sk_palloc(64 * 1024);
      if (last == NULL) _exit(30);
    }
    memset(last, 0xA5, 64 * 1024);
    ginfo->contexts = (Contexts)last;
    size_t child_grown = (size_t)(ginfo->end - base);
    sk_global_unlock();
    _exit(child_grown > grown && child_grown <= cap ? 0 : 31);
  }
  int gstatus = 0;
  if (waitpid(grower, &gstatus, 0) != grower) return 22;
  if (!WIFEXITED(gstatus) || WEXITSTATUS(gstatus) != 0) return 23;
  // Readable immediately without even taking the global lock.
  size_t parent_seen = (size_t)(ginfo->end - base);
  if (parent_seen <= grown || parent_seen > cap) return 24;
  if (fstat(sk_data_fd, &st) != 0 || (size_t)st.st_size != parent_seen + 1)
    return 25;
  unsigned char* from_child = (unsigned char*)ginfo->contexts;
  if (from_child[0] != 0xA5 || from_child[64 * 1024 - 1] != 0xA5) return 26;
  // Also verify sk_commit (msync over the grown length) succeeds.
  sk_global_lock();
  sk_commit(ginfo->contexts, 1);
  sk_global_unlock();

  // Hitting the file-backed bound exits with ERROR_OUT_OF_MEMORY.
  pid_t foom = fork();
  if (foom == 0) {
#ifdef __APPLE__
    sk_global_lock_open(path);
#endif
    sk_global_lock();
    for (;;) {
      sk_palloc(64 * 1024);
    }
    _exit(42);
  }
  int fstatus = 0;
  if (waitpid(foom, &fstatus, 0) != foom) return 28;
  if (!WIFEXITED(fstatus) || WEXITSTATUS(fstatus) != ERROR_OUT_OF_MEMORY)
    return 29;

#ifdef __APPLE__
  char lock_path[sizeof(dir) + 10];
  strcpy(lock_path, path);
  strcat(lock_path, ".lock");
  unlink(lock_path);
#endif
  unlink(path);
  rmdir(dir);

  // Hitting the anonymous bound exits with ERROR_OUT_OF_MEMORY (checked in a
  // child).
  pid_t pid = fork();
  if (pid == 0) {
    sk_create_mapping(NULL, INITIAL_CAPACITY);  // bound == full mapping
    for (;;) {
      sk_palloc(64 * 1024);
    }
    _exit(42);
  }
  int status = 0;
  if (waitpid(pid, &status, 0) != pid) return 20;
  if (!WIFEXITED(status) || WEXITSTATUS(status) != ERROR_OUT_OF_MEMORY)
    return 21;
  return 0;
}
