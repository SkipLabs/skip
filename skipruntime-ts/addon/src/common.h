// common.h

#ifndef SKCOMMON_H
#define SKCOMMON_H

#include <napi.h>

#include <functional>
#include <sstream>
#include <string>

namespace skbinding {
void AddFunction(Napi::Env, Napi::Object, const char*,
                 Napi::Function::Callback callback);
Napi::Value CallGlobalStaticMethod(Napi::Env, const char*, const char*,
                                   const std::vector<napi_value>&);
void* SKTryCatch(Napi::Env, Napi::Function, Napi::Value,
                 const std::vector<napi_value>&,
                 std::function<void*(Napi::Env, Napi::Value)>,
                 std::function<void(Napi::Env)>);
void SKTryCatchVoid(Napi::Env, Napi::Function, Napi::Value,
                    const std::vector<napi_value>&,
                    std::function<void(Napi::Env)>,
                    std::function<void(Napi::Env)>);
void CallJSVoidFunction(Napi::Env, Napi::Object, const char*,
                        const std::vector<napi_value>&);
void* CallJSFunction(Napi::Env, Napi::Object, const char*,
                     const std::vector<napi_value>&);
void* CallJSNullableFunction(Napi::Env, Napi::Object, const char*,
                             const std::vector<napi_value>&);
double CallJSNumberFunction(Napi::Env, Napi::Object, const char*,
                            const std::vector<napi_value>&);
char* CallJSStringFunction(Napi::Env, Napi::Object, const char*,
                           const std::vector<napi_value>&);
char* CallJSNullableStringFunction(Napi::Env, Napi::Object, const char*,
                                   const std::vector<napi_value>&);
void NatTryCatch(Napi::Env, std::function<void(Napi::Env)>);
Napi::Value RunWithGC(const Napi::CallbackInfo&);
Napi::Value GetErrorObject(const Napi::CallbackInfo&);
char* ToSKString(Napi::Value);
void Print(Napi::Env, const char*, Napi::Value);
Napi::Value JSONStringify(Napi::Env, Napi::Value);
bool JSCheckFunction(Napi::Object, const char*);

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

#endif  // SKCOMMON_H
