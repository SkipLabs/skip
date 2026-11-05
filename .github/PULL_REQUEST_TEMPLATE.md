## Summary

<!-- What does this change do, and why? Keep it to summary + motivation. -->

## Checklist

- [ ] `make check-fmt` passes (run `make fmt` first)
- [ ] Relevant test suites pass (`make test`, or per-package `bin/run-sktest.sh`; for compiler changes also the backend regressions in `skiplang/compiler/tools/`)
- [ ] Each commit is one logical change (an "and"/"also"/";" in a subject is a red flag)
- [ ] Tests introduced with or before the code change they exercise
- [ ] Changes under `skiplang/compiler/`, `skiplang/prelude/runtime/`, `skiplang/skargo/` or `.circleci/`: describe the validation run in the PR body (review is auto-requested via CODEOWNERS)
- [ ] `skiplang/compiler/bootstrap` submodule bumped via `bin/bump_bootstrap.sh` if the compiler IR changed
- [ ] AI-assisted changes carry a `Co-Authored-By` disclosure trailer (provider, model, version, and effort/reasoning setting when known) and are disclosed in this PR description
