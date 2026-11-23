# Skip Code Notes (Living Log)

The **canonical** living collection of lessons about writing good **Skip** code
across the SkipLabs repos — other repos (e.g. SkipLabs/skjs) link here instead
of keeping their own copy. Contributed by agent sessions (this one and others).
It complements the root
[AGENTS.md](../AGENTS.md), [HACKING.md](../HACKING.md), and the nested
`AGENTS.md` files (e.g. `skiplang/compiler/AGENTS.md`): those hold the stable
rules; this file accumulates the specifics we learn by doing — `skargo`/`skc`
errors, test failures, review feedback, and corrections from the project
owner.

## How to Contribute

- **Read the latest entries before writing `.sk` code**, so recent lessons are
  fresh in mind.
- **Append an entry whenever you learn a new lesson — above all when the user
  tells you to do something differently.** If the user corrects your Skip code
  (style, pattern, naming, structure, anything), record the correction here in
  the same session, then apply it to the work in progress. Do not wait to be
  asked twice.
- **Newest entries first.** Keep each entry short: a `###` heading with the
  date and a short title, one or two sentences stating the rule, a source tag
  (`user correction`, `skc/skargo error`, `test failure`, `review`), and a
  small before/after snippet when it helps.
- **Don't duplicate.** If your lesson extends an existing entry, edit that
  entry instead of adding a near-copy. If an entry proves durable and general,
  promote it into the stable docs (root `AGENTS.md`, `HACKING.md`, or the
  relevant nested `AGENTS.md`) and leave a pointer here.
- This file is for lessons about writing Skip code (`.sk` sources, build/test
  workflow gotchas) in any SkipLabs repo. Do not record SKJS-typechecker
  specifics here — those belong to the SKJS project, not to Skip-the-language
  lessons.

Example entry:

```markdown
### 2026-11-20 — Prefer exhaustive matches over a wildcard arm

Source: user correction. When matching on a variant type, enumerate the arms
explicitly instead of ending with `_`, so a new variant forces a decision at
every match site; use `_` only when the default is genuinely correct for any
future variant.

    // worse                    // better
    | Some(x) -> f(x)           | Some(x) -> f(x)
    | _ -> default              | None -> default
```

## Log

<!-- Newest entries first. Add yours at the top of this section. -->

_No entries yet — add the first one the next time you learn something, especially
when the user corrects you._
