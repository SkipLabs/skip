/* Exact duplicate string-valued wrappers, preserving wrapper type. */
typedef struct {
  void **vt;
  const char *name;
  uint64_t count, unique, bytes;
} KeyModel;
typedef struct {
  void **vt;
  char *string;
} KeyEntry;
static KeyModel key_models[32];
static KeyEntry *key_entries;
static size_t key_cap, key_n;
static uint64_t key_hash(void **vt, char *s) {
  sk_string_t *t = get_sk_string(s);
  return mix((uintptr_t)vt ^ ((uint64_t)t->hash << 32) ^ t->size);
}
static void model_key(void *p, void **vt, int pass) {
  if (pass != 1)
    return;
  const char *n = name_of_vt(vt);
  const char *names[] = {
      "OuterIstToIR.SClassIDKey",   "OuterIstToIR.SubtypesKey",
      "OuterIstToIR.SupertypesKey", "OuterIstToIR.SClassIDFile",
      "OuterIstToIR.GClassNameKey", NULL};
  int matched = 0;
  for (int i = 0; names[i]; i++)
    if (!strcmp(n, names[i]))
      matched = 1;
  if (!matched)
    return;
  char *s = *(char **)p;
  if (!s || !SKIP_is_string(s))
    abort();
  KeyModel *m = NULL;
  for (int i = 0; i < 32; i++)
    if (!key_models[i].vt || key_models[i].vt == vt) {
      m = &key_models[i];
      m->vt = vt;
      m->name = n;
      break;
    }
  if (!m)
    abort();
  m->count++;
  m->bytes += alloc_bytes(p);
  if ((key_n + 1) * 10 > key_cap * 7) {
    size_t oldcap = key_cap;
    KeyEntry *old = key_entries;
    key_cap = oldcap ? oldcap * 2 : 1024;
    key_entries = calloc(key_cap, sizeof(KeyEntry));
    if (!key_entries)
      abort();
    for (size_t i = 0; i < oldcap; i++)
      if (old[i].vt) {
        size_t k = key_hash(old[i].vt, old[i].string) & (key_cap - 1);
        while (key_entries[k].vt)
          k = (k + 1) & (key_cap - 1);
        key_entries[k] = old[i];
      }
    free(old);
  }
  size_t k = key_hash(vt, s) & (key_cap - 1);
  sk_string_t *t = get_sk_string(s);
  while (key_entries[k].vt) {
    KeyEntry *e = &key_entries[k];
    sk_string_t *et = get_sk_string(e->string);
    if (e->vt == vt && et->size == t->size && !memcmp(e->string, s, t->size))
      return;
    k = (k + 1) & (key_cap - 1);
  }
  key_entries[k] = (KeyEntry){vt, s};
  key_n++;
  m->unique++;
}
static void dump_keys(void) {
  for (int i = 0; i < 32; i++)
    if (key_models[i].vt) {
      KeyModel *m = &key_models[i];
      printf(
          "KEY_MODEL\t%s\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n",
          m->name, m->count, m->unique, m->bytes, (m->count - m->unique) * 24);
    }
}
