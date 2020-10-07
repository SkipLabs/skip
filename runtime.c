typedef long long uint64_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;

#define SBRK_NUM_PAGES 1
#define NULL ((void*)0)

typedef uint64_t SkipInt;
SkipInt SKIP_getArraySize(char*);
SkipInt SKIP_computeEmbeddedStringHash(const char*, SkipInt);
char* SKIP_getEmptyString();
void SKIP_print_char(uint32_t);
uint32_t SKIP_read_line_fill();
uint32_t SKIP_read_line_get(uint32_t);

void *mymemcpy(char* dest, const char* src, size_t size) {
  char* end = dest + size;
  void* result = dest;
  while(dest < end) {
    *dest = *src;
    dest++;
    src++;
  }
  return result;
}

void print_int(uint64_t x) {
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

extern unsigned char __heap_base;

unsigned char* bump_pointer = &__heap_base;

void* malloc(size_t size) {
  unsigned char* r = bump_pointer;
  bump_pointer += size;
  return (void*)r;
}

void* exn = NULL;

void __cxa_throw(void*, void*, void*);

void SKIP_throw(char* exc) {
  exn = exc;
  __cxa_throw(0, 0, 0);
}

void* SKIP_getExn() {
  return exn;
}

void todo() {
  SKIP_throw((char*)NULL);
}

SkipInt SKIP_String_byteSize(char* str) {
  return (SkipInt)*((uint32_t*)str-2);
}

void throw_Invalid_utf8() {
  todo();
}

void SKIP_print_raw(unsigned char* str) {
  SkipInt size = SKIP_String_byteSize((char*)str);
  SkipInt i = 0;
  while(i < size) {
    if (str[i] < 0x80) {
      SKIP_print_char((uint32_t)str[i]);
    } else {
      throw_Invalid_utf8();
    };
    i++;
  }
}

void print_string(char* str) {
  SKIP_print_raw((unsigned char*)str);
  SKIP_print_char((uint32_t)10);
}


void SKIP_print_error(char* str) {
  SKIP_print_raw((unsigned char*)str);
  SKIP_print_char((uint32_t)10);
}

char* SKIP_Obstack_alloc(size_t size) {
  return (char*)malloc(size);
}
void SKIP_Obstack_auto_collect() {
  todo();
}
void* SKIP_Obstack_calloc(size_t size) {
  unsigned char* result = (unsigned char*)SKIP_Obstack_alloc(size);
  SkipInt i;
  for(i = 0; i < size; i++) {
    result[i] = 0;
  }
  return result;
}

void computeHash(char* str) {
  uint32_t* hash = ((uint32_t*)str)-1;
  uint32_t size = ((uint32_t*)str)[-2];
  SkipInt acc = 0;
  SkipInt i;
  for(i=0; i<size; i++) {
    acc = acc * 31 + str[i];
  }
  *hash = (uint32_t)acc;
}

char* alloc_String(uint32_t size) {
  uint32_t* iresult = (uint32_t*)SKIP_Obstack_alloc(size + 2 * sizeof(uint32_t));
  *iresult = (uint32_t)size;
  iresult++;
  iresult++;
  return (char*)iresult;
}

char* create_String(const char* buffer, uint32_t size) {
  char* result = alloc_String(size);
  mymemcpy(result, buffer, size);
  computeHash(result);
  return result;
}

void SKIP_Regex_initialize() {
  todo();
}

uint32_t SKIP_String_getByte(unsigned char* str, SkipInt idx) {
  return (uint32_t)str[idx];
}


char* SKIP_String_StringIterator__substring(char* argStart, char* argEnd) {
  SkipInt start = ((SkipInt*)argStart)[1];
  SkipInt end = ((SkipInt*)argEnd)[1];
  SkipInt size = end-start;
  char* buffer = *((char**)argStart)+start;
  char* result = create_String(buffer, size);
  return result;
}

char* SKIP_String__fromChars(const char* dumb, char* _src) {
  uint32_t* src = (uint32_t*)_src;
  SkipInt size = SKIP_getArraySize(_src);
  SkipInt i;
  SkipInt resultSize = 0;
  for(i=0; i< size; i++) {
    uint32_t code = src[i];
    if (code < 0) {
      throw_Invalid_utf8();
    } else if (code < 0x80) {
      resultSize++;
    } else if (code < 0x800) {
      resultSize+=2;
    } else if (code < 0x10000) {
      resultSize+=3;
    } else if (code < 0x110000) {
      resultSize +=4;
    } else {
      throw_Invalid_utf8();
    }
  };
  uint32_t* iresult = (uint32_t*)SKIP_Obstack_alloc(size + 2 * sizeof(int));
  *iresult = (uint32_t)size;
  iresult++;
  iresult++;
  char* result = (char*)iresult;
  int j = 0;
  for(i=0; i < size; i++) {
    uint32_t code = src[i];
    if (code < 0) {
      throw_Invalid_utf8();
    } else if (code < 0x80) {
      result[j] = (char)code;
      j++;
    } else if (code < 0x800) {
      result[j] = (char)(192 + code / 64);
      j++;
      result[j] = (char)( 128 + code % 64);
      j++;
    } else if (code < 0x10000) {
      result[j] = (char)(224 + code / 4096);
      j++;
      result[j] = (char)(128 + code / 64 % 64);
      j++;
      result[j] = (char)(128 + code % 64);
      j++;
    } else if (code < 0x110000) {
      result[j] = (char)(240 + code / 262144);
      j++;
      result[j] = (char)(128 + code / 4096 % 64);
      j++;
      result[j] = (char)(128 + code / 64 % 64);
      j++;
      result[j] = (char)(128 + code % 64);
    } else {
      throw_Invalid_utf8();
    }
  };
  computeHash(result);
  return result;
}

char* SKIP_String_concat2(char* str1, char* str2) {
  SkipInt size1 = SKIP_String_byteSize(str1);
  SkipInt size2 = SKIP_String_byteSize(str2);
  char* result = alloc_String(size1 + size2);
  mymemcpy(result, (const char*)str1, size1);
  mymemcpy(result+size1, (const char*)str2, size2);
  computeHash(result);
  return result;
}

int strcmp(const char* str1, const char* str2) {
  while(1) {
    if(*str1 == 0 && *str2 == 0) {
      return 0;
    }
    if(*str1 == 0) {
      return -1;
    }
    if(*str2 == 0) {
      return 1;
    }
    int c = (int)*str1 - (int)*str2;
    if(c != 0) return c;
    str1++;
    str2++;
  }
}

SkipInt SKIP_String_cmp(unsigned char* str1, unsigned char* str2) {
  SkipInt size1 = SKIP_String_byteSize((char*)str1);
  SkipInt size2 = SKIP_String_byteSize((char*)str2);
  SkipInt c = size1 - size2;
  unsigned char* end1 = str1 + size1;
  unsigned char* end2 = str2 + size2;
  while(1) {
    if(str1 == end1 && str2 == end2) {
      return 0;
    }
    if(str1 == end1) {
      return -1;
    }
    if(str2 == end2) {
      return 1;
    }
    SkipInt c1 = *str1;
    SkipInt c2 = *str2;
    SkipInt diff = c1 - c2;
    if(diff != 0) return c;
    str1++;
    str2++;
  }
}

char* SKIP_intern(char* obj) {
  // TODO
  return obj;
}

void SKIP_internalExit() {
  todo();
}

void SKIP_print_last_exception_stack_trace_and_exit() {
  todo();
}
void SKIP_unreachableMethodCall() {
  todo();
}
void SKIP_unreachableWithExplanation() {
  todo();
}

void SKIP_Obstack_vectorUnsafeSet(char** arr, char* x) {
  *arr = x;
}

void SKIP_Obstack_collect(char* dumb1, char** dumb2, SkipInt dumb3) {
}

void* SKIP_llvm_memcpy(char* dest, char* val, SkipInt len) {
  return mymemcpy(dest, val, (size_t)len);
}

char* SKIP_Obstack_shallowClone(size_t size, char* obj) {
  char* mem = SKIP_Obstack_alloc(size);
  mymemcpy(mem, obj, size);
  return mem;
}

extern void skip_main(void);

char* SKIP_read_line() {
  uint32_t size = SKIP_read_line_fill();
  uint32_t i;
  char* result = SKIP_Obstack_alloc(size);

  for(i = 0; i < size; i++) {
    result[i] = SKIP_read_line_get(i);
  }

  result = create_String(result, size);
  SKIP_print_raw((unsigned char*)result);
  SKIP_print_char('\n');
  return result;
}
