#!/usr/bin/env bash

gitroot=$(git rev-parse --show-toplevel)
echo "** git root location: $gitroot **"

scale_factor=0.2
tarantool_src=tarantool-src
branch=master
mem_size=$(echo 1024^3 | bc)

export LC_ALL=C

checkout() {
        echo "** git clone repo **"
        time (
                if [[ ! -d $tarantool_src ]]; then
                        git clone --depth=1024 --single-branch --branch=$branch \
                        https://github.com/tarantool/tarantool.git $tarantool_src
                fi
        )
        echo "** git checkout submodules **"
        time (
                cd $tarantool_src
                git clean -fdx .
                git reset --hard
                git checkout -b lmaster origin/$branch
                git submodule update --depth 512 --init --recursive
                git fetch --tags --depth=1024 --recurse-submodules-default=no

        )
}

apply_patches() {
        echo "** git apply patches **"
        time (  cd $tarantool_src
                patch -p1 < ../patches/0001-*.patch
        )
}

build_tarantool() {
        echo "** cmake configure **"
        time (  cd $tarantool_src
                cmake -S . -B build \
                -DCMAKE_C_COMPILER_LAUNCHER=ccache \
                -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
                -DCMAKE_BUILD_TYPE=RelWithDebInfo
        )
        echo "** cmake build **"
        time (  cd $tarantool_src
                cmake --build build
        )
}

clean_bench() {
        echo "** clean TNT database, if any **"
        time make clean-tnt
}
bench_tarantool() {
        echo "** create TNT database memtx_size=$MEM_SIZE **"
        time make create_TNT_db \
                  TARANTOOL=$tarantool_src/build/src/tarantool \
                  SCALE_FACTOR=$scale_factor \
                  MEM_SIZE=$mem_size
        echo "** bench TNT database memtx_size=$MEM_SIZE"
        time make MEM_SIZE=$mem_size bench-tnt
}

checkout
apply_patches
build_tarantool
clean_bench
bench_tarantool
