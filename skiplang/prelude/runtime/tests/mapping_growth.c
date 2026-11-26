// Regression test: a persistent file starts at INITIAL_CAPACITY and grows on
// demand up to the capacity bound (DEFAULT_CAPACITY, raised by SKIP_CAPACITY
// or --capacity; the flag wins over the env var). Existing contents must
// survive a growth, and hitting the bound is a clean out-of-memory exit. The
// anonymous heap is mapped at its full capacity up front. Build with section
// GC so only the exercised parts of palloc.c need runtime definitions.
#define _DEFAULT_SOURCE
#define SKIP64 1
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
  // --capacity > SKIP_CAPACITY > default bound of 16 GiB.
  if (parse_capacity(1, argv_default) != DEFAULT_CAPACITY) return 1;
  if (DEFAULT_CAPACITY != 16L * 1024L * 1024L * 1024L) return 2;
  setenv("SKIP_CAPACITY", "64G", 1);
  if (parse_capacity(1, argv_default) != 64L * 1024L * 1024L * 1024L) return 3;
  if (parse_capacity(3, argv_flag) != 2L * 1024L * 1024L * 1024L) return 4;
  unsetenv("SKIP_CAPACITY");

  // Anonymous heap: mapped at its full capacity up front (sparse).
  sk_create_mapping(NULL, DEFAULT_CAPACITY);
  if (sk_mapped_size != DEFAULT_CAPACITY) return 5;
  if (ginfo->end != sk_mapping_base + DEFAULT_CAPACITY) return 6;

  // File-backed heap: the file starts at INITIAL_CAPACITY, and ftruncate
  // plus an in-place MAP_FIXED mmap grow it on demand, never past the bound;
  // the header keeps the capacity bound. Contents survive the growth.
  char dir[] = "/tmp/skip-mapping-growth-XXXXXX";
  if (mkdtemp(dir) == NULL) return 7;
  char path[sizeof(dir) + 4];
  strcpy(path, dir);
  strcat(path, "/db");
  size_t cap = 3 * INITIAL_CAPACITY;
  sk_create_mapping(path, cap);
  if (sk_mapped_size != INITIAL_CAPACITY) return 8;
  if (*capacity != cap) return 9;
  struct stat st;
  if (fstat(sk_data_fd, &st) != 0 || (size_t)st.st_size != sk_mapped_size + 1)
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
  size_t grown = sk_mapped_size;
  if (grown <= INITIAL_CAPACITY) return 13;  // it grew
  if (grown > cap) return 14;                // but not past the bound
  if (ginfo->end != sk_mapping_base + grown) return 15;
  if (fstat(sk_data_fd, &st) != 0 || (size_t)st.st_size != grown + 1) return 16;
  if (((unsigned char*)first)[0] != 0x5A ||
      ((unsigned char*)first)[64 * 1024 - 1] != 0x5A)
    return 17;
  // Reloading maps the grown file size and keeps the bound.
  sk_load_mapping(path);
  if (sk_mapped_size != grown) return 18;
  if (*capacity != cap) return 19;
  unlink(path);
  rmdir(dir);

  // Hitting the bound exits with ERROR_OUT_OF_MEMORY (checked in a child).
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
