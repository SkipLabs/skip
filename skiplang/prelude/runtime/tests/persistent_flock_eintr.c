// Standalone regression test: a process waiting for the shared file lock on a
// persistent mapping must survive signals delivered by a handler installed
// without SA_RESTART, which make the blocking flock fail with EINTR. Build with
// section GC so only the exercised parts of palloc.c need runtime definitions.
#define SKIP64 1
#include <signal.h>
#include <sys/time.h>
#include <sys/wait.h>

#include "../palloc.c"

static volatile sig_atomic_t interrupts = 0;

static void count_interrupt(int sig) {
  (void)sig;
  interrupts++;
}

int main(void) {
  char path[] = "/tmp/test-palloc-flock-eintr-XXXXXX";
  int initial = mkstemp(path);
  if (initial < 0) return 1;
  close(initial);
  unlink(path);

  pid_t creator = fork();
  if (creator == 0) {
    sk_create_mapping(path, 1024 * 1024);
    _exit(0);
  }
  int status;
  if (creator < 0 || waitpid(creator, &status, 0) != creator ||
      !WIFEXITED(status) || WEXITSTATUS(status))
    return 2;

  // Hold the exclusive lock so the user below blocks waiting for LOCK_SH.
  int holder = open(path, O_RDWR);
  if (holder < 0 || flock(holder, LOCK_EX) != 0) return 3;

  pid_t user = fork();
  if (user == 0) {
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = count_interrupt;  // No SA_RESTART: flock returns EINTR.
    if (sigaction(SIGALRM, &sa, NULL) != 0) _exit(4);
    struct itimerval every_5ms = {{0, 5000}, {0, 5000}};
    if (setitimer(ITIMER_REAL, &every_5ms, NULL) != 0) _exit(5);
    sk_load_mapping(path);
    struct itimerval off = {{0, 0}, {0, 0}};
    setitimer(ITIMER_REAL, &off, NULL);
    _exit(interrupts > 0 ? 0 : 6);
  }
  if (user < 0) return 7;

  alarm(10);  // Fail rather than hang if the user never gets the lock.
  usleep(200 * 1000);
  if (flock(holder, LOCK_UN) != 0) return 8;
  if (waitpid(user, &status, 0) != user) return 9;
  alarm(0);
  close(holder);
  unlink(path);
  if (!WIFEXITED(status)) return 10;
  if (WEXITSTATUS(status) == ERROR_LOCKING) return 11;  // EINTR was fatal.
  return WEXITSTATUS(status) == 0 ? 0 : 12;
}
