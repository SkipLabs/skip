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
  the critical path moves. The critical path today is `compiler` (the stage1
  build) followed by the jobs that wait for it (`compiler-tests`, `skargo`,
  `backend-regressions`).
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
- The `skipruntime` and `skipruntime-bun` jobs cache the native build products
  (`libskipruntime.so`, `libskipruntime.wasm`, the node-gyp addon, and the
  Docker-built release `.so`) in CircleCI, keyed by
  `bin/native_artifacts_cache_key.sh` on a content hash of their inputs, so
  PRs that only change TypeScript do not rebuild them. The jobs set
  `SKIP_NATIVE_BUILDS_IF_PRESENT=1`, which makes the build scripts skip the
  build when the artifact is already present; a cache hit is only possible
  when the inputs are unchanged. Bump the `v1` in the cache keys in
  `.circleci/base.yml` to bust the caches.
- The native-addon release rehearsal is its own `native-addon-unreleased` job,
  scheduled beside `skipruntime`, so its from-source Docker rebuild (on a
  cache miss) runs in parallel with the runtime tests instead of after them.
- Doc-only and `.gitignore`-only changes schedule no jobs at all — not even
  `fast-checks`, whose formatters and shellcheck cover neither — so only
  `setup` and the no-op `all-checks` run (`.circleci/generate_config.sh`);
  keep it that way for other paths that cannot affect a build or a check.
- Likewise, a `bin/` script triggers only the jobs that actually execute it:
  the job-relevant scripts are listed in `BIN_*_SCRIPTS` at the top of
  `.circleci/generate_config.sh` (e.g. `bin/merge-bot.sh` is covered by
  `fast-checks` alone, since `make check-sh` runs its selftest). List a
  script there only when a job's steps, Makefiles or Dockerfiles run it.

### Publishing CI Docker images

CircleCI jobs run inside the `skiplabs/*:latest` images published from the
`ci` group in `docker-bake.hcl`. Those images carry a prebuilt stage0 compiler
(`skc`, `skargo`, `skfmt`) built from the pinned `skiplang/compiler/bootstrap`
submodule, plus the apt/npm/pip tooling from `bin/apt-install.sh` and the
Dockerfiles. `docker-publish` rebuilds them from `main` every Monday, and
also on every push to `main` that changes an image input (see the `push` paths
in `.github/workflows/docker-publish.yml`), so between runs CI uses the
images from the last successful publish.

The image's stage0 toolchain is built by `make STAGE=0` in the root
`Dockerfile` from `skiplang/compiler` **and the prelude it builds**, so all of
`skiplang/prelude/` — `src/`, `build.sk`, `Makefile`, `runtime/`,
`libbacktrace/` — is an image input, not just the runtime. A std API change
like #1743 lands green (its own jobs use the candidate toolchain) but leaves
the published `libstd.sklib` stale, and every later PR whose jobs use the
image's toolchain then fails compiling `prelude/build.sk` until a republish
(#1373, #1749). That is why the push-triggered publish exists: it shrinks
that window from up to a week to minutes.

Run `docker-publish` manually on `main` (Actions → docker-publish → Run
workflow) after merging a change that **both**:

1. **changes what goes into an image**: anything under `skiplang/prelude/`,
   a bootstrap bump (`skiplang/compiler/bootstrap/`), `skiplang/compiler/Makefile`,
   `bin/apt-install.sh`, `requirements-dev.txt`, a Dockerfile or
   `docker-bake.hcl`; **and**
2. **is needed by CI before the next publish**, in a job that uses the
   image's toolchain rather than building its own. For example, Skip code that
   needs the newer compiler from a bootstrap bump, or a test that needs a newly
   added apt/npm/pip tool. The jobs that use the image's toolchain are
   `skip-package-build`/`skip-package-tests`, `skdb`, `skdb-wasm`, `check-ts`,
   `skipruntime` and `skipruntime-bun`. `compiler` and `skargo` use the
   compiler built from the PR itself, so they never need a republish.

A change that meets only the first condition is covered by the push trigger
and the weekly run. A PR's own CI always runs against the already-published
images, so it cannot validate an image change; the publish after merge is the
first real test.

Instead of running the publish by hand, label the PR `docker-publish`: when it
merges to `main`, the `docker-publish-on-label` workflow dispatches
`docker-publish` on `main` automatically. PRs from forks cannot dispatch
workflows (their token is read-only), so for those run it manually after
merging. (The push trigger covers in-repo merges regardless of the label.)

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

### Merge bot

`bin/merge-bot.sh` (driven by the `.vibe/skills/merge-bot` skill) runs the merge
queue. A PR is ready when **auto-merge is enabled and its CI is green**; PRs
with red CI are never considered. Among ready PRs the bot acts on **one at a
time**: green + up-to-date PRs are simply waited on until auto-merge lands them
(and no rebase is scheduled until they have merged); green + not-up-to-date PRs
(`BEHIND`/conflicting, i.e. `main` moved ahead) are rebased onto `main` —
fastest expected CI first (the PR's last pipeline wall time, else a
changed-paths heuristic) — then pushed with `--force-with-lease`. Run from a
clone of this repo and the bot reuses that clone, doing the git work in
`git worktree`s under `~/.cache/skip-merge-bot` (never in your checkout's
working tree, no second clone); run from elsewhere and it keeps a dedicated
clone under `~/.cache/skip-merge-bot`. Fork-headed
PRs are included when they allow maintainer edits ("Allow edits from
maintainers"), which lets maintainers push to the fork's branch; the bot then
pushes the rebase to the fork. If `main` moves again while the bot waits on a
rebased PR (strict required checks block merging a `BEHIND` PR), the bot
re-rebases, up to `MERGE_BOT_REBASE_ATTEMPTS` (default 3) rounds. Rebase
conflicts (and CI failures the rebase triggers) are handed to a sub-agent
(`.vibe/skills/merge-bot/references/fix-conflicts.md` / `fix-ci.md`); if a fix
is non-trivial, the bot comments on the PR, disables auto-merge, and skips it
for now. Otherwise it waits until GitHub's auto-merge actually lands the PR
before moving to the next one.

Run it interactively through the `merge-bot` skill, or unattended with
`bin/merge-bot.sh run` (see `bin/merge-bot.sh --help`; `--dry-run` previews
without pushing). `bin/merge-bot.sh board` prints a one-shot dashboard (bot
alive?, scheduling decision, queue with per-PR buckets, in-flight worktrees,
recent log); `bin/merge-bot.sh watch [seconds]` refreshes it live.
`bin/merge-bot.sh --selftest` unit-tests the
readiness/CI-estimate logic and runs as part of `make check-sh`.

#### Reusing the bot from another repo

Repos that keep a skip checkout next to them (e.g. skjs) should not copy this
bot; a thin `bin/merge-bot.sh` wrapper that execs `../skip/bin/merge-bot.sh`
is enough. The script is parameterized for that:

- the state dir defaults to `~/.cache/<repo>-merge-bot` (repo name from
  `--repo`/origin), so each repo gets its own clone/worktrees/lock;
- `MERGE_BOT_PATH_EST` overrides the changed-paths CI heuristic body (jq, `$p`
  = changed paths → expected CI seconds) with the other repo's layout;
- `MERGE_BOT_REFERENCES_DIR` points at a dir with fixer briefs
  (`fix-conflicts.md` / `fix-ci.md`); files missing there fall back to the
  bundled `.vibe/skills/merge-bot/references/`;
- the skill itself can be shared verbatim: symlink
  `.vibe/skills/merge-bot/SKILL.md` to
  `../../../../skip/.vibe/skills/merge-bot/SKILL.md` (from
  `<repo>/.vibe/skills/merge-bot/` up to the parent dir that holds the skip
  checkout) and keep only local overrides (e.g. a repo-specific
  `references/fix-ci.md`) in `.vibe/skills/merge-bot/`.

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
