// Standalone regression test for persistent heaps on macOS. A heap stores
// absolute pointers into the executable, so the runtime re-executes itself
// without ASLR before mapping one at its fixed address. It keys the heap on the
// executable's LC_UUID and replaces the process-shared mutex (macOS has no
// robust mutexes) with an flock on "<file>.lock", which the kernel releases
// when a holder dies. Build with section GC so only the exercised parts of
// palloc.c need runtime definitions.
#define SKIP64 1
#include <sys/wait.h>

#include "../palloc.c"

static char path[] = "/tmp/test-palloc-macos-XXXXXX";

static int wait_child(pid_t child) {
  int status;
  if (child < 0 || waitpid(child, &status, 0) != child || !WIFEXITED(status))
    return -1;
  return WEXITSTATUS(status);
}

// Opens the heap like SKIP_memory_init, after re-executing without ASLR.
static void open_heap(char** argv, int create) {
  sk_disable_aslr(argv);
  if (create) {
    sk_create_mapping(path, 1024 * 1024);
  } else {
    sk_load_mapping(path);
  }
  sk_global_lock_open(path);
}

// Re-executed child: `argv[1]` names the step, `argv[2]` the heap.
static int child_main(char** argv) {
  memcpy(path, argv[2], sizeof(path));
  const char* step = argv[1];
  if (strcmp(step, "create") == 0) {
    open_heap(argv, 1);
    // Store a pointer into the executable, as vtables and constants are.
    sk_global_lock();
    ginfo->contexts = (void*)&child_main;
    sk_global_unlock();
    return 0;
  }
  open_heap(argv, 0);
  if (strcmp(step, "check") == 0) {
    // The slide is 0, so the stored code pointer is still valid.
    return ginfo->contexts == (void*)&child_main ? 0 : 20;
  }
  if (strcmp(step, "die-locked") == 0) {
    sk_global_lock();
    _exit(0);  // Exit without unlocking.
  }
  if (strcmp(step, "lock") == 0) {
    alarm(5);  // A lock left by a dead holder would block forever.
    sk_global_lock();
    sk_global_unlock();
    return 0;
  }
  return 21;
}

static int run(const char* self, const char* step) {
  pid_t child = fork();
  if (child == 0) {
    if (strcmp(step, "check-foreign") == 0) {
      // Silence the expected mismatch error.
      int null = open("/dev/null", O_WRONLY);
      if (null < 0 || dup2(null, STDERR_FILENO) < 0) _exit(101);
      step = "check";
    }
    char* argv[] = {(char*)self, (char*)step, path, NULL};
    execv(self, argv);
    _exit(100);
  }
  return wait_child(child);
}

int main(int argc, char** argv) {
  if (argc == 3) return child_main(argv);

  int initial = mkstemp(path);
  if (initial < 0) return 1;
  close(initial);
  unlink(path);
  char lock[sizeof(path) + 5];
  snprintf(lock, sizeof(lock), "%s.lock", path);

  char self[PATH_MAX];
  uint32_t size = sizeof(self);
  if (_NSGetExecutablePath(self, &size) != 0) return 2;

  int result = 0;
  int rv;
  if ((rv = run(self, "create")) != 0) result = 10 + rv;

  // The header records this executable's LC_UUID.
  unsigned char own[SK_BUILD_ID_MAX];
  uint32_t own_size = sk_read_build_id(own, sizeof(own));
  file_mapping_header_t header;
  int fd = open(path, O_RDWR);
  if (!result &&
      (own_size != 16 || fd < 0 ||
       pread(fd, &header, sizeof(header), 0) != (ssize_t)sizeof(header) ||
       header.magic != SK_MAPPING_MAGIC || header.build_id_size != own_size ||
       memcmp(header.build_id, own, own_size) != 0 ||
       header.bottom_addr != BOTTOM_ADDR))
    result = 3;

  // Another run, re-executed without ASLR, reads the stored code pointer.
  if (!result && (rv = run(self, "check")) != 0) result = 30 + rv;

  // A holder dying with the global lock held does not block later users.
  if (!result && (rv = run(self, "die-locked")) != 0) result = 50 + rv;
  if (!result && (rv = run(self, "lock")) != 0) result = 70 + rv;

  // A live holder does block others until it unlocks.
  if (!result) {
    int lfd = open(lock, O_RDWR);
    if (lfd < 0 || flock(lfd, LOCK_EX) != 0) result = 4;
    pid_t child = fork();
    if (!result && child == 0) {
      char* cargv[] = {self, "lock", path, NULL};
      execv(self, cargv);
      _exit(100);
    }
    if (!result) {
      usleep(200000);
      int status;
      if (waitpid(child, &status, WNOHANG) != 0) result = 5;
      flock(lfd, LOCK_UN);
      if (wait_child(child) != 0 && !result) result = 6;
    }
    if (lfd >= 0) close(lfd);
  }

  // A heap written by another executable is rejected.
  if (!result) {
    header.build_id[0] ^= 0xff;
    if (pwrite(fd, &header, sizeof(header), 0) != (ssize_t)sizeof(header))
      result = 7;
  }
  if (!result && run(self, "check-foreign") != ERROR_MAPPING_VERSION)
    result = 8;

  if (fd >= 0) close(fd);
  unlink(path);
  unlink(lock);
  return result;
}
