// Standalone regression test: creating a persistent mapping over an existing
// file must exit with ERROR_MAPPING_EXISTS, not ERROR_FILE_IO. The runtime
// reports the error with perror, which may change errno, so the exit code must
// come from the errno saved before it (#1588). stderr is redirected to a file,
// as under skargo or CI, where glibc's perror leaves errno set to EINVAL. Build
// with section GC so only the exercised parts of palloc.c need runtime
// definitions.
#define SKIP64 1
#include <sys/wait.h>

#include "../palloc.c"

int SKIP_get_version(void) {
  return 42;
}

static int create_in_child(const char* path, const char* log) {
  pid_t child = fork();
  if (child == 0) {
    int err = open(log, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0600);
    if (err < 0 || dup2(err, STDERR_FILENO) < 0) _exit(100);
    sk_create_mapping((char*)path, 1024 * 1024);
    _exit(0);
  }
  int status;
  if (child < 0 || waitpid(child, &status, 0) != child || !WIFEXITED(status))
    return -1;
  return WEXITSTATUS(status);
}

int main(void) {
  char path[] = "/tmp/test-palloc-mapping-exists-XXXXXX";
  int initial = mkstemp(path);
  if (initial < 0) return 1;
  close(initial);
  unlink(path);
  char log[sizeof(path) + 4];
  snprintf(log, sizeof(log), "%s.err", path);

  int first = create_in_child(path, log);
  int second = create_in_child(path, log);
  unlink(path);
  unlink(log);
  if (first != 0) return 2;
  if (second == ERROR_FILE_IO) return 3;  // errno read after perror.
  return second == ERROR_MAPPING_EXISTS ? 0 : 4;
}
