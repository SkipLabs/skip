#include "runtime.h"

#ifdef SKIP64
#include <stdlib.h>
#include <string.h>
#endif

/*****************************************************************************/
/* String implementation */
/*****************************************************************************/

void sk_string_set_hash(char* obj) {
  sk_string_t* str = (sk_string_t*)(obj-sizeof(uint32_t)*2);
  SkipInt acc = 0;
  uint32_t i;

  for(i = 0; i < str->size; i++) {
    acc = acc * 31 + str->data[i];
  }

  // This tag is used by the interning to recognize strings.
  acc |= 0x80000000;
  str->hash = (uint32_t)acc;
}


uint32_t SKIP_String_byteSize(char* obj) {
  sk_string_t* str = (sk_string_t*)(obj-sizeof(uint32_t)*2);
  return str->size;
}

// Allocates a string (with no data nor hash).
char* sk_string_alloc(uint32_t size) {
  uint32_t* iresult = (uint32_t*)SKIP_Obstack_alloc(size + 2 * sizeof(uint32_t));
  *iresult = (uint32_t)size;
  iresult++;
  iresult++;
  return (char*)iresult;
}

char* sk_string_create(const char* buffer, uint32_t size) {
  char* result = sk_string_alloc(size);
  memcpy(result, buffer, size);
  sk_string_set_hash(result);
  return result;
}

char* SKIP_getBuildVersion() {
  return sk_string_create("1", 1);
}

char* SKIP_String__fromUtf8(char* class, char* array) {
  SkipInt size = SKIP_getArraySize(array);
  return sk_string_create(array, size);
}

uint32_t SKIP_String_getByte(unsigned char* bytes, SkipInt idx) {
  return (uint32_t)bytes[idx];
}

char* SKIP_String_StringIterator__substring(char* argStart, char* argEnd) {
  SkipInt start = ((SkipInt*)argStart)[1];
  SkipInt end = ((SkipInt*)argEnd)[1];
  SkipInt size = end-start;
  char* buffer = *((char**)argStart)+start;
  char* result = sk_string_create(buffer, size);
  return result;
}

unsigned char* SKIP_String__fromChars(const unsigned char* dumb, unsigned char* src_) {
  uint32_t* src = (uint32_t*)src_;
  SkipInt size = SKIP_getArraySize((char*)src_);
  SkipInt i;
  size_t result_size = 0;
  for(i = 0; i < size; i++) {
    uint32_t code = src[i];
    if (code < 0) {
      SKIP_invalid_utf8();
    } else if (code < 0x80) {
      result_size++;
    } else if (code < 0x800) {
      result_size+=2;
    } else if (code < 0x10000) {
      result_size+=3;
    } else if (code < 0x110000) {
      result_size+=4;
    } else {
      SKIP_invalid_utf8();
    }
  };
  uint32_t* iresult = (uint32_t*)SKIP_Obstack_alloc(result_size + 2 * sizeof(uint32_t));
  uint32_t* bsize = iresult;
  iresult++;
  iresult++;
  unsigned char* result = (unsigned char*)iresult;
  int j = 0;
  for(i = 0; i < size; i++) {
    uint32_t code = src[i];
    if (code < 0) {
      SKIP_invalid_utf8();
    } else if (code < 0x80) {
      result[j] = (unsigned char)code;
      j++;
    } else if (code < 0x800) {
      result[j] = (unsigned char)(192 + code / 64);
      j++;
      result[j] = (unsigned char)(128 + code % 64);
      j++;
    } else if (code < 0x10000) {
      result[j] = (unsigned char)(224 + code / 4096);
      j++;
      result[j] = (unsigned char)(128 + code / 64 % 64);
      j++;
      result[j] = (unsigned char)(128 + code % 64);
      j++;
    } else if (code < 0x110000) {
      result[j] = (unsigned char)(240 + code / 262144);
      j++;
      result[j] = (unsigned char)(128 + code / 4096 % 64);
      j++;
      result[j] = (unsigned char)(128 + code / 64 % 64);
      j++;
      result[j] = (unsigned char)(128 + code % 64);
      j++;
    } else {
      SKIP_invalid_utf8();
    }
  };
  *bsize = (uint32_t)j;
  sk_string_set_hash((char*)result);
  return result;
}

char* SKIP_String_concat2(char* str1, char* str2) {
  SkipInt size1 = SKIP_String_byteSize(str1);
  SkipInt size2 = SKIP_String_byteSize(str2);
  char* result = sk_string_alloc(size1 + size2);
  memcpy(result, (const char*)str1, size1);
  memcpy(result+size1, (const char*)str2, size2);
  sk_string_set_hash(result);
  return result;
}

char* SKIP_String_concatN(char** arr) {
  uint32_t arr_size = SKIP_getArraySize((char*)arr);
  SkipInt byte_size = 0;
  int i;

  for(i = 0; i < arr_size; i++) {
    byte_size += SKIP_String_byteSize(arr[i]);
  }

  char* result = sk_string_alloc(byte_size);
  char* buffer = result;

  for(i = 0; i < arr_size; i++) {
    SkipInt str_size = SKIP_String_byteSize(arr[i]);
    memcpy(buffer, (const char*)arr[i], str_size);
    buffer += str_size;
  }

  sk_string_set_hash(result);
  return result;
}

SkipInt SKIP_String_cmp(unsigned char* str1, unsigned char* str2) {
  SkipInt size1 = SKIP_String_byteSize((char*)str1);
  SkipInt size2 = SKIP_String_byteSize((char*)str2);
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
    unsigned char c1 = *str1;
    unsigned char c2 = *str2;
    SkipInt diff = c1 - c2;
    if(diff != 0) return diff;
    str1++;
    str2++;
  }
}

/*****************************************************************************/
/* Unsafe char access */
/*****************************************************************************/

uint32_t SKIP_String_unsafe_get(unsigned char* str, SkipInt n) {
  return (uint32_t)str[n];
}

void SKIP_String_unsafe_set(unsigned char* str, SkipInt n, SkipInt v) {
  unsigned char c = (unsigned char)v;
  str[n] = v;
}

void SKIP_String_unsafe_write_int(unsigned char* str, SkipInt n, SkipInt v) {
  memcpy(&str[n], &v, sizeof(SkipInt));
}

void SKIP_String_unsafe_write_string(unsigned char* str, SkipInt n, char* v) {
  memcpy(&str[n], v, SKIP_String_byteSize(v));
}

SkipInt SKIP_String_unsafe_read_int(unsigned char* str, SkipInt n) {
  SkipInt v;
  memcpy(&v, &str[n], sizeof(SkipInt));
  return v;
}

char* SKIP_String_unsafe_read_string(unsigned char* str, SkipInt n, SkipInt size) {
  char* v = sk_string_alloc((uint32_t)size);
  memcpy(v, &str[n], size);
  sk_string_set_hash(v);
  return v;
}

SkipInt SKIP_String_unsafe_size(unsigned char* str) {
  return SKIP_String_byteSize((char*)str);
}

void* SKIP_String_unsafe_slice(unsigned char* str, SkipInt n1, SkipInt n2) {
  size_t size = n2 - n1;
  char* result = sk_string_alloc(size);
  memcpy(result, str + n1, size);
  sk_string_set_hash(result);
  return result;
}

void* SKIP_String_unsafe_create(SkipInt size) {
  char* result = SKIP_Obstack_alloc(size + 2 * sizeof(uint32_t));
  *(uint32_t*)result = (uint32_t)size;
  result += sizeof(uint32_t);
  result += sizeof(uint32_t);
  sk_string_set_hash(result);
  return result;
}

char* SKIP_unsafe_int_to_string(SkipInt n) {
  return (char*)n;
}

SkipInt SKIP_unsafe_string_to_int(char* n) {
  return (SkipInt)n;
}

SkipInt SKIP_unsafe_float_to_int(double f) {
  SkipInt* x = (SkipInt*)&f;
  return *x;
}

double SKIP_unsafe_int_to_float(SkipInt f) {
  double* x = (double*)&f;
  return *x;
}

int ipow(int x, int y) {
  if(y == 0) {
    return 1;
  }
  int tmp = ipow(x, y/2);
  if(y % 2 == 0) {
    return tmp * tmp;
  }
  else {
    return tmp * tmp * x;
  }
}
extern char* SKIP_floatToString(double origf);

char* SKIP_Float_toString(double origf) {
  return SKIP_floatToString(origf);
}

SkipInt SKIP_unsafe_get_svalue(SkipInt* buffer, SkipInt n) {
  return buffer[n];
}

double SKIP_String__toFloat_raw(char* str) {
  #ifdef SKIP32
  SKIP_throw(NULL); // TODO
  return 0.0;
  #endif
  #ifdef SKIP64
  size_t size = SKIP_String_byteSize((char*)str);
  if(size >= 255) {
    SKIP_throw(NULL); // TODO
  }
  char cstr[256];
  memcpy(cstr, str, size);
  cstr[size] = 0;

  return atof(cstr);
  #endif
}

char* SKIP_float_to_string(double f) {
  #ifdef SKIP64
  char s[256];
  sprintf(s, "%.17g", f);
  int size = strlen(s);
  int i;
  int needs_trailing_dot = 1;
  for(i = 0; i < size; i++) {
    if((s[i] >= '0') && (s[i] <= '9') || (s[i] == '-')) {
      continue;
    }
    needs_trailing_dot = 0;
  }
  if(needs_trailing_dot) {
    s[size] = '.';
    s[size+1] = '0';
    size += 2;
  }
  return sk_string_create(s, size);
  #endif
  #ifdef SKIP32
  // Not implemented
  return sk_string_create("", 0);
  #endif
}

char SKIP_Unsafe_string_utf8_get(char* str, SkipInt n) {
  return str[n];
}

/*****************************************************************************/
/* Multibyte utf8 string used for testing purposes. */
/*****************************************************************************/

static unsigned int test_utf8_data[] = {126, 240, 157, 152, 136, 225, 184, 134, 240, 157, 150, 162, 240, 157, 149, 175, 217, 164, 225, 184, 158, 212, 141, 208, 157, 199, 143, 240, 157, 153, 133, 198, 152, 212, 184, 226, 178, 152, 240, 157, 153, 137, 224, 167, 166, 206, 161, 240, 157, 151, 164, 201, 140, 240, 157, 147, 162, 200, 154, 208, 166, 240, 157, 146, 177};

static unsigned char string_utf8_buffer[sizeof(test_utf8_data)/sizeof(int) + 1];

char* SKIP_utf8_test_string() {
  int i;
  for(i = 0; i < sizeof(string_utf8_buffer); i++) {
    string_utf8_buffer[i] = (unsigned char)test_utf8_data[i];
  }
  return sk_string_create((char*)string_utf8_buffer, sizeof(string_utf8_buffer));
}

char* SKIP_invalid_utf8_test_string() {
  int i;
  for(i = 0; i < 2; i++) {
    string_utf8_buffer[i] = (unsigned char)test_utf8_data[i];
  }
  return sk_string_create((char*)string_utf8_buffer, 2);
}

char* SKIP_largest_string() {
  static unsigned char buffer[] = { 255, 255, 255, 255, 255, 255, 255, 255 };
  return sk_string_create((char*)buffer, 8);
}
