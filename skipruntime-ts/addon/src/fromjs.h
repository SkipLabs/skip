// fromjs.h

#ifndef SK_FROMJSBINDING_H
#define SK_FROMJSBINDING_H

#include <napi.h>

namespace skipruntime {

void SetFromJSBinding(Napi::Env, Napi::Object);

}  // namespace skipruntime

#endif  // SK_FROMJSBINDING_H
