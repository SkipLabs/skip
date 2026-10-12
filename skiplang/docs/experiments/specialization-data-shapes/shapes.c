/* Disposable, destructive graph census. Runs only when SKIP_DATA_SHAPES is set,
 * at specialization completion; exits before the marked graph can be reused.
 * Object type metadata and ref masks come from this binary's compiler/runtime.
 * The forwarding bit marks the context traversal; payload passes use separate
 * pointer sets, preserving sharing without touching the runtime string tag.
 */
#include "runtime.h"
#include <inttypes.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
extern SKIP_gc_type_t *epointer_ty;
#define NT 65536
#define NF 262144
#define ND 4096
#define NR 65536
#define GIB (1024ULL * 1024 * 1024)
typedef struct {
  void **vt;
  uint64_t n, bytes, payload, slots, refs, lengths[8];
} Type;
typedef struct {
  void **owner, **target;
  size_t off;
  int kind, scope;
  uint64_t n, sum, max, hist[8], unique, unique_bytes, unique_elems;
} Field;
typedef struct {
  const char *name;
  uint64_t versions, rows, rows_bytes, values[8], files;
} Dir;
typedef struct {
  Dir *dir;
  const char *key, *file;
  uint64_t rows, files;
} Row;
static Type full[NT], data[NT], girdata[NT];
static Field fields[NF];
static Dir dirs[ND];
static Row rows[NR];
static sk_cell_t *pages;
static size_t np;
static sk_stack_t roots, giroots;
static uint64_t root_count, all_strings, all_string_bytes, payload_strings,
    payload_string_bytes, external_refs, aliases, cut_refs, gir_strings,
    gir_string_bytes, overlap_bytes, overlap_objects;
/* Strings use a side set: marking their size would lose the length for pass 2.
 */
static uintptr_t *strings;
static size_t string_cap, string_n;
static uint64_t mix(uint64_t x) {
  x ^= x >> 30;
  x *= 0xbf58476d1ce4e5b9ULL;
  x ^= x >> 27;
  x *= 0x94d049bb133111ebULL;
  return x ^ (x >> 31);
}
static int string_visit(void *p) {
  if ((string_n + 1) * 10 > string_cap * 7) {
    size_t oldcap = string_cap;
    uintptr_t *old = strings;
    string_cap = oldcap ? oldcap * 2 : 65536;
    strings = calloc(string_cap, sizeof(uintptr_t));
    if (!strings)
      abort();
    for (size_t i = 0; i < oldcap; i++)
      if (old[i]) {
        size_t k = mix(old[i]) & (string_cap - 1);
        while (strings[k])
          k = (k + 1) & (string_cap - 1);
        strings[k] = old[i];
      }
    free(old);
  }
  size_t k = mix((uintptr_t)p) & (string_cap - 1);
  while (strings[k] && strings[k] != (uintptr_t)p)
    k = (k + 1) & (string_cap - 1);
  if (strings[k])
    return 0;
  strings[k] = (uintptr_t)p;
  string_n++;
  return 1;
}
static uintptr_t *payload_seen;
static size_t payload_cap, payload_n;
static uintptr_t payload_bits(void *p) {
  if (!payload_cap)
    return 0;
  size_t k = mix((uintptr_t)p) & (payload_cap - 1);
  while (payload_seen[k] && (payload_seen[k] & ~7ULL) != (uintptr_t)p)
    k = (k + 1) & (payload_cap - 1);
  return payload_seen[k] & 7;
}
static int payload_visit(void *p, int pass) {
  if ((payload_n + 1) * 10 > payload_cap * 7) {
    size_t oldcap = payload_cap;
    uintptr_t *old = payload_seen;
    payload_cap = oldcap ? oldcap * 2 : 65536;
    payload_seen = calloc(payload_cap, sizeof(uintptr_t));
    if (!payload_seen)
      abort();
    for (size_t i = 0; i < oldcap; i++)
      if (old[i]) {
        size_t k = mix(old[i] & ~7ULL) & (payload_cap - 1);
        while (payload_seen[k])
          k = (k + 1) & (payload_cap - 1);
        payload_seen[k] = old[i];
      }
    free(old);
  }
  size_t k = mix((uintptr_t)p) & (payload_cap - 1);
  while (payload_seen[k] && (payload_seen[k] & ~7ULL) != (uintptr_t)p)
    k = (k + 1) & (payload_cap - 1);
  uintptr_t bit = pass == 2 ? 4 : 2;
  if (payload_seen[k] & bit)
    return 0;
  if (!payload_seen[k]) {
    payload_n++;
    payload_seen[k] = (uintptr_t)p;
  }
  payload_seen[k] |= bit;
  return 1;
}
static void **vt_of(void *p) {
  return (void **)((uintptr_t)container_of(p, sk_class_inst_t, data)->vtable &
                   ~1ULL);
}
static SKIP_gc_type_t *ty_of(void *p) { return vt_of(p)[1]; }
static const char *name_of_vt(void **vt) {
  SKIP_gc_type_t *t = vt[1];
  size_t masks = (t->m_refsHintMask & 1)
                     ? ((t->m_userByteSize / sizeof(void *) + 63) / 64)
                     : 0;
  return t->m_hasName ? (char *)(t->m_refMask + masks) : "<unnamed>";
}
static const char *name_of(void *p) {
  if ((uintptr_t)p < 64)
    return "<immediate>";
  if (SKIP_is_string(p))
    return "String";
  return name_of_vt(vt_of(p));
}
static int in_pages(void *p) {
  return (uintptr_t)p >= 64 && sk_get_obstack_idx(p, pages, np) < np;
}
static int bucket(uint64_t n) {
  return n < 4 ? n : n < 8 ? 4 : n < 32 ? 5 : n < 128 ? 6 : 7;
}
static size_t alloc_bytes(void *p) {
  SKIP_gc_type_t *t = ty_of(p);
  size_t z = t->m_userByteSize * skip_object_len(t, p) +
             uninterned_metadata_byte_size(t) + 8;
  return (z + 7) & ~7ULL;
}
static Type *type_entry(Type *table, void **vt) {
  size_t k = mix((uintptr_t)vt) & (NT - 1);
  while (table[k].vt && table[k].vt != vt)
    k = (k + 1) & (NT - 1);
  table[k].vt = vt;
  return &table[k];
}
static int payload_root(const char *n) {
  if (strncmp(n, "OuterIstToIR.", 13))
    return 0;
  n += 13;
  const char *names[] = {"GClassNameKey",
                         "SubtypesKey",
                         "SupertypesKey",
                         "SClassIDFile",
                         "SortedSetSClassIDFile",
                         "HalfSClassKey",
                         "SClassIDKey",
                         "SClassInfoFile",
                         "OptionLayoutFile",
                         "GFunKeyKey",
                         "GFunKeyFile",
                         "ContinuationFile",
                         "TodoFile",
                         "FStackElement",
                         "CStackElement",
                         NULL};
  for (int i = 0; names[i]; i++)
    if (!strcmp(n, names[i]))
      return 1;
  return 0;
}
static int cut_payload(const char *n) {
  return !strncmp(n, "SKStore.", 8) || !strcmp(n, "Config.Config") ||
         !strcmp(n, "ConvertTree.Converter") || !strcmp(n, "OuterIst.Program");
}
static Dir *dir_entry(const char *n) {
  uint64_t h = 0;
  for (const char *c = n; *c; c++)
    h = h * 31 + (unsigned char)*c;
  size_t k = mix(h) & (ND - 1);
  while (dirs[k].name && strcmp(dirs[k].name, n))
    k = (k + 1) & (ND - 1);
  dirs[k].name = n;
  return &dirs[k];
}
static void row_entry(Dir *d, const char *k, const char *f, uint64_t count) {
  size_t i =
      mix((uintptr_t)d ^ mix((uintptr_t)k) ^ mix((uintptr_t)f)) & (NR - 1);
  while (rows[i].dir && (rows[i].dir != d || strcmp(rows[i].key, k) ||
                         strcmp(rows[i].file, f)))
    i = (i + 1) & (NR - 1);
  rows[i].dir = d;
  rows[i].key = k;
  rows[i].file = f;
  rows[i].rows++;
  rows[i].files += count;
}
static void inspect_dir(void *p) {
  SKIP_gc_type_t *t = ty_of(p);
  if (t->m_userByteSize != 136)
    return;
  void **o = p;
  void *dn = o[0];
  if (strcmp(name_of(dn), "SKStore.DirName"))
    return;
  const char *n = *(char **)dn;
  if (strncmp(n, "/specializer/", 13))
    return;
  Dir *d = dir_entry(n);
  d->versions++;
  void *fm = o[4];
  if (strncmp(name_of(fm), "SKStore.FixedDataMap", 20))
    return;
  void *fd = *(void **)fm;
  if (strncmp(name_of(fd), "SKStore.FixedDir", 15))
    return;
  void *arr = *(void **)fd;
  SKIP_gc_type_t *at = ty_of(arr);
  if (!ty_is_array(at) || at->m_userByteSize != 40)
    return;
  size_t len = skip_object_len(at, arr);
  d->rows += len;
  d->rows_bytes += alloc_bytes(arr);
  for (size_t i = 0; i < len; i++) {
    void **r = (void **)((char *)arr + 40 * i);
    void *v = r[1];
    SKIP_gc_type_t *vt = ty_of(v);
    if (!ty_is_array(vt) || vt->m_userByteSize != 8)
      abort();
    size_t nv = skip_object_len(vt, v);
    d->values[bucket(nv)]++;
    d->files += nv;
    if (!nv)
      row_entry(d, name_of(r[0]), "<empty>", 0);
    else {
      const char *f = name_of(*(void **)v);
      row_entry(d, name_of(r[0]), f, nv);
    }
  }
}
static Field *field_entry(void **owner, size_t off, void **target, int kind,
                          int scope) {
  size_t k = mix((uintptr_t)owner ^ mix(off + 1) ^ mix((uintptr_t)target) ^
                 mix(kind + 7) ^ mix(scope + 3)) &
             (NF - 1);
  while (fields[k].owner &&
         (fields[k].owner != owner || fields[k].off != off ||
          fields[k].target != target || fields[k].kind != kind ||
          fields[k].scope != scope))
    k = (k + 1) & (NF - 1);
  fields[k].owner = owner;
  fields[k].target = target;
  fields[k].off = off;
  fields[k].kind = kind;
  fields[k].scope = scope;
  return &fields[k];
}

#include "key-model.h"
#include "map-layout.h"
#include "map-model.h"
static void observe_field(void **owner, size_t off, void *obj, int scope) {
  if ((uintptr_t)obj < 64 || SKIP_is_string(obj))
    return;
  void **vt = vt_of(obj);
  SKIP_gc_type_t *t = vt[1];
  const char *n = name_of_vt(vt);
  uint64_t len = 0;
  int kind = -1;
  if (ty_is_array(t)) {
    kind = 0;
    len = skip_object_len(t, obj);
  } else if (!strncmp(n, "SortedMap.Node", 14)) {
    kind = 1;
    len = map_size(obj, vt);
  } else if (!strncmp(n, "SortedMap.Nil", 13)) {
    kind = 1;
    len = 0;
  } else if (!strncmp(n, "UnorderedMap", 12) && !strstr(n, "Slot") &&
             !strstr(n, "Closure") && !strstr(n, "Meta")) {
    if (t->m_userByteSize == 32) {
      kind = 2;
      len = ((uint64_t *)obj)[1];
    }
  }
  if (kind < 0)
    return;
  model_map(owner, off, obj, scope);
  /* A child link is a subtree, not a user's independent map field. */
  const char *on = name_of_vt(owner);
  if (!strncmp(on, "SortedMap.Node", 14) &&
      (vt == owner || !strncmp(n, "SortedMap.Nil", 13)))
    return;
  Field *f = field_entry(owner, off, vt, kind, scope);
  f->n++;
  f->sum += len;
  if (len > f->max)
    f->max = len;
  f->hist[bucket(len)]++;
  if (in_pages(obj) && !(payload_bits(obj) & (scope == 2 ? 4 : 2))) {
    f->unique++;
    f->unique_bytes += alloc_bytes(obj);
    f->unique_elems += len;
  }
}
static void scan(void *root, int pass) {
  sk_stack_t st;
  sk_stack_init(&st, 1024);
  sk_stack_push(&st, root, NULL);
  if (pass) {
    sk_stack_t *rr = pass == 2 ? &giroots : &roots;
    for (size_t i = 0; i < rr->head; i++)
      sk_stack_push(&st, rr->values[i].value, NULL);
  }
  uint64_t processed = 0;
  while (st.head) {
    sk_value_t cell = sk_stack_pop(&st);
    void *p = cell.value; /* stack holds object pointers, not slots */
    if ((uintptr_t)p < 64)
      continue;
    if (!in_pages(p)) {
      if (!pass)
        external_refs++;
      continue;
    }
    if (SKIP_is_string(p)) {
      uintptr_t before = pass ? payload_bits(p) : 0;
      if (pass ? payload_visit(p, pass) : string_visit(p)) {
        size_t b =
            (get_sk_string(p)->size + 1 + sk_string_header_size + 8 + 7) &
            ~7ULL;
        if (pass == 2) {
          gir_strings++;
          gir_string_bytes += b;
          if (before & 2) {
            overlap_bytes += b;
            overlap_objects++;
          }
        } else if (pass) {
          payload_strings++;
          payload_string_bytes += b;
        } else {
          all_strings++;
          all_string_bytes += b;
        }
      }
      continue;
    }
    void ***vp = &container_of(p, sk_class_inst_t, data)->vtable;
    uintptr_t raw = (uintptr_t)*vp;
    void **vt = (void **)(raw & ~1ULL);
    const char *n = name_of_vt(vt);
    if (pass && cut_payload(n)) {
      cut_refs++;
      continue;
    }
    uintptr_t before = pass ? payload_bits(p) : 0;
    if (pass ? !payload_visit(p, pass) : (raw & 1)) {
      if (!pass)
        aliases++;
      continue;
    }
    if (!pass)
      *vp = (void **)(raw | 1);
    SKIP_gc_type_t *t = vt[1];
    size_t len = skip_object_len(t, p), body = t->m_userByteSize * len;
    Type *c = type_entry(pass == 2 ? girdata : pass ? data : full, vt);
    model_key(p, vt, pass);
    c->n++;
    c->payload += body;
    size_t b = (body + uninterned_metadata_byte_size(t) + 8 + 7) & ~7ULL;
    c->bytes += b;
    if (pass == 2 && (before & 2)) {
      overlap_bytes += b;
      overlap_objects++;
    }
    size_t slot = 8;
    while (slot < body + uninterned_metadata_byte_size(t) + 8)
      slot *= 2;
    c->slots += slot;
    if (ty_is_array(t))
      c->lengths[bucket(len)]++;
    if (!pass) {
      if (!strcmp(n, "OuterIstToIR.GClassFile") ||
          !strcmp(n, "OuterIstToIR.GFunctionFile") ||
          !strcmp(n, "OuterIst.CallableDefFile"))
        sk_stack_push(&giroots, p, NULL);
      if (payload_root(n)) {
        sk_stack_push(&roots, p, NULL);
        root_count++;
      }
      if (!strncmp(n, "SKStore.TEagerDir", 16))
        inspect_dir(p);
    }
    if (t != epointer_ty && (t->m_refsHintMask & 1)) {
      for (size_t a = 0; a < body; a += t->m_userByteSize) {
        for (size_t w = 0; w < t->m_userByteSize / 8; w++)
          if (((uint64_t)t->m_refMask[w / 64] >> (w % 64)) & 1) {
            void *child = *(void **)((char *)p + a + w * 8);
            if (child) {
              c->refs++;
              if (pass)
                observe_field(vt, w * 8, child, pass);
              sk_stack_push(&st, child, NULL);
            }
          }
      }
    }
    processed++;
    if (processed % 50000000 == 0) {
      fprintf(stderr, "SHAPE_PROGRESS pass=%d objects=%" PRIu64 " stack=%zu\n",
              pass, processed, st.head);
      fflush(stderr);
    }
  }
  sk_stack_free(&st);
}
static void dump_types(const char *scope, Type *ts) {
  for (size_t i = 0; i < NT; i++)
    if (ts[i].vt) {
      Type *t = &ts[i];
      SKIP_gc_type_t *ty = t->vt[1];
      printf("TYPE\t%s\t%p\t%s\t%u\t%lld\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64
             "\t%" PRIu64 "\t%" PRIu64,
             scope, t->vt, name_of_vt(t->vt), ty->m_kind,
             (long long)ty->m_userByteSize, t->n, t->payload, t->bytes,
             t->slots, t->refs);
      for (int j = 0; j < 8; j++)
        printf("\t%" PRIu64, t->lengths[j]);
      puts("");
    }
}
void SKIP_shape_probe(void *ctx, void *sp, int64_t stage) {
  const char *e = getenv("SKIP_DATA_SHAPES");
  if (!e || atoi(e) != stage)
    return;
  np = sk_get_nbr_pages(NULL, NULL);
  pages = sk_get_pages(NULL, np);
  fprintf(stderr, "SHAPE_BEGIN stage=%lld pages=%zu\n", (long long)stage, np);
  fflush(stderr);
  sk_stack_init(&roots, 1024);
  sk_stack_init(&giroots, 1024);
  /* scan uses object-valued stack entries; seed specializer plus its context.
   */
  scan(ctx, 0);
  scan(sp, 0);
  free(strings);
  strings = NULL;
  string_cap = string_n = 0;
  scan(sp, 1);
  free(strings);
  strings = NULL;
  string_cap = string_n = 0;
  scan(NULL, 2);
  dump_types("context", full);
  dump_types("payload", data);
  dump_types("gir", girdata);
  for (size_t i = 0; i < NF; i++)
    if (fields[i].owner) {
      Field *f = &fields[i];
      printf("%s\t%s\t%zu\t%d\t%s\t%lld\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64
             "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64,
             f->scope == 2 ? "GIRFIELD" : "FIELD", name_of_vt(f->owner), f->off,
             f->kind, name_of_vt(f->target),
             (long long)((SKIP_gc_type_t *)f->target[1])->m_userByteSize, f->n,
             f->sum, f->max, f->unique, f->unique_bytes, f->unique_elems);
      for (int j = 0; j < 8; j++)
        printf("\t%" PRIu64, f->hist[j]);
      puts("");
    }
  for (size_t i = 0; i < ND; i++)
    if (dirs[i].name) {
      Dir *d = &dirs[i];
      printf("DIR\t%s\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64,
             d->name, d->versions, d->rows, d->rows_bytes, d->files);
      for (int j = 0; j < 8; j++)
        printf("\t%" PRIu64, d->values[j]);
      puts("");
    }
  for (size_t i = 0; i < NR; i++)
    if (rows[i].dir) {
      Row *r = &rows[i];
      printf("ROW\t%s\t%s\t%s\t%" PRIu64 "\t%" PRIu64 "\n", r->dir->name,
             r->key, r->file, r->rows, r->files);
    }
  printf("TOTAL\tstage=%lld\troots=%" PRIu64 "\tstrings=%" PRIu64
         "\tstring_bytes=%" PRIu64 "\tpayload_strings=%" PRIu64
         "\tpayload_string_bytes=%" PRIu64 "\texternal_refs=%" PRIu64
         "\taliases=%" PRIu64 "\tcut_refs=%" PRIu64 "\n",
         (long long)stage, root_count, all_strings, all_string_bytes,
         payload_strings, payload_string_bytes, external_refs, aliases,
         cut_refs);
  printf("CACHE_TOTAL\tgir_roots=%zu\tgir_strings=%" PRIu64
         "\tgir_string_bytes=%" PRIu64 "\tshared_object_bytes=%" PRIu64
         "\tshared_objects=%" PRIu64 "\n",
         giroots.head, gir_strings, gir_string_bytes, overlap_bytes,
         overlap_objects);
  dump_models();
  dump_keys();
  puts("SHAPE_END");
  fflush(stdout);
  exit(0);
}
