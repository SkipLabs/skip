# Incremental Skargo compiler history sweep

The active run checks 100 distinct `skiplang/compiler` directory trees,
ordered from oldest to newest. Its first revision is `7449893695`
(2026-07-22). Most revisions came from refs in `~/skip2`; two later
replacements came from `~/skip` and were fetched into `~/skip2` as
`sweep-current`. The exact revision list and completed results are frozen in
`/tmp/skip-skargo-100-current/progress.json`.

The run verified 15 revisions, then stopped at `8660a1f129`. A fresh target
failed on the same source error. The next revision, `00dc44e0a`, has the same
error. Both were removed from the frozen list, and `4786d1df8` and
`e003bd45c` were appended as later replacements. The 100-revision
verification is still in progress.

Run the sweep with `tools/sweep_skargo_history.py`. It checks out each revision
in `~/skip2`, runs `skargo build` against one persistent target, checks that
the resulting `skc --version` names the checked-out commit, compiles a small
program with that `skc`, then rebuilds without changes and compares all four
output hashes. Each build and smoke check has its own log in
`/tmp/skip-skargo-100-current/logs`. The checkout is restored to `pr-1541`
after all 100 pass; a failure leaves it at the failing revision.

Current resume invocation (the saved progress file supplies the exact list):

```sh
python3 -u tools/sweep_skargo_history.py \
  --repo ~/skip2 \
  --work /tmp/skip-skargo-100-current \
  --anchor pr-1541 --count 100 --all-unique-trees \
  --exclude 8660a1f129 --exclude 00dc44e0a \
  --target-dir /tmp/skip100-current-target \
  --skargo /tmp/skip100-skargo-bin/skargo \
  --skc /tmp/skip100-skargo-bin/skc-clean-wrapper
```

## Failures found before the current run

- A first-parent source sweep reaching `30dbb26a5` (2026-07-07) failed while
  compiling its old prelude: the newer stage1 compiler rejects a private
  `.`-global native function. The prelude was fixed in `d5c438553`; the current
  100-tree selection starts after that fix. Log:
  `/tmp/skip-skargo-100/logs/000-30dbb26a5d-build.log`.
- Reusing an existing target built at the latest `pr-1541` tip and jumping
  directly back to `7449893695` caused the older `c8e2c42a9` compiler to
  receive `SIGSEGV` in `sk_get_nbr_pages` during `SKIP_intern_shared`. A fresh
  target at `7449893695` built successfully in 273 seconds. This backwards
  cache transition remains unexplained. Logs:
  `/tmp/skip-skargo-100-unique/logs/000-7449893695-build.log`.
- The first forward update from `7449893695` to `78999bccb` reported a
  successful build but produced an `skc` still reporting `744989369`. Skargo
  reused the compiler's build-script output because it did not fingerprint
  Git `HEAD` or default package sources. After that was corrected, a second
  stale value remained: compiler archive generation read an environment input
  with `unsafeGet`, so changing `GIT_COMMIT_HASH` did not invalidate the
  archive mapper. Both changes are covered by
  `skargo/tests/build_script_revision.sk`. Logs:
  `/tmp/skip-skargo-100-forward/logs/001-78999bccba-build.log`.
- At `c37f0874a`, the historical compiler rejects a native declaration in
  that revision's stdlib for lacking an allocation annotation. The full
  `skargo build` succeeds; only the supplemental stdlib smoke check failed.
  The sweep now smoke-checks a small `--no-std` class instead.
- At `8660a1f129`, `skargo build` fails because `src/specialize.sk` initializes
  `tick` after the field was removed. A clean target reproduces the same error,
  confirming that this snapshot cannot pass the sweep as committed. Logs:
  `/tmp/skip-skargo-100-current/logs/015-8660a1f129-build.log`.
