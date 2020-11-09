#include "runtime.h"

/*****************************************************************************/
/* String implementation */
/*****************************************************************************/

static void sk_string_set_hash(char* obj) {
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
static char* sk_string_alloc(uint32_t size) {
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
