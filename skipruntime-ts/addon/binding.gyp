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
      "libraries": ["-L<!(pwd)/dist -lskip-runtime-ts-<!(node -e \"const process = require('process');console.log(process.arch + '-' + process.platform)\")"],
      "ldflags": ['-Wl,-rpath,<(module_root_dir)/dist'],
    }
  ]
}