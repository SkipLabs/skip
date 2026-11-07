# Hacking on skip

This document is a perpetually under construction collection of tips and potentially useful information for people hacking on the skip implementation.

### Developer workflow

TL;DR: During development, do not invoke `npm` commands directly, use the `make` targets.

The npm package configuration files are set up to optimize the end-user scenario, where the native addon uses a binary release of the skipruntime. In contrast, during development it is generally desired to use the currently unreleased version of the skipruntime. To support both of these scenarios, directly invoked `npm` commands follow code paths that lead to using released skipruntime binaries, and `npm` commands invoked by `make` follow code paths that lead to building the current skipruntime sources and using that. In particular, `skipruntime-ts/Makefile` sets `SKIPRUNTIME_VERSION`, `LDFLAGS`, and `LD_LIBRARY_PATH` environment variables.

### Code formatting

There is a CI job that checks that code is auto-formatted by running `make check-fmt`.
This can be run manually prior to submitting a PR if desired.
If desired, a git pre-commit hook that automatically formats changed files when committing can be installed by running `make setup-git-hooks`.

### Continuous integration

Pull requests are gated by CircleCI (`.circleci/`): the required `ci/circleci: *`
statuses run the compiler, prelude, skargo, skdb and runtime test suites.
`.circleci/generate_config.sh` schedules only the jobs a PR's changes trigger,
diffing the PR against its merge base with `main`.

`main` runs tests again after every merge. There, the script diffs the merge
commit against its first parent (the `main` the PR was merged into), so the
jobs the PR triggered rerun on the merged tree, candidate toolchain included.
That catches merge skew: a PR tested against an older `main` that breaks in
combination with what merged since. A push to `main` that is not a merge
commit, and the root commit, run every job. A failure on `main` doesn't block
anything, so check the CircleCI status of your merge commit after merging.

GitHub Actions (`.github/workflows/`) complements CircleCI but does not gate
PRs. Only `actionlint`, `docs` and the docker `check-images` job run on pull
requests, and only for the paths they watch. The docker publish pipeline
(`check-push-access`, `build`, `merge`) is skipped on PRs by design: it needs
registry secrets and only makes sense on `main`, so seeing those checks as
`skipped` on a PR is expected, not a failure. CodeQL runs on a weekly schedule,
not per PR.

#### CI time budget

Keep a full CircleCI pipeline (first job start to last job end, for a PR that
triggers every job) **under 15-20 minutes**. Slow CI delays every merge and
encourages batching unrelated changes.

- When a PR adds tests or CI steps, check the job durations on its CircleCI
  run against a recent run on `main`, and say in the PR description how much
  the critical path moves. The critical path today is `compiler` followed by
  the jobs that wait for it (`skargo`, `backend-regressions`).
- If a change pushes the pipeline past the budget, fix that in the same PR:
  run the work concurrently, split it into a job that runs in parallel, or move
  checks that don't need to gate every PR (e.g. for disabled experimental
  options) to a scheduled job. If that isn't possible, open an issue with the
  measurements before merging.
- Long Python test suites should report per-test durations (as
  `skiplang/compiler/tools/run_backend_tests.py` does) so regressions in a
  single test are visible in the CI log.
- `backend-regressions` is split across parallel containers; the count is its
  `shards` parameter in `.circleci/base.yml`. See
  [`skiplang/compiler/tools/README.md`](skiplang/compiler/tools/README.md#sharding-in-ci)
  for how modules are balanced and how to refresh their expected durations.
- Doc-only and `.gitignore`-only changes schedule no test jobs
  (`.circleci/generate_config.sh`); keep it that way for other paths that
  cannot affect a build.

### Publishing CI Docker images

CircleCI jobs run inside the `skiplabs/*:latest` images published from the
`ci` group in `docker-bake.hcl`. Those images carry a prebuilt stage0 compiler
(`skc`, `skargo`, `skfmt`) built from the pinned `skiplang/compiler/bootstrap`
submodule, plus the apt/npm/pip tooling from `bin/apt-install.sh` and the
Dockerfiles. `docker-publish` rebuilds them from `main` every Monday, so
between runs CI uses the images from the last successful publish.

Run `docker-publish` manually on `main` (Actions → docker-publish → Run
workflow) after merging a change that **both**:

1. **changes what goes into an image**: a bootstrap bump, the prelude runtime
   (`skiplang/prelude/runtime/`), `bin/apt-install.sh`, `requirements-dev.txt`,
   a Dockerfile or `docker-bake.hcl`; **and**
2. **is needed by CI before the next weekly publish**, in a job that uses the
   image's toolchain rather than building its own. For example, Skip code that
   needs the newer compiler from a bootstrap bump, or a test that needs a newly
   added apt/npm/pip tool. The jobs that use the image's toolchain are
   `skip-package-build`/`skip-package-tests`, `skdb`, `skdb-wasm`, `check-ts`,
   `skipruntime` and `skipruntime-bun`. `compiler` and `skargo` use the
   compiler built from the PR itself, so they never need a republish.

A change that meets only the first condition can wait for the weekly run. A PR's
own CI always runs against the already-published images, so it cannot validate
an image change; the publish after merge is the first real test.

CircleCI never builds the images. The publish builds the compiler inside Docker
on GitHub's 16 GiB runners, so a bootstrap or runtime change can pass CI and
still break the publish (#1589). After merging one, run the publish promptly, or
at least check the next scheduled run. A failed publish pushes nothing, so
`:latest` keeps the last good images.

`bin/release_docker_ci_images.sh` publishes the same images by hand if the
workflow is unavailable. `skiplabs/skdb` is not in the `ci` group and is
published only by the manual `docker-publish-skdb` workflow, as a release.

#### Downstream: skjs

[skjs](https://github.com/SkipLabs/skjs) depends on both. Its CI (CircleCI and
GitHub Actions) runs in `skiplabs/skip:latest`, and it clones this repository's
`main` next to it (`../skip`) for `std`, `cli`, `cc` and `sktest`. So skjs
builds this repository's current `main` sources with the compiler from the last
published image. A compiler or runtime change can therefore break skjs on
merge, or on the next publish, even when this repository's CI is green.

Before merging a change to the compiler, the prelude (including its runtime) or
skargo, also test skjs against it: check out skjs next to this branch as
`../skip` and run `make test`, or run skjs's CI against the branch. After a
publish that changes the toolchain, check that skjs's next CI run on `main` is
still green.

### Building skip client in Docker against unreleased skip packages

Sometimes it is useful to be able to build a skip client against locally modified, unreleased, skip framework packages.

In some cases, `npm link` can be used to create a symbolic link in the client code's `node_modules` that points to the locally modified skip package.
If the client runs in docker, however, this approach does not work since the target of the link will not be available in the container.

An alternative is to use `npm pack`. For example:
```
> cd path/to/skip
> mkdir path/to/client/pack
> npm pack --pack-destination path/to/client/pack -w skipruntime-ts/core
```
This creates a tarball of the `@skipruntime/core` package in `path/to/client/pack` directory.
Any other packages desired from the list of workspaces in `skip/package.json` can be added with `-w` flags.
Then the client's `package.json` needs to be modified to install from the tarball instead of the network.
Modify `packages.json` replacing a line such as:
```
    "@skipruntime/core": "0.0.12",
```
with
```
    "@skipruntime/core": "file:/./pack/skipruntime-core-0.0.12.tgz",
```
Next check the client's `Dockerfile` to ensure that the `pack` directory is copied into the container; for example it may be necessary to add `COPY pack pack` before `RUN npm install`.
Then proceed with the client build, such as:
```
> cd path/to/client
> docker compose up --build
```

### Migrating branches from before the history rewrite

The repository's history was rewritten to purge large generated bootstrap
binaries from every commit; they are now provided by the `compiler/bootstrap`
and `prebuild` submodules. Because this re-hashed every commit past the rewrite
point, any branch created before the rewrite is stranded on the *old* history:
it shares no recent ancestor with `main`, cannot be merged, and shows up as
thousands of phantom changes in comparisons.

`bin/migrate-old-history-branches.sh` re-anchors such branches onto the current
history. It replays only each branch's own commits onto the new-history *twin*
of the exact commit it forked from — it does not rebase them forward onto a
newer base — so a branch's content is preserved byte-for-byte and any stacking
between your branches is kept intact. The old history is never fetched, so the
purged binaries are not re-imported into your repository.

```
# preview your local branches (no changes are made)
bin/migrate-old-history-branches.sh

# migrate them in place (originals saved under refs/migrate-backup/*)
bin/migrate-old-history-branches.sh --apply

# migrate and push the branches of a remote, e.g. your fork
bin/migrate-old-history-branches.sh --remote <remote> --apply --push
```

Run with `--help` for all options. Branches with complex history (for example,
merges of the old mainline) are reported as needing manual attention rather than
being migrated automatically.
