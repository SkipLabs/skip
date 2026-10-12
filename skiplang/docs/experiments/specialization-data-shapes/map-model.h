/* Exact existing-node union versus independently flattened distinct map roots.
 * Flat size uses Array allocation rules and inline (key,value) entry widths.
 * Keys and values remain shared pointers; comparisons and update costs are not
 * modeled.
 */
typedef struct {
  uintptr_t *slots;
  size_t cap, n;
} PointerSet;
static int pointer_add(PointerSet *s, void *p) {
  if ((s->n + 1) * 10 > s->cap * 7) {
    size_t oldcap = s->cap;
    uintptr_t *old = s->slots;
    s->cap = oldcap ? oldcap * 2 : 1024;
    s->slots = calloc(s->cap, sizeof(uintptr_t));
    if (!s->slots)
      abort();
    for (size_t i = 0; i < oldcap; i++)
      if (old[i]) {
        size_t k = mix(old[i]) & (s->cap - 1);
        while (s->slots[k])
          k = (k + 1) & (s->cap - 1);
        s->slots[k] = old[i];
      }
    free(old);
  }
  size_t k = mix((uintptr_t)p) & (s->cap - 1);
  while (s->slots[k] && s->slots[k] != (uintptr_t)p)
    k = (k + 1) & (s->cap - 1);
  if (s->slots[k])
    return 0;
  s->slots[k] = (uintptr_t)p;
  s->n++;
  return 1;
}
typedef struct {
  const char *name;
  PointerSet roots, nodes;
  uint64_t root_refs, entries, node_bytes, flat_bytes, hist[8];
} Model;
static Model models[3] = {{.name = "SClassInfo.extends_"},
                          {.name = "SClassInfo.methods"},
                          {.name = "SortedSetSClassIDFile.value"}};
static void model_map(void **owner, size_t off, void *obj, int scope) {
  if (scope != 1)
    return;
  const char *n = name_of_vt(owner);
  int ix = -1;
  if (!strcmp(n, "OuterIstToIR.SClassInfo"))
    ix = off == 24 ? 0 : off == 32 ? 1 : -1;
  else if (!strcmp(n, "OuterIstToIR.SortedSetSClassIDFile") && off == 0)
    ix = 2;
  if (ix < 0)
    return;
  void **vt = vt_of(obj);
  const char *mn = name_of_vt(vt);
  if (strncmp(mn, "SortedMap.Node", 14) && strncmp(mn, "SortedMap.Nil", 13))
    return;
  Model *m = &models[ix];
  m->root_refs++;
  if (!strncmp(mn, "SortedMap.Nil", 13)) {
    m->hist[0]++;
    return;
  }
  if (!pointer_add(&m->roots, obj))
    return;
  uint64_t len = map_size(obj, vt);
  m->hist[bucket(len)]++;
  m->entries += len;
  SKIP_gc_type_t *t = vt[1];
  m->flat_bytes += (24 + len * (t->m_userByteSize - 32) + 7) & ~7ULL;
  sk_stack_t st;
  sk_stack_init(&st, 32);
  sk_stack_push(&st, obj, NULL);
  while (st.head) {
    void *p = sk_stack_pop(&st).value;
    if (!pointer_add(&m->nodes, p))
      continue;
    m->node_bytes += alloc_bytes(p);
    SKIP_gc_type_t *nt = ty_of(p);
    for (size_t w = 0; w < nt->m_userByteSize / 8; w++)
      if (((uint64_t)nt->m_refMask[w / 64] >> (w % 64)) & 1) {
        void *ch = ((void **)p)[w];
        if (ch && (uintptr_t)ch >= 64 && !SKIP_is_string(ch) && vt_of(ch) == vt)
          sk_stack_push(&st, ch, NULL);
      }
  }
  sk_stack_free(&st);
}
static void dump_models(void) {
  for (int i = 0; i < 3; i++) {
    Model *m = &models[i];
    printf("MODEL\t%s\t%" PRIu64 "\t%zu\t%zu\t%" PRIu64 "\t%" PRIu64
           "\t%" PRIu64,
           m->name, m->root_refs, m->roots.n, m->nodes.n, m->entries,
           m->node_bytes, m->flat_bytes);
    for (int j = 0; j < 8; j++)
      printf("\t%" PRIu64, m->hist[j]);
    puts("");
  }
}
