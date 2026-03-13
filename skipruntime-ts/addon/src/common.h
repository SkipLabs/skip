// common.h
#ifndef SKCOMMON_H
#define SKCOMMON_H

#include <node.h>

#include <string>

namespace skbinding {
v8::Local<v8::String> FromUtf8(v8::Isolate*, const char*);
void AddFunction(v8::Isolate*, v8::Local<v8::Object>, const char*,
                 v8::FunctionCallback callback);
v8::Local<v8::Value> CallGlobalStaticMethod(v8::Isolate*, const char*,
                                            const char*, int,
                                            v8::Local<v8::Value> argv[]);
void* SKTryCatch(v8::Isolate*, v8::Local<v8::Function>, v8::Local<v8::Value>,
                 int, v8::Local<v8::Value>[],
                 std::function<void*(v8::Isolate*, v8::Local<v8::Value>)>,
                 std::function<void(v8::Isolate*)>);
void SKTryCatchVoid(v8::Isolate*, v8::Local<v8::Function>, v8::Local<v8::Value>,
                    int, v8::Local<v8::Value>[],
                    std::function<void(v8::Isolate*)>,
                    std::function<void(v8::Isolate*)>);
void CallJSVoidFunction(v8::Isolate*, v8::Local<v8::Object>, const char*, int,
                        v8::Local<v8::Value>[]);
void* CallJSFunction(v8::Isolate*, v8::Local<v8::Object>, const char*, int,
                     v8::Local<v8::Value>[]);
void* CallJSNullableFunction(v8::Isolate*, v8::Local<v8::Object>, const char*,
                             int, v8::Local<v8::Value>[]);
double CallJSNumberFunction(v8::Isolate*, v8::Local<v8::Object>, const char*,
                            int, v8::Local<v8::Value>[]);
char* CallJSStringFunction(v8::Isolate*, v8::Local<v8::Object>, const char*,
                           int, v8::Local<v8::Value>[]);
char* CallJSNullableStringFunction(v8::Isolate*, v8::Local<v8::Object>,
                                   const char*, int, v8::Local<v8::Value>[]);
void NatTryCatch(v8::Isolate*, std::function<void(v8::Isolate*)>);
void RunWithGC(const v8::FunctionCallbackInfo<v8::Value>&);
void UnsafeAsyncRunWithGC(const v8::FunctionCallbackInfo<v8::Value>&);
void GetErrorObject(const v8::FunctionCallbackInfo<v8::Value>&);
char* ToSKString(v8::Isolate*, v8::Local<v8::Value>);
void Print(v8::Isolate*, const char*, v8::Local<v8::Value>);
v8::Local<v8::Value> JSONStringify(v8::Isolate*, v8::Local<v8::Value>);
bool JSCheckFunction(v8::Isolate*, v8::Local<v8::Object>, const char*);

struct SkipException : std::exception {
  explicit SkipException(void* exc) : m_skipException(exc) {}

  virtual const char* what() const noexcept override;

  const char* name() const noexcept;

  void* m_skipException;
};

}  // namespace skbinding

#define SKError void*
#define SKObstack void*
#define CJSON void*
#define CJArray void*
#define CJObject void*
#define PartialCJObj void*
#define PartialCJArr void*
#define SKException void*
#define SKContext void*
#define SKNonEmptyIterator void*
#define SKResource void*
#define SKLazyCompute void*
#define SKIdentifier void*
#define SKService void*
#define SKNotifier void*
#define SKReducer void*
#define SKMapper void*
#define SKMergeState void*

#endif  // SKCOMMON_H
