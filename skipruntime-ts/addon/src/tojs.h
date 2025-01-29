
// tojs.h
#ifndef SK_TOJSBINDING_H
#define SK_TOJSBINDING_H

#include <node.h>

namespace skipruntime {

void GetToJSBinding(const v8::FunctionCallbackInfo<v8::Value>&);

}  // namespace skipruntime

#endif  // SK_TOJSBINDING_H
