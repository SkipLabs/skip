# Skip Code Notes (Living Style & Lessons Log)

The **canonical** living collection of **style preferences and newly learned
lessons** for writing good **Skip** code across the SkipLabs repos — other repos
(e.g. SkipLabs/skjs) link here instead of keeping their own copy.

For stable language, standard library, tooling/FFI, and SKStore references, see
[`skiplang/docs/`](../skiplang/docs/):
- [language.md](../skiplang/docs/language.md) — core language grammar, types, mutability, purity, patterns, macros
- [modifiers-and-annotations.md](../skiplang/docs/modifiers-and-annotations.md) — modifier & `@annotation` semantics
- [stdlib.md](../skiplang/docs/stdlib.md) — `std` primitives, traits, collections, I/O, first-party packages
- [tooling-and-ffi.md](../skiplang/docs/tooling-and-ffi.md) — `skargo`, `sktest`, `skfmt`, `skc`, C/Wasm FFI
- [SKStore.md](../skiplang/docs/SKStore.md) — reactive store & incremental efficiency

## How to Contribute

- **Read the latest entries before writing `.sk` code**, alongside the relevant
  reference(s) under `skiplang/docs/`.
- **Append an entry whenever you learn a new lesson — above all when the user
  tells you to do something differently.** If the user corrects your Skip code
  (style, pattern, naming, structure, anything), record the correction here in
  its own PR, then apply it to the work in progress. Do not wait to be asked
  twice.
- **Newest entries first.** Keep each entry short: a `###` heading with a
  short title, one or two sentences stating the rule, and a small before/after
  snippet when it helps.
- **Promote durable facts into `skiplang/docs/`, don't duplicate.** If an entry
  is a compiler/stdlib/tooling/FFI/SKStore fact rather than a house style
  preference, add or update it directly in the appropriate `skiplang/docs/*.md`
  file instead of duplicating it here.
- This file is for lessons about writing Skip code (`.sk` sources) in any
  SkipLabs repo. Do not record SKJS-typechecker specifics here — those belong to
  the SKJS project, not to Skip-the-language lessons.
- **Bugs are not lessons.** This log is about how to _write_ Skip code, not
  about things that go wrong. Report bugs as GitHub issues
  (https://github.com/SkipLabs/skip/issues) — do not log them here.

Entry shape: `### <short title>`, then the rule in one or two sentences, and a
before/after snippet when it helps.

## Log

<!-- Newest entries first. Add yours at the top of this section. -->

### Initialize config-like state in the constructor, not by assigning a mutable field after construction

Make per-run configuration a **non-mutable constructor field** with a default and pass it at the construction site, instead of a `mutable` field assigned with `!x = ...` after `Class(...)`. Constructor arguments are positional (`Name => v` is record-only syntax), so place the field where the call site can pass it.

    // worse: mutable field, assigned after construction
    mutable class Parser(
      lex: mutable Lexer,
      ...,
      mutable userLiteralSpelling: Bool = false,
    );
    parser = mutable Parser(lexer);
    !parser.userLiteralSpelling = getConfig(context).compilerOptions.userLiteralSpelling;

    // better: non-mutable field, initialized during construction
    mutable class Parser(
      lex: mutable Lexer,
      userLiteralSpelling: Bool = false,
      ...,
    );
    parser = mutable Parser(lexer, getConfig(context).compilerOptions.userLiteralSpelling);

### Use the `Equality` trait for value comparison — `==` usually comes for free

`uses Equality` (`skiplang/prelude/src/core/traits/Equality.sk`) supplies field-wise structural `==`/`!=` — usually write no implementation and compare with `a == b` directly, never via a `kind(): String`/`toString` detour. Override `==` only when structural comparison isn't what you mean; on a variant base class declare it with the explicit base type (`fun ==(other: FieldAccess)`), not `other: this`.

    // no == implementation needed — it comes from the trait:
    value class Money(cents: Int) uses Equality
    a == b   // true iff every field is equal

    // better: custom == only when needed, declared with the explicit base type
    base class FieldAccess uses Equality {
      fun ==(other: FieldAccess): Bool { /* by kind, ignoring pos */ }
    }
    prev.access != f.access   // != also comes from the trait

### Put variant classifiers on the value class, not as statics on an unrelated class

A helper that classifies, compares, or projects the variants of a value class belongs on that class itself — an instance method or trait override in its body — not as a `static fun` on a distant class.

    // worse: static helper on an unrelated class
    // (on TEnv)  static fun accessKind(a: FieldAccess): String { ... }

    // better: on FieldAccess itself
    //            fun ==(other: FieldAccess): Bool { ... }

### Use `.any()` / `.all()` (including on `Range`) or loop return values instead of flag loops

`.any(p)` short-circuits on the first match and `.all(p)` on the first failure — and `Range` is a `Sequence`, so index-based checks can use `Range(0, n).all(i -> ...)` directly instead of a mutable flag. When you genuinely need a loop, return a value from it with `for (...) { if (...) break false } else { true }` rather than mutating a boolean flag before `break void`.

    // worse
    equal = true;
    for (i in Range(0, n)) {
      if (native_eq(a[i], b[i]) != 0) {
        !equal = false;
        break void;
      }
    };
    if (equal) return void;

    // better (Sequence / Range)
    if (Range(0, n).all(i -> native_eq(a[i], b[i]) == 0)) return void;

    // better (when a loop is needed)
    equal = for (i in Range(0, n)) {
      if (native_eq(a[i], b[i]) != 0) break false;
    } else {
      true
    };

### Style rules don't apply to tests

Rules in this log govern `.sk` sources, not test files under `tests/` and `invalid_tests/` (also excluded from `skfmt`, see the `fmt-sk` target in the Makefile) — don't rewrite tests or goldens to satisfy a style rule.

### Prefer exhaustive matches over a wildcard arm

When matching on a variant type, enumerate the arms explicitly instead of ending with `_`, so that adding a new variant forces an explicit decision at every match site; use `_` only when the default is genuinely correct for any future variant, and say why.

    // worse                    // better
    | Some(x) -> f(x)           | Some(x) -> f(x)
    | _ -> default              | None() -> default
