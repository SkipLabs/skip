#include "cjson.h"

#include <iostream>

#include "common.h"

extern "C" {
// object
PartialCJObj SKIP_SKJSON_startCJObject();
void SKIP_SKJSON_addToCJObject(PartialCJObj obj, char* name, CJSON value);
CJObject SKIP_SKJSON_endCJObject(PartialCJObj obj);
// array
PartialCJArr SKIP_SKJSON_startCJArray();
void SKIP_SKJSON_addToCJArray(PartialCJArr arr, CJSON value);
CJArray SKIP_SKJSON_endCJArray(PartialCJArr arr);
// primitives
CJSON SKIP_SKJSON_createCJNull();
CJSON SKIP_SKJSON_createCJInt(int64_t v);
CJSON SKIP_SKJSON_createCJFloat(double v);
CJSON SKIP_SKJSON_createCJString(char* str);
CJSON SKIP_SKJSON_createCJBool(bool v);

double SKIP_SKJSON_typeOf(CJSON json);
double SKIP_SKJSON_asNumber(CJSON json);
int32_t SKIP_SKJSON_asBoolean(CJSON json);
char* SKIP_SKJSON_asString(CJSON json);
CJObject SKIP_SKJSON_asObject(CJSON json);
CJArray SKIP_SKJSON_asArray(CJSON json);
//
char* SKIP_SKJSON_fieldAt(CJObject json, double idx);
CJSON SKIP_SKJSON_get(CJObject json, double idx);
CJSON SKIP_SKJSON_at(CJArray json, double idx);
//
double SKIP_SKJSON_objectSize(CJSON json);
double SKIP_SKJSON_arraySize(CJArray json);
}

namespace skjson {

using skbinding::AddFunction;
using skbinding::FromUtf8;
using skbinding::NatTryCatch;
using skbinding::ToSKString;
using v8::Array;
using v8::BigInt;
using v8::Boolean;
using v8::Context;
using v8::Exception;
using v8::External;
using v8::Function;
using v8::FunctionCallback;
using v8::FunctionCallbackInfo;
using v8::FunctionTemplate;
using v8::HandleScope;
using v8::Int32;
using v8::Isolate;
using v8::Local;
using v8::MaybeLocal;
using v8::Null;
using v8::Number;
using v8::Object;
using v8::Proxy;
using v8::String;
using v8::Uint32;
using v8::Undefined;
using v8::Value;

void StartCJObject(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    PartialCJObj skobject = SKIP_SKJSON_startCJObject();
    args.GetReturnValue().Set(External::New(isolate, skobject));
  });
}

void AddToCJObject(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
    SKIP_SKJSON_addToCJObject(args[0].As<External>()->Value(),
                              ToSKString(isolate, args[1].As<String>()),
                              args[2].As<External>()->Value());
  });
}

void EndCJObject(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
    CJObject skobject =
        SKIP_SKJSON_endCJObject(args[0].As<External>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skobject));
  });
}

void StartCJArray(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    PartialCJArr skarray = SKIP_SKJSON_startCJArray();
    args.GetReturnValue().Set(External::New(isolate, skarray));
  });
}

void AddToCJArray(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
  if (args.Length() != 2) {
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
  if (!args[1]->IsExternal()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a pointer.")));
    return;
  }
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    SKIP_SKJSON_addToCJArray(args[0].As<External>()->Value(),
                             args[1].As<External>()->Value());
  });
}

void EndCJArray(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
    CJArray skarray = SKIP_SKJSON_endCJArray(args[0].As<External>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skarray));
  });
}

void CreateCJNull(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJSON sknull = SKIP_SKJSON_createCJNull();
    args.GetReturnValue().Set(External::New(isolate, sknull));
  });
}

void CreateCJInt(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsNumber() && !args[0]->IsBigInt()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a number or a bigint.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    int64_t skvalue;
    if (args[0]->IsNumber()) {
      skvalue = (int64_t)args[0].As<Number>()->Value();
    } else {
      skvalue = args[0].As<BigInt>()->Int64Value();
    }
    CJSON skint = SKIP_SKJSON_createCJInt(skvalue);
    args.GetReturnValue().Set(External::New(isolate, skint));
  });
}

void CreateCJFloat(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skvalue = args[0].As<Number>()->Value();
    CJSON skfloat = SKIP_SKJSON_createCJFloat(skvalue);
    args.GetReturnValue().Set(External::New(isolate, skfloat));
  });
}

void CreateCJString(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skvalue = ToSKString(isolate, args[0].As<String>());
    CJSON skstring = SKIP_SKJSON_createCJString(skvalue);
    args.GetReturnValue().Set(External::New(isolate, skstring));
  });
}

void CreateCJBool(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
  if (args.Length() != 1) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameter.")));
    return;
  };
  if (!args[0]->IsBoolean()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a boolean.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    bool skvalue = args[0].As<Boolean>()->Value();
    CJSON skbool = SKIP_SKJSON_createCJFloat(skvalue);
    args.GetReturnValue().Set(External::New(isolate, skbool));
  });
}

void TypeOf(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double sktype = SKIP_SKJSON_typeOf(args[0].As<External>()->Value());
    args.GetReturnValue().Set(Number::New(isolate, sktype));
  });
}

void AsNumber(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skvalue = SKIP_SKJSON_asNumber(args[0].As<External>()->Value());
    args.GetReturnValue().Set(Number::New(isolate, skvalue));
  });
}

void AsBoolean(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    int32_t skvalue = SKIP_SKJSON_asBoolean(args[0].As<External>()->Value());
    args.GetReturnValue().Set(Boolean::New(isolate, (bool)skvalue));
  });
}

void AsString(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skvalue = SKIP_SKJSON_asString(args[0].As<External>()->Value());
    args.GetReturnValue().Set(FromUtf8(isolate, skvalue));
  });
}

void AsObject(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJObject object = SKIP_SKJSON_asObject(args[0].As<External>()->Value());
    args.GetReturnValue().Set(External::New(isolate, object));
  });
}

void AsArray(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJArray array = SKIP_SKJSON_asArray(args[0].As<External>()->Value());
    args.GetReturnValue().Set(External::New(isolate, array));
  });
}

void FieldAt(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  if (!args[1]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a number.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    char* skvalue = SKIP_SKJSON_fieldAt(args[0].As<External>()->Value(),
                                        args[1].As<Number>()->Value());
    args.GetReturnValue().Set(FromUtf8(isolate, skvalue));
  });
}

void Get(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  if (!args[1]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a number.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJSON skvalue = SKIP_SKJSON_get(args[0].As<External>()->Value(),
                                    args[1].As<Number>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skvalue));
  });
}

void At(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  if (!args[1]->IsNumber()) {
    // Throw an Error that is passed back to JavaScript
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The second parameter must be a number.")));
    return;
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    CJSON skvalue = SKIP_SKJSON_at(args[0].As<External>()->Value(),
                                   args[1].As<Number>()->Value());
    args.GetReturnValue().Set(External::New(isolate, skvalue));
  });
}

void ObjectSize(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skvalue = SKIP_SKJSON_objectSize(args[0].As<External>()->Value());
    args.GetReturnValue().Set(Number::New(isolate, skvalue));
  });
}

void ArraySize(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
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
  };
  NatTryCatch(isolate, [&args](Isolate* isolate) {
    double skvalue = SKIP_SKJSON_arraySize(args[0].As<External>()->Value());
    args.GetReturnValue().Set(Number::New(isolate, skvalue));
  });
}

void GetBinding(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  HandleScope scope(isolate);
  Local<Object> binding = Object::New(isolate);
  AddFunction(isolate, binding, "SKIP_SKJSON_startCJObject", StartCJObject);
  AddFunction(isolate, binding, "SKIP_SKJSON_addToCJObject", AddToCJObject);
  AddFunction(isolate, binding, "SKIP_SKJSON_endCJObject", EndCJObject);

  AddFunction(isolate, binding, "SKIP_SKJSON_startCJArray", StartCJArray);
  AddFunction(isolate, binding, "SKIP_SKJSON_addToCJArray", AddToCJArray);
  AddFunction(isolate, binding, "SKIP_SKJSON_endCJArray", EndCJArray);

  AddFunction(isolate, binding, "SKIP_SKJSON_createCJNull", CreateCJNull);
  AddFunction(isolate, binding, "SKIP_SKJSON_createCJInt", CreateCJInt);
  AddFunction(isolate, binding, "SKIP_SKJSON_createCJFloat", CreateCJFloat);
  AddFunction(isolate, binding, "SKIP_SKJSON_createCJString", CreateCJString);
  AddFunction(isolate, binding, "SKIP_SKJSON_createCJBool", CreateCJBool);

  AddFunction(isolate, binding, "SKIP_SKJSON_typeOf", TypeOf);
  AddFunction(isolate, binding, "SKIP_SKJSON_asNumber", AsNumber);
  AddFunction(isolate, binding, "SKIP_SKJSON_asBoolean", AsBoolean);
  AddFunction(isolate, binding, "SKIP_SKJSON_asString", AsString);
  AddFunction(isolate, binding, "SKIP_SKJSON_asObject", AsObject);
  AddFunction(isolate, binding, "SKIP_SKJSON_asArray", AsArray);

  AddFunction(isolate, binding, "SKIP_SKJSON_fieldAt", FieldAt);
  AddFunction(isolate, binding, "SKIP_SKJSON_get", Get);
  AddFunction(isolate, binding, "SKIP_SKJSON_at", At);

  AddFunction(isolate, binding, "SKIP_SKJSON_objectSize", ObjectSize);
  AddFunction(isolate, binding, "SKIP_SKJSON_arraySize", ArraySize);

  args.GetReturnValue().Set(binding);
}

}  // namespace skjson
