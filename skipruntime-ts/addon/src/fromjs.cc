
#include "common.h"

// testCloseSession

namespace skipruntime {

using skbinding::CallJSFunction;
using skbinding::CallJSNullableFunction;
using skbinding::CallJSNullableStringFunction;
using skbinding::CallJSNumberFunction;
using skbinding::CallJSStringFunction;
using skbinding::CallJSVoidFunction;
using skbinding::FromUtf8;

using v8::External;
using v8::HandleScope;
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
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {External::New(isolate, exn)};
  double handle = CallJSNumberFunction(isolate, externFunctions,
                                       "SkipRuntime_getErrorHdl", 1, argv);
  return handle;
}

void SkipRuntime_pushContext(SKContext context) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {External::New(isolate, context)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_pushContext", 1,
                     argv);
}

void SkipRuntime_popContext() {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_popContext", 0,
                     nullptr);
}

void* SkipRuntime_getContext() {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  return CallJSNullableFunction(isolate, externFunctions,
                                "SkipRuntime_getContext", 0, nullptr);
}

void* SkipRuntime_getFork() {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  return CallJSNullableStringFunction(isolate, externFunctions,
                                      "SkipRuntime_getFork", 0, nullptr);
}

CJArray SkipRuntime_Mapper__mapEntry(uint32_t mapperId, CJSON key,
                                     SKNonEmptyIterator values) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, mapperId),
      External::New(isolate, key),
      External::New(isolate, values),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_Mapper__mapEntry", 3, argv);
}

CJObject SkipRuntime_Mapper__getInfo(uint32_t mapperId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, mapperId),
  };
  return CallJSFunction(isolate, externFunctions, "SkipRuntime_Mapper__getInfo",
                        1, argv);
}

uint32_t SkipRuntime_Mapper__isEquals(uint32_t mapperId, uint32_t otherId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, mapperId),
      Number::New(isolate, otherId),
  };
  return (uint32_t)CallJSNumberFunction(
      isolate, externFunctions, "SkipRuntime_Mapper__isEquals", 2, argv);
}

void SkipRuntime_deleteMapper(uint32_t mapperId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, mapperId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteMapper", 1,
                     argv);
}

CJSON SkipRuntime_LazyCompute__compute(uint32_t lazyComputeId, char* self,
                                       CJSON key) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, lazyComputeId),
      FromUtf8(isolate, self),
      External::New(isolate, key),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_LazyCompute__compute", 3, argv);
}

CJObject SkipRuntime_LazyCompute__getInfo(uint32_t mapperId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, mapperId),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_LazyCompute__getInfo", 1, argv);
}

uint32_t SkipRuntime_LazyCompute__isEquals(uint32_t mapperId,
                                           uint32_t otherId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, mapperId),
      Number::New(isolate, otherId),
  };
  return (uint32_t)CallJSNumberFunction(
      isolate, externFunctions, "SkipRuntime_LazyCompute__isEquals", 2, argv);
}

void SkipRuntime_deleteLazyCompute(uint32_t lazyComputeId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, lazyComputeId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteLazyCompute",
                     1, argv);
}

double SkipRuntime_ExternalService__subscribe(uint32_t externalSupplierId,
                                              char* collection, char* sessionId,
                                              char* resource, CJObject params) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[5] = {
      Number::New(isolate, externalSupplierId),
      FromUtf8(isolate, collection),
      FromUtf8(isolate, sessionId),
      FromUtf8(isolate, resource),
      External::New(isolate, params),
  };
  return CallJSNumberFunction(isolate, externFunctions,
                              "SkipRuntime_ExternalService__subscribe", 5,
                              argv);
}

void SkipRuntime_ExternalService__unsubscribe(uint32_t externalSupplierId,
                                              char* sessionId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, externalSupplierId),
      FromUtf8(isolate, sessionId),
  };
  CallJSVoidFunction(isolate, externFunctions,
                     "SkipRuntime_ExternalService__unsubscribe", 2, argv);
}

double SkipRuntime_ExternalService__shutdown(uint32_t externalSupplierId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, externalSupplierId)};
  return CallJSNumberFunction(isolate, externFunctions,
                              "SkipRuntime_ExternalService__shutdown", 1, argv);
}

void SkipRuntime_deleteExternalService(uint32_t externalSupplierId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, externalSupplierId)};
  CallJSVoidFunction(isolate, externFunctions,
                     "SkipRuntime_deleteExternalService", 1, argv);
}

char* SkipRuntime_Resource__instantiate(uint32_t resourceId,
                                        CJObject collections) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
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
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, resourceId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteResource", 1,
                     argv);
}

SKResource SkipRuntime_ResourceBuilder__build(uint32_t builderId,
                                              CJObject params) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, builderId),
      External::New(isolate, params),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_ResourceBuilder__build", 2, argv);
}

void SkipRuntime_deleteResourceBuilder(uint32_t resourceBuilderId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, resourceBuilderId)};
  CallJSVoidFunction(isolate, externFunctions,
                     "SkipRuntime_deleteResourceBuilder", 1, argv);
}

void SkipRuntime_Checker__check(uint32_t executorId, char* request) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, executorId),
      FromUtf8(isolate, request),
  };
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_Checker__check", 2,
                     argv);
}

void SkipRuntime_deleteChecker(uint32_t checkerId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, checkerId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteChecker", 1,
                     argv);
}

void SkipRuntime_deleteService(uint32_t serviceId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, serviceId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteService", 1,
                     argv);
}

CJObject SkipRuntime_Service__createGraph(uint32_t serviceId,
                                          CJObject collections) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, serviceId),
      External::New(isolate, collections),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_Service__createGraph", 2, argv);
}

void SkipRuntime_Notifier__subscribed(uint32_t notifierId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, notifierId)};
  CallJSVoidFunction(isolate, externFunctions,
                     "SkipRuntime_Notifier__subscribed", 1, argv);
}

void SkipRuntime_Notifier__notify(uint32_t notifierId, CJArray values,
                                  char* watermark, uint32_t updates) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
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
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, notifierId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_Notifier__close", 1,
                     argv);
}

void SkipRuntime_deleteNotifier(uint32_t notifierId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, notifierId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteNotifier", 1,
                     argv);
}

CJSON SkipRuntime_Reducer__init(uint32_t reducerId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, reducerId),
  };
  return CallJSFunction(isolate, externFunctions, "SkipRuntime_Reducer__init",
                        1, argv);
}

CJSON SkipRuntime_Reducer__add(uint32_t reducerId, CJSON acc, CJSON value) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
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
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[3] = {
      Number::New(isolate, reducerId),
      External::New(isolate, acc),
      External::New(isolate, value),
  };
  return CallJSNullableFunction(isolate, externFunctions,
                                "SkipRuntime_Reducer__remove", 3, argv);
}

uint32_t SkipRuntime_Reducer__isEquals(uint32_t reducerId, uint32_t otherId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[2] = {
      Number::New(isolate, reducerId),
      Number::New(isolate, otherId),
  };
  return (uint32_t)CallJSNumberFunction(
      isolate, externFunctions, "SkipRuntime_Reducer__isEquals", 2, argv);
}

CJObject SkipRuntime_Reducer__getInfo(uint32_t reducerId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {
      Number::New(isolate, reducerId),
  };
  return CallJSFunction(isolate, externFunctions,
                        "SkipRuntime_Reducer__getInfo", 1, argv);
}

void SkipRuntime_deleteReducer(uint32_t reducerId) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);
  Local<Object> externFunctions = kExternFunctions.Get(isolate);
  Local<Value> argv[1] = {Number::New(isolate, reducerId)};
  CallJSVoidFunction(isolate, externFunctions, "SkipRuntime_deleteReducer", 1,
                     argv);
}
}  // extern "C"

}  // namespace skipruntime
