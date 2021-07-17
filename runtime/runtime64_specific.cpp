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

uint32_t SKIP_read_line_fill(void) {
  std::getline(std::cin, lineBuffer);
  if (std::cin.fail()) {
    SKIP_throw_EndOfFile();
  }
  return lineBuffer.size();
}

uint32_t SKIP_read_line_get(uint32_t i) {
  return lineBuffer[i];
}

uint32_t SKIP_getchar(uint64_t) {
  int c = std::getchar();
  if(c == EOF) {
    SKIP_throw_EndOfFile();
  }
  return (uint32_t)c;
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
  char* buffer = (char*)malloc(size+1);
  memcpy(buffer, str, size);
  buffer[size] = 0;
  fprintf(descr, "%s", buffer);
  free(buffer);
}

void SKIP_print_raw(char* str) {
  print(stdout, str);
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

char* SKIP_read_file(char* filename_obj) {
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

int64_t SKIP_unix_open(char* filename_obj) {
 struct stat s;
 size_t filename_size = SKIP_String_byteSize(filename_obj);
 char* filename = (char*)malloc(filename_size+1);
 memcpy(filename, filename_obj, filename_size);
 filename[filename_size] = (char)0;

 int fd = open(filename, O_WRONLY | O_CREAT | O_APPEND, 0777);

 if(fd == -1) {
   perror("ERROR file open failed");
   fprintf(stderr, "Could not open file: %s\n", filename);
   exit(45);
 }

 free(filename);

 return (int64_t)fd;
}

int64_t SKIP_unix_close(int64_t fd) {
 int status = close((int)fd);
 return (int64_t)status;
}

void SKIP_write_to_file(int64_t fd, char* str) {
 size_t size = SKIP_String_byteSize(str);
 while(size > 0) {
   size_t written = write(fd, str, size);
   size -= written;
 }
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

}
