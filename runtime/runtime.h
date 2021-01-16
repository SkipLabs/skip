/*****************************************************************************/
/* We are really trying to keep it to a bare minimum when it comes to C/C++
 * dependencies. We need the runtime to compile to webassembly, and each
 * additional dependency makes it more challenging.
 */
/*****************************************************************************/

#ifndef SKIP_RUNTIME
#define SKIP_RUNTIME 1

#define NULL ((void*)0)
#define PAGE_SIZE (1024 * 1024)

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef long long uint64_t;
typedef unsigned int uint32_t;
typedef unsigned long size_t;
typedef uint64_t SkipInt;

#ifdef SKIP32
typedef unsigned int uintptr_t;
typedef int intptr_t;
#define WORDSIZE 4
#endif

#ifdef SKIP64
#include <stdio.h>
#define WORDSIZE 8
typedef unsigned long uintptr_t;
typedef long intptr_t;
#endif

/*****************************************************************************/
/* Types used for the Obstack pages info. */
/*****************************************************************************/

typedef struct {
  void* head;
  size_t size;
} page_t;

typedef struct {
  page_t* pages;
  long pages_size;
} sk_pinfo_t;

/*****************************************************************************/
/* Types used for the hashtable. */
/*****************************************************************************/

typedef struct {
  void* key;
  void* value;
} sk_cell_t;

typedef struct {
  size_t size;
  size_t rsize;
  size_t bitcapacity;
  sk_cell_t* data;
} sk_htbl_t;


void sk_htbl_init(sk_htbl_t* table, size_t bitcapacity);
void sk_htbl_free(sk_htbl_t* table);
void sk_htbl_add(sk_htbl_t* table, void* key, void* value);
sk_cell_t* sk_htbl_find(sk_htbl_t* table, void* key);
int sk_htbl_mem(sk_htbl_t* table, void* key);
void sk_htbl_remove(sk_htbl_t* table, void* key);
SkipInt SKIP_String_cmp(unsigned char* str1, unsigned char* str2);
size_t nbr_pages();
sk_cell_t* get_pages(size_t size);
int is_in_obstack(void* ptr, sk_cell_t* pages, size_t size);

/*****************************************************************************/
/* Stack types. */
/*****************************************************************************/

typedef struct {
  void** value;
  void** slot;
} value_t;

typedef struct {
  size_t head;
  size_t capacity;
  value_t* values;
} stack_t;

void SKIP_stack_init(stack_t* st, size_t capacity);
void SKIP_stack_free(stack_t* st);
void SKIP_stack_push(stack_t* st, void** value, void** slot);
value_t SKIP_stack_pop(stack_t* st);

/*****************************************************************************/
/* The type information exposed by the Skip compiler for each object. */
/*****************************************************************************/

typedef struct {
  uint8_t m_refsHintMask;
  uint8_t m_kind;
  uint8_t m_tilesPerMask;
  uint8_t m_hasName;
  uint16_t m_uninternedMetadataByteSize;
  uint16_t m_internedMetadataByteSize;
  size_t m_userByteSize;
  #ifdef SKIP32
  void* unused1;
  void* unused2;
  #endif
  void (*m_onStateChange)(void*, long);
  size_t m_refMask[0];
} SkipGcType;

/*****************************************************************************/
/* SKIP String representation. */
/*****************************************************************************/

typedef struct {
  uint32_t size;
  uint32_t hash;
  unsigned char data[0];
} sk_string_t;

/*****************************************************************************/
/* Function signatures. */
/*****************************************************************************/

void* malloc(size_t);
void SKIP_throw(void*);
SkipInt SKIP_getArraySize(char*);
void SKIP_print_char(uint32_t);
uint32_t SKIP_read_line_fill();
uint32_t SKIP_read_line_get(uint32_t);
char* SKIP_get_free_slot(uint32_t);
void SKIP_add_free_slot(char*, uint32_t);
char* SKIP_Obstack_alloc(size_t size);
void free(void*);
void free_size(void*, size_t);
void* memcpy(void* dest, const void* src, size_t size);
void throw_Invalid_utf8();
uint32_t SKIP_String_byteSize(char* str);
void todo();
char* sk_string_create(const char* buffer, uint32_t size);
void SKIP_invalid_utf8();
char* SKIP_intern(char* obj);
sk_cell_t* find_itable(char* mem);
void free_intern(char* obj, size_t memsize, size_t leftsize);
void SKIP_internalExit();
uint32_t SKIP_is_string(char* obj);
void SKIP_free(stack_t* st, char* obj);
int memcmp(const void * ptr1, const void * ptr2, size_t num);

#endif
