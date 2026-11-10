"""A native fixture checks shared references, rounding, and read-only failure paths."""

import csv
import fcntl
import hashlib
import io
import json
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

FIXTURE = r"""
#define _GNU_SOURCE
#include "runtime.h"
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <string.h>
#include <sys/mman.h>
#include <elf.h>
#include <unistd.h>
// The executable's own GNU build-id, which the database header must record.
extern const Elf64_Ehdr __ehdr_start;
static unsigned build_id(unsigned char *out) {
  const Elf64_Phdr *ph = (const void *)((const char *)&__ehdr_start + __ehdr_start.e_phoff);
  for (int i = 0; i < __ehdr_start.e_phnum; i++) {
    if (ph[i].p_type != PT_NOTE) continue;
    const char *p = (const char *)ph[i].p_vaddr, *end = p + ph[i].p_memsz;
    while (p + sizeof(Elf64_Nhdr) <= end) {
      const Elf64_Nhdr *n = (const void *)p;
      const char *desc = p + sizeof(*n) + ((n->n_namesz + 3) & ~3u);
      if (n->n_type == NT_GNU_BUILD_ID) { memcpy(out, desc, n->n_descsz); return n->n_descsz; }
      p = desc + ((n->n_descsz + 3) & ~3u);
    }
  }
  return 0;
}
struct RootType {
  uint8_t refs, kind, unused, has_name;
  uint16_t header, unused_header;
  uint64_t width, padding, mask;
  char name[16];
} root_type = {1, 0, 0, 1, 8, 0, 16, 0, 3, "Fixture.Root"};
void *root_vtable[2] = {0, &root_type};
struct RootType array_type = {1, 1, 0, 1, 16, 0, 8, 0, 1, "Fixture.Array"};
void *array_vtable[2] = {0, &array_type};
struct Global {
  void *free_table[512], *contexts;
  char *head, *end, *filename;
  size_t allocated;
};
struct Mapping {
  uint64_t magic; void *base;
  uint32_t build_id_size; unsigned char build_id[64];
  pthread_mutexattr_t attr; pthread_mutex_t mutex;
  struct Global global;
  uint64_t gid; size_t capacity; void **constants;
};
int main(int argc, char **argv) {
  int pairs = argc == 3 && !strcmp(argv[2], "pairs");
  if (argc != 2 && !pairs && !(argc == 3 && !strcmp(argv[2], "foreign")))
    return 2;
  size_t capacity = 1024*1024;
  int fd = open(argv[1], O_RDWR|O_CREAT|O_EXCL, 0600);
  if (fd < 0 || ftruncate(fd, capacity+1)) return 3;
  char *base = mmap((void *)0x1000000000, capacity, PROT_READ|PROT_WRITE,
                   MAP_SHARED|MAP_FIXED_NOREPLACE, fd, 0);
  if (base == MAP_FAILED) return 4;
  struct Mapping *m = (void *)base;
  m->magic=0x31504d4e504b53ULL; m->base=base; m->capacity=capacity;
  m->build_id_size=build_id(m->build_id);
  if (!m->build_id_size) return 5;
  if (argc == 3 && !strcmp(argv[2], "foreign")) m->build_id[0] ^= 0xff;
  // Three references to one string: one from the root and two from an array.
  // Allocations include 32 bytes for the root, 320 for the 300-byte string,
  // and 40 for the two-element array, whose refcount precedes both metadata words.
  char *root = base+8192+16, *string = base+8192+32+16;
  char *array = base+8192+352+24;
  *(uint64_t *)(root-16)=1; *(void **)(root-8)=root_vtable;
  *(uint64_t *)(string-16)=3;
  *(uint32_t *)(string-8)=2; *(uint32_t *)(string-4)=300;
  memset(string, 'x', 300); string[300]=0;
  *(uint64_t *)(array-24)=1; *(uint32_t *)(array-12)=2;
  *(void **)(array-8)=array_vtable;
  ((void **)array)[0]=string; ((void **)array)[1]=string;
  ((void **)root)[0]=string; ((void **)root)[1]=array;
  m->global.contexts=root; m->global.head=base+8192+392;
  m->global.end=base+capacity; m->global.allocated=392;
  if (pairs) {
    // Three pair objects: two share identical reference values, one differs.
    // Root also has this layout but a different pair; the array closes a cycle.
    *(uint64_t *)(array-24)=2; *(uint32_t *)(array-12)=3;
    for (int i=0; i<3; i++) {
      char *pair = base+8192+400+i*32+16;
      *(uint64_t *)(pair-16)=1; *(void **)(pair-8)=root_vtable;
      ((void **)pair)[0] = i == 2 ? array : string;
      ((void **)pair)[1] = 0;
      ((void **)array)[i] = pair;
    }
    m->global.head=base+8192+496; m->global.allocated=496;
  }
  return msync(base, capacity, MS_SYNC) != 0;
}
"""


C_COMPILER = shutil.which("cc") or shutil.which("clang")


@unittest.skipUnless(C_COMPILER, "C compiler unavailable")
class PersistentCensusTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temporary = tempfile.TemporaryDirectory(prefix="skip-census-test-")
        cls.root = Path(cls.temporary.name)
        runtime = Path(__file__).resolve().parents[2] / "prelude/runtime"
        common = [
            C_COMPILER,
            "-O2",
            "-DSKIP64",
            "-Wall",
            "-Wextra",
            "-Werror",
            "-I",
            str(runtime),
        ]
        cls.tool = cls.root / "census"
        cls.fixture = cls.root / "fixture"
        source = cls.root / "fixture.c"
        source.write_text(FIXTURE)
        subprocess.run(
            [
                *common,
                "-fPIE",
                "-pie",
                str(Path(__file__).with_name("persistent_census.c")),
                "-o",
                str(cls.tool),
            ],
            check=True,
        )
        subprocess.run(
            [
                *common,
                "-fno-pie",
                "-no-pie",
                str(source),
                "-o",
                str(cls.fixture),
            ],
            check=True,
        )
        cls.database = cls.root / "state.db"
        subprocess.run([cls.fixture, cls.database], check=True)

    @classmethod
    def tearDownClass(cls):
        cls.temporary.cleanup()

    def census(self, database=None):
        return subprocess.run(
            [self.tool, self.fixture, database or self.database],
            capture_output=True,
            text=True,
        )

    def test_shared_objects_rounding_and_no_database_writes(self):
        before = hashlib.sha256(self.database.read_bytes()).hexdigest()
        result = self.census()
        self.assertEqual(result.returncode, 0, result.stderr)
        summary = json.loads(result.stderr)
        self.assertEqual(summary["objects"], 2)
        self.assertEqual(summary["strings"], 1)
        self.assertEqual(summary["reachable_bytes"], 392)
        rows = {
            r["type"]: r for r in csv.DictReader(io.StringIO(result.stdout))
        }
        self.assertEqual(int(rows["Fixture.Root"]["references"]), 2)
        self.assertEqual(int(rows["String"]["allocated_bytes"]), 320)
        self.assertEqual(int(rows["Fixture.Root"]["reference_count_sum"]), 1)
        self.assertEqual(int(rows["Fixture.Root"]["single_owner_objects"]), 1)
        self.assertEqual(int(rows["Fixture.Array"]["allocated_bytes"]), 40)
        self.assertEqual(int(rows["Fixture.Array"]["references"]), 2)
        self.assertEqual(int(rows["Fixture.Array"]["reference_count_sum"]), 1)
        self.assertEqual(int(rows["Fixture.Array"]["single_owner_objects"]), 1)
        self.assertEqual(int(rows["String"]["reference_count_sum"]), 3)
        self.assertEqual(int(rows["String"]["single_owner_objects"]), 0)
        self.assertEqual(
            hashlib.sha256(self.database.read_bytes()).hexdigest(), before
        )

    def test_active_database_is_rejected(self):
        with self.database.open("rb") as stream:
            fcntl.flock(stream, fcntl.LOCK_SH)
            result = self.census()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("database is active", result.stderr)

    def test_exact_reference_pairs_and_read_only_cycle(self):
        rows = {
            r["type"]: r
            for r in csv.DictReader(io.StringIO(self.census().stdout))
        }
        database = self.root / "pairs.db"
        subprocess.run([self.fixture, database, "pairs"], check=True)
        before = hashlib.sha256(database.read_bytes()).hexdigest()
        result = subprocess.run(
            [
                self.tool,
                self.fixture,
                database,
                "--pair-vtable",
                rows["Fixture.Root"]["vtable"],
            ],
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        reports = [json.loads(line) for line in result.stderr.splitlines()]
        pairs = next(
            r for r in reports if r["scope"] == "exact reference pairs"
        )
        self.assertEqual(pairs["objects"], 4)
        self.assertEqual(pairs["distinct_pairs"], 3)
        self.assertEqual(pairs["duplicate_objects"], 1)
        self.assertEqual(pairs["duplicate_allocation_bytes"], 32)
        self.assertEqual(reports[-1]["reachable_bytes"], 496)
        self.assertEqual(
            hashlib.sha256(database.read_bytes()).hexdigest(), before
        )

    def test_pair_census_rejects_array_layout(self):
        rows = {
            r["type"]: r
            for r in csv.DictReader(io.StringIO(self.census().stdout))
        }
        result = subprocess.run(
            [
                self.tool,
                self.fixture,
                self.database,
                "--pair-vtable",
                rows["Fixture.Array"]["vtable"],
            ],
            capture_output=True,
            text=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn(
            "requires a 16-byte class with two references", result.stderr
        )

    def test_other_executables_database_is_rejected(self):
        database = self.root / "foreign.db"
        subprocess.run([self.fixture, database, "foreign"], check=True)
        result = self.census(database)
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("build-id mismatch", result.stderr)


if __name__ == "__main__":
    unittest.main()
