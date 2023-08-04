#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/errno.h>
#include <sys/wait.h>
#include <unistd.h>

#include "runtime.h"

int64_t SKIP_posix_open(char *path_obj, int64_t oflag, int64_t mode) {
  char *path = sk2c_string(path_obj);
  int fd = open(path, oflag, mode);
  if (path != path_obj) free(path);

  if (fd == -1) {
    perror("open");
    fprintf(stderr, "Could not open file: %s\n", path);
    exit(EXIT_FAILURE);
  }

  return (int64_t)fd;
}

int64_t SKIP_posix_open_flags(int64_t read, int64_t write, int64_t append,
                              int64_t truncate, int64_t create,
                              int64_t create_new) {
  int res = 0;
  if (read && write) {
    res = O_RDWR;
  } else if (read) {
    res = O_RDONLY;
  } else if (write) {
    res = O_WRONLY;
  } else {
    return -1;
  }

  if (append) {
    res |= O_APPEND;
  }
  if (truncate) {
    res |= O_TRUNC;
  }
  if (create) {
    res |= O_CREAT;
  }
  if (create_new) {
    res |= O_EXCL;
  }

  return (int64_t)res;
}

void SKIP_posix_close(int64_t fd) {
  int rv = close((int)fd);
  if (rv != 0) {
    perror("close");
    exit(EXIT_FAILURE);
  }
}

int64_t SKIP_posix_write(int64_t fd, char *buf) {
  int rv = write((int)fd, buf, SKIP_String_byteSize(buf));
  if (rv == -1) {
    perror("write");
    exit(EXIT_FAILURE);
  }
  return (int64_t)rv;
}

char *SKIP_posix_read(int64_t fd, int64_t len) {
  // TODO: zero-length?
  char *buf = (char *)malloc(len);
  if (buf == NULL) {
    perror("malloc");
    exit(EXIT_FAILURE);
  }
  int rv = read((int)fd, buf, len);
  if (rv == -1) {
    perror("read");
    exit(EXIT_FAILURE);
  }
  return sk_string_create(buf, rv);
}

char *sk_create_posix_pipe(int64_t output_fd, int64_t input_fd);

char *SKIP_posix_pipe() {
  int fds[] = {-1, -1};
  if (pipe(fds) == -1) {
    perror("pipe");
    exit(EXIT_FAILURE);
  }
  return sk_create_posix_pipe((int64_t)fds[0], (int64_t)fds[1]);
}

void SKIP_posix_dup2(int64_t oldfd, int64_t newfd) {
  while (dup2((int)oldfd, (int)newfd) == -1) {
    if (errno == EINTR) continue;
    perror("dup2");
    exit(EXIT_FAILURE);
  }
}

void SKIP_posix_kill(int64_t pid, int64_t sig) {
  int rv = kill((int)pid, (int)sig);
  if (rv != 0) {
    perror("kill");
    exit(EXIT_FAILURE);
  }
}

int64_t SKIP_posix_waitpid(int64_t pid, char nohang) {
  int stat_loc;
  int opts = 0;
  if (nohang) {
    opts |= WNOHANG;
  }
  int rv = waitpid((int)pid, &stat_loc, opts);
  if (rv == -1) {
    perror("waitpid");
    exit(EXIT_FAILURE);
  }
  if (nohang && rv == 0) {
    return (int64_t)(-1);
  }
  return (int64_t)stat_loc;
}

char SKIP_posix_wifexited(int64_t stat_loc) {
  return (char)WIFEXITED((int)stat_loc);
}

char SKIP_posix_wifsignaled(int64_t stat_loc) {
  return (char)WIFSIGNALED((int)stat_loc);
}

char SKIP_posix_wifstopped(int64_t stat_loc) {
  return (char)WIFSTOPPED((int)stat_loc);
}

int64_t SKIP_posix_wexitstatus(int64_t stat_loc) {
  return (int64_t)WEXITSTATUS((int)stat_loc);
}

int64_t SKIP_posix_wtermsig(int64_t stat_loc) {
  return (int64_t)WTERMSIG((int)stat_loc);
}

int64_t SKIP_posix_wstopsig(int64_t stat_loc) {
  return (int64_t)WSTOPSIG((int)stat_loc);
}

int64_t SKIP_posix_poll(char *pollfds) {
  int nfds = *(uint32_t *)(pollfds - sizeof(char *) - sizeof(uint32_t));

  for (;;) {
    int rv = poll((struct pollfd *)pollfds, nfds, -1);
    if (rv == -1) {
      if (errno == EINTR) {
        continue;
      } else {
        perror("poll");
        exit(EXIT_FAILURE);
      }
    }
    return (int64_t)rv;
  }
}

int64_t SKIP_posix_fork() {
  pid_t pid = fork();
  if (pid == -1) {
    perror("fork");
    exit(EXIT_FAILURE);
  }
  return (int64_t)pid;
}

void SKIP_posix_execvp(char *args_obj) {
  size_t num_args = *(uint32_t *)(args_obj - sizeof(char *) - sizeof(uint32_t));
  char **args = (char **)malloc(sizeof(char *) * (num_args + 1));
  if (args == NULL) {
    perror("malloc");
    exit(EXIT_FAILURE);
  }
  for (size_t i = 0; i < num_args; ++i) {
    char *arg_obj = *((char **)args_obj + i);
    size_t sz = SKIP_String_byteSize(arg_obj);
    args[i] = (char *)malloc(sizeof(char) * (sz + 1));
    if (args[i] == NULL) {
      perror("malloc");
      exit(EXIT_FAILURE);
    }
    memcpy(args[i], arg_obj, sz);
    args[i][sz] = 0;
  }
  args[num_args] = 0;

  // TODO: Optional envp with execvpe.
  execvp(args[0], args);
  perror("execvp");
  exit(EXIT_FAILURE);
}

char SKIP_posix_isatty(int64_t fd) {
  int rv = isatty((int)fd);
  if (rv == 0 && errno != ENOTTY) {
    perror("isatty");
    exit(EXIT_FAILURE);
  }
  return (char)rv;
}

int64_t SKIP_posix_mkstemp(char *template_obj) {
  char *template = sk2c_string(template_obj);

  int rv = mkstemp(template);
  if (rv == -1) {
    perror("mkstemp");
    exit(EXIT_FAILURE);
  }
  if (template != template_obj) {
    free(template);
  }

  return rv;
}
