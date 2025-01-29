// fromjs.h
#ifndef SK_FROMJSBINDING_H
#define SK_FROMJSBINDING_H

#include <node.h>

namespace skipruntime {

void SetFromJSBinding(v8::Isolate*, v8::Local<v8::Object>);

}  // namespace skipruntime

#endif  // SK_FROMJSBINDING_H
