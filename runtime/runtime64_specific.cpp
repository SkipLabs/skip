#include <stdio.h>
#include <stdlib.h>
#include <cstdint>
#include <exception>
#include <string>
#include <string.h>
#include <iostream>
#include <algorithm>
#include <vector>
#include <map>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <linux/limits.h>
#include <pthread.h>

namespace skip {
struct SkipException : std::exception {
  explicit SkipException(void* exc) : m_skipException(exc) {}

  void* m_skipException;
};
}

extern "C" {

void SKIP_call0(void*);
void SKIP_initializeSkip();
void skip_main();
uint32_t SKIP_String_byteSize(char*);
char* sk_string_create(const char* buffer, uint32_t size);
void SKIP_throw_EndOfFile();

void SKIP_print_char(uint32_t x) {
  printf("%c", x);
}

void SKIP_throw(void* exc) {
  throw skip::SkipException(exc);
}

thread_local std::string lineBuffer;

int32_t SKIP_read_line_fill(void) {
  std::getline(std::cin, lineBuffer);
  if (std::cin.fail()) {
      return -1;
  }
  return lineBuffer.size();
}

uint32_t SKIP_read_line_get(uint32_t i) {
  return lineBuffer[i];
}

uint32_t SKIP_getchar(uint64_t) {
  int c1 = (uint32_t)getc(stdin);

  if(c1 == EOF) {
    SKIP_throw_EndOfFile();
  }

  if ((c1 & 0x80) == 0) {
    return c1;
  }

  int c2 = (uint32_t)getc(stdin);

  if(c2 == EOF) {
    fprintf(stderr, "Invalid utf8");
    exit(23);
  }

  if ((c1 & 0x20) == 0) {
    return (c1 - 192) * 64 + (c2 - 128);
  }

  int c3 = (uint32_t)getc(stdin);

  if(c3 == EOF) {
    fprintf(stderr, "Invalid utf8");
    exit(23);
  }

  if((c1 & 0x10) == 0) {
    return (c1 - 224) * 4096 +
      (c2 - 128) * 64 +
      (c3 - 128);
  }

  int c4 = (uint32_t)getc(stdin);

  if(c4 == EOF) {
    fprintf(stderr, "Invalid utf8");
    exit(23);
  }

  if((c1 & 0x8) == 0) {
    return (c1 - 240) * 262144 +
      (c2 - 128) * 4096 +
      (c3 - 128) * 64 +
      (c4 - 128);
  }

  fprintf(stderr, "Invalid utf8");
  exit(23);
  return 0;
}

uint32_t SKIP_isatty() {
  return (uint32_t)isatty(fileno(stdin));
}

thread_local void* exn;

void* SKIP_getExn() {
  return exn;
}

void SKIP_saveExn(void* e) {
  exn = e;
}

static int argc = 0;
static char** argv = NULL;

uint32_t SKIP_getArgc() {
  return argc-1;
}

char* SKIP_getArgN(uint32_t n) {
  n = n + 1;
  return sk_string_create(argv[n], strlen(argv[n]));
}

void SKIP_memory_init(int pargc, char** pargv);
void sk_persist_consts();
extern void* program_break;

void __attribute__ ((constructor)) premain()
{
  program_break = sbrk(0);
}

int main(int pargc, char** pargv) {
  argc = pargc;
  argv = pargv;
  SKIP_memory_init(pargc, pargv);
  SKIP_initializeSkip();
  sk_persist_consts();
  skip_main();
}

static void print(FILE* descr, char* str) {
  size_t size = SKIP_String_byteSize((char*)str);
  fwrite(str, size, 1, descr);
}

void SKIP_print_raw(char* str) {
  print(stdout, str);
}

void SKIP_print_error_raw(char* str) {
  print(stderr, str);
}

void SKIP_flush_stdout() {
  fflush(stdout);
  fflush(stderr);
}

void print_string(char* str) {
  print(stdout, str);
  printf("\n");
}

void SKIP_print_error(char* str) {
  print(stderr, str);
  fprintf(stderr, "\n");
}

char* sk_string_alloc(size_t);
void sk_string_set_hash(char*);

char* SKIP_open_file(char* filename_obj) {
 struct stat s;
 size_t filename_size = SKIP_String_byteSize(filename_obj);
 char* filename = (char*)malloc(filename_size+1);
 memcpy(filename, filename_obj, filename_size);
 filename[filename_size] = (char)0;

 int fd = open(filename, O_RDONLY);
 int status = fstat(fd, &s);
 size_t size = s.st_size;

 char* f = (char*)mmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
 if(f == (void*)MAP_FAILED) {
   perror("ERROR (MMap FAILED)");
   fprintf(stderr, "Could not open file: %s\n", filename);
   exit(45);
 }
 char* result = sk_string_alloc(size);
 memcpy(result, f, size);
 sk_string_set_hash(result);
 free(filename);
 munmap(f, size);
 close(fd);
 return result;
}

std::map<std::string, int> files;

int64_t SKIP_unix_open(char* filename_obj) {
 size_t filename_size = SKIP_String_byteSize(filename_obj);
 char* filename = (char*)malloc(filename_size+1);
 memcpy(filename, filename_obj, filename_size);
 filename[filename_size] = (char)0;
 std::string s(filename);

 if(files.count(s) != 0) {
   return files[s];
 }

 int fd = open(filename, O_WRONLY | O_CREAT | O_APPEND, 0777);
 files[s] = fd;

 if(fd == -1) {
   perror("ERROR file open failed");
   fprintf(stderr, "Could not open file: %s\n", filename);
   exit(45);
 }

 return (int64_t)fd;
}

int64_t SKIP_unix_close(int64_t fd) {
//  int status = close((int)fd);
//  return (int64_t)status;
  return 0;
}

void SKIP_write_to_file(int64_t fd, char* str) {
 size_t size = SKIP_String_byteSize(str);
 while(size > 0) {
   size_t written = write(fd, str, size);
   size -= written;
 }
}

void SKIP_check_if_file_exists(char* filename_obj) {
}

int64_t SKIP_notify(char* filename_obj, uint64_t tick) {
  size_t filename_size = SKIP_String_byteSize(filename_obj);
  char* filename = (char*)malloc(filename_size+1);
  memcpy(filename, filename_obj, filename_size);
  filename[filename_size] = (char)0;

  int fd = open(filename, O_CREAT | O_WRONLY, 0644);

  if(fd == -1) {
    free(filename);
    return -1;
  }

  char buf_data[256];
  char* buf = buf_data;
  sprintf(buf, "%ld\n", tick);
  size_t size = strlen(buf);

  while(size > 0) {
    size_t written = write(fd, buf, size);
    if(written == -1) {
      free(filename);
      return -1;
    }
    buf += written;
    size -= written;
  }

  if(close(fd) == -1) {
    free(filename);
    return -1;
  }

  free(filename);
  return 0;
}

int64_t SKIP_time() {
  return (int64_t)time(NULL);
}

void SKIP_localtime(int64_t timep, char* resultp) {
  localtime_r(&timep, (struct tm*)resultp);
}

void SKIP_gmtime(int64_t timep, char* resultp) {
  gmtime_r(&timep, (struct tm*)resultp);
}

int64_t SKIP_mktime_local(char* timedate) {
  return (int64_t)mktime((struct tm*)timedate);
}

int64_t SKIP_mktime_utc(char* timedate) {
  return (int64_t)mktime((struct tm*)timedate) - timezone;
}

char* SKIP_unix_strftime(char* formatp, char* timep) {
  struct tm* tm = (struct tm*)timep;
  char buffer[1024];
  char cformat[1024];
  uint32_t byteSize = SKIP_String_byteSize(formatp);
  if(byteSize >= 1024) {
    fprintf(stderr, "format string too large");
    exit(23);
  }
  cformat[byteSize] = 0;
  memcpy(cformat, formatp, byteSize);
  size_t size = strftime(buffer, 1024, cformat, tm);
  return sk_string_create(buffer, size);
}

char* SKIP_getcwd() {
  char path[PATH_MAX];
  getcwd(path, PATH_MAX);
  return sk_string_create(path, strlen(path));
}

int64_t SKIP_numThreads() {
  return 1;
}

void SKIP_string_to_file(char* str, char* file) {
  FILE *out = fopen(file, "w");
  size_t size = SKIP_String_byteSize(str);
  while(size != 0) {
    size_t written = fwrite(str, 1, size, out);
    size -= written;
  }
  fclose(out);
}

int64_t SKIP_get_mtime(char *path) {
    struct stat st;
    if(stat(path, &st) < 0) {
      return 0;
    }
    return st.st_mtime;
}

void SKIP_exit(uint64_t code) {
  exit(code);
}

int32_t SKIP_stdin_has_data() {
  fd_set rfds;
  struct timeval tv;
  int retval;

  /* Watch stdin (fd 0) to see when it has input. */
  FD_ZERO(&rfds);
  FD_SET(0, &rfds);
  tv.tv_sec = 0;
  tv.tv_usec = 0;

  retval = select(1, &rfds, NULL, NULL, &tv);
  /* Don't rely on the value of tv now! */

  if (retval) {
    return 1;
  }
  else {
    return 0;
  }
}

void* wait_for_EOF(void*) {
  char buf[256];
  while(read(0, buf, 256) > 0);
  exit(0);
  return NULL;
}

void SKIP_unix_die_on_EOF() {
  pthread_t thread_id;
  pthread_create(&thread_id, NULL, &wait_for_EOF, NULL);
}

char* SKIP_call_external_fun(int32_t, char*) {
  fprintf(stderr, "SKIP_call_external_fun not implemented in native mode");
  exit(2);
}

}
