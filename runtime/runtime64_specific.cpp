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
void sk_memory_init();
void sk_memory_check_init();
void sk_memory_check_init_over();
void sk_new_page(size_t size);
void SKIP_memory_init();
void* get_pages(size_t);
size_t nbr_pages();
int is_in_obstack(void*, void*, size_t);

extern __thread void* break_ptr;

extern size_t const_page_size;
extern void* const_pages;

int sk_is_const(void* obj) {
  return is_in_obstack(obj, const_pages, const_page_size);
}

int main(int pargc, char** pargv) {
  pthread_mutex_init(&glock, NULL);
  break_ptr = sbrk(0);
  sk_memory_check_init();
  argc = pargc;
  argv = pargv;
  SKIP_memory_init();
  SKIP_initializeSkip();
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

}
