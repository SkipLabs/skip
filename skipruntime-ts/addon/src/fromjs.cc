
#include "common.h"

// testCloseSession

namespace skipruntime {

using skbinding::CallJSFunction;
using skbinding::CallJSNullableFunction;
using skbinding::CallJSNumberFunction;
using skbinding::CallJSStringFunction;
using skbinding::CallJSVoidFunction;
using skbinding::CallNullableStringFunction;
using skbinding::FromUtf8;

using v8::BigInt;
using v8::External;
using v8::Isolate;
using v8::Local;
using v8::MaybeLocal;
using v8::Number;
using v8::Object;
using v8::Persistent;
using v8::Value;

static Persistent<Object> kExternFunctions;

void SetFromJSBinding(Isolate* isolate, Local<Object> externFunctions) {
  kExternFunctions.Reset(isolate, externFunctions);
}

extern "C" {

double SkipRuntime_getErrorHdl(SKException exn) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {External::New(isolate, exn)};
  double handle = CallJSNumberFunction(isolate, externFunctions,
                                       "SkipRuntime_getErrorHdl", 1, argv);
  return handle;
}

void SkipRuntime_pushContext(SKContext context) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {External::New(isolate, context)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_pushContext", 1,
                     argv);
}

void SkipRuntime_popContext() {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_popContext", 0,
                     nullptr);
}

void* SkipRuntime_getContext() {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  return CallJSNullableFunction(isolate, externFunctions,
                                "SkipRuntime_getContext", 0, nullptr);
}

CJArray SkipRuntime_Mapper__mapEntry(uint32_t mapperId, CJSON key,
                                     SKNonEmptyIterator values) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, mapperId),
      External::New(isolate, key),
      External::New(isolate, values),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_Mapper__mapEntry", 3, argv);
}

void SkipRuntime_deleteMapper(uint32_t mapperId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, mapperId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteMapper", 1,
                     argv);
}

CJSON SkipRuntime_LazyCompute__compute(uint32_t lazyComputeId, char* self,
                                       CJSON key) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, lazyComputeId),
      FromUtf8(isolate, self),
      External::New(isolate, key),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_LazyCompute__compute", 3, argv);
}

void SkipRuntime_deleteLazyCompute(uint32_t lazyComputeId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, lazyComputeId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteLazyCompute",
                     1, argv);
}

char* SkipRuntime_Resource__instantiate(uint32_t resourceId,
                                        CJObject collections) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, resourceId),
      External::New(isolate, collections),
  };
  return CallJSStringFunction(isolate, externFunctions,
                              "SkipRuntime_Resource__instantiate", 2, argv);
}

void SkipRuntime_deleteResource(uint32_t resourceId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, resourceId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteResource", 1,
                     argv);
}

void SkipRuntime_Executor__resolve(uint32_t checkerId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, checkerId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_Executor__resolve",
                     1, argv);
}

void SkipRuntime_IntExecutor__resolve(uint32_t checkerId, int64_t instance) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {Number::New(isolate, checkerId),
                          BigInt::New(isolate, instance)};
  CallJSVoidFunction(isolate, externFunctions,
                     "SkipRuntime_IntExecutor__resolve", 2, argv);
}

void SkipRuntime_Executor__reject(uint32_t checkerId, double handle) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {Number::New(isolate, checkerId),
                          Number::New(isolate, handle)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_Executor__reject",
                     2, argv);
}

void SkipRuntime_deleteExecutor(uint32_t checkerId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, checkerId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteExecutor", 1,
                     argv);
}

void SkipRuntime_deleteService(uint32_t serviceId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, serviceId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteService", 1,
                     argv);
}

void SkipRuntime_ServiceDefinition__subscribe(uint32_t serviceId,
                                              char* collection, char* supplier,
                                              char* sessionId, char* resource,
                                              CJObject params) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[6] = {
      Number::New(isolate, serviceId), FromUtf8(isolate, collection),
      FromUtf8(isolate, supplier),     FromUtf8(isolate, sessionId),
      FromUtf8(isolate, resource),     External::New(isolate, params),
  };
  return CallJSVoidFunction(isolate, externFunctions,
                            "SkipRuntime_ServiceDefinition__subscribe", 6,
                            argv);
}

void SkipRuntime_ServiceDefinition__unsubscribe(uint32_t serviceId,
                                                char* supplier,
                                                char* sessionId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, serviceId),
      FromUtf8(isolate, supplier),
      FromUtf8(isolate, sessionId),
  };
  CallJSVoidFunction(isolate, externFunctions,
                     "SkipRuntime_ServiceDefinition__unsubscribe", 3, argv);
}

double SkipRuntime_ServiceDefinition__shutdown(uint32_t serviceId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, serviceId)};
  return CallJSNumberFunction(isolate, externFunctions,
                              "SkipRuntime_ServiceDefinition__shutdown", 1,
                              argv);
}

CJArray SkipRuntime_ServiceDefinition__inputs(uint32_t serviceId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, serviceId),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_ServiceDefinition__inputs", 1, argv);
}

char* SkipRuntime_ServiceDefinition__from(uint32_t serviceId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, serviceId),
  };
  return CallNullableStringFunction(
      isolate, externFunctions, "SkipRuntime_ServiceDefinition__from", 1, argv);
}

CJArray SkipRuntime_ServiceDefinition__initialData(uint32_t serviceId,
                                                   char* input) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, serviceId),
      FromUtf8(isolate, input),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_ServiceDefinition__initialData", 2, argv);
}

CJArray SkipRuntime_ServiceDefinition__resources(uint32_t serviceId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, serviceId),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_ServiceDefinition__resources", 1, argv);
}

SKResource SkipRuntime_ServiceDefinition__buildResource(uint32_t serviceId,
                                                        char* resource,
                                                        CJObject params) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, serviceId),
      FromUtf8(isolate, resource),
      External::New(isolate, params),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_ServiceDefinition__buildResource", 3,
                        argv);
}

CJObject SkipRuntime_ServiceDefinition__createGraph(uint32_t serviceId,
                                                    CJObject collections) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, serviceId),
      External::New(isolate, collections),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_ServiceDefinition__createGraph", 2, argv);
}

void SkipRuntime_Notifier__subscribed(uint32_t notifierId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, notifierId)};
  CallJSVoidFunction(isolate, externFunctions,
                     "SkipRuntime_Notifier__subscribed", 1, argv);
}

void SkipRuntime_Notifier__notify(uint32_t notifierId, CJArray values,
                                  char* watermark, uint32_t updates) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[4] = {
      Number::New(isolate, notifierId),
      External::New(isolate, values),
      FromUtf8(isolate, watermark),
      Number::New(isolate, updates),
  };
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_Notifier__notify",
                     4, argv);
}

void SkipRuntime_Notifier__close(uint32_t notifierId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, notifierId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_Notifier__close", 1,
                     argv);
}

void SkipRuntime_deleteNotifier(uint32_t notifierId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, notifierId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteNotifier", 1,
                     argv);
}

CJSON SkipRuntime_Reducer__add(uint32_t reducerId, CJSON acc, CJSON value) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, reducerId),
      External::New(isolate, acc),
      External::New(isolate, value),
  };
  return CallJSFunction(isolate, externFunctions, "SkipRuntime_Reducer__add", 3,
                        argv);
}

CJSON SkipRuntime_Reducer__remove(uint32_t reducerId, CJSON acc, CJSON value) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, reducerId),
      External::New(isolate, acc),
      External::New(isolate, value),
  };
  return CallJSNullableFunction(isolate, externFunctions,
                                "SkipRuntime_Reducer__remove", 3, argv);
}

CJSON SkipRuntime_Reducer__init(uint32_t reducerId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, reducerId),
  };
  return CallJSFunction(isolate, externFunctions, "SkipRuntime_Reducer__init",
                        1, argv);
}

void SkipRuntime_deleteReducer(uint32_t reducerId) {
  Isolate* isolate = Isolate::GetCurrent();
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, reducerId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteReducer", 1,
                     argv);
}
}  // extern "C"

}  // namespace skipruntime
