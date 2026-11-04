# Compiler build memory

Checkpoint: 2026-11-04, review revision `b301f5042`.

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
