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

pthread_mutex_t glock;
void sk_memory_check_init();
void sk_memory_check_init_over();
void sk_new_page(size_t size);
void SKIP_memory_init();
void SKIP_destroy_Obstack(char*);
void* get_pages(size_t);
size_t nbr_pages();
int is_in_obstack(void*, void*, size_t);
extern __thread char* head;
extern __thread void* break_ptr;

int main(int pargc, char** pargv) {
  pthread_mutex_init(&glock, NULL);
  break_ptr = sbrk(0);
  sk_memory_check_init();
  argc = pargc;
  argv = pargv;
  SKIP_memory_init();
  SKIP_initializeSkip();
  if(head != NULL) {
    SKIP_destroy_Obstack(NULL);
  }
  sk_memory_check_init_over();
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

void SKIP_glock() {
  pthread_mutex_lock(&glock);
}

void SKIP_gunlock() {
  pthread_mutex_unlock(&glock);
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

}
