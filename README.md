# skdb

This repository contains the source code for SKDB and its associated
components.


## Running Prepackaged SKDB

You can run the latest release of SKDB's development server with Docker:

```sh
docker run -it -p 3586:8080 skiplabs/skdb-dev-server
```

The three SKDB packages (`skdb`, `skdb-dev`, and `skdb-react`) are all
available as normal NPM packages.


## Building From Source

It is recommended that you use the prepackaged version of SKBD in most
situations.

For those who need to build from source, you will need a number of
dependencies installed: SKDB's
[`Dockerfile`](https://github.com/SkipLabs/skdb/blob/main/Dockerfile) contains
the definitive list for Ubuntu, and will give users of other operating systems
a good idea of what is needed. Note that you will need LLVM 15, and that other
tools relevant to LLVM need to be compatible with LLVM 15.

If your distribution/OS doesn't include typescript, you can install your own
with `npm install --prefix=/path/to/install typescript`.


### Build steps

These build steps can be simplified for your first build, but for simplicity's
sake we assume that you are doing multiple builds, and need to clean artifacts
from previous builds: this is also safe, if unnecessary, for your first build.

First build the bootstrap compiler:

```sh
cd /path/to/skdbrepo/compiler && make clean && default STAGE=0
```

Then build the rest of the system ensuring that `$PATH` points to the compiler
built in the previous stage:

```sh
cd /path/to/skdbrepo && make clean && PATH=/path/to/skdbrepo/compiler/stage0/bin:$PATH make
```

To build the NPM packages locally:

```sh
cd /path/to/skdbrepo/packages/dev
rm -rf node_modules && yarn install && yarn build
cd ../react
rm -rf node_modules && yarn install && yarn build
```

If you wish to use the NPM packages locally add `&& yarn link` after both `yarn
build` commands.

To build local copies of the Docker images:

```sh
cd /path/to/skdbrepo
bin/build_docker_images.sh
```

This will build and add three Docker images locally. Note that if you have
previously built/installed SKDB Docker images, you should have stopped both any
running containers (`docker container prune`) and their associated images
(`docker image prune`) before running `build_docker_images.sh`.
