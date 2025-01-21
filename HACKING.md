# Hacking on skip

This document is a perpetually under construction collection of tips and potentially useful information for people hacking on the skip implementation.

### Code formatting

There is a CI job that checks that code is auto-formatted by running `make check-fmt`.
This can be run manually prior to submitting a PR if desired.
If desired, a git pre-commit hook that automatically formats changed files when committing can be installed by running `make setup-git-hooks`.
