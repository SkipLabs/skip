// cjson.h

#ifndef SK_CJSON_H
#define SK_CJSON_H

#include <napi.h>

namespace skjson {

Napi::Value GetBinding(const Napi::CallbackInfo&);

}  // namespace skjson

#endif  // SK_CJSON_H
