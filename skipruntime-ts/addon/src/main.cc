
#include <node.h>

#include "cjson.h"
#include "common.h"
#include "fromjs.h"
#include "tojs.h"

void InitToBinding(const v8::FunctionCallbackInfo<v8::Value>& args) {
  v8::Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    isolate->ThrowException(v8::Exception::TypeError(
        skbinding::FromUtf8(isolate, "Must have one parameters.")));
    return;
  };
  if (!args[0]->IsObject()) {
    isolate->ThrowException(v8::Exception::TypeError(
        skbinding::FromUtf8(isolate, "The parameter must be an object.")));
    return;
  }
  v8::Local<v8::Object> binding = args[0].As<v8::Object>();
  skipruntime::SetFromJSBinding(isolate, binding);
}

void Initialize(v8::Local<v8::Object> exports, v8::Local<v8::Value> module,
                void* context) {
  NODE_SET_METHOD(exports, "runWithGC", skbinding::RunWithGC);
  NODE_SET_METHOD(exports, "getErrorObject", skbinding::GetErrorObject);
  NODE_SET_METHOD(exports, "getJsonBinding", skjson::GetBinding);
  NODE_SET_METHOD(exports, "getSkipRuntimeFromBinding",
                  skipruntime::GetToJSBinding);
  NODE_SET_METHOD(exports, "initSkipRuntimeToBinding", InitToBinding);
}

NODE_MODULE(NODE_GYP_MODULE_NAME, Initialize)
