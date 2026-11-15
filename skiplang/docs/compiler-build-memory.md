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

CircleCI job [20830](https://circleci.com/gh/SkipLabs/skip/20830), on revision
`eecca396a`, then passed its clean stage1 build and language-test phases with the
existing 16 GB allocation and 14 GiB RSS guard. The build peaked at 13.52 GiB
sampled RSS; the compiler process's kernel high-water mark was 13.82 GiB and
the conservative sum for live processes was 13.90 GiB. The language-test phase
peaked at 8.04 GiB. Clang was measured separately in the local runs above, not
in this CI job.

The job's later runtime-test step could not link the image's missing UBSan
diagnostic library. The test runner now uses UBSan trap mode, preserving the
checks without that optional dependency; a deliberately restored signed-shift
bug traps at both `-O0` and `-O2`. Runtime tests run before the compiler build so
environment failures are reported early. The final commit's CI status remains
the authority for the complete suite result.

The margin below 14 GiB is small. These measurements do not establish a bound
for arbitrary compiler workloads.

## Disposable release builds (2026-11-14)

Starting from compiler source `5baa561d`, `skargo build --release` now selects
`skc --one-shot` for release compilation units. `skargo check --release` keeps
its incremental frontend databases, including dependencies, and builds leave
those release databases untouched. Ordinary artifact fingerprints still skip
unchanged builds. Host build dependencies using the dev profile retain their
existing behavior. Release native builds enable `--split-support-module`.

The one-shot backend passes explicit state between phases. Frontend and
conversion contexts are temporary; snapshots retain values rather than arrows,
dependencies and old versions. Typed trees are released after outer conversion,
and the remaining conversion context is released before optimization. Lowering,
LLVM graph construction, emission and linking each receive only their required
inputs. Archive decoding has a separate region, and archive encoding reclaims
escaping scratch for each source file.

The region collector marks live objects, frees empty pages and evacuates sparse
pages one at a time. Bitmap ranks index forwarding tables, allowing each old
page to be freed before all references have been rewritten. Dense and large
pages stay in place. This avoids the temporary second copy of the live graph
that raised earlier Mistigri attempts above 35 GiB. On glibc, freed arena pages
are returned to the OS at checkpoints.

The measured workload was a fresh `skargo build --release --jobs 1 --bin
lean4-simp` of Mistigri `cbbd0d07`, with all 1,507 maintained modules and 115
project source files (315,192,640 bytes). No source subset was selected.
The unmodified compiler was stopped by its memory guard at **49.99 GiB sampled
process-tree RSS**, before finishing the library; this is a lower bound, not a
completed baseline peak.

The changed compiler completed the library, executable and native link in
**561.38 seconds**. The compiler's kernel high-water mark was **27.06 GiB**.
The sampled process-tree peak was 26.75 GiB; the conservative sum of high-water
marks for observed concurrently live processes was **27.18 GiB**. Use the latter
when assessing memory headroom. Native compiler and linker children are included
in the process-tree measurements. The executable also passed its CLI usage smoke
check. This measures the `lean4-simp` target, not every Mistigri executable.

The measurements ran on AArch64 Linux with Clang 20.1.8, with fresh target
directories and no overlapping heavy workload. The baseline source was built
using the installed `skc` at `5ceb49e2`; the changed compiler was built using
that source-built baseline. These results do not claim a refreshed bootstrap.
Exact identities, RSS bytes, phase samples and validation results are recorded in
[`compiler-release-memory-results-20261114.json`](compiler-release-memory-results-20261114.json).

The final compiler passed all 1,766 language tests, 195 backend checks (zero
skipped), and 13 Skargo integration tests. The latter include release checks
interleaved with builds and edits to both the root package and a dependency,
verifying cache reuse and correct executable output. Native runtime tests pass
at `-O0` and `-O2` with UBSan, including bounded page evacuation, sharing,
cycles and retained-page references. The Wasm collector test also passes with
four-byte pointer alignment and reused pages.
