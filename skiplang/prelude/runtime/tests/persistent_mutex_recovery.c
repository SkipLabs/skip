// Standalone regression test for reopening a persistent heap after its mutex
// contains an owner from a previous process namespace. Build with section GC
// so only the exercised parts of palloc.c need runtime definitions.
#define SKIP64 1
#include "../palloc.c"

#include <poll.h>
#include <sys/wait.h>

int SKIP_get_version(void) { return 42; }

int main(void) {
  char path[] = "/tmp/test-palloc-mutex-XXXXXX";
  int initial = mkstemp(path);
  if (initial < 0) return 1;
  close(initial);
  unlink(path);

  pid_t creator = fork();
  if (creator == 0) {
    sk_create_mapping(path, 1024 * 1024);
    sk_global_lock();
    sk_global_unlock();
    _exit(0);
  }
  int status;
  if (creator < 0 || waitpid(creator, &status, 0) != creator ||
      !WIFEXITED(status) || WEXITSTATUS(status))
    return 2;

  int fd = open(path, O_RDWR);
  if (fd < 0) return 3;
  pthread_mutex_t poisoned;
  off_t offset = offsetof(file_mapping_t, gmutex);
  if (pread(fd, &poisoned, sizeof(poisoned), offset) != sizeof(poisoned))
    return 4;
  poisoned.__data.__lock = 0x800f423f;
  poisoned.__data.__owner = 999999;
  poisoned.__data.__count = 1;
  if (pwrite(fd, &poisoned, sizeof(poisoned), offset) != sizeof(poisoned))
    return 5;
  close(fd);

  alarm(5);  // The old runtime waited forever on this stale owner.
  sk_load_mapping(path);
  sk_global_lock();
  sk_global_unlock();
  alarm(0);

  // A second live user must share the file lease and wait for this mutex.
  int pipefd[2];
  if (pipe(pipefd) != 0) return 6;
  sk_global_lock();
  pid_t user = fork();
  if (user == 0) {
    close(pipefd[0]);
    sk_load_mapping(path);
    sk_global_lock();
    char done = 'x';
    if (write(pipefd[1], &done, 1) != 1) _exit(7);
    sk_global_unlock();
    _exit(0);
  }
  if (user < 0) return 8;
  close(pipefd[1]);
  struct pollfd ready = {.fd = pipefd[0], .events = POLLIN};
  if (poll(&ready, 1, 200) != 0) return 9;
  sk_global_unlock();
  if (poll(&ready, 1, 5000) != 1) return 10;
  char done;
  if (read(pipefd[0], &done, 1) != 1 || done != 'x') return 11;
  if (waitpid(user, &status, 0) != user || !WIFEXITED(status) ||
      WEXITSTATUS(status))
    return 12;
  close(pipefd[0]);
  unlink(path);
  return 0;
}
