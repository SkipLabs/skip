#include "runtime.h"

#ifdef SKIP64

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <stdlib.h>
#include <errno.h>
#include <poll.h>
#include <unistd.h>
#include <sys/wait.h>

void* SKIP_exec(char* cmd) {
  size_t size = SKIP_String_byteSize(cmd);
  char* cstr = malloc(size+1);
  memcpy(cstr, cmd, size);
  cstr[size] = 0;

  FILE* fstream = popen(cstr, "w");

  if(fstream == NULL) {
    perror("Could not execute command");
    exit(4);
  }

  free(cstr);

  return fstream;
}

uint32_t SKIP_write_to_proc(FILE* f, char* str) {
  size_t size = SKIP_String_byteSize(str);
  size_t n = fwrite(str, 1, size, f);
  if(n != size) {
    return 1;
  };
  return 0;
}

uint32_t SKIP_wait_for_proc(FILE* f) {
  return pclose(f);
}

#endif

#ifdef SKIP32

void* memset(void* ptr, int value, size_t size) {
  void* result = ptr;

  if(value != 0) {
    // memset only implemented for zero
    SKIP_throw_cruntime(ERROR_NOT_IMPLEMENTED);
  }

  const char* end = (char*)ptr + size;
  const char* lend = (char*)ptr + (size / sizeof(long) * sizeof(long));

  while(ptr < (void*)lend) {
    *(long*)ptr = 0;
    ptr += sizeof(long);
  }

  while(ptr < (void*)end) {
    *(char*)ptr = 0;
    ptr++;
  }

  return result;
}

void* memcpy(void* dest, const void* src, size_t size) {
  void* result = dest;
  const char* end = (char*)src + size;
  const char* lend = (char*)src + (size / sizeof(long) * sizeof(long));

  while(src < (void*)lend) {
    *(long*)dest = *(long*)src;
    dest += sizeof(long);
    src += sizeof(long);
  }

  while(src < (void*)end) {
    *(char*)dest = *(char*)src;
    dest++;
    src++;
  }
  return result;
}

#endif

void sk_print_int(uint64_t x) {
  char str[256];
  SkipInt i = 255;
  if(x == 0) {
    SKIP_print_char('0');
    SKIP_print_char('\n');
    return;
  }
  while(x != 0) {
    if(x % 10 == 0) str[i] = '0';
    if(x % 10 == 1) str[i] = '1';
    if(x % 10 == 2) str[i] = '2';
    if(x % 10 == 3) str[i] = '3';
    if(x % 10 == 4) str[i] = '4';
    if(x % 10 == 5) str[i] = '5';
    if(x % 10 == 6) str[i] = '6';
    if(x % 10 == 7) str[i] = '7';
    if(x % 10 == 8) str[i] = '8';
    if(x % 10 == 9) str[i] = '9';
    i--;
    x = x / 10;
  };
  for(i++; i < 256; i++) {
    SKIP_print_char(str[i]);
  };
  SKIP_print_char('\n');
}

void todo() {
  SKIP_throw_cruntime(ERROR_TODO);
}


char* SKIP_read_line() {
  int32_t size = SKIP_read_line_fill();

  if (size < 0) {
      return NULL;
  }

  uint32_t i;
  char* result = SKIP_Obstack_alloc(size);

  for(i = 0; i < size; i++) {
    result[i] = SKIP_read_line_get(i);
  }

  result = sk_string_create(result, size);
  return result;
}

#ifdef SKIP64

char* sk_completed_process_create(char* args, SkipInt exitcode, char* stdout, char* stderr);

char* SKIP_System_subprocess(char *args_obj) {
  size_t num_args = *(uint32_t*)(args_obj-sizeof(char*)-sizeof(uint32_t));
  char **args = malloc(sizeof(char *) * (num_args + 1));
  if (args == NULL) {
    perror("malloc");
    exit(1);
  }
  for (int i = 0; i < num_args; ++i) {
    char *arg_obj = *((char **)args_obj + i);
    size_t sz = SKIP_String_byteSize(arg_obj);
    args[i] = malloc(sizeof(char) * (sz + 1));
    if (args[i] == NULL) {
      perror("malloc");
      exit(1);
    }
    memcpy(args[i], arg_obj, sz);
    args[i][sz] = 0;
  }
  args[num_args] = 0;

  int stdout_fd[2];
  if (pipe(stdout_fd) == -1) {
    perror("pipe");
    exit(1);
  }

  int stderr_fd[2];
  if (pipe(stderr_fd) == -1) {
    perror("pipe");
    exit(1);
  }

  pid_t pid = fork();

  if (pid == -1) {
    perror("fork");
    exit(1);
  }

  if (pid == 0) {
    while (dup2(stdout_fd[1], STDOUT_FILENO) == -1) {
      if (errno == EINTR) continue;
      perror("dup2");
      exit(1);
    }
    while (dup2(stderr_fd[1], STDERR_FILENO) == -1) {
      if (errno == EINTR) continue;
      perror("dup2");
      exit(1);
    }
    for (int i = 0; i < 2; ++i) {
      if (close(stdout_fd[i]) == -1) {
        perror("close");
        exit(1);
      }
      if (close(stderr_fd[i]) == -1) {
        perror("close");
        exit(1);
      }
    }

    // TODO: Optional envp with execvpe.
    execvp(args[0], args);
    perror("execvp");
    exit(1);
  }
  if (close(stdout_fd[1]) == -1) {
    perror("close");
    exit(1);
  }
  if (close(stderr_fd[1]) == -1) {
    perror("close");
    exit(1);
  }

  for (int i = 0; i < num_args; ++i) {
    free(args[i]);
  }
  free(args);

  const int nfds = 2;
  char *out[nfds];
  size_t len[nfds];
  size_t size[nfds];
  for (size_t i = 0; i < nfds; ++i) {
    len[i] = 0;
    size[i] = 4096;
    out[i] = malloc(size[i]);
    if (out[i] == NULL) {
      perror("malloc");
      exit(1);
    }
  }

  int open_fds = nfds;
  struct pollfd pfds[] = {
    {stdout_fd[0], POLLIN, 0},
    {stderr_fd[0], POLLIN, 0},
  };
  while (open_fds > 0) {
    if (poll(pfds, nfds, -1) == -1) {
      if (errno == EINTR) {
        continue;
      } else {
        perror("poll");
        exit(1);
      }
    }

    for (nfds_t i = 0; i < nfds; ++i) {
      if (pfds[i].revents == 0) continue;

      if (pfds[i].revents & POLLIN) {
        if (size[i] == len[i]) {
          size[i] *= 2;
          out[i] = realloc(out[i], size[i]);
          if (out[i] == NULL) {
            perror("realloc");
            exit(1);
          }
        }
        ssize_t count = read(pfds[i].fd, out[i] + len[i], size[i] - len[i]);
        if (count == -1) {
          if (errno == EINTR) {
            continue;
          } else {
            perror("read");
            exit(1);
          }
        }
        len[i] += count;
      } else { // POLLERR | POLLHUP
        if (close(pfds[i].fd) == -1) {
          perror("close");
          exit(1);
        }
        pfds[i].fd = -1;
        --open_fds;
      }
    }
  }

  char *stdout = sk_string_create(out[0], len[0]);
  free(out[0]);
  char *stderr = sk_string_create(out[1], len[1]);
  free(out[1]);

  int status;
  if (waitpid(pid, &status, 0) == -1) {
    perror("waitpid");
    exit(1);
  }

  int32_t exitcode = 0;
  if (WIFEXITED(status)) {
    exitcode = WEXITSTATUS(status);
  }

  return sk_completed_process_create(args_obj, exitcode, stdout, stderr);
}

#endif // SKIP64
