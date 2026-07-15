#include "tojs.h"

#include <iostream>

#include "common.h"
#include "fromjs.h"

namespace skipruntime {

extern "C" {
CJSON SkipRuntime_CollectionWriter__update(char* collection, CJArray values,
                                           int32_t isInit);

char* SkipRuntime_Context__createLazyCollection(SKLazyCompute lazyCompute);
CJArray SkipRuntime_Context__jsonExtract(CJObject json, char* pattern);
char* SkipRuntime_Context__useExternalResource(char* service, char* identifier,
                                               CJObject json);

SKMapper SkipRuntime_createMapper(int32_t ref);
SKLazyCompute SkipRuntime_createLazyCompute(int32_t ref);
SKResource SkipRuntime_createResource(int32_t ref);
SKService SkipRuntime_createService(int32_t ref);
SKNotifier SkipRuntime_createNotifier(int32_t ref);
SKReducer SkipRuntime_createReducer(int32_t ref);

CJSON SkipRuntime_initService(SKService service);
double SkipRuntime_closeService();
CJArray SkipRuntime_Collection__getArray(char* collection, CJSON key);
char* SkipRuntime_Collection__map(char* collection, SKMapper mapper);
char* SkipRuntime_Collection__mapReduce(char* collection, SKMapper mapper,
                                        SKReducer reducer);
char* SkipRuntime_Collection__nativeMapReduce(char* collection, SKMapper mapper,
                                              char* reducer);
char* SkipRuntime_Collection__reduce(char* collection, SKReducer reducer);
char* SkipRuntime_Collection__nativeReduce(char* collection, char* reducer);
char* SkipRuntime_Collection__slice(char* collection, CJArray ranges);
char* SkipRuntime_Collection__take(char* collection, int64_t limit);
char* SkipRuntime_Collection__merge(char* collection, CJArray others);
int64_t SkipRuntime_Collection__size(char* collection);

CJSON SkipRuntime_NonEmptyIterator__next(SKNonEmptyIterator it);

CJSON SkipRuntime_LazyCollection__getArray(char* handle, CJSON key);

CJSON SkipRuntime_Runtime__createResource(char* identifier, char* resource,
                                          CJObject jsonParams);
double SkipRuntime_Runtime__closeResource(char* identifier);
int64_t SkipRuntime_Runtime__subscribe(char* reactiveId, SKNotifier notifier,
                                       char* watermark);
double SkipRuntime_Runtime__unsubscribe(char* identifier);
CJSON SkipRuntime_Runtime__getAll(char* resource, CJObject jsonParams);
CJSON SkipRuntime_Runtime__getForKey(char* resource, CJObject jsonParams,
                                     CJSON key);
CJSON SkipRuntime_Runtime__update(char* input, CJSON values);
double SkipRuntime_Runtime__fork(char* input);
double SkipRuntime_Runtime__merge(CJArray);
double SkipRuntime_Runtime__abortFork();
uint32_t SkipRuntime_Runtime__forkExists(char* input);
CJSON SkipRuntime_Runtime__reload(SKService service);
double SkipRuntime_Runtime__closeResourceStreams(CJArray streams);
int64_t SkipRuntime_getSkipPersistentSize();
}

using skbinding::AddFunction;
using skbinding::NatTryCatch;
using skbinding::ToSKString;

/* CollectionWriter operations. */

Napi::Value UpdateOfCollectionWriter(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 3) {
    throw Napi::TypeError::New(env, "Must have three parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  if (!info[2].IsBoolean()) {
    throw Napi::TypeError::New(env, "The third parameter must be a boolean.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skcollection = ToSKString(info[0]);
    CJArray skvalues = info[1].As<Napi::External<void>>().Data();
    int32_t skisinit = info[2].As<Napi::Boolean>().Value() ? 1 : 0;
    CJSON skresult =
        SkipRuntime_CollectionWriter__update(skcollection, skvalues, skisinit);
    result = Napi::External<void>::New(env, skresult);
  });
  return result;
}

/* Context operations. */

Napi::Value CreateLazyCollectionOfContext(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKLazyCompute sklazyCompute = info[0].As<Napi::External<void>>().Data();
    char* skResult = SkipRuntime_Context__createLazyCollection(sklazyCompute);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value JSONExtractOfContext(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The first parameter must be a pointer.");
  }
  if (!info[1].IsString()) {
    throw Napi::TypeError::New(env, "The second parameter must be a string.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJArray skResult = SkipRuntime_Context__jsonExtract(
        info[0].As<Napi::External<void>>().Data(), ToSKString(info[1]));
    result = Napi::External<void>::New(env, skResult);
  });
  return result;
}

Napi::Value UseExternalResourceOfContext(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 3) {
    throw Napi::TypeError::New(env, "Must have three parameters.");
  }
  if (!info[0].IsString() || !info[1].IsString()) {
    throw Napi::TypeError::New(
        env, "The first and second parameters must be strings.");
  }
  if (!info[2].IsExternal()) {
    throw Napi::TypeError::New(env, "The third parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skcollection = SkipRuntime_Context__useExternalResource(
        ToSKString(info[0]), ToSKString(info[1]),
        info[2].As<Napi::External<void>>().Data());
    result = Napi::String::New(env, skcollection);
  });
  return result;
}

/* Object factories: create a Skip-side object from a numeric reference id. */

Napi::Value CreateMapper(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber()) {
    throw Napi::TypeError::New(env, "The parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKMapper skMapper =
        SkipRuntime_createMapper(info[0].As<Napi::Number>().Int32Value());
    result = Napi::External<void>::New(env, skMapper);
  });
  return result;
}

Napi::Value CreateLazyCompute(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber()) {
    throw Napi::TypeError::New(env, "The parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKLazyCompute skLazyCompute =
        SkipRuntime_createLazyCompute(info[0].As<Napi::Number>().Int32Value());
    result = Napi::External<void>::New(env, skLazyCompute);
  });
  return result;
}

Napi::Value CreateResource(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber()) {
    throw Napi::TypeError::New(env, "The parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKResource skResource =
        SkipRuntime_createResource(info[0].As<Napi::Number>().Int32Value());
    result = Napi::External<void>::New(env, skResource);
  });
  return result;
}

Napi::Value CreateService(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber()) {
    throw Napi::TypeError::New(env, "The parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKService skService =
        SkipRuntime_createService(info[0].As<Napi::Number>().Int32Value());
    result = Napi::External<void>::New(env, skService);
  });
  return result;
}

Napi::Value CreateNotifier(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber()) {
    throw Napi::TypeError::New(env, "The parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKNotifier skNotifier =
        SkipRuntime_createNotifier(info[0].As<Napi::Number>().Int32Value());
    result = Napi::External<void>::New(env, skNotifier);
  });
  return result;
}

Napi::Value CreateReducer(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber()) {
    throw Napi::TypeError::New(env, "The parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKReducer skReducer =
        SkipRuntime_createReducer(info[0].As<Napi::Number>().Int32Value());
    result = Napi::External<void>::New(env, skReducer);
  });
  return result;
}

/* Service lifecycle. */

Napi::Value InitService(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJSON skresult =
        SkipRuntime_initService(info[0].As<Napi::External<void>>().Data());
    result = Napi::External<void>::New(env, skresult);
  });
  return result;
}

Napi::Value CloseService(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Value result;
  NatTryCatch(env, [&result, env](Napi::Env) {
    double skresult = SkipRuntime_closeService();
    result = Napi::Number::New(env, skresult);
  });
  return result;
}

/* Eager collection operations. */

Napi::Value GetArrayOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    void* skKey = info[1].As<Napi::External<void>>().Data();
    void* skResult = SkipRuntime_Collection__getArray(skCollection, skKey);
    result = Napi::External<void>::New(env, skResult);
  });
  return result;
}

Napi::Value SizeOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The parameter must be a string.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    int64_t skResult = SkipRuntime_Collection__size(skCollection);
    result = Napi::Number::New(env, skResult);
  });
  return result;
}

Napi::Value MapOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    SKMapper skmapper = info[1].As<Napi::External<void>>().Data();
    char* skResult = SkipRuntime_Collection__map(skCollection, skmapper);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value MapReduceOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 3) {
    throw Napi::TypeError::New(env, "Must have three parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal() || !info[2].IsExternal()) {
    throw Napi::TypeError::New(
        env, "The second and third parameters must be pointers.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    SKMapper skmapper = info[1].As<Napi::External<void>>().Data();
    SKMapper skreducer = info[2].As<Napi::External<void>>().Data();
    char* skResult =
        SkipRuntime_Collection__mapReduce(skCollection, skmapper, skreducer);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value NativeMapReduceOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 3) {
    throw Napi::TypeError::New(env, "Must have three parameters.");
  }
  if (!info[0].IsString() || !info[2].IsString()) {
    throw Napi::TypeError::New(
        env, "The first and third parameters must be strings.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    SKMapper skmapper = info[1].As<Napi::External<void>>().Data();
    char* reducer = ToSKString(info[2]);
    char* skResult = SkipRuntime_Collection__nativeMapReduce(skCollection,
                                                             skmapper, reducer);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value ReduceOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    SKMapper skreducer = info[1].As<Napi::External<void>>().Data();
    char* skResult = SkipRuntime_Collection__reduce(skCollection, skreducer);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value NativeReduceOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString() || !info[1].IsString()) {
    throw Napi::TypeError::New(env, "Both parameters must be strings.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    char* reducer = ToSKString(info[1]);
    char* skResult =
        SkipRuntime_Collection__nativeReduce(skCollection, reducer);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value SliceOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    CJArray skranges = info[1].As<Napi::External<void>>().Data();
    char* skResult = SkipRuntime_Collection__slice(skCollection, skranges);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value TakeOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsNumber() && !info[1].IsBigInt()) {
    throw Napi::TypeError::New(
        env, "The second parameter must be a number or a bigint.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    int64_t sklimit;
    if (info[1].IsNumber()) {
      sklimit = (int64_t)info[1].As<Napi::Number>().DoubleValue();
    } else {
      bool lossless;
      sklimit = info[1].As<Napi::BigInt>().Int64Value(&lossless);
    }
    char* skResult = SkipRuntime_Collection__take(skCollection, sklimit);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

Napi::Value MergeOfEagerCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    CJArray skotherCollections = info[1].As<Napi::External<void>>().Data();
    char* skResult =
        SkipRuntime_Collection__merge(skCollection, skotherCollections);
    result = Napi::String::New(env, skResult);
  });
  return result;
}

/* NonEmptyIterator: nullable iterator step. */

Napi::Value NextOfNonEmptyIterator(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The first parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    SKNonEmptyIterator skiterator = info[0].As<Napi::External<void>>().Data();
    CJSON skResult = SkipRuntime_NonEmptyIterator__next(skiterator);
    if (skResult != nullptr) {
      result = Napi::External<void>::New(env, skResult);
    } else {
      result = env.Null();
    }
  });
  return result;
}

/* Lazy collection accessor. */

Napi::Value GetArrayOfLazyCollection(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skCollection = ToSKString(info[0]);
    void* skKey = info[1].As<Napi::External<void>>().Data();
    void* skResult = SkipRuntime_LazyCollection__getArray(skCollection, skKey);
    result = Napi::External<void>::New(env, skResult);
  });
  return result;
}

/* Runtime operations exposed to JS. */

Napi::Value CreateResourceOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 3) {
    throw Napi::TypeError::New(env, "Must have three parameters.");
  }
  if (!info[0].IsString() || !info[1].IsString() || !info[2].IsExternal()) {
    throw Napi::TypeError::New(env, "Invalid parameters.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skidentifier = ToSKString(info[0]);
    char* skresource = ToSKString(info[1]);
    CJObject skparams = info[2].As<Napi::External<void>>().Data();
    CJSON skresult =
        SkipRuntime_Runtime__createResource(skidentifier, skresource, skparams);
    result = Napi::External<void>::New(env, skresult);
  });
  return result;
}

Napi::Value CloseResourceOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The parameter must be a string.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skidentifier = ToSKString(info[0]);
    double skerror = SkipRuntime_Runtime__closeResource(skidentifier);
    result = Napi::Number::New(env, skerror);
  });
  return result;
}

Napi::Value UnsubscribeOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The parameter must be a string.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* sksession = ToSKString(info[0]);
    double skerror = SkipRuntime_Runtime__unsubscribe(sksession);
    result = Napi::Number::New(env, skerror);
  });
  return result;
}

/* Subscribe: returns a 64-bit session id wrapped as a JS BigInt. */

Napi::Value SubscribeOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  if (!info[2].IsString() && !info[2].IsNull() && !info[2].IsUndefined()) {
    throw Napi::TypeError::New(
        env, "The third parameter must be a string or undefined.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skidentifier = ToSKString(info[0]);
    SKNotifier sknotifier = info[1].As<Napi::External<void>>().Data();
    char* skwatermark = nullptr;
    if (info[2].IsString()) {
      skwatermark = ToSKString(info[2]);
    }
    int64_t session =
        SkipRuntime_Runtime__subscribe(skidentifier, sknotifier, skwatermark);
    result = Napi::BigInt::New(env, session);
  });
  return result;
}

Napi::Value GetAllOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skresource = ToSKString(info[0]);
    CJObject skparams = info[1].As<Napi::External<void>>().Data();
    CJSON skresult = SkipRuntime_Runtime__getAll(skresource, skparams);
    result = Napi::External<void>::New(env, skresult);
  });
  return result;
}

Napi::Value GetForKeyOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal() || !info[2].IsExternal()) {
    throw Napi::TypeError::New(
        env, "The second and third parameters must be pointers.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skresource = ToSKString(info[0]);
    CJObject skparams = info[1].As<Napi::External<void>>().Data();
    CJSON skkey = info[2].As<Napi::External<void>>().Data();
    CJSON skresult =
        SkipRuntime_Runtime__getForKey(skresource, skparams, skkey);
    result = Napi::External<void>::New(env, skresult);
  });
  return result;
}

Napi::Value UpdateOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The first parameter must be a string.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skinput = ToSKString(info[0]);
    CJSON skvalues = info[1].As<Napi::External<void>>().Data();
    CJSON skresult = SkipRuntime_Runtime__update(skinput, skvalues);
    result = Napi::External<void>::New(env, skresult);
  });
  return result;
}

Napi::Value ForkOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The parameter must be a string.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skname = ToSKString(info[0]);
    double skerror = SkipRuntime_Runtime__fork(skname);
    result = Napi::Number::New(env, skerror);
  });
  return result;
}

Napi::Value MergeOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    double skerror =
        SkipRuntime_Runtime__merge(info[0].As<Napi::External<void>>().Data());
    result = Napi::Number::New(env, skerror);
  });
  return result;
}

Napi::Value AbortForkOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Value result;
  NatTryCatch(env, [&result, env](Napi::Env) {
    double skerror = SkipRuntime_Runtime__abortFork();
    result = Napi::Number::New(env, skerror);
  });
  return result;
}

Napi::Value ForkExistsOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The parameter must be a string.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skname = ToSKString(info[0]);
    uint32_t skexists = SkipRuntime_Runtime__forkExists(skname);
    result = Napi::Boolean::New(env, skexists != 0);
  });
  return result;
}

Napi::Value ReloadOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJSON skresult =
        SkipRuntime_Runtime__reload(info[0].As<Napi::External<void>>().Data());
    result = Napi::External<void>::New(env, skresult);
  });
  return result;
}

Napi::Value CloseResourceStreamsOfRuntime(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    double skerror = SkipRuntime_Runtime__closeResourceStreams(
        info[0].As<Napi::External<void>>().Data());
    result = Napi::Number::New(env, skerror);
  });
  return result;
}

Napi::Value GetSkipPersistentSize(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Value result;
  NatTryCatch(env, [&result, env](Napi::Env) {
    int64_t skresult = SkipRuntime_getSkipPersistentSize();
    result = Napi::Number::New(env, skresult);
  });
  return result;
}

/* Assemble the binding object exposed to JS. */

Napi::Value GetToJSBinding(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Object binding = Napi::Object::New(env);
  AddFunction(env, binding, "SkipRuntime_CollectionWriter__update",
              UpdateOfCollectionWriter);
  //
  AddFunction(env, binding, "SkipRuntime_Context__createLazyCollection",
              CreateLazyCollectionOfContext);
  AddFunction(env, binding, "SkipRuntime_Context__jsonExtract",
              JSONExtractOfContext);
  AddFunction(env, binding, "SkipRuntime_Context__useExternalResource",
              UseExternalResourceOfContext);
  //
  AddFunction(env, binding, "SkipRuntime_createMapper", CreateMapper);
  AddFunction(env, binding, "SkipRuntime_createLazyCompute", CreateLazyCompute);
  AddFunction(env, binding, "SkipRuntime_createResource", CreateResource);
  AddFunction(env, binding, "SkipRuntime_createService", CreateService);
  AddFunction(env, binding, "SkipRuntime_createNotifier", CreateNotifier);
  AddFunction(env, binding, "SkipRuntime_createReducer", CreateReducer);
  //
  AddFunction(env, binding, "SkipRuntime_initService", InitService);
  AddFunction(env, binding, "SkipRuntime_closeService", CloseService);
  //
  AddFunction(env, binding, "SkipRuntime_Collection__getArray",
              GetArrayOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__map",
              MapOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__mapReduce",
              MapReduceOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__nativeMapReduce",
              NativeMapReduceOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__reduce",
              ReduceOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__nativeReduce",
              NativeReduceOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__slice",
              SliceOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__take",
              TakeOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__merge",
              MergeOfEagerCollection);
  AddFunction(env, binding, "SkipRuntime_Collection__size",
              SizeOfEagerCollection);
  //
  AddFunction(env, binding, "SkipRuntime_NonEmptyIterator__next",
              NextOfNonEmptyIterator);
  //
  AddFunction(env, binding, "SkipRuntime_LazyCollection__getArray",
              GetArrayOfLazyCollection);
  //
  AddFunction(env, binding, "SkipRuntime_Runtime__createResource",
              CreateResourceOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__closeResource",
              CloseResourceOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__subscribe",
              SubscribeOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__unsubscribe",
              UnsubscribeOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__getAll", GetAllOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__getForKey",
              GetForKeyOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__update", UpdateOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__fork", ForkOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__merge", MergeOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__abortFork",
              AbortForkOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__forkExists",
              ForkExistsOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__reload", ReloadOfRuntime);
  AddFunction(env, binding, "SkipRuntime_Runtime__closeResourceStreams",
              CloseResourceStreamsOfRuntime);
  AddFunction(env, binding, "SkipRuntime_getSkipPersistentSize",
              GetSkipPersistentSize);
  return binding;
}

}  // namespace skipruntime
