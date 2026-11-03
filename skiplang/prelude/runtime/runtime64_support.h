#ifndef SKIP_RUNTIME64_SUPPORT_H
#define SKIP_RUNTIME64_SUPPORT_H

#include <exception>

extern "C" {
#include "runtime.h"

typedef struct {
  char* head;
  char* page;
  char* end;
} sk_saved_obstack_t;

void* sk_get_exception_type(void*);
void* sk_get_exception_message(void*);
sk_saved_obstack_t* SKIP_new_Obstack();
void SKIP_destroy_Obstack(sk_saved_obstack_t*);
}

namespace skip {
struct SkipException : std::exception {
  explicit SkipException(void* exc) : m_skipException(exc) {}

  virtual const char* what() const noexcept override {
    char* str = (char*)sk_get_exception_message(m_skipException);
    sk_string_check_c_safe(str);
    return str;
  }

  const char* name() const noexcept {
    char* str = (char*)sk_get_exception_type(m_skipException);
    sk_string_check_c_safe(str);
    return str;
  }

  void* m_skipException;
};

}  // namespace skip
#endif
