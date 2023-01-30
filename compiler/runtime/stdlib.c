#include "runtime.h"

#ifdef SKIP64

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <stdlib.h>
#include <errno.h>
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

char* dump_output(int fd) {
  size_t size = 4096;
  char *buf = malloc(size);
  size_t len = 0;
  for (;;) {
    if (len == size) {
      size *= 2;
      buf = realloc(buf, size);
    }
    ssize_t count = read(fd, buf + len, size - len);
    if (count == -1) {
      if (errno == EINTR) {
        continue;
      } else {
        perror("read");
        exit(1);
      }
    } else if (count == 0) {
      break;
    }

    len += count;
  }

  char *res = sk_string_create(buf, len);
  free(buf);

  return res;
}

char* SKIP_System_subprocess(char *args_obj) {
  size_t num_args = *(uint32_t*)(args_obj-sizeof(char*)-sizeof(uint32_t));
  char **args = malloc(sizeof(char *) * (num_args + 1));
  for (int i = 0; i < num_args; ++i) {
    char *arg_obj = *((char **)args_obj + i);
    size_t sz = SKIP_String_byteSize(arg_obj);
    args[i] = malloc(sizeof(char) * (sz + 1));
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
    while ((dup2(stdout_fd[1], STDOUT_FILENO) == -1) && (errno == EINTR));
    close(stdout_fd[0]);
    close(stdout_fd[1]);

    while ((dup2(stderr_fd[1], STDERR_FILENO) == -1) && (errno == EINTR));
    close(stderr_fd[0]);
    close(stderr_fd[1]);

    // TODO: Optional envp with execvpe.
    execvp(args[0], args);
    perror("execvp");
    exit(1);
  }
  close(stdout_fd[1]);
  close(stderr_fd[1]);

  char* out = dump_output(stdout_fd[0]);
  close(stdout_fd[0]);
  char* err = dump_output(stderr_fd[0]);
  close(stderr_fd[0]);

  int status;
  if (waitpid(pid, &status, 0) == -1) {
    perror("waitpid");
    exit(1);
  }

  int32_t exitcode = 0;
  if (WIFEXITED(status)) {
    exitcode = WEXITSTATUS(status);
  }

  for (int i = 0; i < num_args; ++i) {
    free(args[i]);
  }
  free(args);

  return sk_completed_process_create(args_obj, exitcode, out, err);
}

#endif // SKIP64
