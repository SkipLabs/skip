# Installation instructions

## Skiplang tool chain

### Dependencies

You will need at least the following installed:

 * LLVM 20.
 * wasm-ld 20 (this is part of LLVM, but your distribution might split it into
   a separate package: your wasm-ld version must match your LLVM version).
 * typescript 5.7 or later.

On Debian/Ubuntu, you can use `./bin/apt-install.sh` to install these dependencies.

On macOS (Apple silicon), install LLVM 20 and lld with Homebrew, and put LLVM's
tools (`llvm-config`, `llvm-ar`, `llvm-ranlib`) on your `PATH` after the system
ones, so that Apple's clang stays the compiler:

```sh
brew install llvm@20 lld
export PATH="$PATH:$(brew --prefix llvm@20)/bin"
```

Executables are linked with lld because Apple's linker rejects the metadata
stored in `.sklib` archives.
 
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
