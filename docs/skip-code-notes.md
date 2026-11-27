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
- **Newest entries first.** Keep each entry short: a `###` heading with a
  short title, one or two sentences stating the rule, and a small before/after
  snippet when it helps.
- **Don't duplicate.** If your lesson extends an existing entry, edit that
  entry instead of adding a near-copy. If an entry proves durable and general,
  promote it into the stable docs (root `AGENTS.md`, `HACKING.md`, or the
  relevant nested `AGENTS.md`) and leave a pointer here.
- This file is for lessons about writing Skip code (`.sk` sources, build/test
  workflow gotchas) in any SkipLabs repo. Do not record SKJS-typechecker
  specifics here — those belong to the SKJS project, not to Skip-the-language
  lessons.
- **Bugs are not lessons.** This log is about how to _write_ Skip code, not
  about things that go wrong. Report bugs as GitHub issues
  (https://github.com/SkipLabs/skip/issues) — do not log them here.

Entry shape: `### <short title>`, then the rule in one or two sentences, and a
before/after snippet when it helps.

## Log

<!-- Newest entries first. Add yours at the top of this section. -->

### Pure `~>` closures cannot capture mutable variables; use `->`

A pure lambda (`~>`) may not capture a mutable variable — declare it `->` instead. A plain `fun` helper invoked on a mutable object must be `readonly fun`.

### Write non-terminating loops with `loop`, not `while (true)`

`while (true)` is rejected; use `loop { ... }` for non-terminating loops.

### `values()` returns a mutable `Iterator`, not a collection; `Array` has `zip`, not `combine`

`UMap.values()` returns a mutable `Iterator`; iterators have no `.toArray()` — use `.items().map(...)` / `.collect(Array)` to get a collection. `Array` has `.zip`; `.combine` is on `Parameters`.

### Lambda parameters cannot have default values

Lambda parameters cannot have default values — `(x = 1) => ...` is rejected.

### `Ref(42)` const-folds to one shared image constant

Two `Ref(42)` are the *same* pointer — use `Array::mfill` when a test needs distinct objects.

### The void literal is `void`, not `()`

### `--export-function-as` needs the module-qualified name

Pass e.g. `Runtime_PhysEq.main=skip_main`; otherwise `main` is DCE'd under `--emit=llvm-ir --no-link`.

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

### Match extern return types to the C ABI; wrap an Int32-returning extern in an always-inlined Bool wrapper

A `@cpp_extern` whose C function returns `uint32_t` must be declared `Int32` — `Bool` (i1) mismatches the C i32 return and links as a trapping `bitcast_invalid` stub on wasm32. Never call a pointer-signature extern (e.g. `SKIP_physEq(char*, char*)`) with value-class arguments (`void`, `Int`, `Bool`): on wasm32 they are erased, producing a zero-arg call that traps. When argument representation matters, prefer a compiler intrinsic over a generic `@cpp_extern`.

    // worse: i1 return mismatches the C i32 return -> traps on wasm32
    @cpp_extern("SKIP_physEq")
    native fun phys_eq<T>(T, T): Bool;

    // better: raw extern matches the C ABI; small always-inlined Bool wrapper
    @cpp_extern("SKIP_physEq")
    @no_alloc
    native fun physEqRaw<T>(T, T): Int32;

    @always_inline
    fun phys_eq<T>(t: T, u: T): Bool {
      physEqRaw(t, u) != 0
    }

### `uses Orderable, Equality` together conflict on `==`; only `!=` comes for free

Both traits define `==`, so a class using both needs an explicit `fun ==(other: TheClass)` override; `!=` comes free from `Equality`. Don't drop `Orderable` to dodge the conflict — a field of an `Orderable` class must itself be `Orderable`. Default `==` is field-wise over *all* fields, including position-carrying ones like `Name`/`PosRange`; override it when position must not matter.

    base class FieldAccess uses XXHashable, Orderable, Equality {
      fun ==(other: FieldAccess): Bool { /* by kind, ignoring pos */ }
      // no != needed — inherited from Equality
    }

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

### Never build an Array by `append` in a loop; use a mutable Vector

`Array.append` returns a copy, so appending n elements in a loop is O(n²). Accumulate into a `mutable Vector` (amortized O(1) `push`) and call `.collect(Array)` once at the end if an Array is needed.

    // worse (quadratic)              // better
    r = Array<Int>[];                r = mutable Vector<Int>[];
    for (x in xs) {                  for (x in xs) {
      !r = r.append(f(x))              r.push(f(x))
    }                                }
                                     r.collect(Array)

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
