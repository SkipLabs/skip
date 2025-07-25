# Installation instructions

## Skiplang tool chain

### Dependencies

You will need at least the following installed:

 * LLVM 20.
 * wasm-ld 20 (this is part of LLVM, but your distribution might split it into
   a separate package: your wasm-ld version must match your LLVM version).
 * typescript 5.7 or later.

On Debian/Ubuntu, you can use `./bin/apt-install.sh` to install these dependencies.
 
### Building the toolchain

```sh
git clone --recursive https://github.com/SkipLabs/skip.git
cd skip
cd skiplang/compiler
make
```

### Installing the toolchain

```make install prefix=<installation_dir_prefix>```

`<installation_dir_prefix>/bin` and `<installation_dir_prefix>/lib` directories will be created.

Then make sure `<installation_dir_prefix>/bin` is available in `$PATH`.
