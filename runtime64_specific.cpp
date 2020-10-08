#include <stdio.h>
#include <stdlib.h>
#include <cstdint>
#include <exception>
#include <string>
#include <iostream>
#include <vector>

#define PAGE_SIZE (1024 * 1024)

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
    fprintf(stderr, "Error: read_line fail");
    exit(23);
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

thread_local std::vector<char*>* pages = new std::vector<char*>();
thread_local char* head = NULL;
thread_local char* end = NULL;

char* SKIP_Obstack_alloc(size_t size) {
  if(head + size > end) {
    size_t block_size = std::max(size, (size_t)PAGE_SIZE);
    head = (char*)malloc(block_size);
    end = head + block_size;
    pages->push_back(head);
  }
  char* result = head;
  head += size;
  return result;
}

void SKIP_Obstack_free() {
  while(!pages->empty()) {
    free(pages->back());
    pages->pop_back();
  }
}

int main() {
  SKIP_initializeSkip();
  skip_main();
}

}
