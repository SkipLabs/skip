/* Low-overhead companion to incremental_profile.py. Linux/POSIX, no libraries.
 * cc -O2 -Wall -Wextra -Werror incremental_profile_wrap.c -o profile-wrap
 * profile-wrap --kind clang --real /usr/bin/clang++ -- ARGS ...
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/file.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

static void die(const char *message) {
  perror(message);
  exit(125);
}

static int64_t now_ns(void) {
  struct timespec value;
  if (clock_gettime(CLOCK_MONOTONIC, &value)) die("clock_gettime");
  return (int64_t)value.tv_sec * 1000000000 + value.tv_nsec;
}

static void json_string(FILE *out, const char *value) {
  if (!value) {
    fputs("null", out);
    return;
  }
  fputc('"', out);
  for (const unsigned char *p = (const unsigned char *)value; *p; ++p) {
    if (*p == '"' || *p == '\\') fprintf(out, "\\%c", *p);
    else if (*p < 32) fprintf(out, "\\u%04x", *p);
    else fputc(*p, out);
  }
  fputc('"', out);
}

static int is_source(const char *arg) {
  const char *ext = strrchr(arg, '.');
  return ext && (!strcmp(ext, ".ll") || !strcmp(ext, ".bc") ||
    !strcmp(ext, ".c") || !strcmp(ext, ".cc") || !strcmp(ext, ".cpp") ||
    !strcmp(ext, ".cxx") || !strcmp(ext, ".s") || !strcmp(ext, ".S"));
}

static void replay(const char *path, FILE *output) {
  if (!path) return;
  FILE *input = fopen(path, "rb");
  if (!input) die("capture read");
  char buffer[65536];
  size_t length;
  while ((length = fread(buffer, 1, sizeof(buffer), input))) {
    if (fwrite(buffer, 1, length, output) != length) die("capture replay");
  }
  if (ferror(input)) die("capture read");
  fclose(input);
}

int main(int argc, char **argv) {
  if (argc < 6 || strcmp(argv[1], "--kind") || strcmp(argv[3], "--real") ||
      strcmp(argv[5], "--")) {
    fputs("usage: profile-wrap --kind KIND --real EXECUTABLE -- ARGS ...\n", stderr);
    return 125;
  }
  const char *kind = argv[2], *directory = getenv("SKC_PROFILE_DIR");
  int linking = 0;
  if (!strcmp(kind, "clang")) {
    int version = 0, compile = 0, source = 0;
    for (int i = 6; i < argc; ++i) {
      if (!strcmp(argv[i], "--version")) version = 1;
      if (!strcmp(argv[i], "-c")) compile = 1;
      if (!strcmp(argv[i], "-o") && i + 1 < argc) { ++i; continue; }
      if (argv[i][0] != '-' && is_source(argv[i])) source = 1;
    }
    kind = version ? "clang_version" : compile ? "clang_compile" :
      source ? "clang_compile_link" : "native_link";
    linking = !version && !compile;
  }
  char **command = calloc((size_t)argc + 2, sizeof(char *));
  if (!command) die("calloc");
  int count = 0;
  command[count++] = argv[4];
  // Toolchain selection must survive disabling recording for overhead controls.
  // The direct-exec path below skips observation, not the requested linker.
  const char *linker = linking ? getenv("SKC_PROFILE_LINKER") : NULL;
  if (linker) {
    for (int i = 6; i < argc; ++i) {
      if (!strncmp(argv[i], "-fuse-ld", 8) || !strncmp(argv[i], "--ld-path", 9)) {
        fputs("Explicit linker selection conflicts with profiling wrapper\n", stderr);
        return 125;
      }
    }
    if (asprintf(&command[count++], "--ld-path=%s", linker) < 0) die("asprintf");
  }
  for (int i = 6; i < argc; ++i) command[count++] = argv[i];
  if (!directory) {
    execv(command[0], command);
    die("execv");
  }
  char *stderr_path = NULL, *stdout_path = NULL;
  int error_fd = -1, output_fd = -1;
  if (!strcmp(kind, "skc")) {
    if (asprintf(&stderr_path, "%s/skc-%d.stderr", directory, getpid()) < 0) die("asprintf");
    error_fd = open(stderr_path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (error_fd < 0) die("stderr log");
    if (asprintf(&stdout_path, "%s/skc-%d.stdout", directory, getpid()) < 0) die("asprintf");
    output_fd = open(stdout_path, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (output_fd < 0) die("stdout log");
  }
  int64_t start = now_ns();
  pid_t child = fork();
  if (child < 0) die("fork");
  if (!child) {
    if (error_fd >= 0) {
      if (dup2(error_fd, STDERR_FILENO) < 0) die("dup2");
      close(error_fd);
    }
    if (output_fd >= 0) {
      if (dup2(output_fd, STDOUT_FILENO) < 0) die("dup2");
      close(output_fd);
    }
    execv(command[0], command);
    die("execv");
  }
  if (error_fd >= 0) close(error_fd);
  if (output_fd >= 0) close(output_fd);
  int status;
  struct rusage usage;
  while (wait4(child, &status, 0, &usage) < 0) {
    if (errno != EINTR) die("wait4");
  }
  int64_t end = now_ns();
  int result = WIFEXITED(status) ? WEXITSTATUS(status) : -WTERMSIG(status);
  char *path = NULL, *cwd = getcwd(NULL, 0);
  if (!cwd || asprintf(&path, "%s/processes.jsonl", directory) < 0) die("event path");
  int fd = open(path, O_WRONLY | O_CREAT | O_APPEND, 0644);
  if (fd < 0 || flock(fd, LOCK_EX)) die("event lock");
  FILE *out = fdopen(fd, "a");
  if (!out) die("fdopen");
  fputs("{\"kind\":", out); json_string(out, kind);
  fprintf(out, ",\"wrapper_pid\":%d,\"pid\":%d,\"parent_pid\":%d,\"command\":[",
    getpid(), child, getppid());
  for (int i = 0; i < count; ++i) {
    if (i) fputc(',', out);
    json_string(out, command[i]);
  }
  fputs("],\"cwd\":", out); json_string(out, cwd);
  fprintf(out, ",\"start_ns\":%" PRId64 ",\"end_ns\":%" PRId64
    ",\"seconds\":%.9f,\"returncode\":%d,\"user_s\":%.6f,\"system_s\":%.6f,"
    "\"maxrss_bytes\":%ld,\"stderr\":", start, end, (end-start)/1e9, result,
    usage.ru_utime.tv_sec + usage.ru_utime.tv_usec/1e6,
    usage.ru_stime.tv_sec + usage.ru_stime.tv_usec/1e6, usage.ru_maxrss*1024);
  json_string(out, stderr_path);
  fputs(",\"stdout\":", out); json_string(out, stdout_path);
  fputs("}\n", out);
  if (fflush(out) || ferror(out)) die("event write");
  if (flock(fd, LOCK_UN) || fclose(out)) die("event close");
  replay(stderr_path, stderr);
  // Preserve the complete link plan while retaining diagnostics that Skargo
  // consumes without echoing. This wrapper is for batch compiler invocations.
  replay(stdout_path, stdout);
  free(path); free(cwd); free(stderr_path); free(stdout_path);
  if (linker) free(command[1]);
  free(command);
  return result < 0 ? 128-result : result;
}
