{
  "targets": [
    {
      "target_name": "skip_runtime",
      "sources": [
        "src/common.cc",
        "src/cjson.cc",
        "src/tojs.cc",
        "src/fromjs.cc",
        "src/main.cc"
      ],
      "include_dirs": ["<!@(node -p \"require('node-addon-api').include\")"],
      "dependencies": ["<!(node -p \"require('node-addon-api').gyp\")"],
      "defines": ["NAPI_VERSION=8", "NAPI_CPP_EXCEPTIONS"],
      "cflags!": ["-fno-exceptions"],
      "cflags_cc!": ["-fno-exceptions"],
      "libraries": [
        "-lskipruntime<!(echo $VERSION)",
        "-Wl,--require-defined=SKIP_new_Obstack"
      ]
    }
  ]
}
