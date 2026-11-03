/* Read-only census of a stopped native 64-bit compiler's persisted context.
 * Build as PIE, with -DSKIP64 and -I skiplang/prelude/runtime. Supply the exact
 * non-PIE compiler executable that created the database. Neither file is run
 * or modified. Exclusive nonblocking flock rejects an active database.
 *
 * Runtime GC masks identify references; a side bitmap counts shared objects
 * once. ELF segments supply type metadata at their original virtual addresses.
 * Byte counts include refcounts, headers and allocator size-class rounding.
 * Scope is the context root, not constants reachable only from the constant
 * registry, native allocator pages, temporary arenas, or RSS.
 */
#define _GNU_SOURCE
#include <elf.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include "alloc_size_classes.h"
#include "runtime.h"

typedef struct {
  void *free_table[512], *contexts;
  char *head, *end, *filename;
  size_t allocated;
} Global;
typedef struct {
  int64_t version;
  void* base;
  pthread_mutexattr_t attributes;
  pthread_mutex_t mutex;
  Global global;
  uint64_t gid;
  size_t capacity;
  void** constants;
} Mapping;
typedef struct {
  uintptr_t begin, end;
} Region;
typedef struct {
  void** vtable;
  const char* name;
  uint64_t width, kind;
  uint64_t objects, body_bytes, allocated_bytes, references;
  uint64_t reference_count_sum, single_owner_objects;
} Type;
static Region image, heap;
static unsigned char* visited;
static void** stack;
static size_t stack_size, stack_capacity;
static Type types[65536];
static uint64_t objects, bytes, strings, string_bytes, external_edges;
static uint64_t string_reference_count_sum, single_owner_strings;
// Optional shallow identity census. Equal reference pairs prove duplicate
// payloads; different pairs can still be logically equal and are not counted.
typedef struct {
  uintptr_t first, second;
} ReferencePair;
static uintptr_t pair_vtable;
static ReferencePair* pairs;
static size_t pair_count, pair_capacity;

static _Noreturn void fail(const char* message) {
  fprintf(stderr, "persistent census: %s (%s)\n", message, strerror(errno));
  exit(2);
}
void SKIP_throw_cruntime(int code) {
  (void)code;
  fail("allocation size overflow");
}
static int within(Region r, const void* pointer, size_t size) {
  uintptr_t p = (uintptr_t)pointer;
  return p >= r.begin && p <= r.end && size <= r.end - p;
}
static void require(int condition, const char* message) {
  if (!condition) {
    errno = 0;
    fail(message);
  }
}
static void read_exact(int fd, void* buffer, size_t size, off_t offset) {
  require(pread(fd, buffer, size, offset) == (ssize_t)size, "short file read");
}
static void map_image(const char* path, int64_t expected_version) {
  int fd = open(path, O_RDONLY | O_CLOEXEC);
  if (fd < 0) fail("open compiler");
  Elf64_Ehdr eh;
  read_exact(fd, &eh, sizeof(eh), 0);
  require(!memcmp(eh.e_ident, ELFMAG, SELFMAG) &&
              eh.e_ident[EI_CLASS] == ELFCLASS64 &&
              eh.e_ident[EI_DATA] == ELFDATA2LSB && eh.e_type == ET_EXEC,
          "requires a little-endian non-PIE ELF64 compiler");
  require(eh.e_phentsize == sizeof(Elf64_Phdr),
          "unexpected ELF program headers");
  Elf64_Phdr* ph = calloc(eh.e_phnum, sizeof(*ph));
  if (!ph) fail("program header allocation");
  read_exact(fd, ph, eh.e_phnum * sizeof(*ph), eh.e_phoff);
  uintptr_t page = (uintptr_t)sysconf(_SC_PAGESIZE);
  image.begin = UINTPTR_MAX;
  for (int i = 0; i < eh.e_phnum; i++)
    if (ph[i].p_type == PT_LOAD) {
      uintptr_t lo = ph[i].p_vaddr & ~(page - 1);
      uintptr_t hi = (ph[i].p_vaddr + ph[i].p_memsz + page - 1) & ~(page - 1);
      if (lo < image.begin) image.begin = lo;
      if (hi > image.end) image.end = hi;
    }
  require(image.end > image.begin, "missing ELF load segments");
  void* base =
      mmap((void*)image.begin, image.end - image.begin, PROT_READ | PROT_WRITE,
           MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED_NOREPLACE, -1, 0);
  if (base == MAP_FAILED)
    fail("reserve compiler address range; build census as PIE");
  for (int i = 0; i < eh.e_phnum; i++)
    if (ph[i].p_type == PT_LOAD) {
      require(within(image, (void*)ph[i].p_vaddr, ph[i].p_filesz),
              "invalid ELF segment");
      read_exact(fd, (void*)ph[i].p_vaddr, ph[i].p_filesz, ph[i].p_offset);
    }
  free(ph);
  require(eh.e_shentsize == sizeof(Elf64_Shdr),
          "unexpected ELF section headers");
  Elf64_Shdr* sh = calloc(eh.e_shnum, sizeof(*sh));
  if (!sh) fail("section header allocation");
  read_exact(fd, sh, eh.e_shnum * sizeof(*sh), eh.e_shoff);
  int found = 0;
  int64_t version = 0;
  for (int i = 0; i < eh.e_shnum; i++)
    if (sh[i].sh_type == SHT_SYMTAB) {
      require(sh[i].sh_link < eh.e_shnum, "invalid ELF symbol strings");
      Elf64_Shdr names = sh[sh[i].sh_link];
      char* text = malloc(names.sh_size);
      Elf64_Sym* symbols = malloc(sh[i].sh_size);
      if (!text || !symbols) fail("symbol allocation");
      read_exact(fd, text, names.sh_size, names.sh_offset);
      read_exact(fd, symbols, sh[i].sh_size, sh[i].sh_offset);
      for (size_t j = 0; j < sh[i].sh_size / sizeof(*symbols); j++) {
        Elf64_Sym s = symbols[j];
        if (s.st_name < names.sh_size && !strcmp(text + s.st_name, "version")) {
          require(within(image, (void*)s.st_value, 8),
                  "invalid runtime version symbol");
          version = (int32_t)*(uint64_t*)s.st_value;
          found = 1;
        }
      }
      free(text);
      free(symbols);
    }
  free(sh);
  close(fd);
  if (found)
    require(version == expected_version, "compiler runtime version mismatch");
  if (mprotect(base, image.end - image.begin, PROT_READ))
    fail("protect compiler image");
}
static void push(void* pointer) {
  if (!within(heap, pointer, 0) || (uintptr_t)pointer == heap.end) {
    if ((uintptr_t)pointer >= 64) external_edges++;
    return;
  }
  require(!((uintptr_t)pointer & 7), "unaligned object reference");
  size_t bit = ((uintptr_t)pointer - heap.begin) / 8;
  unsigned char mask = (unsigned char)(1u << (bit % 8));
  if (visited[bit / 8] & mask) return;
  visited[bit / 8] |= mask;
  if (stack_size == stack_capacity) {
    stack_capacity = stack_capacity ? stack_capacity * 2 : 4096;
    void** next = realloc(stack, stack_capacity * sizeof(void*));
    if (!next) fail("traversal stack allocation");
    stack = next;
  }
  stack[stack_size++] = pointer;
}
static size_t rounded(size_t size) {
  return sk_size_of_slot(sk_slot_of_size(size));
}
static void record_pair(const void* object) {
  if (pair_count == pair_capacity) {
    size_t next = pair_capacity ? pair_capacity * 2 : 4096;
    require(next > pair_capacity && next <= SIZE_MAX / sizeof(*pairs),
            "pair census size overflow");
    ReferencePair* storage = realloc(pairs, next * sizeof(*pairs));
    if (!storage) fail("pair census allocation");
    pairs = storage;
    pair_capacity = next;
  }
  memcpy(&pairs[pair_count++], object, sizeof(*pairs));
}
static int compare_pair(const void* left, const void* right) {
  const ReferencePair *a = left, *b = right;
  if (a->first != b->first) return a->first < b->first ? -1 : 1;
  return (a->second > b->second) - (a->second < b->second);
}
static void scan(void* root) {
  push(root);
  while (stack_size) {
    char* p = stack[--stack_size];
    require(within(heap, p - 8, 8), "invalid object header");
    uintptr_t header = *(uintptr_t*)(p - 8);
    if (header & 2) {
      size_t length = *(uint32_t*)(p - 4);
      require(within(heap, p, length + 1), "invalid string length");
      uint64_t allocation = rounded(length + 1 + 16);
      require(within(heap, p - 16, 8), "invalid string reference count");
      uint64_t references = *(uint64_t*)(p - 16);
      string_reference_count_sum += references;
      single_owner_strings += references == 1;
      strings++;
      string_bytes += allocation;
      bytes += allocation;
      continue;
    }
    require(!(header & 7), "unexpected marked object or vtable tag");
    void** vtable = (void**)header;
    require(within(image, vtable, 16),
            "vtable is outside the supplied compiler");
    SKIP_gc_type_t* ty = vtable[1];
    require(within(image, ty, sizeof(*ty)), "invalid GC metadata");
    require(ty->m_kind <= 1 && ty->m_userByteSize < (1ULL << 32),
            "invalid GC layout");
    size_t mask_words =
        (ty->m_refsHintMask & 1) ? (ty->m_userByteSize / 8 + 63) / 64 : 0;
    require(within(image, ty->m_refMask, mask_words * 8 + 1),
            "invalid GC mask");
    const char* name =
        ty->m_hasName ? (char*)(ty->m_refMask + mask_words) : "<unnamed>";
    if (ty->m_hasName)
      require(memchr(name, 0, image.end - (uintptr_t)name) != NULL,
              "unterminated type name");
    size_t length = ty_is_array(ty) ? *(uint32_t*)(p - 12) : 1;
    size_t body = ty->m_userByteSize * length;
    require(within(heap, p, body), "invalid object size");
    if (header == pair_vtable) record_pair(p);
    uint64_t allocation = rounded(body + (ty_is_array(ty) ? 24 : 16));
    size_t slot = ((header >> 3) ^ (header >> 19)) & 65535, attempts = 0;
    while (types[slot].vtable && types[slot].vtable != vtable) {
      require(++attempts < 65536, "too many GC types");
      slot = (slot + 1) & 65535;
    }
    Type* t = &types[slot];
    t->vtable = vtable;
    t->name = name;
    t->objects++;
    t->width = ty->m_userByteSize;
    t->kind = ty->m_kind;
    t->body_bytes += body;
    t->allocated_bytes += allocation;
    // Persistent reference counts include owners outside the selected root.
    // They measure sharing of reachable objects, not a context-only edge
    // census.
    char* count = p - (ty_is_array(ty) ? 24 : 16);
    require(within(heap, count, 8), "invalid object reference count");
    uint64_t references = *(uint64_t*)count;
    t->reference_count_sum += references;
    t->single_owner_objects += references == 1;
    objects++;
    bytes += allocation;
    if ((ty->m_refsHintMask & 1) && strcmp(name, "SKStore.ExternalPointer")) {
      for (size_t off = 0; off < body; off += ty->m_userByteSize) {
        for (size_t word = 0; word < ty->m_userByteSize / 8; word++) {
          if ((ty->m_refMask[word / 64] >> (word % 64)) & 1) {
            t->references++;
            push(*(void**)(p + off + word * 8));
          }
        }
      }
    }
    if (objects % 10000000 == 0)
      fprintf(stderr, "census: %" PRIu64 " objects, %.2f GiB\n", objects,
              bytes / 1073741824.0);
  }
}
static void csv_name(const char* name) {
  putchar('"');
  for (; *name; name++) {
    if (*name == '"') putchar('"');
    putchar(*name);
  }
  putchar('"');
}
int main(int argc, char** argv) {
  if (argc != 4 && argc != 6) {
    fprintf(stderr,
            "usage: persistent-census EXACT-COMPILER STATE.DB RUNTIME-VERSION "
            "[--pair-vtable ADDRESS]\n");
    return 2;
  }
  char* tail;
  int64_t version = (int32_t)strtoll(argv[3], &tail, 10);
  require(
      *argv[3] && !*tail,
      "invalid expected runtime version (from the matching build's magic.c)");
  map_image(argv[1], version);
  if (argc == 6) {
    require(!strcmp(argv[4], "--pair-vtable"), "unknown census option");
    errno = 0;
    uint64_t address = strtoull(argv[5], &tail, 0);
    require(!errno && *argv[5] && !*tail && address && address <= UINTPTR_MAX,
            "invalid pair vtable address");
    pair_vtable = (uintptr_t)address;
    require(!(pair_vtable & 7) && within(image, (void*)pair_vtable, 16),
            "invalid pair vtable");
    SKIP_gc_type_t* ty = ((void**)pair_vtable)[1];
    require(within(image, ty, sizeof(*ty) + 8), "invalid pair metadata");
    require(ty->m_kind == kSkipGcKindClass &&
                (uint64_t)ty->m_userByteSize == sizeof(ReferencePair) &&
                (ty->m_refsHintMask & 1) && ty->m_refMask[0] == 3,
            "pair census requires a 16-byte class with two references");
  }
  int fd = open(argv[2], O_RDONLY | O_CLOEXEC);
  if (fd < 0) fail("open database read-only");
  if (flock(fd, LOCK_EX | LOCK_NB))
    fail("database is active; stop its compiler first");
  struct stat st;
  if (fstat(fd, &st)) fail("stat database");
  Mapping header;
  read_exact(fd, &header, sizeof(header), 0);
  require(header.version == version, "runtime format version mismatch");
  require(header.capacity + 1 == (uint64_t)st.st_size &&
              (uintptr_t)header.global.end ==
                  (uintptr_t)header.base + header.capacity,
          "unsupported persistent mapping layout");
  void* mapping = mmap(header.base, header.capacity, PROT_READ,
                       MAP_PRIVATE | MAP_FIXED_NOREPLACE, fd, 0);
  if (mapping == MAP_FAILED)
    fail("map database read-only at its recorded address");
  heap = (Region){(uintptr_t)header.base, (uintptr_t)header.global.head};
  require(heap.end > heap.begin && heap.end <= (uintptr_t)header.global.end,
          "invalid allocation frontier");
  visited = calloc((heap.end - heap.begin + 63) / 64, 1);
  if (!visited) fail("visited bitmap allocation");
  scan(header.global.contexts);
  require(bytes <= header.global.allocated,
          "reachable bytes exceed allocator counter");
  printf(
      "type,objects,body_bytes,allocated_bytes,references,width,kind,vtable,"
      "reference_count_sum,single_owner_objects\n");
  printf(
      "\"String\",%" PRIu64 ",0,%" PRIu64 ",0,1,2,0,%" PRIu64 ",%" PRIu64 "\n",
      strings, string_bytes, string_reference_count_sum, single_owner_strings);
  for (size_t i = 0; i < 65536; i++)
    if (types[i].vtable) {
      Type t = types[i];
      csv_name(t.name);
      printf(",%" PRIu64 ",%" PRIu64 ",%" PRIu64 ",%" PRIu64 ",%" PRIu64
             ",%" PRIu64 ",%" PRIuPTR ",%" PRIu64 ",%" PRIu64 "\n",
             t.objects, t.body_bytes, t.allocated_bytes, t.references, t.width,
             t.kind, (uintptr_t)t.vtable, t.reference_count_sum,
             t.single_owner_objects);
    }
  fflush(stdout);
  if (pair_vtable) {
    if (pair_count) qsort(pairs, pair_count, sizeof(*pairs), compare_pair);
    uint64_t distinct = pair_count ? 1 : 0;
    for (size_t i = 1; i < pair_count; i++)
      distinct += compare_pair(&pairs[i - 1], &pairs[i]) != 0;
    fprintf(stderr,
            "{\"scope\":\"exact reference pairs\",\"vtable\":%" PRIuPTR
            ",\"objects\":%zu,\"distinct_pairs\":%" PRIu64
            ",\"duplicate_objects\":%" PRIu64
            ",\"duplicate_allocation_bytes\":%" PRIu64
            ",\"note\":\"Conservative lower bound; does not compare logical "
            "key equality\"}\n",
            pair_vtable, pair_count, distinct, (uint64_t)pair_count - distinct,
            ((uint64_t)pair_count - distinct) *
                rounded(sizeof(ReferencePair) + 16));
    free(pairs);
  }
  fprintf(stderr,
          "{\"scope\":\"context root\",\"objects\":%" PRIu64
          ",\"strings\":%" PRIu64 ",\"reachable_bytes\":%" PRIu64
          ",\"persistent_live_bytes\":%zu,\"external_edges\":%" PRIu64
          ",\"allocated_disk_bytes\":%" PRIu64 "}\n",
          objects, strings, bytes, header.global.allocated, external_edges,
          (uint64_t)st.st_blocks * 512);
  return 0;
}
