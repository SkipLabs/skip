// Regression test: the default persistent-mapping capacity is 16 GiB, and
// SKIP_CAPACITY / --capacity raise it when a workload needs more. Build with
// section GC so only the exercised parts of palloc.c need runtime definitions.
#define _DEFAULT_SOURCE
#define SKIP64 1
#include "../palloc.c"

int main(void) {
  char* argv_default[] = {"test", NULL};
  char* argv_flag[] = {"test", "--capacity", "2G", NULL};
  unsetenv("SKIP_CAPACITY");
  if (parse_capacity(1, argv_default) != 16L * 1024L * 1024L * 1024L) return 1;
  if (DEFAULT_CAPACITY != 16L * 1024L * 1024L * 1024L) return 2;
  setenv("SKIP_CAPACITY", "64G", 1);
  if (parse_capacity(1, argv_default) != 64L * 1024L * 1024L * 1024L) return 3;
  // --capacity wins over SKIP_CAPACITY.
  if (parse_capacity(3, argv_flag) != 2L * 1024L * 1024L * 1024L) return 4;
  return 0;
}
