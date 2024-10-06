{
  "targets": [
    {
      "target_name": "skip_runtime",
      "sources": [
        "src/common.cc",
        "src/cjson.cc",
        "src/tojs.cc",
        "src/fromjs.cc",
        "src/main.cc",
      ],
      "cflags!": ["-fno-exceptions"],
      "cflags_cc!": ["-fno-exceptions"],
      "libraries": ["~/skip-runtime/libskip-runtime-ts.so"]
    }
  ]
}