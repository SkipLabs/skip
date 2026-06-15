
#include "common.h"

// testCloseSession

namespace skipruntime {

using skbinding::CallJSFunction;
using skbinding::CallJSNullableFunction;
using skbinding::CallJSNullableStringFunction;
using skbinding::CallJSNumberFunction;
using skbinding::CallJSStringFunction;
using skbinding::CallJSVoidFunction;

/* Persistent reference to the JS object holding all the user's
   callbacks Skip can invoke from native code. Initialized once at startup
   via SetFromJSBinding, then used for each Skip -> JS call. */

static Napi::ObjectReference kExternFunctions;

void SetFromJSBinding(Napi::Env /*env*/, Napi::Object externFunctions) {
  kExternFunctions = Napi::Persistent(externFunctions);
  kExternFunctions.SuppressDestruct();
}

extern "C" {

/* Error / context plumbing. */

double SkipRuntime_getErrorHdl(SKException exn) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::External<void>::New(env, exn)};
  return CallJSNumberFunction(env, externFunctions, "SkipRuntime_getErrorHdl",
                              args);
}

void SkipRuntime_pushContext(SKContext context) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::External<void>::New(env, context)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_pushContext", args);
}

void SkipRuntime_popContext() {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_popContext", {});
}

void* SkipRuntime_getContext() {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  return CallJSNullableFunction(env, externFunctions, "SkipRuntime_getContext",
                                {});
}

void* SkipRuntime_getFork() {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  return CallJSNullableStringFunction(env, externFunctions,
                                      "SkipRuntime_getFork", {});
}

uint32_t SkipRuntime_getChangeManager() {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  return (uint32_t)CallJSNumberFunction(env, externFunctions,
                                        "SkipRuntime_getChangeManager", {});
}

/* Mapper callbacks. */

CJArray SkipRuntime_Mapper__mapEntry(uint32_t mapperId, CJSON key,
                                     SKNonEmptyIterator values) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, mapperId),
      Napi::External<void>::New(env, key),
      Napi::External<void>::New(env, values),
  };
  return CallJSFunction(env, externFunctions, "SkipRuntime_Mapper__mapEntry",
                        args);
}

CJObject SkipRuntime_Mapper__getInfo(uint32_t mapperId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, mapperId),
  };
  return CallJSFunction(env, externFunctions, "SkipRuntime_Mapper__getInfo",
                        args);
}

uint32_t SkipRuntime_Mapper__isEquals(uint32_t mapperId, uint32_t otherId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, mapperId),
      Napi::Number::New(env, otherId),
  };
  return (uint32_t)CallJSNumberFunction(env, externFunctions,
                                        "SkipRuntime_Mapper__isEquals", args);
}

void SkipRuntime_deleteMapper(uint32_t mapperId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, mapperId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_deleteMapper", args);
}

/* LazyCompute callbacks. */

CJSON SkipRuntime_LazyCompute__compute(uint32_t lazyComputeId, char* self,
                                       CJSON key) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, lazyComputeId),
      Napi::String::New(env, self),
      Napi::External<void>::New(env, key),
  };
  return CallJSFunction(env, externFunctions,
                        "SkipRuntime_LazyCompute__compute", args);
}

CJObject SkipRuntime_LazyCompute__getInfo(uint32_t mapperId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, mapperId),
  };
  return CallJSFunction(env, externFunctions,
                        "SkipRuntime_LazyCompute__getInfo", args);
}

uint32_t SkipRuntime_LazyCompute__isEquals(uint32_t mapperId,
                                           uint32_t otherId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, mapperId),
      Napi::Number::New(env, otherId),
  };
  return (uint32_t)CallJSNumberFunction(
      env, externFunctions, "SkipRuntime_LazyCompute__isEquals", args);
}

void SkipRuntime_deleteLazyCompute(uint32_t lazyComputeId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, lazyComputeId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_deleteLazyCompute",
                     args);
}

/* Resource callbacks. */

char* SkipRuntime_Resource__instantiate(uint32_t resourceId,
                                        CJObject collections) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, resourceId),
      Napi::External<void>::New(env, collections),
  };
  return CallJSStringFunction(env, externFunctions,
                              "SkipRuntime_Resource__instantiate", args);
}

void SkipRuntime_deleteResource(uint32_t resourceId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, resourceId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_deleteResource", args);
}

/* Service definition callbacks. */

void SkipRuntime_deleteService(uint32_t serviceId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, serviceId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_deleteService", args);
}

double SkipRuntime_ServiceDefinition__subscribe(uint32_t serviceId,
                                                char* collection,
                                                char* supplier, char* sessionId,
                                                char* resource,
                                                CJObject params) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId), Napi::String::New(env, collection),
      Napi::String::New(env, supplier),  Napi::String::New(env, sessionId),
      Napi::String::New(env, resource),  Napi::External<void>::New(env, params),
  };
  return CallJSNumberFunction(env, externFunctions,
                              "SkipRuntime_ServiceDefinition__subscribe", args);
}

void SkipRuntime_ServiceDefinition__unsubscribe(uint32_t serviceId,
                                                char* supplier,
                                                char* sessionId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId),
      Napi::String::New(env, supplier),
      Napi::String::New(env, sessionId),
  };
  CallJSVoidFunction(env, externFunctions,
                     "SkipRuntime_ServiceDefinition__unsubscribe", args);
}

double SkipRuntime_ServiceDefinition__shutdown(uint32_t serviceId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, serviceId)};
  return CallJSNumberFunction(env, externFunctions,
                              "SkipRuntime_ServiceDefinition__shutdown", args);
}

CJArray SkipRuntime_ServiceDefinition__inputs(uint32_t serviceId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId),
  };
  return CallJSFunction(env, externFunctions,
                        "SkipRuntime_ServiceDefinition__inputs", args);
}

CJArray SkipRuntime_ServiceDefinition__initialData(uint32_t serviceId,
                                                   char* input) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId),
      Napi::String::New(env, input),
  };
  return CallJSFunction(env, externFunctions,
                        "SkipRuntime_ServiceDefinition__initialData", args);
}

CJArray SkipRuntime_ServiceDefinition__resources(uint32_t serviceId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId),
  };
  return CallJSFunction(env, externFunctions,
                        "SkipRuntime_ServiceDefinition__resources", args);
}

SKResource SkipRuntime_ServiceDefinition__buildResource(uint32_t serviceId,
                                                        char* resource,
                                                        CJObject params) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId),
      Napi::String::New(env, resource),
      Napi::External<void>::New(env, params),
  };
  return CallJSFunction(env, externFunctions,
                        "SkipRuntime_ServiceDefinition__buildResource", args);
}

CJObject SkipRuntime_ServiceDefinition__createGraph(uint32_t serviceId,
                                                    CJObject collections) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId),
      Napi::External<void>::New(env, collections),
  };
  return CallJSFunction(env, externFunctions,
                        "SkipRuntime_ServiceDefinition__createGraph", args);
}

/* ChangeManager callbacks. */

uint32_t SkipRuntime_ChangeManager__needInputReload(uint32_t serviceId,
                                                    char* name) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, serviceId),
                                  Napi::String::New(env, name)};
  return CallJSNumberFunction(
      env, externFunctions, "SkipRuntime_ChangeManager__needInputReload", args);
}

uint32_t SkipRuntime_ChangeManager__needResourceReload(uint32_t serviceId,
                                                       char* name) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, serviceId),
                                  Napi::String::New(env, name)};
  return CallJSNumberFunction(env, externFunctions,
                              "SkipRuntime_ChangeManager__needResourceReload",
                              args);
}

uint32_t SkipRuntime_ChangeManager__needExternalServiceReload(
    uint32_t serviceId, char* name, char* resource) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, serviceId),
                                  Napi::String::New(env, name),
                                  Napi::String::New(env, resource)};
  return CallJSNumberFunction(
      env, externFunctions,
      "SkipRuntime_ChangeManager__needExternalServiceReload", args);
}

/* Notifier callbacks. */

void SkipRuntime_Notifier__subscribed(uint32_t notifierId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, notifierId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_Notifier__subscribed",
                     args);
}

void SkipRuntime_Notifier__notify(uint32_t notifierId, CJArray values,
                                  char* watermark, uint32_t updates) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, notifierId),
      Napi::External<void>::New(env, values),
      Napi::String::New(env, watermark),
      Napi::Number::New(env, updates),
  };
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_Notifier__notify",
                     args);
}

void SkipRuntime_Notifier__close(uint32_t notifierId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, notifierId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_Notifier__close", args);
}

void SkipRuntime_deleteNotifier(uint32_t notifierId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, notifierId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_deleteNotifier", args);
}

/* Reducer callbacks. */

CJSON SkipRuntime_Reducer__init(uint32_t reducerId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, reducerId),
  };
  return CallJSFunction(env, externFunctions, "SkipRuntime_Reducer__init",
                        args);
}

CJSON SkipRuntime_Reducer__add(uint32_t reducerId, CJSON acc, CJSON value) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, reducerId),
      Napi::External<void>::New(env, acc),
      Napi::External<void>::New(env, value),
  };
  return CallJSFunction(env, externFunctions, "SkipRuntime_Reducer__add", args);
}

CJSON SkipRuntime_Reducer__remove(uint32_t reducerId, CJSON acc, CJSON value) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, reducerId),
      Napi::External<void>::New(env, acc),
      Napi::External<void>::New(env, value),
  };
  return CallJSNullableFunction(env, externFunctions,
                                "SkipRuntime_Reducer__remove", args);
}

uint32_t SkipRuntime_Reducer__isEquals(uint32_t reducerId, uint32_t otherId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, reducerId),
      Napi::Number::New(env, otherId),
  };
  return (uint32_t)CallJSNumberFunction(env, externFunctions,
                                        "SkipRuntime_Reducer__isEquals", args);
}

CJObject SkipRuntime_Reducer__getInfo(uint32_t reducerId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, reducerId),
  };
  return CallJSFunction(env, externFunctions, "SkipRuntime_Reducer__getInfo",
                        args);
}

void SkipRuntime_deleteReducer(uint32_t reducerId) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {Napi::Number::New(env, reducerId)};
  CallJSVoidFunction(env, externFunctions, "SkipRuntime_deleteReducer", args);
}

/* External service fetch callback. */

double SkipRuntime_ServiceDefinition__fetch(uint32_t serviceId, char* supplier,
                                            char* dirName, CJSON key) {
  Napi::Env env = kExternFunctions.Env();
  Napi::HandleScope scope(env);
  Napi::Object externFunctions = kExternFunctions.Value();
  std::vector<napi_value> args = {
      Napi::Number::New(env, serviceId),
      Napi::String::New(env, supplier),
      Napi::String::New(env, dirName),
      Napi::External<void>::New(env, key),
  };
  return CallJSNumberFunction(env, externFunctions,
                              "SkipRuntime_ServiceDefinition__fetch", args);
}

}  // extern "C"

}  // namespace skipruntime
