
#include "common.h"

#include <functional>  // obsolete since <napi.h> include it
#include <iostream>
#include <sstream>

#define SKCONTEXT void*

namespace skbinding {

extern "C" {
char* sk_get_exception_message(SKError skExn);
void sk_string_check_c_safe(char* str);
char* SkipRuntime_getExceptionStack(SKError error);
char* SkipRuntime_getExceptionType(SKError error);
SKObstack SKIP_new_Obstack();
void SKIP_destroy_Obstack(SKObstack obstack);
char* sk_string_create(const char* buffer, uint32_t size);
}

// Register a C++ function as a named property on a JS object.
void AddFunction(Napi::Env env, Napi::Object handler, const char* name,
                 Napi::Function::Callback callback) {
  handler.Set(name, Napi::Function::New(env, callback, name));
}

// Call a static method on a global JS class (ex. JSON.stringify).
Napi::Value CallGlobalStaticMethod(Napi::Env env, const char* className,
                                   const char* methodName,
                                   const std::vector<napi_value>& args) {
  Napi::Object global = env.Global();
  Napi::Object classRef = global.Get(className).As<Napi::Object>();
  Napi::Function method = classRef.Get(methodName).As<Napi::Function>();
  return method.Call(classRef, args);
}

// Print a JS value to stdout with a prefix.
void Print(Napi::Env /*env*/, const char* prefix, Napi::Value value) {
  std::string val = value.ToString().Utf8Value();
  std::cout << prefix << ": " << val << std::endl;
}

// Convert any JS value to a Skip string, using JS coercion if needed.
char* ToSKString(Napi::Value value) {
  std::string cppStr = value.ToString().Utf8Value();
  return sk_string_create(cppStr.c_str(), cppStr.size());
}

// Serialize a JS value to its JSON string representation.
Napi::Value JSONStringify(Napi::Env env, Napi::Value value) {
  return CallGlobalStaticMethod(env, "JSON", "stringify", {value});
}

// Best-effort stringify: JSON.stringify throws on circular values, so fall
// back to a placeholder rather than let a C++ exception unwind through Skip.
static char* SafeStringifyToSK(Napi::Env env, Napi::Value value) {
  try {
    Napi::Value json = JSONStringify(env, value);
    return ToSKString(json);
  } catch (const Napi::Error&) {
    const char* fallback = "<unserializable exception value>";
    return sk_string_create(fallback, strlen(fallback));
  }
}

extern "C" {
[[noreturn]] void SkipRuntime_throwExternalException(char*, char*, char*);
}

/*
  Internal helper shared by SKTryCatch and SKTryCatchVoid.
  Converts a JS exception into a call to SkipRuntime_throwExternalException.
  N-API semantics, intentionally differing from the old V8 path:
  - an object with a string "stack" is treated as a native error;
  - the type is read from "name" (a subclass without its own name forwards
    "Error", not the constructor name);
  - a non-string message is JSON-stringified.
  Never returns.
*/
static void HandleJSException(Napi::Env env, Napi::Value exception) {
  if (exception.IsObject()) {
    Napi::Object jsObj = exception.As<Napi::Object>();
    Napi::Value stackVal = jsObj.Get("stack");
    if (stackVal.IsString()) {
      Napi::Value nameVal = jsObj.Get("name");
      Napi::Value messageVal = jsObj.Get("message");
      char* sktype =
          nameVal.IsString() ? ToSKString(nameVal) : sk_string_create("", 0);
      char* skmessage = messageVal.IsString() ? ToSKString(messageVal)
                                              : sk_string_create("", 0);
      char* skstack = ToSKString(stackVal);
      SkipRuntime_throwExternalException(sktype, skmessage, skstack);
    }
    Napi::Value messageVal = jsObj.Get("message");
    char* skempty = sk_string_create("", 0);
    char* skmessage;
    if (messageVal.IsString()) {
      skmessage = ToSKString(messageVal);
    } else {
      skmessage = SafeStringifyToSK(env, exception);
    }
    SkipRuntime_throwExternalException(skempty, skmessage, skempty);
  } else if (exception.IsString()) {
    char* skempty = sk_string_create("", 0);
    char* skmessage = ToSKString(exception);
    SkipRuntime_throwExternalException(skempty, skmessage, skempty);
  } else {
    // Primitive non-string (number, boolean, null, undefined)
    char* skempty = sk_string_create("", 0);
    char* skmessage = SafeStringifyToSK(env, exception);
    SkipRuntime_throwExternalException(skempty, skmessage, skempty);
  }
}

/*
  Call a JS function from C++ and forward JS exceptions to the Skip runtime.
  On success, delegates result handling to the `success` lambda.
  On failure, runs `failure` for cleanup before propagating the error.
*/
void* SKTryCatch(Napi::Env env, Napi::Function fn, Napi::Value recv,
                 const std::vector<napi_value>& args,
                 std::function<void*(Napi::Env, Napi::Value)> success,
                 std::function<void(Napi::Env)> failure) {
  try {
    Napi::Value result = fn.Call(recv, args);
    return success(env, result);
  } catch (const Napi::Error& e) {
    failure(env);
    HandleJSException(env, e.Value());
    return nullptr;
  }
}

// Same as SKTryCatch but for JS functions whose return value is unused.
void SKTryCatchVoid(Napi::Env env, Napi::Function fn, Napi::Value recv,
                    const std::vector<napi_value>& args,
                    std::function<void(Napi::Env)> success,
                    std::function<void(Napi::Env)> failure) {
  try {
    fn.Call(recv, args);
    success(env);
  } catch (const Napi::Error& e) {
    failure(env);
    HandleJSException(env, e.Value());
  }
}

/*
  Check that a binding property exists and is a function.
  On failure, throws a JS-visible error and returns false.
*/
bool JSCheckFunction(Napi::Object binding, const char* name) {
  Napi::Env env = binding.Env();
  Napi::Value value = binding.Get(name);
  if (value.IsUndefined()) {
    std::ostringstream error;
    error << "Missing function: " << name;
    Napi::Error::New(env, error.str()).ThrowAsJavaScriptException();
    return false;
  }
  if (!value.IsFunction()) {
    std::ostringstream error;
    error << name << " is not a function";
    Napi::Error::New(env, error.str()).ThrowAsJavaScriptException();
    return false;
  }
  return true;
}

/*
  Retrieve a function from the binding object.
  On failure, throws a Skip runtime exception instead of a JS one,
  so the error integrates with Skip's internal mechanism.
*/
Napi::Function CheckFunction(Napi::Object binding, const char* name) {
  Napi::Value value = binding.Get(name);
  if (value.IsUndefined()) {
    std::ostringstream error;
    error << "Undefined function: " << name;
    std::string msg = error.str();
    char* skempty = sk_string_create("", 0);
    char* skmessage = sk_string_create(msg.c_str(), msg.size());
    SkipRuntime_throwExternalException(skempty, skmessage, skempty);
  }
  if (!value.IsFunction()) {
    std::ostringstream error;
    error << "Invalid function: " << name;
    std::string msg = error.str();
    char* skempty = sk_string_create("", 0);
    char* skmessage = sk_string_create(msg.c_str(), msg.size());
    SkipRuntime_throwExternalException(skempty, skmessage, skempty);
  }
  return value.As<Napi::Function>();
}

/*
  Typed wrappers around SKTryCatch for common JS return types.
  The `env` parameter is currently unused (Napi::Env is derived from `binding`)
  but kept in the signature to preserve the existing API contract.
*/
void CallJSVoidFunction(Napi::Env /*env*/, Napi::Object binding,
                        const char* name, const std::vector<napi_value>& args) {
  Napi::Function function = CheckFunction(binding, name);
  SKTryCatchVoid(
      binding.Env(), function, binding, args, [](Napi::Env) {},
      [](Napi::Env) {});
}

void* CallJSFunction(Napi::Env /*env*/, Napi::Object binding, const char* name,
                     const std::vector<napi_value>& args) {
  Napi::Function function = CheckFunction(binding, name);
  return SKTryCatch(
      binding.Env(), function, binding, args,
      [](Napi::Env, Napi::Value result) -> void* {
        if (!result.IsExternal()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        return result.As<Napi::External<void>>().Data();
      },
      [](Napi::Env) {});
}

void* CallJSNullableFunction(Napi::Env /*env*/, Napi::Object binding,
                             const char* name,
                             const std::vector<napi_value>& args) {
  Napi::Function function = CheckFunction(binding, name);
  return SKTryCatch(
      binding.Env(), function, binding, args,
      [](Napi::Env, Napi::Value result) -> void* {
        if (!result.IsExternal() && !result.IsNull()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        if (result.IsExternal()) {
          return result.As<Napi::External<void>>().Data();
        }
        return (void*)nullptr;
      },
      [](Napi::Env) {});
}

double CallJSNumberFunction(Napi::Env /*env*/, Napi::Object binding,
                            const char* name,
                            const std::vector<napi_value>& args) {
  Napi::Function function = CheckFunction(binding, name);
  double returnValue = 0.0;
  SKTryCatch(
      binding.Env(), function, binding, args,
      [&returnValue](Napi::Env, Napi::Value result) -> void* {
        if (!result.IsNumber()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        returnValue = result.As<Napi::Number>().DoubleValue();
        return nullptr;
      },
      [](Napi::Env) {});
  return returnValue;
}

char* CallJSStringFunction(Napi::Env /*env*/, Napi::Object binding,
                           const char* name,
                           const std::vector<napi_value>& args) {
  Napi::Function function = CheckFunction(binding, name);
  return (char*)SKTryCatch(
      binding.Env(), function, binding, args,
      [](Napi::Env, Napi::Value result) -> void* {
        if (!result.IsString()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        std::string cppStr = result.As<Napi::String>().Utf8Value();
        return sk_string_create(cppStr.c_str(), cppStr.size());
      },
      [](Napi::Env) {});
}

char* CallJSNullableStringFunction(Napi::Env /*env*/, Napi::Object binding,
                                   const char* name,
                                   const std::vector<napi_value>& args) {
  Napi::Function function = CheckFunction(binding, name);
  return (char*)SKTryCatch(
      binding.Env(), function, binding, args,
      [](Napi::Env, Napi::Value result) -> void* {
        if (!result.IsString() && !result.IsNull()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        if (result.IsNull()) {
          return (void*)nullptr;
        }
        std::string cppStr = result.As<Napi::String>().Utf8Value();
        return (void*)sk_string_create(cppStr.c_str(), cppStr.size());
      },
      [](Napi::Env) {});
}

/*
  Catches Skip and std::exception errors raised by C++ code
  invoked from JS, and re-throws them as JS-visible errors.
  With NAPI_CPP_EXCEPTIONS enabled, Napi::Error propagates automatically
  and does not need to be handled here.
*/
void NatTryCatch(Napi::Env env, std::function<void(Napi::Env)> run) {
  try {
    run(env);
  } catch (skbinding::SkipException& e) {
    std::ostringstream error;
    error << e.name() << ": " << e.what();
    Napi::Error napiError = Napi::Error::New(env, error.str());
    char* stack = SkipRuntime_getExceptionStack(e.m_skipException);
    if (stack != nullptr && strlen(stack) > 0) {
      sk_string_check_c_safe(stack);
      napiError.Value().Set("stack", Napi::String::New(env, stack));
    }
    napiError.ThrowAsJavaScriptException();
  } catch (const Napi::Error&) {
    throw;
  } catch (std::exception& e) {
    Napi::Error::New(env, e.what()).ThrowAsJavaScriptException();
  }
}

/*
  Functions exposed directly to JS via main.cc bindings.
  They follow the node-addon-api callback signature:
  Napi::Value(const Napi::CallbackInfo&).
*/
Napi::Value RunWithGC(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsFunction()) {
    throw Napi::TypeError::New(env, "The parameter must be a function.");
  }
  SKObstack obstack = SKIP_new_Obstack();
  Napi::Function fn = info[0].As<Napi::Function>();
  try {
    Napi::Value result = fn.Call(env.Null(), {});
    SKIP_destroy_Obstack(obstack);
    return result;
  } catch (...) {
    SKIP_destroy_Obstack(obstack);
    throw;
  }
}

Napi::Value GetErrorObject(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  if (info.Length() != 1) {
    throw Napi::TypeError::New(env, "Must have one parameter.");
  }
  if (!info[0].IsExternal()) {
    throw Napi::TypeError::New(env, "The parameter must be a pointer.");
  }
  SKError skExn = info[0].As<Napi::External<void>>().Data();

  std::ostringstream error;
  char* type = SkipRuntime_getExceptionType(skExn);
  sk_string_check_c_safe(type);
  if (strlen(type) > 0) {
    error << type << ": ";
  }
  error << (char*)sk_get_exception_message(skExn);
  Napi::Error napiError = Napi::Error::New(env, error.str());
  char* stack = SkipRuntime_getExceptionStack(skExn);
  if (stack != nullptr && strlen(stack) > 0) {
    sk_string_check_c_safe(stack);
    napiError.Value().Set("stack", Napi::String::New(env, stack));
  }
  return napiError.Value();
}

const char* SkipException::what() const noexcept {
  char* str = (char*)sk_get_exception_message(m_skipException);
  sk_string_check_c_safe(str);
  return str;
}

const char* SkipException::name() const noexcept {
  char* str = (char*)SkipRuntime_getExceptionType(m_skipException);
  sk_string_check_c_safe(str);
  return str;
}

}  // namespace skbinding
