
#include "common.h"

#include <functional>
#include <iostream>
#include <regex>

#define SKCONTEXT void*

namespace skbinding {

using v8::Array;
using v8::Boolean;
using v8::Context;
using v8::Exception;
using v8::External;
using v8::Function;
using v8::FunctionCallback;
using v8::FunctionCallbackInfo;
using v8::FunctionTemplate;
using v8::Isolate;
using v8::Local;
using v8::MaybeLocal;
using v8::Number;
using v8::Object;
using v8::ObjectTemplate;
using v8::Persistent;
using v8::PropertyDescriptor;
using v8::String;
using v8::Symbol;
using v8::TryCatch;
using v8::Value;

extern "C" {
char* sk_get_exception_message(SKError skExn);
void sk_string_check_c_safe(char* str);
char* SkipRuntime_getExceptionStack(SKError error);
char* SkipRuntime_getExceptionType(SKError error);
SKObstack SKIP_new_Obstack();
void SKIP_destroy_Obstack(SKObstack obstack);
}

Local<String> FromUtf8(Isolate* isolate, const char* str) {
  return String::NewFromUtf8(isolate, str).ToLocalChecked();
}

void AddFunction(Isolate* isolate, Local<Object> handler, const char* name,
                 FunctionCallback callback) {
  Local<Context> context = isolate->GetCurrentContext();
  Local<FunctionTemplate> v8Tpl = FunctionTemplate::New(isolate, callback);
  Local<Function> v8Fn = v8Tpl->GetFunction(context).ToLocalChecked();
  handler->Set(context, FromUtf8(isolate, name), v8Fn).FromJust();
}

Local<Value> CallGlobalStaticMethod(Isolate* isolate, const char* className,
                                    const char* methodName, int argc,
                                    Local<Value> argv[]) {
  Local<Context> context = isolate->GetCurrentContext();
  Local<Object> global = context->Global();
  Local<Object> classRef = global->Get(context, FromUtf8(isolate, className))
                               .ToLocalChecked()
                               .As<Object>();
  Local<Function> method = classRef->Get(context, FromUtf8(isolate, methodName))
                               .ToLocalChecked()
                               .As<Function>();
  return method->Call(context, classRef, argc, argv).ToLocalChecked();
}

void Print(Isolate* isolate, const char* prefix, Local<Value> value) {
  v8::String::Utf8Value jsValue(isolate, value);
  const char* val = *jsValue;
  std::cout << prefix << ": " << val << std::endl;
}

Local<Value> JSONStringify(Isolate* isolate, Local<Value> value) {
  Local<Value> argv[1] = {value};
  return CallGlobalStaticMethod(isolate, "JSON", "stringify", 1, argv);
}

extern "C" {
[[noreturn]] void SkipRuntime_throwExternalException(char*, char*, char*);

char* sk_string_create(const char* buffer, uint32_t size);
}

void* SKTryCatch(Isolate* isolate, Local<Function> fn, Local<Value> recv,
                 int argc, Local<Value> argv[],
                 std::function<void*(Isolate*, Local<Value>)> success,
                 std::function<void(Isolate*)> failure) {
  Local<Context> context = isolate->GetCurrentContext();
  TryCatch tryCatch(isolate);
  MaybeLocal<Value> optResult = fn->Call(context, recv, argc, argv);
  if (!tryCatch.HasCaught()) {
    return success(isolate, optResult.ToLocalChecked());
  } else {
    failure(isolate);
    Local<Value> exception = tryCatch.Exception();
    if (exception->IsNativeError()) {
      Local<Context> context = isolate->GetCurrentContext();
      Local<Object> jsObj = exception->ToObject(context).ToLocalChecked();
      char* sktype = ToSKString(isolate, jsObj->GetConstructorName());
      char* skmessage = ToSKString(
          isolate,
          jsObj->Get(context, FromUtf8(isolate, "message")).ToLocalChecked());
      char* skstack = ToSKString(
          isolate,
          jsObj->Get(context, FromUtf8(isolate, "stack")).ToLocalChecked());
      SkipRuntime_throwExternalException(sktype, skmessage, skstack);
    } else if (exception->IsObject()) {
      MaybeLocal<Value> message =
          exception.As<Object>()->Get(context, FromUtf8(isolate, "message"));
      char* skempty = sk_string_create("", 0);
      char* skmessage;
      if (!message.IsEmpty()) {
        skmessage = ToSKString(isolate, message.ToLocalChecked());
      } else {
        Local<Value> jsmessage = JSONStringify(isolate, exception);
        skmessage = ToSKString(isolate, jsmessage);
      }
      SkipRuntime_throwExternalException(skempty, skmessage, skempty);
    } else if (exception->IsString()) {
      char* skempty = sk_string_create("", 0);
      char* skmessage = ToSKString(isolate, exception);
      SkipRuntime_throwExternalException(skempty, skmessage, skempty);
    } else {
      char* skempty = sk_string_create("", 0);
      Local<Value> jsmessage = JSONStringify(isolate, exception);
      char* skmessage = ToSKString(isolate, jsmessage);
      SkipRuntime_throwExternalException(skempty, skmessage, skempty);
    }
    return nullptr;
  }
}

void SKTryCatchVoid(Isolate* isolate, Local<Function> fn, Local<Value> recv,
                    int argc, Local<Value> argv[],
                    std::function<void(Isolate*)> success,
                    std::function<void(Isolate*)> failure) {
  Local<Context> context = isolate->GetCurrentContext();
  TryCatch tryCatch(isolate);
  auto result = fn->Call(context, recv, argc, argv);
  (void)result;
  if (!tryCatch.HasCaught()) {
    success(isolate);
  } else {
    failure(isolate);
    Local<Value> exception = tryCatch.Exception();
    if (exception->IsNativeError()) {
      Local<Context> context = isolate->GetCurrentContext();
      Local<Object> jsObj = exception->ToObject(context).ToLocalChecked();
      char* sktype = ToSKString(isolate, jsObj->GetConstructorName());
      char* skmessage = ToSKString(
          isolate,
          jsObj->Get(context, FromUtf8(isolate, "message")).ToLocalChecked());
      char* skstack = ToSKString(
          isolate,
          jsObj->Get(context, FromUtf8(isolate, "stack")).ToLocalChecked());
      SkipRuntime_throwExternalException(sktype, skmessage, skstack);
    } else if (exception->IsObject()) {
      MaybeLocal<Value> message =
          exception.As<Object>()->Get(context, FromUtf8(isolate, "message"));
      char* skempty = sk_string_create("", 0);
      char* skmessage;
      if (!message.IsEmpty()) {
        skmessage = ToSKString(isolate, message.ToLocalChecked());
      } else {
        Local<Value> jsmessage = JSONStringify(isolate, exception);
        skmessage = ToSKString(isolate, jsmessage);
      }
      SkipRuntime_throwExternalException(skempty, skmessage, skempty);
    } else if (exception->IsString()) {
      char* skempty = sk_string_create("", 0);
      char* skmessage = ToSKString(isolate, exception);
      SkipRuntime_throwExternalException(skempty, skmessage, skempty);
    } else {
      char* skempty = sk_string_create("", 0);
      Local<Value> jsmessage = JSONStringify(isolate, exception);
      char* skmessage = ToSKString(isolate, jsmessage);
      SkipRuntime_throwExternalException(skempty, skmessage, skempty);
    }
  }
}

bool JSCheckFunction(Isolate* isolate, Local<Object> binding,
                     const char* name) {
  Local<Context> context = isolate->GetCurrentContext();
  MaybeLocal<Value> optValue = binding->Get(context, FromUtf8(isolate, name));
  if (optValue.IsEmpty()) {
    std::ostringstream error;
    error << "Missing function"
          << ": " << name;
    isolate->ThrowException(
        Exception::Error(FromUtf8(isolate, error.str().c_str())));
    return false;
  }
  Local<Value> value = optValue.ToLocalChecked();
  if (!value->IsFunction()) {
    std::ostringstream error;
    error << name << " Is not a function";
    isolate->ThrowException(
        Exception::Error(FromUtf8(isolate, error.str().c_str())));
    return false;
  }
  return true;
}

Local<Function> CheckFunction(Isolate* isolate, Local<Object> binding,
                              const char* name) {
  Local<Context> context = isolate->GetCurrentContext();
  MaybeLocal<Value> optValue = binding->Get(context, FromUtf8(isolate, name));
  if (optValue.IsEmpty()) {
    char* skempty = sk_string_create("", 0);
    std::ostringstream error;
    error << "Undefined function"
          << ": " << name;
    std::string strerror(error.str());
    char* skmessage = sk_string_create(strerror.c_str(), strerror.size());
    SkipRuntime_throwExternalException(skempty, skmessage, skempty);
  }
  Local<Value> value = optValue.ToLocalChecked();
  if (!value->IsFunction()) {
    char* skempty = sk_string_create("", 0);
    std::ostringstream error;
    error << "Invalid function"
          << ": " << name;
    std::string strerror(error.str());
    char* skmessage = sk_string_create(strerror.c_str(), strerror.size());
    SkipRuntime_throwExternalException(skempty, skmessage, skempty);
  }
  return value.As<Function>();
}

void CallJSVoidFunction(Isolate* isolate, Local<Object> binding,
                        const char* name, int argc, Local<Value> argv[]) {
  Local<Function> function = CheckFunction(isolate, binding, name);
  SKTryCatchVoid(
      isolate, function, binding, argc, argv, [](Isolate* _i) {},
      [](Isolate* _i) {});
}

void* CallJSFunction(Isolate* isolate, Local<Object> binding, const char* name,
                     int argc, Local<Value> argv[]) {
  Local<Function> function = CheckFunction(isolate, binding, name);
  return SKTryCatch(
      isolate, function, binding, argc, argv,
      [](Isolate* i, Local<Value> result) {
        if (!result->IsExternal()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        return result.As<External>()->Value();
      },
      [](Isolate* _i) {});
}

void* CallJSNullableFunction(Isolate* isolate, Local<Object> binding,
                             const char* name, int argc, Local<Value> argv[]) {
  Local<Function> function = CheckFunction(isolate, binding, name);
  return SKTryCatch(
      isolate, function, binding, argc, argv,
      [](Isolate* _i, Local<Value> result) {
        if (!result->IsExternal() && !result->IsNull()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        if (result->IsExternal()) {
          return result.As<External>()->Value();
        }
        return (void*)nullptr;
      },
      [](Isolate* _i) {});
}

double CallJSNumberFunction(Isolate* isolate, Local<Object> binding,
                            const char* name, int argc, Local<Value> argv[]) {
  Local<Function> function = CheckFunction(isolate, binding, name);
  double returnValue = 0.0;
  SKTryCatch(
      isolate, function, binding, argc, argv,
      [&returnValue](Isolate* _i, Local<Value> result) {
        if (!result->IsNumber()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        returnValue = result.As<Number>()->Value();
        return nullptr;
      },
      [](Isolate* _i) {});
  return returnValue;
}

char* CallJSStringFunction(Isolate* isolate, Local<Object> binding,
                           const char* name, int argc, Local<Value> argv[]) {
  Local<Function> function = CheckFunction(isolate, binding, name);
  return (char*)SKTryCatch(
      isolate, function, binding, argc, argv,
      [](Isolate* isolate, Local<Value> result) {
        if (!result->IsString()) {
          const char* message = "Invalid function return type";
          char* skempty = sk_string_create("", 0);
          char* skmessage = sk_string_create(message, strlen(message));
          SkipRuntime_throwExternalException(skempty, skmessage, skempty);
        }
        String::Utf8Value v8Str(isolate, result.As<String>());
        std::string cppStr(*v8Str);
        return sk_string_create(cppStr.c_str(), cppStr.size());
      },
      [](Isolate* _i) {});
}

void NatTryCatch(Isolate* isolate, std::function<void(Isolate*)> run) {
  try {
    run(isolate);
  } catch (skbinding::SkipException& e) {
    std::ostringstream error;
    error << e.name() << ": " << e.what();
    Local<Value> v8Error =
        Exception::Error(FromUtf8(isolate, error.str().c_str()));
    if (v8Error->IsNativeError()) {
      char* stack = SkipRuntime_getExceptionStack(e.m_skipException);
      if (stack != nullptr && strlen(stack) > 0) {
        sk_string_check_c_safe(stack);
        Local<Context> context = isolate->GetCurrentContext();
        Local<Object> exc = v8Error.As<Object>();
        exc->Set(context, FromUtf8(isolate, "stack"), FromUtf8(isolate, stack))
            .FromJust();
      }
    }
    isolate->ThrowException(v8Error);
  } catch (std::exception& e) {
    const char* what = e.what();
    isolate->ThrowException(Exception::Error(FromUtf8(isolate, what)));
  }
}

void RunWithGC(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameters.")));
    return;
  };
  if (!args[0]->IsFunction()) {
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a function.")));
    return;
  }
  SKObstack obstack = SKIP_new_Obstack();
  Local<Context> context = isolate->GetCurrentContext();
  TryCatch tryCatch(isolate);
  MaybeLocal<Value> optResult =
      args[0].As<Function>()->Call(context, Null(isolate), 0, nullptr);
  if (!tryCatch.HasCaught()) {
    args.GetReturnValue().Set(optResult.ToLocalChecked());
  } else {
    Local<Value> exception = tryCatch.Exception();
    isolate->ThrowException(exception);
  }
  SKIP_destroy_Obstack(obstack);
}

void GetErrorObject(const v8::FunctionCallbackInfo<v8::Value>& args) {
  Isolate* isolate = args.GetIsolate();
  if (args.Length() != 1) {
    isolate->ThrowException(
        Exception::TypeError(FromUtf8(isolate, "Must have one parameters.")));
    return;
  };
  if (!args[0]->IsExternal()) {
    isolate->ThrowException(Exception::TypeError(
        FromUtf8(isolate, "The parameter must be a pointer.")));
    return;
  }
  SKError skExn = args[0].As<External>()->Value();

  std::ostringstream error;
  char* type = SkipRuntime_getExceptionType(skExn);
  sk_string_check_c_safe(type);
  if (strlen(type) > 0) {
    error << type << ": ";
  }
  error << (char*)sk_get_exception_message(skExn);
  Local<Value> v8Error =
      Exception::Error(FromUtf8(isolate, error.str().c_str()));
  if (v8Error->IsNativeError()) {
    char* stack = SkipRuntime_getExceptionStack(skExn);
    if (stack != nullptr && strlen(stack) > 0) {
      sk_string_check_c_safe(stack);
      Local<Context> context = isolate->GetCurrentContext();
      Local<Object> exc = v8Error.As<Object>();
      exc->Set(context, FromUtf8(isolate, "stack"), FromUtf8(isolate, stack))
          .FromJust();
    }
  }
  args.GetReturnValue().Set(v8Error);
}

char* ToSKString(Isolate* isolate, Local<Value> value) {
  String::Utf8Value jsValue(isolate, value);
  const char* strValue = *jsValue;
  return sk_string_create(strValue, strlen(strValue));
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
