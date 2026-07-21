// tojs.h

#ifndef SK_TOJSBINDING_H
#define SK_TOJSBINDING_H

#include <napi.h>

namespace skipruntime {

Napi::Value GetToJSBinding(const Napi::CallbackInfo&);

}  // namespace skipruntime

#endif  // SK_TOJSBINDING_H
