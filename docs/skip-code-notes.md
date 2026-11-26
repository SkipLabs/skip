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
- **Bugs are not lessons.** This log is about how to _write_ Skip code, not
  about things that go wrong. Report bugs as GitHub issues
  (https://github.com/SkipLabs/skip/issues) — do not log them here.

Entry shape: `### <date> — <short title>`, then the rule in one or two
sentences, a source tag, and a before/after snippet when it helps.

## Log

<!-- Newest entries first. Add yours at the top of this section. -->

### 2026-11-26 — Pure `~>` closures cannot capture mutable variables; use `->`

Source: review (mixed positional/named params work, PR #1738). A pure lambda (`~>`) may not capture a mutable variable (e.g. a `BufferedPrinter.Out`) — declare the lambda `->` instead. Related: a plain `fun` helper invoked on a mutable object must be declared `readonly fun`.

### 2026-11-26 — Write non-terminating loops with `loop`, not `while (true)`

Source: review (PR #1738). `while (true)` is rejected by the compiler; use `loop { ... }` for non-terminating loops.

### 2026-11-26 — `values()` returns a mutable `Iterator`, not a collection; `Array` has `zip`, not `combine`

Source: review (PR #1738). `UMap.values()` returns a mutable `Iterator`, and iterators have no `.toArray()` — use `.items().map(...)` / `.collect(Array)` to get a collection. `Array` has `.zip`; `.combine` exists only on `Parameters`.

### 2026-11-26 — Lambda parameters cannot have default values

Source: review (PR #1738). Lambdas reject default parameter values language-wide (`(x = 1) => ...`); any new lambda parse path must reject `=` explicitly, or it ICEs later in `ensureIsExpression`.

### 2026-11-26 — `Ref(42)` const-folds to one shared constant; the void literal is `void`; qualify `--export-function-as`

Source: review (triage of #1724). In tests, `Ref(42)` const-folds to a shared image constant — two `Ref(42)` are the *same* pointer, so use `Array::mfill` when a test needs distinct objects. The void literal is `void`, not `()`. `--export-function-as` needs the module-qualified name (e.g. `Runtime_PhysEq.main=skip_main`), otherwise `main` is DCE'd under `--emit=llvm-ir --no-link`.

### 2026-11-26 — Initialize config-like state in the constructor, not by assigning a mutable field after construction

Source: user correction, from SkipLabs/skjs#1147 (`Parser.userLiteralSpelling`). When a class needs a piece of per-run configuration, make it a **non-mutable constructor field** with a default and pass it at the construction site, instead of declaring a `mutable` field and assigning it with `!x = ...` right after `Class(...)`. The mutable-field version leaves a window where the object exists with the wrong value, invites later mutation, and (because an updated variable cannot be captured by a pure lambda) can break closures that reference the variable. Note that class constructor arguments are positional (`Name => v` record syntax is for records only), so place the field where the call site can pass it — e.g. right after the first parameter — or rely on its default at sites that don't care.

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

### 2026-11-25 — Match extern return types to the C ABI; wrap an Int32-returning extern in an always-inlined Bool wrapper

Source: user correction, from a `skdb-wasm` CI failure (PR #1766). A `@cpp_extern` whose C function returns `uint32_t` must be declared `Int32` in `.sk` — declaring it `Bool` (i1) mismatches the C i32 return and links as a trapping `bitcast_invalid` stub on wasm32. If you want a `Bool`, declare the raw extern with the C-matching type and write a small `@always_inline` wrapper around it. Related: never call a pointer-signature extern (e.g. `SKIP_physEq(char*, char*)`) with value-class arguments (`void`, `Int`, `Bool`) — on wasm32 those arguments are erased, producing a zero-arg call that mismatches the declare and traps; only call such externs with pointer-represented arguments. When argument *representation* matters on wasm32, prefer a compiler intrinsic over a generic `@cpp_extern` — the `Int32`+wrapper pattern above is the fallback.

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

### 2026-11-25 — `uses Orderable, Equality` together conflict on `==`; only `!=` comes for free

Source: user correction (follow-up to skip#1765). Both traits define `==`, so a class using both fails with "Inheritance conflict needs resolution" until you write an explicit `fun ==(other: TheClass)` override in the class body — but `!=` needs nothing, since `Equality` supplies it as `!(this == other)`. Don't drop `Orderable` to dodge the conflict: a field of an `Orderable` class must itself be `Orderable` (its `compare` macro walks every field). And remember the default `==` is field-wise over *all* fields, including position-carrying ones like `Name`/`PosRange` — when position must not matter (e.g. two declarations of the same class at different positions), override `==` regardless.

    base class FieldAccess uses XXHashable, Orderable, Equality {
      fun ==(other: FieldAccess): Bool { /* by kind, ignoring pos */ }
      // no != needed — inherited from Equality
    }

### 2026-11-25 — Use the `Equality` trait for value comparison — `==` usually comes for free

Source: user correction (skip#1765). The `Equality` trait
(`skiplang/prelude/src/core/traits/Equality.sk`) supplies an overridable,
field-wise structural `==` (and `!=`), so a class that `uses Equality` gets
working equality without you writing any implementation — most of the time you
never write `==` at all. And never add a `kind(): String` (or reuse `toString`)
just to compare two values; with `Equality` on the class, callers write `a == b`
directly. Override `==` only when structural comparison isn't what you mean; on
a variant base class declare the override in the base body with the explicit
base type (`fun ==(other: FieldAccess)`), not `other: this` — children inherit
the member and `this` does not typecheck there.

    // no == implementation needed — it comes from the trait:
    value class Money(cents: Int) uses Equality
    a == b   // true iff every field is equal

    // worse: string conversion just to compare
    prev.access.kind() != f.access.kind()

    // better: custom == only when needed, declared with the explicit base type
    base class FieldAccess uses Equality {
      fun ==(other: FieldAccess): Bool { /* by kind, ignoring pos */ }
    }
    prev.access != f.access   // != also comes from the trait

### 2026-11-25 — Put variant classifiers on the value class, not as statics on an unrelated class

Source: user correction. A small helper that classifies, compares, or projects the variants of a value class belongs on that class itself — an instance method or a trait override in its body, where the exhaustive match over its `children` lives — not as a `static fun` on a distant class that happens to need it.

    // worse: static helper on an unrelated class
    // (on TEnv)  static fun accessKind(a: FieldAccess): String { ... }

    // better: on FieldAccess itself
    //            fun ==(other: FieldAccess): Bool { ... }

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
