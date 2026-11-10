// Standalone regression test: a persistent heap is stamped with the GNU
// build-id of the executable that created it, and only an executable with the
// same build-id may reopen it (#1606). The previous stamp was a per-build
// timestamp, which rejected heaps after every fresh checkout and accepted them
// from a different executable linked against the same runtime objects. Build
// with section GC so only the exercised parts of palloc.c need runtime
// definitions.
#define SKIP64 1
#include <sys/wait.h>

#include "../palloc.c"

// Runs `action` in a child with stderr redirected to `log`; returns its exit
// status, or -1 if it did not exit normally.
static int in_child(void (*action)(char*), char* path, const char* log) {
  pid_t child = fork();
  if (child == 0) {
    int err = open(log, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0600);
    if (err < 0 || dup2(err, STDERR_FILENO) < 0) _exit(100);
    action(path);
    _exit(0);
  }
  int status;
  if (child < 0 || waitpid(child, &status, 0) != child || !WIFEXITED(status))
    return -1;
  return WEXITSTATUS(status);
}

static void create(char* path) {
  sk_create_mapping(path, 1024 * 1024);
}

static void load(char* path) {
  sk_load_mapping(path);
}

int main(void) {
  unsigned char own[SK_BUILD_ID_MAX];
  uint32_t own_size = sk_read_build_id(own, sizeof(own));
  if (own_size == 0) return 1;  // Linked without a build-id note.

  char path[] = "/tmp/test-palloc-mapping-identity-XXXXXX";
  int initial = mkstemp(path);
  if (initial < 0) return 2;
  close(initial);
  unlink(path);
  char log[sizeof(path) + 4];
  snprintf(log, sizeof(log), "%s.err", path);

  int result = 0;
  if (in_child(create, path, log) != 0) result = 3;

  // The header records this executable's build-id.
  file_mapping_header_t header;
  int fd = open(path, O_RDWR);
  if (!result && (fd < 0 || pread(fd, &header, sizeof(header), 0) !=
                                (ssize_t)sizeof(header)))
    result = 4;
  if (!result &&
      (header.magic != SK_MAPPING_MAGIC || header.build_id_size != own_size ||
       memcmp(header.build_id, own, own_size) != 0))
    result = 5;

  // The same executable reopens it.
  if (!result && in_child(load, path, log) != 0) result = 6;

  // A heap written by another executable (a different build-id) is rejected
  // with ERROR_MAPPING_VERSION, before it is mapped.
  if (!result) {
    header.build_id[0] ^= 0xff;
    if (pwrite(fd, &header, sizeof(header), 0) != (ssize_t)sizeof(header))
      result = 7;
  }
  if (!result && in_child(load, path, log) != ERROR_MAPPING_VERSION) result = 8;

  // So is a heap in the previous format (version stamp, no magic).
  if (!result) {
    int64_t old_header[2] = {66751276, (int64_t)BOTTOM_ADDR};
    if (pwrite(fd, old_header, sizeof(old_header), 0) !=
        (ssize_t)sizeof(old_header))
      result = 9;
  }
  if (!result && in_child(load, path, log) != ERROR_MAPPING_VERSION)
    result = 10;

  if (fd >= 0) close(fd);
  unlink(path);
  unlink(log);
  return result;
}
