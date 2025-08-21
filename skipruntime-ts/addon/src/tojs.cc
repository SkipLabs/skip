
#include "tojs.h"

#include <iostream>

#include "common.h"
#include "fromjs.h"

namespace skipruntime {

extern "C" {
double SkipRuntime_CollectionWriter__update(char* collection, CJArray values,
                                            int32_t isInit,
                                            SKExecutor executor);
double SkipRuntime_CollectionWriter__initialized(char* collection, CJSON error);
double SkipRuntime_CollectionWriter__error(char* collection, CJSON error);

char* SkipRuntime_Context__createLazyCollection(SKLazyCompute lazyCompute);
CJArray SkipRuntime_Context__jsonExtract(CJObject json, char* pattern);
char* SkipRuntime_Context__useExternalResource(char* extservice,
                                               char* identifier, CJObject json);

SKMapper SkipRuntime_createMapper(int32_t ref);
SKLazyCompute SkipRuntime_createLazyCompute(int32_t ref);
SKResource SkipRuntime_createResource(int32_t ref);
SKExecutor SkipRuntime_createExecutor(int32_t ref);
SKExecutor SkipRuntime_createIntExecutor(int32_t ref);
SKService SkipRuntime_createService(int32_t ref);
SKNotifier SkipRuntime_createNotifier(int32_t ref);
SKReducer SkipRuntime_createReducer(int32_t ref, CJSON json);

double SkipRuntime_initService(char* identifier, SKService service,
                               SKExecutor executor);
double SkipRuntime_closeService(char* identifier);
double SkipRuntime_invalidateCollections(CJArray collections);

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

double SkipRuntime_Runtime__createResource(char* service, char* identifier,
                                           char* resource, CJObject jsonParams,
                                           SKExecutor executor);
double SkipRuntime_Runtime__closeResource(char* identifier);
CJArray SkipRuntime_Runtime__resourceInstances(CJArray resources);
double SkipRuntime_Runtime__reloadResource(char* service, char* resource,
                                           CJObject jsonParams,
                                           SKExecutor executor);
double SkipRuntime_Runtime__replaceActiveResources(char* service,
                                                   CJArray resources);
double SkipRuntime_Runtime__destroyResources(CJArray resources);

int64_t SkipRuntime_Runtime__subscribe(char* reactiveId, SKNotifier notifier,
                                       char* watermark);
double SkipRuntime_Runtime__unsubscribe(int64_t id);
CJSON SkipRuntime_Runtime__getAll(char* service, char* resource,
                                  CJObject jsonParams);
CJSON SkipRuntime_Runtime__getForKey(char* service, char* resource,
                                     CJObject jsonParams, CJSON key);
double SkipRuntime_Runtime__update(char* service, char* input, CJSON values,
                                   SKExecutor executor);
}

using skbinding::AddFunction;
using skbinding::FromUtf8;
using skbinding::NatTryCatch;
using skbinding::ToSKString;
using v8::Array;
using v8::BigInt;
using v8::Boolean;
using v8::Exception;
using v8::External;
using v8::FunctionCallbackInfo;
using v8::Int32;
using v8::Isolate;
using v8::Local;
using v8::MaybeLocal;
using v8::Number;
using v8::Object;
using v8::String;
using v8::Value;

void UpdateOfCollectionWriter(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 4) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  };
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  if (!args[2]->IsBoolean()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The third parameter must be a boolean.")));
    return;
  }
  if (!args[3]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The fourth parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skcollection = ToSKString(isolate, args[0].As<String>());
    CJArray skvalues = args[1].As<External>()->Value();
    int32_t skisinit = args[2].As<Boolean>()->Value() ? 1 : 0;
    SKExecutor skexecutor = args[3].As<External>()->Value();
    double skerror = SkipRuntime_CollectionWriter__update(
        skcollection, skvalues, skisinit, skexecutor);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void InitializedOfCollectionWriter(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  };
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skcollection = ToSKString(isolate, args[0].As<String>());
    CJSON skerr = args[1].As<External>()->Value();
    double skerror =
        SkipRuntime_CollectionWriter__initialized(skcollection, skerr);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void ErrorOfCollectionWriter(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  };
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skcollection = ToSKString(isolate, args[0].As<String>());
    CJSON skerr = args[1].As<External>()->Value();
    double skerror = SkipRuntime_CollectionWriter__error(skcollection, skerr);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void CreateLazyCollectionOfContext(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKLazyCompute sklazyCompute = args[0].As<External>()->Value();
    char* skResult = SkipRuntime_Context__createLazyCollection(sklazyCompute);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void JSONExtractOfContext(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  };
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  if (!args[1]->IsString()) {
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a string.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJArray skResult = SkipRuntime_Context__jsonExtract(
        args[0].As<External>()->Value(),
        ToSKString(isolate, args[1].As<String>()));
    args.GetReturnValue().Set(External::New(isolate, skResult));
  });
}

void UseExternalResourceOfContext(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  };
  if (!args[0]->IsString() || !args[1]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first and second parameters must be string.")));
    return;
  }
  if (!args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The third parameter must be pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skcollection = SkipRuntime_Context__useExternalResource(
        ToSKString(isolate, args[0].As<String>()),
        ToSKString(isolate, args[1].As<String>()),
        args[2].As<External>()->Value());
    args.GetReturnValue().Set(FromUtf8(isolate, skcollection));
  });
}

void CreateMapper(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKMapper skMapper = SkipRuntime_createMapper(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skMapper));
  });
}

void CreateLazyCompute(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKLazyCompute skLazyCompute =
        SkipRuntime_createLazyCompute(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skLazyCompute));
  });
}

void CreateResource(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKResource skResource =
        SkipRuntime_createResource(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skResource));
  });
}

void CreateExecutor(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKExecutor skExecutor =
        SkipRuntime_createExecutor(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skExecutor));
  });
}

void CreateIntExecutor(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKExecutor skExecutor =
        SkipRuntime_createIntExecutor(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skExecutor));
  });
}

void CreateService(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameters.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKService skService =
        SkipRuntime_createService(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skService));
  });
}

void CreateNotifier(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKNotifier skNotifier =
        SkipRuntime_createNotifier(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skNotifier));
  });
}

void CreateReducer(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a number.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKReducer skReducer = SkipRuntime_createReducer(
        args[0].As<Int32>()->Value(), args[1].As<External>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skReducer));
  });
}

void InitService(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameter.")));
    return;
  };
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal() || !args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The second end third parameters must be pointers.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skerror = SkipRuntime_initService(
        ToSKString(isolate, args[0].As<String>()),
        args[1].As<External>()->Value(), args[2].As<External>()->Value());
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void CloseService(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a string.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skresult =
        SkipRuntime_closeService(ToSKString(isolate, args[0].As<String>()));
    args.GetReturnValue().Set(Number::New(isolate, skresult));
  });
}

void InvalidateCollections(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  }
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJArray skcollections = args[0].As<External>()->Value();
    double skresult = SkipRuntime_invalidateCollections(skcollections);
    args.GetReturnValue().Set(Number::New(isolate, skresult));
  });
}

void GetArrayOfEagerCollection(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    void* skKey = args[1].As<External>()->Value();
    void* skResult = SkipRuntime_Collection__getArray(skCollection, skKey);
    args.GetReturnValue().Set(External::New(isolate, skResult));
  });
}

void SizeOfEagerCollection(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a string.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    int64_t skResult = SkipRuntime_Collection__size(skCollection);
    args.GetReturnValue().Set(Number::New(isolate, skResult));
  });
}

void MapOfEagerCollection(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    SKMapper skmapper = args[1].As<External>()->Value();
    char* skResult = SkipRuntime_Collection__map(skCollection, skmapper);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void MapReduceOfEagerCollection(
    const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal() || !args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second and third parameter must be pointers.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    SKMapper skmapper = args[1].As<External>()->Value();
    SKMapper skreducer = args[2].As<External>()->Value();
    char* skResult =
        SkipRuntime_Collection__mapReduce(skCollection, skmapper, skreducer);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void NativeMapReduceOfEagerCollection(
    const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  }
  if (!args[0]->IsString() || !args[2]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first and third parameters must be strings.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }

  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    SKMapper skmapper = args[1].As<External>()->Value();
    char* reducer = ToSKString(isolate, args[2].As<String>());
    char* skResult = SkipRuntime_Collection__nativeMapReduce(skCollection,
                                                             skmapper, reducer);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void ReduceOfEagerCollection(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be pointers.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    SKMapper skreducer = args[1].As<External>()->Value();
    char* skResult = SkipRuntime_Collection__reduce(skCollection, skreducer);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}
void NativeReduceOfEagerCollection(
    const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  }
  if (!args[0]->IsString() || !args[1]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "Both parameters must be strings.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    char* reducer = ToSKString(isolate, args[1].As<String>());
    char* skResult =
        SkipRuntime_Collection__nativeReduce(skCollection, reducer);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void SliceOfEagerCollection(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a pointer.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    CJArray skranges = args[1].As<External>()->Value();
    char* skResult = SkipRuntime_Collection__slice(skCollection, skranges);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void TakeOfEagerCollection(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsNumber() && !args[1]->IsBigInt()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The second parameter must be a number or a bigint.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    int64_t sklimit;
    if (args[1]->IsNumber()) {
      sklimit = (int64_t)args[1].As<Number>()->Value();
    } else {
      sklimit = args[1].As<BigInt>()->Int64Value();
    }
    char* skResult = SkipRuntime_Collection__take(skCollection, sklimit);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void MergeOfEagerCollection(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a pointer.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    CJArray skotherCollections = args[1].As<External>()->Value();
    char* skResult =
        SkipRuntime_Collection__merge(skCollection, skotherCollections);
    args.GetReturnValue().Set(FromUtf8(isolate, skResult));
  });
}

void NextOfNonEmptyIterator(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKNonEmptyIterator skiterator = args[0].As<External>()->Value();
    CJSON skResult = SkipRuntime_NonEmptyIterator__next(skiterator);
    Local<Value> returnValue;
    if (skResult != nullptr) {
      returnValue = External::New(isolate, skResult);
    } else {
      returnValue = Null(isolate);
    }
    args.GetReturnValue().Set(returnValue);
  });
}

void GetArrayOfLazyCollection(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    void* skKey = args[1].As<External>()->Value();
    void* skResult = SkipRuntime_LazyCollection__getArray(skCollection, skKey);
    args.GetReturnValue().Set(External::New(isolate, skResult));
  });
}

void CreateResourceOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 5) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have four parameters.")));
    return;
  }
  if (!args[0]->IsString() || !args[1]->IsString() || !args[2]->IsString() ||
      !args[3]->IsExternal() || !args[4]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Invalid parameters.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skservice = ToSKString(isolate, args[0].As<String>());
    char* skidentifier = ToSKString(isolate, args[1].As<String>());
    char* skresource = ToSKString(isolate, args[2].As<String>());
    CJObject skparams = args[3].As<External>()->Value();
    CJObject skexecutor = args[4].As<External>()->Value();
    double skerror = SkipRuntime_Runtime__createResource(
        skservice, skidentifier, skresource, skparams, skexecutor);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void CloseResourceOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a string.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skidentifier = ToSKString(isolate, args[0].As<String>());
    double skerror = SkipRuntime_Runtime__closeResource(skidentifier);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void ResourceInstancesOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1 || !args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJArray skresources = args[0].As<External>()->Value();
    CJArray skinstances = SkipRuntime_Runtime__resourceInstances(skresources);
    args.GetReturnValue().Set(External::New(isolate, skinstances));
  });
}

void ReloadResourceOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 4) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have four parameters.")));
    return;
  }
  if (!args[0]->IsString() || !args[1]->IsString() || !args[2]->IsExternal() ||
      !args[3]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Invalid parameters.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skservice = ToSKString(isolate, args[0].As<String>());
    char* skresource = ToSKString(isolate, args[1].As<String>());
    CJObject skparams = args[2].As<External>()->Value();
    CJObject skexecutor = args[3].As<External>()->Value();
    double skerror = SkipRuntime_Runtime__reloadResource(skservice, skresource,
                                                         skparams, skexecutor);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void ReplaceActiveResourcesOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2 || !args[0]->IsString() || !args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate,
        "The first parameter must be a string and the second a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skservice = ToSKString(isolate, args[0].As<String>());
    CJArray skresources = args[1].As<External>()->Value();
    double skerror =
        SkipRuntime_Runtime__replaceActiveResources(skservice, skresources);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void DestroyResourcesOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1 || !args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJArray skresources = args[0].As<External>()->Value();
    double skerror = SkipRuntime_Runtime__destroyResources(skresources);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void UnsubscribeOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 2) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have two parameters.")));
    return;
  }
  if (!args[0]->IsNumber() && !args[0]->IsBigInt()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number or a bigint.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    int64_t sksession;
    if (args[0]->IsNumber()) {
      sksession = (int64_t)args[0].As<Number>()->Value();
    } else {
      sksession = args[0].As<BigInt>()->Int64Value();
    }
    double skerror = SkipRuntime_Runtime__unsubscribe(sksession);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void SubscribeOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  }
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  if (!args[2]->IsString() && !args[2]->IsNull() && !args[2]->IsUndefined()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The third parameter must be a string or undefined.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skidentifier = ToSKString(isolate, args[0].As<String>());
    SKNotifier sknotifier = args[1].As<External>()->Value();
    char* skwatermark = nullptr;
    if (args[2]->IsString()) {
      skwatermark = ToSKString(isolate, args[2].As<String>());
    }
    int64_t session =
        SkipRuntime_Runtime__subscribe(skidentifier, sknotifier, skwatermark);
    args.GetReturnValue().Set(BigInt::New(isolate, session));
  });
}

void GetAllOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  }
  if (!args[0]->IsString() || !args[1]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The first and second parameters must be a string.")));
    return;
  }
  if (!args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The third parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skservice = ToSKString(isolate, args[0].As<String>());
    char* skresource = ToSKString(isolate, args[1].As<String>());
    CJObject skparams = args[2].As<External>()->Value();
    CJSON skresult =
        SkipRuntime_Runtime__getAll(skservice, skresource, skparams);
    args.GetReturnValue().Set(External::New(isolate, skresult));
  });
}

void GetForKeyOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 4) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have four parameters.")));
    return;
  }
  if (!args[0]->IsString() || !args[1]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The first and second parameters must be a string.")));
    return;
  }
  if (!args[2]->IsExternal() || !args[3]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The third and fourth parameters must be pointers.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skservice = ToSKString(isolate, args[0].As<String>());
    char* skresource = ToSKString(isolate, args[1].As<String>());
    CJObject skparams = args[2].As<External>()->Value();
    CJSON skkey = args[3].As<External>()->Value();
    CJSON skresult =
        SkipRuntime_Runtime__getForKey(skservice, skresource, skparams, skkey);
    args.GetReturnValue().Set(External::New(isolate, skresult));
  });
}

void UpdateOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 4) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have four parameters.")));
    return;
  }
  if (!args[0]->IsString() || !args[1]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first and second parameters must be strings.")));
    return;
  }
  if (!args[2]->IsExternal() || !args[3]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The third and fours parameters must be pointers.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skservice = ToSKString(isolate, args[0].As<String>());
    char* skinput = ToSKString(isolate, args[1].As<String>());
    CJSON skvalues = args[2].As<External>()->Value();
    SKExecutor skexecutor = args[3].As<External>()->Value();
    double skerror =
        SkipRuntime_Runtime__update(skservice, skinput, skvalues, skexecutor);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void GetToJSBinding(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  Local<Object> binding = Object::New(isolate);
  AddFunction(isolate, binding, "SkipRuntime_CollectionWriter__update",
              UpdateOfCollectionWriter);
  AddFunction(isolate, binding, "SkipRuntime_CollectionWriter__initialized",
              InitializedOfCollectionWriter);
  AddFunction(isolate, binding, "SkipRuntime_CollectionWriter__error",
              ErrorOfCollectionWriter);
  //
  AddFunction(isolate, binding, "SkipRuntime_Context__createLazyCollection",
              CreateLazyCollectionOfContext);
  AddFunction(isolate, binding, "SkipRuntime_Context__jsonExtract",
              JSONExtractOfContext);
  AddFunction(isolate, binding, "SkipRuntime_Context__useExternalResource",
              UseExternalResourceOfContext);
  //
  AddFunction(isolate, binding, "SkipRuntime_createMapper", CreateMapper);
  AddFunction(isolate, binding, "SkipRuntime_createLazyCompute",
              CreateLazyCompute);
  AddFunction(isolate, binding, "SkipRuntime_createResource", CreateResource);
  AddFunction(isolate, binding, "SkipRuntime_createExecutor", CreateExecutor);
  AddFunction(isolate, binding, "SkipRuntime_createIntExecutor",
              CreateIntExecutor);
  AddFunction(isolate, binding, "SkipRuntime_createService", CreateService);
  AddFunction(isolate, binding, "SkipRuntime_createNotifier", CreateNotifier);
  AddFunction(isolate, binding, "SkipRuntime_createReducer", CreateReducer);
  //
  AddFunction(isolate, binding, "SkipRuntime_initService", InitService);
  AddFunction(isolate, binding, "SkipRuntime_closeService", CloseService);
  AddFunction(isolate, binding, "SkipRuntime_invalidateCollections",
              InvalidateCollections);
  //
  AddFunction(isolate, binding, "SkipRuntime_Collection__getArray",
              GetArrayOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__map",
              MapOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__mapReduce",
              MapReduceOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__nativeMapReduce",
              NativeMapReduceOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__reduce",
              ReduceOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__nativeReduce",
              NativeReduceOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__slice",
              SliceOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__take",
              TakeOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__merge",
              MergeOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__size",
              SizeOfEagerCollection);
  //
  AddFunction(isolate, binding, "SkipRuntime_NonEmptyIterator__next",
              NextOfNonEmptyIterator);
  //
  AddFunction(isolate, binding, "SkipRuntime_LazyCollection__getArray",
              GetArrayOfLazyCollection);
  //
  AddFunction(isolate, binding, "SkipRuntime_Runtime__createResource",
              CreateResourceOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__closeResource",
              CloseResourceOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__subscribe",
              SubscribeOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__unsubscribe",
              UnsubscribeOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__getAll", GetAllOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__getForKey",
              GetForKeyOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__update", UpdateOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__resourceInstances",
              ResourceInstancesOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__reloadResource",
              ReloadResourceOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__replaceActiveResources",
              ReplaceActiveResourcesOfRuntime);
  AddFunction(isolate, binding, "SkipRuntime_Runtime__destroyResources",
              DestroyResourcesOfRuntime);
  args.GetReturnValue().Set(binding);
}

}  // namespace skipruntime
