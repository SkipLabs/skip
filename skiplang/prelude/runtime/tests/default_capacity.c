// Regression test: the default mapping capacity adapts to the host's
// available memory, clamped to [MIN_DEFAULT_CAPACITY, MAX_DEFAULT_CAPACITY],
// and SKIP_CAPACITY / --capacity override it when a workload needs more.
// Build with section GC so only the exercised parts of palloc.c need runtime
// definitions.
#define _DEFAULT_SOURCE
#define SKIP64 1
#include "../palloc.c"

int main(void) {
  char* argv_default[] = {"test", NULL};
  char* argv_flag[] = {"test", "--capacity", "2G", NULL};
  unsetenv("SKIP_CAPACITY");
  // The host's memory should be detectable on supported platforms.
  if (available_memory_bytes() == 0) return 5;
  // The cap stays at 16 GiB.
  if (MAX_DEFAULT_CAPACITY != 16L * 1024L * 1024L * 1024L) return 6;
  size_t d = default_capacity();
  if (d < MIN_DEFAULT_CAPACITY || d > MAX_DEFAULT_CAPACITY) return 2;
  if (parse_capacity(1, argv_default) != d) return 1;
  setenv("SKIP_CAPACITY", "64G", 1);
  if (parse_capacity(1, argv_default) != 64L * 1024L * 1024L * 1024L) return 3;
  // --capacity wins over SKIP_CAPACITY.
  if (parse_capacity(3, argv_flag) != 2L * 1024L * 1024L * 1024L) return 4;
  return 0;
}
