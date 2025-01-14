
#include "tojs.h"

#include <iostream>

#include "common.h"
#include "fromjs.h"

namespace skipruntime {

extern "C" {
double SkipRuntime_CollectionWriter__update(char* collection, CJArray values,
                                            int32_t isInit);
double SkipRuntime_CollectionWriter__loading(char* collection);
double SkipRuntime_CollectionWriter__error(char* collection, CJSON error);

SKResourceBuilderMap SkipRuntime_ResourceBuilderMap__create();
void SkipRuntime_ResourceBuilderMap__add(SKResourceBuilderMap builders,
                                         char* name, SKResourceBuilder builder);

SKExternalServiceMap SkipRuntime_ExternalServiceMap__create();
void SkipRuntime_ExternalServiceMap__add(SKExternalServiceMap services,
                                         char* name, SKExternalService service);

char* SkipRuntime_Context__createLazyCollection(SKLazyCompute lazyCompute);
CJArray SkipRuntime_Context__jsonExtract(CJObject json, char* pattern);
char* SkipRuntime_Context__useExternalResource(char* service, char* identifier,
                                               CJObject json);

SKMapper SkipRuntime_createMapper(int32_t ref);
SKLazyCompute SkipRuntime_createLazyCompute(int32_t ref);
SKExternalService SkipRuntime_createExternalService(int32_t ref);
SKResource SkipRuntime_createResource(int32_t ref);
SKResourceBuilder SkipRuntime_createResourceBuilder(int32_t ref);
SKChecker SkipRuntime_createChecker(int32_t ref);
SKIdentifier SkipRuntime_createIdentifier(char* name);
SKService SkipRuntime_createService(int32_t ref, CJObject inputs,
                                    SKResourceBuilderMap resources,
                                    SKExternalServiceMap exservices);
SKNotifier SkipRuntime_createNotifier(int32_t ref);
SKReducer SkipRuntime_createReducer(int32_t ref, CJSON json);

double SkipRuntime_initService(SKService service);
double SkipRuntime_closeService();

CJArray SkipRuntime_Collection__getArray(char* collection, CJSON key);
CJSON SkipRuntime_Collection__getUnique(char* collection, CJSON key);
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

CJSON SkipRuntime_NonEmptyIterator__first(SKNonEmptyIterator it);
CJSON SkipRuntime_NonEmptyIterator__next(SKNonEmptyIterator it);
CJSON SkipRuntime_NonEmptyIterator__uniqueValue(SKNonEmptyIterator it);
SKNonEmptyIterator SkipRuntime_NonEmptyIterator__clone(SKNonEmptyIterator it);

CJSON SkipRuntime_LazyCollection__getArray(char* handle, CJSON key);
CJSON SkipRuntime_LazyCollection__getUnique(char* handle, CJSON key);

double SkipRuntime_Runtime__createResource(char* identifier, char* resource,
                                           CJObject jsonParams);
double SkipRuntime_Runtime__closeResource(char* identifier);
int64_t SkipRuntime_Runtime__subscribe(char* reactiveId, SKNotifier notifier,
                                       char* watermark);
double SkipRuntime_Runtime__unsubscribe(int64_t id);
CJSON SkipRuntime_Runtime__getAll(char* resource, CJObject jsonParams,
                                  SKRequest optRequest);
CJSON SkipRuntime_Runtime__getForKey(char* resource, CJObject jsonParams,
                                     CJSON key, SKRequest optRequest);
double SkipRuntime_Runtime__update(char* input, CJSON values);
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
  if (args.Length() != 3) {
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
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skcollection = ToSKString(isolate, args[0].As<String>());
    CJArray skvalues = args[1].As<External>()->Value();
    int32_t skisinit = args[1].As<Boolean>()->Value() ? 1 : 0;
    double skerror =
        SkipRuntime_CollectionWriter__update(skcollection, skvalues, skisinit);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void LoadingOfCollectionWriter(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameters.")));
    return;
  };
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a string.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skcollection = ToSKString(isolate, args[0].As<String>());
    double skerror = SkipRuntime_CollectionWriter__loading(skcollection);
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

void CreateOfResourceBuilderMap(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKResourceBuilderMap skmap = SkipRuntime_ResourceBuilderMap__create();
    args.GetReturnValue().Set(External::New(isolate, skmap));
  });
}

void AddOfResourceBuilderMap(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  };
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  if (!args[1]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a string.")));
    return;
  }
  if (!args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The third parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SkipRuntime_ResourceBuilderMap__add(
        args[0].As<External>()->Value(),
        ToSKString(isolate, args[1].As<String>()),
        args[2].As<External>()->Value());
  });
}

void CreateOfExternalServiceMap(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKExternalServiceMap skmap = SkipRuntime_ExternalServiceMap__create();
    args.GetReturnValue().Set(External::New(isolate, skmap));
  });
}

void AddOfExternalServiceMap(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 3) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have three parameters.")));
    return;
  };
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  if (!args[1]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a string.")));
    return;
  }
  if (!args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The third parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SkipRuntime_ExternalServiceMap__add(
        args[0].As<External>()->Value(),
        ToSKString(isolate, args[1].As<String>()),
        args[2].As<External>()->Value());
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

void CreateExternalService(const FunctionCallbackInfo<Value>& args) {
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
    SKExternalService skexternalService =
        SkipRuntime_createExternalService(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skexternalService));
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

void CreateResourceBuilder(const FunctionCallbackInfo<Value>& args) {
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
    SKResourceBuilder skResourceBuilder =
        SkipRuntime_createResourceBuilder(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skResourceBuilder));
  });
}

void CreateChecker(const FunctionCallbackInfo<Value>& args) {
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
    SKChecker skChecker =
        SkipRuntime_createChecker(args[0].As<Int32>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skChecker));
  });
}

void CreateIdentifier(const FunctionCallbackInfo<Value>& args) {
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
    char* skId = ToSKString(isolate, args[0].As<String>());
    SKIdentifier skIdentifier = SkipRuntime_createIdentifier(skId);
    args.GetReturnValue().Set(External::New(isolate, skIdentifier));
  });
}

void CreateService(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 4) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have four parameters.")));
    return;
  };
  if (!args[0]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number.")));
    return;
  }
  if (!args[1]->IsExternal() || !args[2]->IsExternal() ||
      !args[3]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Invalid parameter types.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKService skService = SkipRuntime_createService(
        args[0].As<Int32>()->Value(), args[1].As<External>()->Value(),
        args[2].As<External>()->Value(), args[3].As<External>()->Value());
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
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skerror = SkipRuntime_initService(args[0].As<External>()->Value());
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void CloseService(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skerror = SkipRuntime_closeService();
    args.GetReturnValue().Set(Number::New(isolate, skerror));
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
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skCollection = ToSKString(isolate, args[0].As<String>());
    void* skKey = args[1].As<External>()->Value();
    void* skResult = SkipRuntime_Collection__getArray(skCollection, skKey);
    args.GetReturnValue().Set(External::New(isolate, skResult));
  });
}

void GetUniqueOfEagerCollection(const FunctionCallbackInfo<Value>& args) {
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
    void* skResult = SkipRuntime_Collection__getUnique(skCollection, skKey);
    Local<Value> returnValue;
    if (skResult != nullptr) {
      returnValue = External::New(isolate, skResult);
    } else {
      returnValue = Null(isolate);
    }
    args.GetReturnValue().Set(returnValue);
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

void FirstOfNonEmptyIterator(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKNonEmptyIterator skiterator = args[0].As<External>()->Value();
    CJSON skResult = SkipRuntime_NonEmptyIterator__first(skiterator);
    args.GetReturnValue().Set(External::New(isolate, skResult));
  });
}

void UniqueValueOfNonEmptyIterator(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKNonEmptyIterator skiterator = args[0].As<External>()->Value();
    CJSON skResult = SkipRuntime_NonEmptyIterator__uniqueValue(skiterator);
    Local<Value> returnValue;
    if (skResult != nullptr) {
      returnValue = External::New(isolate, skResult);
    } else {
      returnValue = Null(isolate);
    }
    args.GetReturnValue().Set(returnValue);
  });
}

void CloneOfNonEmptyIterator(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKNonEmptyIterator skiterator = args[0].As<External>()->Value();
    CJSON skcloned = SkipRuntime_NonEmptyIterator__clone(skiterator);
    args.GetReturnValue().Set(External::New(isolate, skcloned));
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

void GetUniqueOfLazyCollection(const FunctionCallbackInfo<Value>& args) {
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
    void* skResult = SkipRuntime_LazyCollection__getUnique(skCollection, skKey);
    args.GetReturnValue().Set(External::New(isolate, skResult));
  });
}

void CreateResourceOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsString() || !args[1]->IsString() || !args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Invalid parameters.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skidentifier = ToSKString(isolate, args[0].As<String>());
    char* skresource = ToSKString(isolate, args[1].As<String>());
    CJObject skparams = args[2].As<External>()->Value();
    double skerror =
        SkipRuntime_Runtime__createResource(skidentifier, skresource, skparams);
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

void UnsubscribeOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
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
  if (!args[2]->IsExternal() && !args[2]->IsNull() && !args[2]->IsUndefined()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The third parameter must be a pointer or undefined.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skresource = ToSKString(isolate, args[0].As<String>());
    CJObject skparams = args[1].As<External>()->Value();
    SKRequest skrequest = nullptr;
    if (args[2]->IsExternal()) {
      skrequest = args[2].As<External>()->Value();
    }
    CJSON skresult =
        SkipRuntime_Runtime__getAll(skresource, skparams, skrequest);
    args.GetReturnValue().Set(External::New(isolate, skresult));
  });
}

void GetForKeyOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (!args[0]->IsString()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The first parameter must be a string.")));
    return;
  }
  if (!args[1]->IsExternal() || !args[2]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The second and third parameters must be pointers.")));
    return;
  }
  if (!args[3]->IsExternal() && !args[3]->IsNull() && !args[3]->IsUndefined()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(FromUtf8(
        isolate, "The fourth parameter must be a pointer or undefined.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skresource = ToSKString(isolate, args[0].As<String>());
    CJObject skparams = args[1].As<External>()->Value();
    CJSON skkey = args[2].As<External>()->Value();
    SKRequest skrequest = nullptr;
    if (args[3]->IsExternal()) {
      skrequest = args[3].As<External>()->Value();
    }
    CJSON skresult =
        SkipRuntime_Runtime__getForKey(skresource, skparams, skkey, skrequest);
    args.GetReturnValue().Set(External::New(isolate, skresult));
  });
}

void UpdateOfRuntime(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
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
    char* skinput = ToSKString(isolate, args[0].As<String>());
    CJSON skvalues = args[1].As<External>()->Value();
    double skerror = SkipRuntime_Runtime__update(skinput, skvalues);
    args.GetReturnValue().Set(Number::New(isolate, skerror));
  });
}

void GetToJSBinding(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  Local<Object> binding = Object::New(isolate);
  AddFunction(isolate, binding, "SkipRuntime_CollectionWriter__update",
              UpdateOfCollectionWriter);
  AddFunction(isolate, binding, "SkipRuntime_CollectionWriter__loading",
              LoadingOfCollectionWriter);
  AddFunction(isolate, binding, "SkipRuntime_CollectionWriter__error",
              ErrorOfCollectionWriter);
  //
  AddFunction(isolate, binding, "SkipRuntime_ResourceBuilderMap__create",
              CreateOfResourceBuilderMap);
  AddFunction(isolate, binding, "SkipRuntime_ResourceBuilderMap__add",
              AddOfResourceBuilderMap);
  //
  AddFunction(isolate, binding, "SkipRuntime_ExternalServiceMap__create",
              CreateOfExternalServiceMap);
  AddFunction(isolate, binding, "SkipRuntime_ExternalServiceMap__add",
              AddOfExternalServiceMap);
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
  AddFunction(isolate, binding, "SkipRuntime_createExternalService",
              CreateExternalService);
  AddFunction(isolate, binding, "SkipRuntime_createResource", CreateResource);
  AddFunction(isolate, binding, "SkipRuntime_createResourceBuilder",
              CreateResourceBuilder);
  AddFunction(isolate, binding, "SkipRuntime_createChecker", CreateChecker);
  AddFunction(isolate, binding, "SkipRuntime_createIdentifier",
              CreateIdentifier);
  AddFunction(isolate, binding, "SkipRuntime_createService", CreateService);
  AddFunction(isolate, binding, "SkipRuntime_createNotifier", CreateNotifier);
  AddFunction(isolate, binding, "SkipRuntime_createReducer", CreateReducer);
  //
  AddFunction(isolate, binding, "SkipRuntime_initService", InitService);
  AddFunction(isolate, binding, "SkipRuntime_closeService", CloseService);
  //
  AddFunction(isolate, binding, "SkipRuntime_Collection__getArray",
              GetArrayOfEagerCollection);
  AddFunction(isolate, binding, "SkipRuntime_Collection__getUnique",
              GetUniqueOfEagerCollection);
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
  AddFunction(isolate, binding, "SkipRuntime_NonEmptyIterator__first",
              FirstOfNonEmptyIterator);
  AddFunction(isolate, binding, "SkipRuntime_NonEmptyIterator__next",
              NextOfNonEmptyIterator);
  AddFunction(isolate, binding, "SkipRuntime_NonEmptyIterator__uniqueValue",
              UniqueValueOfNonEmptyIterator);
  AddFunction(isolate, binding, "SkipRuntime_NonEmptyIterator__clone",
              CloneOfNonEmptyIterator);
  //
  AddFunction(isolate, binding, "SkipRuntime_LazyCollection__getArray",
              GetArrayOfLazyCollection);
  AddFunction(isolate, binding, "SkipRuntime_LazyCollection__getUnique",
              GetUniqueOfLazyCollection);
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

  args.GetReturnValue().Set(binding);
}

}  // namespace skipruntime
