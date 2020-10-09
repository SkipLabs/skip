#include <stdio.h>
#include <stdlib.h>
#include <cstdint>
#include <exception>
#include <string>
#include <iostream>
#include <algorithm>
#include <vector>
#include <map>

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

void free_size(void* ptr, size_t size) {
  free(ptr);
}

int main() {
  SKIP_initializeSkip();
  skip_main();
}

}
