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
CJSON SKIP_SKJSON_createCJInt(double v);
CJSON SKIP_SKJSON_createCJFloat(double v);
CJSON SKIP_SKJSON_createCJString(char* str);
CJSON SKIP_SKJSON_createCJBool(bool v);

double SKIP_SKJSON_typeOf(CJSON json);
double SKIP_SKJSON_asNumber(CJSON json);
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
using skbinding::NatTryCatch;
using skbinding::ToSKString;

/* CJObject builders: open / fill / close pattern. */

Napi::Value StartCJObject(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Value result;
  NatTryCatch(env, [&result, env](Napi::Env) {
    PartialCJObj skobject = SKIP_SKJSON_startCJObject();
    result = Napi::External<void>::New(env, skobject);
  });
  return result;
}

Napi::Value AddToCJObject(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 3) {
    throw Napi::TypeError::New(env, "Must have three parameters.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The first parameter must be a pointer.");
  }
  if (!info[1].IsString()) {
    throw Napi::TypeError::New(env, "The second parameter must be a string.");
  }
  if (!info[2].IsExternal()) {
    throw Napi::TypeError::New(env, "The third parameter must be a pointer.");
  }
  NatTryCatch(env, [&info](Napi::Env) {
    SKIP_SKJSON_addToCJObject(info[0].As<Napi::External<void>>().Data(),
                              ToSKString(info[1]),
                              info[2].As<Napi::External<void>>().Data());
  });
  return env.Undefined();
}

Napi::Value EndCJObject(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJObject skobject =
        SKIP_SKJSON_endCJObject(info[0].As<Napi::External<void>>().Data());
    result = Napi::External<void>::New(env, skobject);
  });
  return result;
}

/* CJArray builders: same pattern as CJObject. */

Napi::Value StartCJArray(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Value result;
  NatTryCatch(env, [&result, env](Napi::Env) {
    PartialCJArr skarray = SKIP_SKJSON_startCJArray();
    result = Napi::External<void>::New(env, skarray);
  });
  return result;
}

Napi::Value AddToCJArray(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The first parameter must be a pointer.");
  }
  if (!info[1].IsExternal()) {
    throw Napi::TypeError::New(env, "The second parameter must be a pointer.");
  }
  NatTryCatch(env, [&info](Napi::Env) {
    SKIP_SKJSON_addToCJArray(info[0].As<Napi::External<void>>().Data(),
                             info[1].As<Napi::External<void>>().Data());
  });
  return env.Undefined();
}

Napi::Value EndCJArray(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJArray skarray =
        SKIP_SKJSON_endCJArray(info[0].As<Napi::External<void>>().Data());
    result = Napi::External<void>::New(env, skarray);
  });
  return result;
}

/* Primitive constructors: each wraps a single SKIP_SKJSON_create* call. */

Napi::Value CreateCJNull(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Value result;
  NatTryCatch(env, [&result, env](Napi::Env) {
    CJSON sknull = SKIP_SKJSON_createCJNull();
    result = Napi::External<void>::New(env, sknull);
  });
  return result;
}

Napi::Value CreateCJInt(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber() && !info[0].IsBigInt()) {
    throw Napi::TypeError::New(env,
                               "The parameter must be a number or a bigint.");
  }
  double skvalue;
  if (info[0].IsBigInt()) {
    bool lossless;
    int64_t int64value = info[0].As<Napi::BigInt>().Int64Value(&lossless);
    if (!lossless) {
      throw Napi::RangeError::New(env, "BigInt out of int64 range.");
    }
    skvalue = (double)int64value;
  } else {
    skvalue = info[0].As<Napi::Number>().DoubleValue();
  }
  Napi::Value result;
  NatTryCatch(env, [&result, skvalue, env](Napi::Env) {
    CJSON skint = SKIP_SKJSON_createCJInt(skvalue);
    result = Napi::External<void>::New(env, skint);
  });
  return result;
}

Napi::Value CreateCJFloat(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsNumber()) {
    throw Napi::TypeError::New(env, "The parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    double skvalue = info[0].As<Napi::Number>().DoubleValue();
    CJSON skfloat = SKIP_SKJSON_createCJFloat(skvalue);
    result = Napi::External<void>::New(env, skfloat);
  });
  return result;
}

Napi::Value CreateCJString(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsString()) {
    throw Napi::TypeError::New(env, "The parameter must be a string.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skvalue = ToSKString(info[0]);
    CJSON skstring = SKIP_SKJSON_createCJString(skvalue);
    result = Napi::External<void>::New(env, skstring);
  });
  return result;
}

Napi::Value CreateCJBool(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsBoolean()) {
    throw Napi::TypeError::New(env, "The parameter must be a boolean.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    bool skvalue = info[0].As<Napi::Boolean>().Value();
    CJSON skbool = SKIP_SKJSON_createCJBool(skvalue);
    result = Napi::External<void>::New(env, skbool);
  });
  return result;
}

/* Type introspection and value extraction. */

Napi::Value TypeOf(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    double sktype =
        SKIP_SKJSON_typeOf(info[0].As<Napi::External<void>>().Data());
    result = Napi::Number::New(env, sktype);
  });
  return result;
}

Napi::Value AsNumber(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    double skvalue =
        SKIP_SKJSON_asNumber(info[0].As<Napi::External<void>>().Data());
    result = Napi::Number::New(env, skvalue);
  });
  return result;
}

Napi::Value AsString(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skvalue =
        SKIP_SKJSON_asString(info[0].As<Napi::External<void>>().Data());
    result = Napi::String::New(env, skvalue);
  });
  return result;
}

Napi::Value AsObject(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJObject object =
        SKIP_SKJSON_asObject(info[0].As<Napi::External<void>>().Data());
    result = Napi::External<void>::New(env, object);
  });
  return result;
}

Napi::Value AsArray(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJArray array =
        SKIP_SKJSON_asArray(info[0].As<Napi::External<void>>().Data());
    result = Napi::External<void>::New(env, array);
  });
  return result;
}

/* Indexed accessors and size queries. */

Napi::Value FieldAt(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The first parameter must be a pointer.");
  }
  if (!info[1].IsNumber()) {
    throw Napi::TypeError::New(env, "The second parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    char* skvalue =
        SKIP_SKJSON_fieldAt(info[0].As<Napi::External<void>>().Data(),
                            info[1].As<Napi::Number>().DoubleValue());
    result = Napi::String::New(env, skvalue);
  });
  return result;
}

Napi::Value Get(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The first parameter must be a pointer.");
  }
  if (!info[1].IsNumber()) {
    throw Napi::TypeError::New(env, "The second parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJSON skvalue = SKIP_SKJSON_get(info[0].As<Napi::External<void>>().Data(),
                                    info[1].As<Napi::Number>().DoubleValue());
    result = Napi::External<void>::New(env, skvalue);
  });
  return result;
}

Napi::Value At(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 2) {
    throw Napi::TypeError::New(env, "Must have two parameters.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The first parameter must be a pointer.");
  }
  if (!info[1].IsNumber()) {
    throw Napi::TypeError::New(env, "The second parameter must be a number.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    CJSON skvalue = SKIP_SKJSON_at(info[0].As<Napi::External<void>>().Data(),
                                   info[1].As<Napi::Number>().DoubleValue());
    result = Napi::External<void>::New(env, skvalue);
  });
  return result;
}

Napi::Value ObjectSize(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    double skvalue =
        SKIP_SKJSON_objectSize(info[0].As<Napi::External<void>>().Data());
    result = Napi::Number::New(env, skvalue);
  });
  return result;
}

Napi::Value ArraySize(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  Napi::Value result;
  NatTryCatch(env, [&result, &info, env](Napi::Env) {
    double skvalue =
        SKIP_SKJSON_arraySize(info[0].As<Napi::External<void>>().Data());
    result = Napi::Number::New(env, skvalue);
  });
  return result;
}

/* Assemble the binding object exposed to JS. */

Napi::Value GetBinding(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Object binding = Napi::Object::New(env);
  AddFunction(env, binding, "SKIP_SKJSON_startCJObject", StartCJObject);
  AddFunction(env, binding, "SKIP_SKJSON_addToCJObject", AddToCJObject);
  AddFunction(env, binding, "SKIP_SKJSON_endCJObject", EndCJObject);

  AddFunction(env, binding, "SKIP_SKJSON_startCJArray", StartCJArray);
  AddFunction(env, binding, "SKIP_SKJSON_addToCJArray", AddToCJArray);
  AddFunction(env, binding, "SKIP_SKJSON_endCJArray", EndCJArray);

  AddFunction(env, binding, "SKIP_SKJSON_createCJNull", CreateCJNull);
  AddFunction(env, binding, "SKIP_SKJSON_createCJInt", CreateCJInt);
  AddFunction(env, binding, "SKIP_SKJSON_createCJFloat", CreateCJFloat);
  AddFunction(env, binding, "SKIP_SKJSON_createCJString", CreateCJString);
  AddFunction(env, binding, "SKIP_SKJSON_createCJBool", CreateCJBool);

  AddFunction(env, binding, "SKIP_SKJSON_typeOf", TypeOf);
  AddFunction(env, binding, "SKIP_SKJSON_asNumber", AsNumber);
  AddFunction(env, binding, "SKIP_SKJSON_asString", AsString);
  AddFunction(env, binding, "SKIP_SKJSON_asObject", AsObject);
  AddFunction(env, binding, "SKIP_SKJSON_asArray", AsArray);

  AddFunction(env, binding, "SKIP_SKJSON_fieldAt", FieldAt);
  AddFunction(env, binding, "SKIP_SKJSON_get", Get);
  AddFunction(env, binding, "SKIP_SKJSON_at", At);

  AddFunction(env, binding, "SKIP_SKJSON_objectSize", ObjectSize);
  AddFunction(env, binding, "SKIP_SKJSON_arraySize", ArraySize);

  return binding;
}

}  // namespace skjson
