/* Count actual tree nodes, memoized across retained versions. Do not infer n
 * from vtable slots: compiler folding can reuse getter symbols for both n and
 * h. Children have the same concrete vtable as their parent; Nil contributes
 * zero.
 */
typedef struct {
  void *p;
  uint64_t n;
} SizeEntry;
static SizeEntry *map_sizes;
static size_t size_cap, size_n;
static uint64_t map_size(void *p, void **vt) {
  if ((size_n + 1) * 10 > size_cap * 7) {
    size_t oldcap = size_cap;
    SizeEntry *old = map_sizes;
    size_cap = oldcap ? oldcap * 2 : 1024;
    map_sizes = calloc(size_cap, sizeof(SizeEntry));
    if (!map_sizes)
      abort();
    for (size_t i = 0; i < oldcap; i++)
      if (old[i].p) {
        size_t k = mix((uintptr_t)old[i].p) & (size_cap - 1);
        while (map_sizes[k].p)
          k = (k + 1) & (size_cap - 1);
        map_sizes[k] = old[i];
      }
    free(old);
  }
  size_t k = mix((uintptr_t)p) & (size_cap - 1);
  while (map_sizes[k].p && map_sizes[k].p != p)
    k = (k + 1) & (size_cap - 1);
  if (map_sizes[k].p)
    return map_sizes[k].n;
  SKIP_gc_type_t *t = vt[1];
  uint64_t n = 1;
  int children = 0;
  for (size_t w = 0; w < t->m_userByteSize / 8; w++)
    if (((uint64_t)t->m_refMask[w / 64] >> (w % 64)) & 1) {
      void *ch = ((void **)p)[w];
      if (ch && (uintptr_t)ch >= 64 && !SKIP_is_string(ch) && vt_of(ch) == vt) {
        children++;
        n += map_size(ch, vt);
      }
    }
  if (children > 2) {
    fprintf(stderr, "Ambiguous map child links\n");
    abort();
  }
  /* Recursive insertions may have resized the memo table. */
  if ((size_n + 1) * 10 > size_cap * 7) {
    size_t oldcap = size_cap;
    SizeEntry *old = map_sizes;
    size_cap *= 2;
    map_sizes = calloc(size_cap, sizeof(SizeEntry));
    if (!map_sizes)
      abort();
    for (size_t i = 0; i < oldcap; i++)
      if (old[i].p) {
        size_t z = mix((uintptr_t)old[i].p) & (size_cap - 1);
        while (map_sizes[z].p)
          z = (z + 1) & (size_cap - 1);
        map_sizes[z] = old[i];
      }
    free(old);
  }
  k = mix((uintptr_t)p) & (size_cap - 1);
  while (map_sizes[k].p && map_sizes[k].p != p)
    k = (k + 1) & (size_cap - 1);
  if (!map_sizes[k].p) {
    map_sizes[k] = (SizeEntry){p, n};
    size_n++;
  }
  return n;
}
