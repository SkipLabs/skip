# Tarantool-TPCH 

This is a set of script to run TPC-H benchmarks with SQLite and Tarantool
databases. It was created as a development of SQLite3 benchmark from https://github.com/lovasoa/TPCH-sqlite but then heavily modified to 
actually run queries in SQLite, collect timings, and do the same
with Tarantool (which would be running exactly the same queries as 
SQLite)

It uses the official [tpch-dbgen v2.18.0_rc2](https://github.com/tsafin/tpch-tools) tool to generate the data, and then imports it into an databases.


## How to use

Clone this repository then just run `make` from the root directory of this repo. Be sure to have `sqlite3`, C compiler and Tarantool compiled.

```
git clone git@github.com:tsafin/tnt-tpch.git
cd tnt-tpch
make
```

It assumes that SQLite executable is available on the PATH as `sqlite3`,
and Tarantool is built and available as `tarantool`. If you need to redefine 
Tarantool executable path then override it via environment variable `$TARANTOOL`

```
TARANTOOL=../tarantool/build/src/build make
```

NB! At the moment you have to use specially patched Tarantool version, because you 
need to have restored [datetime support](tarantool/tarantool#4898). To make those 
patches handy they are committed as [./patches/\*.patch](./patches/). Rebuild tarantool
with those patches applied, and then set $TARANTOOL environment variable to the 
modified executable.

So here are side effects generated after running `make`

* Generated SQLite3 database will be located in the current directory as `TPC-H.db`.
* Generated Tarantool snapshots will be here as `*.snap` and `*.xlog`
* Benchmark log for SQLite will be in `bench-sqlite.log`
* Benchmark log for Tarantool will be in `bench-tnt.log`
* CSV with results extracted from those logs above will be saved at `bench-sqlite.csv`
  and `bench-tnt.csv` correspondingly.

### How to set a custom scale factor

By default, the database is generated with a scale factor of 1. You can set a different *scale factor* (**SF**) with

```
SCALE_FACTOR=10 make
```
