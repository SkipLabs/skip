# Compiler build memory

Initial checkpoint: 2026-11-04, review revision `b301f5042`.

The full compiler build completed locally with a sampled peak of 26.52 GiB.
CircleCI job [20769](https://circleci.com/gh/SkipLabs/skip/20769) exceeded its
14 GiB RSS guard while the pinned bootstrap compiler generated the new compiler,
before Clang ran. The job has a 16 GB allocation. The guard stopped it at
14.105 GiB; this was a controlled memory-limit failure, not a confirmed kernel
OOM. The older baseline compiler sources built locally with a 9.89 GiB peak.

The completed language suite peaked at 8.56 GiB, the 166 backend checks at
2.90 GiB, and the seven Skargo tests at 2.49 GiB. These are separate runs and do
not establish a peak for a complete clean build. The new compiler's self-build
also exceeded the 14 GiB guard.

## Investigation

The following bounded probes did not fit under the guard:

- Explicit release mode with the pinned bootstrap.
- Disabling inlining and IPA while generating the compiler host.
- Compiling without a persistent database.
- Disabling all optional optimizer passes. This reached lowering at 13.42 GiB
  before exceeding the guard.
- Forcing large freed native allocations to return to the OS with
  `MALLOC_MMAP_THRESHOLD_=131072` and `MALLOC_TRIM_THRESHOLD_=131072`.

In the allocator probe, at about 10.5 GiB RSS, `malloc_info` reported
11,279,790,080 bytes in 1,343 active mappings. The ordinary malloc arena occupied
about 1.35 MB. Persistent live allocations were only 19,904 bytes at that point.
Freed glibc arena retention and persistent-cache size therefore do not explain
the sampled peak. Active allocation regions can still contain obsolete objects.

Stack samples during growth showed sequential optimization and lowering. A
specific code-review target is `Optimize.optimizeAll`: each function's region
copies its result into the enclosing region. Subsequent rounds replace function
versions in the maps, but the replaced objects remain allocated until their
enclosing region finishes. Whole-program environments also overlap across
lowering passes. The reclaimable volume has not yet been measured.

`SKC_CHECKPOINT_BACKEND_PHASES` targets incremental collection arrows. It does
not split the sequential bulk optimizer and lowering operations observed here.

## Acceptance criteria

Keep the 16 GB CI allocation and the 14 GiB guard while developing a fix. Bound
the lifetime of optimizer and lowering intermediates while preserving pass
ordering, dependency cycles, coroutine-generated functions/classes, diagnostics,
and the release optimization policy. Validate a complete clean compiler build
and the existing language, backend, driver and runtime suites.

The first CI build executes precompiled IR from the pinned bootstrap submodule.
A compiler-source fix must also reach a validated bootstrap before that initial
build benefits. Do not infer success from a later self-build alone.

Raw logs, samples and temporary databases stay outside the repository. Retire
databases after each probe; retain bounded findings and compiler identities.

## Implemented reduction

Sequential non-batch compilation now uses the existing compiler pipeline. It
synchronizes the IR before optimization and separates reachability, lowering,
assembly graph construction and emission. Sequential specialization keeps its
per-request regions: unlike incremental discovery, it drains all requests in
one callback. Batch compilation retains its existing per-unit isolation.

Clang had an independent peak. LLVM's
[LazyCallGraph](https://github.com/llvm/llvm-project/blob/llvmorg-20.1.8/llvm/lib/Analysis/LazyCallGraph.cpp)
recursively follows constant operands when collecting function references. Our
large shared vtable connected many functions to nearly every other function.
An experimental split of the same LLVM input completed at `-O2` with a sampled
2.13 GiB peak; the unsplit input exceeded 14 GiB even at `-O1`.

`--split-support-module` now also separates the sequential native vtable from
the function module. All function bodies remain together for interprocedural
optimization, and cross-module definitions receive hidden linkage unless they
are explicit exports. Unsupported custom preambles use the monolithic path.
Switching back removes the old vtable sidecar. Bootstrap promotion and stage0
linking support the paired modules; older monolithic bootstraps remain usable.
The compiler Makefile enables the split when the bootstrap carries paired
modules. Other native builds opt in with `--split-support-module`.

The completed local validation used AArch64, Clang 20.1.8 and `SKIP_CAPACITY=12G`:

| Run                                 | Result                   | Sampled process-group peak |
| ----------------------------------- | ------------------------ | -------------------------: |
| Clean compiler and formatter build  | Passed the 14 GiB guard  |                  13.23 GiB |
| Language suite, eight jobs          | 1,766 passed             |                   9.08 GiB |
| Backend suite, three module workers | 176 passed, zero skipped |                   5.42 GiB |

Clang's compiler-binary invocation reported a 1.97 GiB peak via `wait4`, measured
separately from Skip. The compiler process's kernel high-water mark was
13.85 GiB. Summing the high-water marks of processes present together gives a conservative 13.94 GiB
bound for the build group. This is close to the target; the sampled number alone
would overstate the available margin. These runs overlapped, so their elapsed
times are not comparative latency benchmarks. The backend worker harness and
raw profiles are scratch artifacts, not additional CI requirements.

## Refreshed bootstrap

Bootstrap `7aa59d1261f145f76f47b2210c7e456a390c847f` contains the canonical
paired LLVM modules generated from source `51d31217b`. A separate checkout,
starting from those compressed images and no build products, completed
`make STAGE=3` under the unchanged 14 GiB guard. Its stage0 compiler reports
`skc 0.3.3 (51d31217b)`.

| Fresh-bootstrap check                                    | Result                                                           |                  Peak |
| -------------------------------------------------------- | ---------------------------------------------------------------- | --------------------: |
| Entire stage0 through stage3 build                       | Passed                                                           | 13.72 GiB sampled RSS |
| Conservative sum of live processes' high-water marks     | Below the guard                                                  |             13.90 GiB |
| Clang, measured separately with `wait4`                  | Passed                                                           |              2.02 GiB |
| Language suite using rebuilt stage1, eight jobs          | 1,766 passed                                                     |  8.05 GiB sampled RSS |
| LLVM fixpoint, all three tools and both modules per tool | All six files identical across source, stage1, stage2 and stage3 |                     — |

The build took 1,067 seconds across all four stages while other validation ran;
this is not an isolated latency measurement. The fresh-build databases were
retired after validation, reclaiming 16.89 GiB. The language-suite database
cleanup reclaimed another 3.00 GiB.

These are local AArch64 results. CI retains its 16 GB allocation and 14 GiB RSS
guard and must validate the pinned bootstrap on its own worker. The margin is
small; neither the sampled peak nor the local fixpoint proves CI success or
establishes a bound for arbitrary compiler workloads.
