"""Native capture-pipe isolation, including the portable synchronized path."""

import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import unittest

FIXTURE = r"""
#include "posix.c"
#include <assert.h>
#include <pthread.h>

struct Pipe { int64_t readfd, writefd; };
char* sk_create_posix_pipe(int64_t readfd, int64_t writefd) {
  struct Pipe *p = malloc(sizeof(*p));
  assert(p);
  *p = (struct Pipe){readfd, writefd};
  return (char*)p;
}
void sk_string_check_c_safe(char *text) { (void)text; }

static struct Pipe capture(void) {
  struct Pipe *p = (struct Pipe*)SKIP_posix_pipe_cloexec();
  struct Pipe result = *p;
  free(p);
  return result;
}
static void close_pipe(struct Pipe p) {
  assert(close(p.readfd) == 0);
  assert(close(p.writefd) == 0);
}
static char *array(char **values, size_t count) {
  sk_array_t *a = calloc(1, sizeof(*a) + count*sizeof(char*));
  assert(a);
  a->length = count;
  memcpy(a->data, values, count*sizeof(char*));
  return a->data;
}
static void free_array(char *a) { free(container_of(a, sk_array_t, data)); }

static const char *program;
static int64_t launch(struct Pipe p, const char *command, const char *option,
                      const char *value) {
  char *values[] = {(char*)command, (char*)option, (char*)value};
  char *args = array(values, value ? 3 : 2);
  char *env = array(values, 0);
  posix_spawn_file_actions_t actions;
  assert(posix_spawn_file_actions_init(&actions) == 0);
  assert(posix_spawn_file_actions_adddup2(&actions, p.writefd, 1) == 0);
  assert(posix_spawn_file_actions_addclose(&actions, p.readfd) == 0);
  assert(posix_spawn_file_actions_addclose(&actions, p.writefd) == 0);
  int64_t pid = SKIP_posix_spawnp(args, env, (char*)&actions);
  assert(posix_spawn_file_actions_destroy(&actions) == 0);
  free_array(args);
  free_array(env);
  return pid;
}
static void finish(struct Pipe p, int64_t pid) {
  assert(pid > 0);
  assert(close(p.writefd) == 0);
  char text[8];
  size_t used = 0;
  for (;;) {
    ssize_t n = read(p.readfd, text+used, sizeof(text)-used);
    if (n < 0 && errno == EINTR) continue;
    assert(n >= 0);
    if (!n) break;
    used += n;
    assert(used < sizeof(text));
  }
  assert(close(p.readfd) == 0);
  int status;
  assert(waitpid(pid, &status, 0) == pid);
  assert(WIFEXITED(status) && WEXITSTATUS(status) == 0);
  assert(used == 3 && memcmp(text, "ok\n", 3) == 0);
}
static void *worker(void *unused) {
  (void)unused;
  for (int i=0; i<32; ++i) {
    struct Pipe p = capture();
    finish(p, launch(p, program, "--check-fds", NULL));
  }
  return NULL;
}
int main(int argc, char **argv) {
  assert(argc >= 2);
  program = argv[0];
  if (!strcmp(argv[1], "--check-fds")) {
    for (int fd=3; fd<1024; ++fd) {
      if (fcntl(fd, F_GETFD) != -1 || errno != EBADF) {
        fprintf(stderr, "inherited unexpected descriptor %d\n", fd);
        return 2;
      }
    }
    assert(write(1, "ok\n", 3) == 3);
  } else if (!strcmp(argv[1], "--expect-fd")) {
    assert(argc == 3 && fcntl(atoi(argv[2]), F_GETFD) >= 0);
    assert(write(1, "ok\n", 3) == 3);
  } else if (!strcmp(argv[1], "flags")) {
    struct Pipe p = capture();
    assert(fcntl(p.readfd, F_GETFD) & FD_CLOEXEC);
    assert(fcntl(p.writefd, F_GETFD) & FD_CLOEXEC);
    close_pipe(p);
    struct Pipe *raw = (struct Pipe*)SKIP_posix_pipe();
    assert(!(fcntl(raw->readfd, F_GETFD) & FD_CLOEXEC));
    assert(!(fcntl(raw->writefd, F_GETFD) & FD_CLOEXEC));
    close_pipe(*raw);
    free(raw);
  } else if (!strcmp(argv[1], "inheritance")) {
    struct Pipe *raw = (struct Pipe*)SKIP_posix_pipe();
    struct Pipe p = capture();
    char fd[32];
    snprintf(fd, sizeof(fd), "%ld", (long)raw->readfd);
    finish(p, launch(p, program, "--expect-fd", fd));
    close_pipe(*raw);
    free(raw);
  } else if (!strcmp(argv[1], "concurrent")) {
    pthread_t threads[8];
    for (int i=0; i<8; ++i) assert(pthread_create(&threads[i], NULL, worker, NULL) == 0);
    for (int i=0; i<8; ++i) assert(pthread_join(threads[i], NULL) == 0);
  } else if (!strcmp(argv[1], "failed-spawn")) {
    struct Pipe p = capture();
    assert(launch(p, "/nonexistent/skip-capture-test-program", "unused", NULL) < 0);
    close_pipe(p);
    p = capture();
    finish(p, launch(p, program, "--check-fds", NULL));
  } else return 3;
  return 0;
}
"""


@unittest.skipUnless(
    sys.platform == "linux" and shutil.which("cc"),
    "Native Linux C toolchain required",
)
class CapturePipeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.temporary = tempfile.TemporaryDirectory(
            prefix="skip-capture-pipes-"
        )
        cls.addClassCleanup(cls.temporary.cleanup)
        root = Path(cls.temporary.name)
        source = root / "fixture.c"
        source.write_text(FIXTURE)
        runtime = Path(__file__).resolve().parents[2] / "prelude/runtime"
        cls.executables = []
        for portable in [False, True]:
            output = root / ("portable" if portable else "atomic")
            subprocess.run(
                [
                    "cc",
                    "-O2",
                    "-g",
                    "-DSKIP64",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-ffunction-sections",
                    "-fdata-sections",
                    "-Wl,--gc-sections",
                    "-pthread",
                    "-I",
                    str(runtime),
                    *(["-DSKIP_POSIX_PIPE_FALLBACK"] if portable else []),
                    str(source),
                    "-o",
                    str(output),
                ],
                check=True,
            )
            cls.executables.append(output)

    def check_mode(self, mode):
        for executable in self.executables:
            with self.subTest(implementation=executable.name):
                result = subprocess.run(
                    [executable, mode],
                    capture_output=True,
                    text=True,
                    timeout=30,
                )
                self.assertEqual(result.returncode, 0, result.stderr)

    def test_capture_flags_preserve_public_pipe_contract(self):
        self.check_mode("flags")

    def test_explicit_descriptor_inheritance_and_capture_still_work(self):
        self.check_mode("inheritance")

    def test_concurrent_children_inherit_only_their_stdio(self):
        self.check_mode("concurrent")

    def test_failed_spawn_releases_portable_lock(self):
        self.check_mode("failed-spawn")


WASM_LINKER = shutil.which("wasm-ld") or shutil.which("wasm-ld-20")


@unittest.skipUnless(
    shutil.which("clang") and WASM_LINKER and shutil.which("node"),
    "Clang, Wasm linker and Node required",
)
class WasmCapturePipeTests(unittest.TestCase):
    def test_both_pipe_entries_use_the_existing_js_bridge(self):
        runtime = Path(__file__).resolve().parents[2] / "prelude/runtime"
        with tempfile.TemporaryDirectory(prefix="skip-capture-wasm-") as tmp:
            root = Path(tmp)
            obj, wasm = root / "runtime.o", root / "pipe.wasm"
            subprocess.run(
                [
                    "clang",
                    "--target=wasm32",
                    "-DSKIP32",
                    "-O2",
                    "-nostdlibinc",
                    "-ffunction-sections",
                    "-fdata-sections",
                    "-c",
                    str(runtime / "runtime32_specific.c"),
                    "-o",
                    str(obj),
                ],
                check=True,
                capture_output=True,
                text=True,
            )
            subprocess.run(
                [
                    WASM_LINKER,
                    "--no-entry",
                    "--allow-undefined",
                    "--export=SKIP_posix_pipe",
                    "--export=SKIP_posix_pipe_cloexec",
                    str(obj),
                    "-o",
                    str(wasm),
                ],
                check=True,
                capture_output=True,
                text=True,
            )
            check = root / "check.cjs"
            check.write_text("""
const fs = require('node:fs');
let calls = 0;
WebAssembly.instantiate(fs.readFileSync(process.argv[2]), {
  env: { SKIP_js_pipe: () => { ++calls; return 1234; } }
}).then(({instance}) => {
  if (instance.exports.SKIP_posix_pipe() !== 1234 ||
      instance.exports.SKIP_posix_pipe_cloexec() !== 1234 || calls !== 2) {
    throw new Error('Capture pipe changed the Wasm bridge');
  }
}).catch(error => { console.error(error); process.exitCode = 1; });
""")
            result = subprocess.run(
                ["node", str(check), str(wasm)],
                capture_output=True,
                text=True,
                timeout=30,
            )
            self.assertEqual(result.returncode, 0, result.stderr)


@unittest.skipUnless(
    os.environ.get("SKC_CAPTURE_TEST_COMPILER"),
    "Set a compiler wrapper with the capture-pipe support archive",
)
class SkipCapturePipeTests(unittest.TestCase):
    def test_parallel_store_workers_capture_success_and_failure_independently(
        self,
    ):
        source = r"""
@cpp_extern("SKIP_parallel_map_worker_id")
native fun captureWorkerId(): Int;
untracked fun main(): void {
  context = SKStore.Context::mcreate{};
  source = context.mkdir(SKStore.IID::keyType, SKStore.IntFile::type,
    SKStore.DirName::create("/capture/source/"),
    Array::fillBy(96, i -> (SKStore.IID(i), SKStore.IntFile(i))));
  output = source.parallelMap(SKStore.IID::keyType, SKStore.IntFile::type,
    context, SKStore.DirName::create("/capture/output/"),
    (_, writer, key, values) ~> {
      expected = values[0].value.toString();
      failure = System.subprocess(Array["/bin/sh", "-c",
        "printf '%s' \"$1\"; printf error >&2; exit 7", "capture-test", expected]).fromSuccess();
      invariant(failure.stdout == expected && failure.stderr == "error");
      invariant(!failure.success() && failure.exitcode() == 7);
      success = System.subprocess(Array["/bin/sh", "-c",
        "printf '%s' \"$1\"", "capture-test", expected]).fromSuccess();
      invariant(success.success() && success.stdout == expected && success.stderr == "");
      writer.set(key, SKStore.IntFile(captureWorkerId()));
    }, None(), 4);
  context.update();
  threads = SortedSet[];
  for (i in Range(0, 96)) {
    !threads = threads.set(output.get(context, SKStore.IID(i)).value)
  };
  invariant(threads.size() == 4, "Expected native worker threads");
  source.writeArray(context, SKStore.IID(17), Array[SKStore.IntFile(901)]);
  context.update();
  invariant(output.getArray(context, SKStore.IID(17)).size() == 1);
  print_raw("validated");
}
"""
        with tempfile.TemporaryDirectory(prefix="skip-capture-binding-") as tmp:
            root = Path(tmp)
            path, binary = root / "input.sk", root / "program"
            path.write_text(source)
            built = subprocess.run(
                [
                    os.environ["SKC_CAPTURE_TEST_COMPILER"],
                    "--release",
                    "-O2",
                    "--export-function-as",
                    "main=skip_main",
                    str(path),
                    "-o",
                    str(binary),
                ],
                capture_output=True,
                text=True,
                timeout=180,
            )
            self.assertEqual(built.returncode, 0, built.stderr[-12000:])
            result = subprocess.run(
                [binary], capture_output=True, text=True, timeout=60
            )
            self.assertEqual(result.returncode, 0, result.stderr[-12000:])
            self.assertEqual(result.stdout, "validated")


if __name__ == "__main__":
    unittest.main()
