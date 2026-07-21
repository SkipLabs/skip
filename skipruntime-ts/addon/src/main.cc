#include <napi.h>

#include "cjson.h"
#include "common.h"
#include "fromjs.h"
#include "tojs.h"

Napi::Value InitToBinding(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsObject()) {
    throw Napi::TypeError::New(env, "The parameter must be an object.");
  }
  Napi::Object binding = info[0].As<Napi::Object>();
  skipruntime::SetFromJSBinding(env, binding);
  return env.Undefined();
}

// was void, became Napi::Object because NAPI requires us to explicitely return
// the now filled `exports` object

Napi::Object Initialize(Napi::Env env, Napi::Object exports) {
  skbinding::AddFunction(env, exports, "runWithGC", skbinding::RunWithGC);
  skbinding::AddFunction(env, exports, "getErrorObject",
                         skbinding::GetErrorObject);
  skbinding::AddFunction(env, exports, "getJsonBinding", skjson::GetBinding);
  skbinding::AddFunction(env, exports, "getSkipRuntimeFromBinding",
                         skipruntime::GetToJSBinding);
  skbinding::AddFunction(env, exports, "initSkipRuntimeToBinding",
                         InitToBinding);
  return exports;
}

NODE_API_MODULE(NODE_GYP_MODULE_NAME, Initialize)
