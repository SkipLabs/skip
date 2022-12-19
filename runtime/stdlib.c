#include "runtime.h"

#ifdef SKIP64

#include <stdio.h>
#include <string.h>
#include <malloc.h>
#include <stdlib.h>

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
    SKIP_throw(NULL);
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
  SKIP_throw(NULL);
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
