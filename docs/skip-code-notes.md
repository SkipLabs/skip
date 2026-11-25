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

Entry shape: `### <date> — <short title>`, then the rule in one or two
sentences, a source tag, and a before/after snippet when it helps.

## Log

<!-- Newest entries first. Add yours at the top of this section. -->

### 2026-11-25 — `uses Equality` gives you `==` for free — usually don't write it

Source: user correction (skip#1765). The `Equality` trait
(`skiplang/prelude/src/core/traits/Equality.sk`) supplies an overridable,
field-wise structural `==` (and `!=`), so a class that `uses Equality` gets
working equality without you writing any implementation — most of the time you
don't write `==` at all. Override it only when structural comparison isn't what
you mean; on a variant base class declare the override with the explicit base
type (`fun ==(other: FieldAccess)`), not `other: this` (see the entry below).

    // no == implementation needed — it comes from the trait:
    value class Money(cents: Int) uses Equality
    a == b   // true iff every field is equal

### 2026-11-25 — Put variant classifiers on the value class, not as statics on an unrelated class

Source: user correction. A small helper that classifies, compares, or projects the variants of a value class belongs on that class itself — an instance method or a trait override in its body, where the exhaustive match over its `children` lives — not as a `static fun` on a distant class that happens to need it.

    // worse: static helper on an unrelated class
    // (on TEnv)  static fun accessKind(a: FieldAccess): String { ... }

    // better: on FieldAccess itself
    //            fun ==(other: FieldAccess): Bool { ... }

### 2026-11-25 — Compare values with the Equality trait, not by converting to String

Source: user correction. Don't add a `kind(): String` (or reuse `toString`) just to compare two values — make the class `uses Equality` and override `==` so callers write `a == b` directly. When overriding `==` on a variant base class, declare it in the base body with the explicit base type (`fun ==(other: FieldAccess)`), not `other: this` — children inherit the member and `this` does not typecheck there.

    // worse: string conversion just to compare
    prev.access.kind() != f.access.kind()

    // better: Equality on the class, callers compare values
    base class FieldAccess uses Equality {
      fun ==(other: FieldAccess): Bool { /* by kind, ignoring pos */ }
      fun !=(other: FieldAccess): Bool { !(this == other) }
    }
    prev.access != f.access

### 2026-11-24 — Never build an Array by `append` in a loop; use a mutable Vector

Source: user correction. `Array.append` returns a copy, so appending n elements
in a loop is O(n²). Accumulate into a `mutable Vector` (amortized O(1) `push`)
and call `.collect(Array)` once at the end if an Array is needed.

    // worse (quadratic)              // better
    r = Array<Int>[];                r = mutable Vector<Int>[];
    for (x in xs) {                  for (x in xs) {
      !r = r.append(f(x))              r.push(f(x))
    }                                }
                                     r.collect(Array)

### 2026-11-24 — Use `.any()` / `.all()` instead of flag-and-full-scan loops

Source: user correction. Don't write `found = false; for (x in xs) { if (p(x))
!found = true }; if (found) ...` — the loop always scans everything. `.any(p)`
short-circuits on the first match and `.all(p)` on the first failure, and read
better.

    // worse                          // better
    found = false;                   hasCmp = xs.any(x -> x is IntCmpUle _);
    for (x in xs) {                  if (hasCmp) { ... }
      if (p(x)) !found = true
    };                               // or: xs.all(x -> p(x))
    if (found) { ... }

Only keep a manual flag when the loop body must do real work per element.

### 2026-11-24 — Style rules don't apply to tests

Source: user correction. The rules in this log (and in the stable docs) govern
`.sk` sources; they do not apply to test files under `tests/` and
`invalid_tests/` — e.g. building expected output with `+` concatenation is
fine there, and test files are also excluded from `skfmt` (see the `fmt-sk`
target in the Makefile). Don't rewrite tests or goldens to satisfy a style
rule.

### 2026-11-23 — Prefer exhaustive matches over a wildcard arm

Source: user correction. When matching on a variant type, enumerate the arms
explicitly instead of ending with `_`, so that adding a new variant forces an
explicit decision at every match site; use `_` only when the default is
genuinely correct for any future variant, and say why.

    // worse                    // better
    | Some(x) -> f(x)           | Some(x) -> f(x)
    | _ -> default              | None() -> default
