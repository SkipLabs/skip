#include "runtime.h"

/*****************************************************************************/
/* Globals needed by the obstack. */
/*****************************************************************************/

// In 32bits mode there are no threads, so the obstack does not have to be
// thread local. This is because wasm doesn't support threads (at least not
// well).

#ifdef SKIP32
char* page = NULL;
char* head = NULL;
char* end = NULL;
#endif

#ifdef SKIP64
__thread char* page = NULL;
__thread char* head = NULL;
__thread char* end = NULL;
#endif

void* mymemcpy(char* dest, const char* src, size_t size) {
  void* result = dest;
  const char* end = src + size;
  const char* lend = src + (size / sizeof(long) * sizeof(long));

  while(src < lend) {
    *(long*)dest = *(long*)src;
    dest += sizeof(long);
    src += sizeof(long);
  }

  while(src < end) {
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

SkipInt SKIP_String_byteSize(char* str) {
  return (SkipInt)*((uint32_t*)str-2);
}

void todo() {
  SKIP_throw(NULL);
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
void SKIP_Obstack_auto_collect() {
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
  uint32_t size = *(((uint32_t*)str)-2);
  unsigned char* ints = (unsigned char*)str;

  SkipInt acc = 0;
  uint32_t i;

  for(i = 0; i < size; i++) {
    acc = acc * 31 + ints[i];
  }

  acc |= 0x80000000;
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
    unsigned char c1 = *str1;
    unsigned char c2 = *str2;
    int diff = c1 - c2;
    if(diff != 0) return c;
    str1++;
    str2++;
  }
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
  size = size + sizeof(void*);
  char* mem = SKIP_Obstack_alloc(size);
  mymemcpy(mem, obj-sizeof(void*), size);
  return mem+sizeof(void*);
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
  return result;
}

/*****************************************************************************/
/* Obstack allocation. */
/*****************************************************************************/

static void new_page(size_t size) {
  size_t block_size = PAGE_SIZE;
  if(size + sizeof(char*) + sizeof(size_t) > block_size) {
    block_size = size + sizeof(char*) + sizeof(size_t);
  }
  head = (char*)malloc(block_size);
  end = head + block_size;
  *(char**)head = page;
  page = head;
  head += sizeof(char*);
  *(size_t*)head = block_size;
  head += sizeof(size_t);
}

char* SKIP_Obstack_alloc(size_t size) {
  if (head + size > end) {
    new_page(size);
  }
  char* result = head;
  head += size;
  return result;
}

char* SKIP_new_Obstack() {
  char* saved = head;
  return saved;
}

void SKIP_destroy_Obstack(char* saved) {
  while(saved < page || saved >= end) {
    char* tofree = page;
    size_t tofree_size = *(size_t*)(page + sizeof(char*));
    page = *(char**)page;
    size_t size = *(size_t*)(page + sizeof(char*));
    end = page + size;
    free_size(tofree, tofree_size);
  }
  head = saved;
}

/*****************************************************************************/
/* Stack of elements to copy. */
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

void SKIP_stack_init(stack_t* st, size_t capacity) {
  st->head = 0;
  st->capacity = capacity;
  st->values = (value_t*)malloc(sizeof(value_t) * capacity);
}

void SKIP_stack_free(stack_t* st) {
  free_size(st->values, sizeof(value_t) * st->capacity);
}

void SKIP_stack_grow(stack_t* st) {
  stack_t new_st;
  new_st.head = 0;
  new_st.capacity = st->capacity * 2;
  new_st.values = (value_t*)malloc(sizeof(value_t) * new_st.capacity);
  for(; new_st.head < st->capacity; new_st.head++) {
    new_st.values[new_st.head] = st->values[new_st.head];
  }
  free_size(st->values, sizeof(value_t) * st->capacity);
  st->head = new_st.head;
  st->capacity = new_st.capacity;
  st->values = new_st.values;
}

void SKIP_stack_push(stack_t* st, void** value, void** slot) {
  st->values[st->head].value = value;
  st->values[st->head].slot = slot;
  st->head++;
  if(st->head >= st->capacity) {
    SKIP_stack_grow(st);
  }
}

value_t SKIP_stack_pop(stack_t* st) {
  st->head--;
  return st->values[st->head];
}

/*****************************************************************************/
/* Interning primitives. */
/*****************************************************************************/

sk_htbl_t itable_holder;
sk_htbl_t *itable = NULL;

static void add_itable(char* mem) {
  if(itable == NULL) {
    itable = &itable_holder;
    sk_htbl_init(itable, 10);
  }
  sk_htbl_add(itable, mem, mem);
}

static sk_cell_t* find_itable(char* mem) {
  if(itable == NULL) {
    itable = &itable_holder;
    sk_htbl_init(itable, 10);
  }
  return sk_htbl_find(itable, mem);
}

static char* shallow_intern(char* obj, size_t memsize, size_t leftsize) {
  memsize += leftsize;
  size_t alloc_size = memsize;
  char* mem = malloc(alloc_size);
  mymemcpy(mem, obj - leftsize, memsize);
  mem = mem + leftsize;
  add_itable(mem);
  return mem;
}

static void free_intern(char* obj, size_t memsize, size_t leftsize) {
  sk_cell_t* cell = find_itable(obj);
  if(cell == NULL || cell->value == NULL) {
    return;
  }
  cell->value = NULL;
  memsize += leftsize;
  free_size(obj-leftsize, memsize);
}

char* SKIP_intern_class(sk_htbl_t* ht, stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  void** result = (void**)shallow_intern(obj, memsize, leftsize);

  if((ty->m_refsHintMask & 1) != 0) {
    size_t size = ty->m_userByteSize / sizeof(void*);
    size_t bitsize = sizeof(void*) * 8;
    size_t slot = 0;
    size_t mask_slot = 0;
    int i;
    while(size > 0) {
      for(i = 0; i < bitsize && i < size; i++) {
        if(ty->m_refMask[mask_slot] & (1 << i)) {
          void** ptr = ((void**)obj)+(mask_slot * bitsize)+i;
          void** slot = result+(mask_slot * bitsize)+i;
          SKIP_stack_push(st, ptr, slot);
        }
      };
      if(size < bitsize) {
        break;
      }
      size -= bitsize;
      mask_slot++;
    }
  }

  return (char*)result;
}

char* SKIP_intern_array(sk_htbl_t* ht, stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t len = *(uint32_t*)(obj-sizeof(char*)-sizeof(uint32_t));
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  void** result = (void**)shallow_intern(obj, memsize, leftsize);
  size_t bitsize = sizeof(void*) * 8;

  if((ty->m_refsHintMask & 1) != 0) {
    char* rhead = (char*)result;
    char* ohead = obj;
    char* end = obj + memsize;

    while(ohead < end) {
      size_t size = ty->m_userByteSize;
      size_t slot = 0;
      size_t mask_slot = 0;
      while(size > 0) {
        int i;
        for(i = 0; i < bitsize && size > 0; i++) {
          if(ty->m_refMask[mask_slot] & (1 << i)) {
            void** ptr = (void**)ohead;
            void** slot = (void**)rhead;
            SKIP_stack_push(st, ptr, slot);
          }
          ohead += sizeof(void*);
          rhead += sizeof(void*);
          size -= sizeof(void*);
        };
        mask_slot++;
      }
    }
  }

  return (char*)result;
}

char* SKIP_intern_string(char* obj) {
  size_t len = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
  char* result = shallow_intern(obj, len, 2 * sizeof(uint32_t));
  return result;
}

uint32_t SKIP_is_string(char* obj) {
  return *(((uint32_t*)obj)-1) & 0x80000000;
}

char* SKIP_intern_obj(sk_htbl_t* ot, sk_htbl_t* ht, stack_t* st, char* obj) {

  if(obj == NULL) {
    return NULL;
  }

  sk_cell_t* icell = find_itable(obj);

  if(icell != NULL && icell->value != NULL) {
    if(!sk_htbl_mem(ot, obj)) {
      sk_htbl_add(ot, obj, obj);
    }
    return obj;
  }

  sk_cell_t* cell = sk_htbl_find(ht, (void*)obj);

  // We already copied this object
  if(cell != NULL) {
    return cell->value;
  }

  char* result;

  // Check if we are dealing with a string
  if(SKIP_is_string(obj)) {
    result = SKIP_intern_string(obj);
    sk_htbl_add(ht, obj, result);
    return result;
  }

  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  switch(ty->m_kind) {
  case 0:
    result = SKIP_intern_class(ht, st, obj);
    break;
  case 1:
    result = SKIP_intern_array(ht, st, obj);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }

  sk_htbl_add(ht, obj, result);

  return (char*)result;
}

static char* intern_with_table(sk_htbl_t* ot, char* obj) {
  sk_htbl_t ht_holder;
  sk_htbl_t* ht = &ht_holder;

  stack_t st_holder;
  stack_t* st = &st_holder;

  sk_htbl_init(ht, 10);
  SKIP_stack_init(st, 1024);

  char* result = SKIP_intern_obj(ot, ht, st, obj);

  while(st->head > 0) {
    value_t delayed = SKIP_stack_pop(st);
    void* toCopy = *delayed.value;
    *delayed.slot = SKIP_intern_obj(ot, ht, st, toCopy);
  }

  SKIP_stack_free(st);
  sk_htbl_free(ht);

  return result;
}

char* SKIP_intern(char* obj) {
  sk_htbl_t ot_holder;
  sk_htbl_t* ot = &ot_holder;

  sk_htbl_init(ot, 10);
  char* result = intern_with_table(ot, obj);
  sk_htbl_free(ot);

  return result;
}

/*****************************************************************************/
/* Freeing primitive. */
/*****************************************************************************/

void SKIP_free_class(sk_htbl_t* ht, stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t memsize = ty->m_userByteSize;
  size_t leftsize = ty->m_uninternedMetadataByteSize;

  if((ty->m_refsHintMask & 1) != 0) {
    size_t size = ty->m_userByteSize / sizeof(void*);
    size_t bitsize = sizeof(void*) * 8;
    size_t slot = 0;
    size_t mask_slot = 0;
    int i;
    while(size > 0) {
      for(i = 0; i < bitsize && i < size; i++) {
        if(ty->m_refMask[mask_slot] & (1 << i)) {
          void* ptr = *(((void**)obj)+(mask_slot * bitsize)+i);
          SKIP_stack_push(st, ptr, ptr);
        }
      };
      if(size < bitsize) {
        break;
      }
      size -= bitsize;
      mask_slot++;
    }
  }

  free_intern(obj, memsize, leftsize);

  return;
}

void SKIP_free_array(sk_htbl_t* ht, stack_t* st, char* obj) {
  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  size_t len = *(uint32_t*)(obj-sizeof(char*)-sizeof(uint32_t));
  size_t memsize = ty->m_userByteSize * len;
  size_t leftsize = ty->m_uninternedMetadataByteSize;
  size_t bitsize = sizeof(void*) * 8;

  if((ty->m_refsHintMask & 1) != 0) {
    char* ohead = obj;
    char* end = obj + memsize;

    while(ohead < end) {
      size_t size = ty->m_userByteSize;
      size_t slot = 0;
      size_t mask_slot = 0;
      while(size > 0) {
        int i;
        for(i = 0; i < bitsize && size > 0; i++) {
          if(ty->m_refMask[mask_slot] & (1 << i)) {
            void* ptr = *((void**)ohead);
            SKIP_stack_push(st, ptr, ptr);
          }
          ohead += sizeof(void*);
          size -= sizeof(void*);
        };
        mask_slot++;
      }
    }
  }

  free_intern(obj, memsize, leftsize);

  return;
}

void SKIP_free(sk_htbl_t* ot, sk_htbl_t* ht, stack_t* st, char* obj) {

  if(obj == NULL) {
    return;
  }

  // Checking if we already freed this object.
  sk_cell_t* cell = sk_htbl_find(ht, (void*)obj);
  if(cell != NULL) {
    return;
  }

  sk_htbl_add(ht, obj, obj);

  // We have been told to keep this object around
  cell = sk_htbl_find(ot, (void*)obj);
  if(cell != NULL) {
    return;
  }

  // Check if we are dealing with a string
  if(SKIP_is_string(obj)) {
    size_t memsize = *(uint32_t*)(obj - 2 * sizeof(uint32_t));
    size_t leftsize = 2 * sizeof(uint32_t);
    free_intern(obj, memsize, leftsize);
    return;
  }

  SkipGcType* ty = *(*(((SkipGcType***)obj)-1)+1);

  switch(ty->m_kind) {
  case 0:
    SKIP_free_class(ht, st, obj);
    break;
  case 1:
    SKIP_free_array(ht, st, obj);
    break;
  default:
    // NOT SUPPORTED
    SKIP_internalExit();
  }

  return;
}

static char* context = NULL;

void SKIP_context_init(char* obj) {
  context = obj;
}

char* SKIP_context_get() {
  return context;
}

void SKIP_context_sync(char* new) {
  sk_htbl_t ot_holder;
  sk_htbl_t* ot = &ot_holder;

  sk_htbl_init(ot, 10);
  char* new_obj = intern_with_table(ot, new);

  sk_htbl_t ht_holder;
  sk_htbl_t* ht = &ht_holder;

  stack_t st_holder;
  stack_t* st = &st_holder;

  sk_htbl_init(ht, 10);
  SKIP_stack_init(st, 1024);

  SKIP_free(ot, ht, st, context);

  while(st->head > 0) {
    value_t delayed = SKIP_stack_pop(st);
    void* toFree = delayed.value;
    SKIP_free(ot, ht, st, toFree);
  }

  SKIP_stack_free(st);
  sk_htbl_free(ht);
  sk_htbl_free(ot);

  context = new_obj;
}
