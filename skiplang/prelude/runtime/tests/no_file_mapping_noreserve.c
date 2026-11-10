// Standalone regression test: the anonymous heap created without a persistent
// file must be mapped with MAP_NORESERVE. Its default capacity (64 GiB) is a
// sparse bound; without the flag, heuristic overcommit refuses it on hosts
// with less RAM plus swap. The kernel marks such mappings "nr" in smaps, which
// holds regardless of the host's overcommit policy. Build with section GC so
// only the exercised parts of palloc.c need runtime definitions.
#define SKIP64 1
#include "../palloc.c"

int main(void) {
  sk_create_mapping(NULL, DEFAULT_CAPACITY);
  uintptr_t heap = (uintptr_t)ginfo;

  FILE* smaps = fopen("/proc/self/smaps", "r");
  if (smaps == NULL) return 1;
  char line[1024];
  int in_heap = 0;
  while (fgets(line, sizeof(line), smaps) != NULL) {
    uintptr_t lo, hi;
    char dash;
    if (sscanf(line, "%" SCNxPTR "%c%" SCNxPTR, &lo, &dash, &hi) == 3 &&
        dash == '-') {
      in_heap = lo <= heap && heap < hi;
    } else if (in_heap && strncmp(line, "VmFlags:", 8) == 0) {
      fclose(smaps);
      return strstr(line, " nr") != NULL ? 0 : 2;
    }
  }
  fclose(smaps);
  return 3;
}
