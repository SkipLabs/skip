# Function and method modifiers and annotations

Skip declarations carry two different kinds of decoration, and they behave very
differently:

- **Modifiers** are bare keywords (`private`, `static`, `mutable`, `untracked`,
  `native`, ...). They are part of the grammar and, in most cases, part of the
  type system. The compiler checks them and rejects what it does not understand.
- **Annotations** are `@name` or `@name("param")`. They are stored as plain
  strings and are mostly directives to the optimizer and the back end. The
  compiler does **not** validate them: an annotation it does not recognize is
  silently ignored.

This document lists both, and what each one actually does.

## Modifiers

### Visibility: `private`, `protected`

Everything is public by default. There is no `public` keyword — writing one is a
parse error that tells you so:

```text
Unexpected 'public'. Methods are public by default. Use 'protected' or 'private'
to change the visibility
```

`private` restricts a class member to code written inside the declaring class.
Inheritance does not grant access: a subclass cannot read its parent's private
members, even though it inherits them. Reading a private member from elsewhere
gives `Cannot access <name>` / `It was declared as private`.

`protected` allows access from the declaring class and from any descendant of it.
Because the parent list is transitive, access through a grandparent works.
`protected` is meaningless outside a class body and the parser will not accept it
on a top-level declaration.

Three details worth knowing:

- Privacy gates *reads* and `with`-updates, not construction. A public
  constructor can still set a private field: `class Holder{private secret: Int}`
  allows `Holder{secret => 7}`.
- A `private` member cannot be abstract, since nothing could ever implement it:
  *"Private methods in base classes must be defined for that class since they are
  only visible for that class"*.
- A `macro` method body is checked against the class it expands *into*, not the
  class that declares it, so a trait macro can read the private fields of a class
  that uses it. This is deliberate, and it is how `#forEachField`-based traits
  work.

Visibility on a **constructor** (`class X private ()`) gates construction, and
also gates `f with {x => v}` and `!f.x = v`, since both build a fresh object.
Under inheritance the two rules differ, which is easy to trip on:

- **Constructors** may *widen*: a child constructor must be as visible as, or
  more visible than, the parent's.
- **Methods and class constants** must match *exactly*: overriding a `protected`
  parent method with a public one is an error, just as narrowing would be.

> **Caveat: module-level `private` is not enforced.** `private fun`/`private
> class` inside a `module M; ... module end;` block parses, and the codebase uses
> it as an intent marker, but nothing prevents an outside caller — the privacy
> check for module elements is currently dead code. Treat it as documentation,
> not as a guarantee. (`private` at global scope, outside any module, *is*
> rejected.)

### `static`

Declares a method on the class rather than on an instance. A static method
receives an implicit `static` parameter instead of `this`, and is called as
`Class::method(...)`.

`static`, `readonly`, `mutable` and `frozen` are mutually exclusive — any two of
them on the same method is a parse error.

### Receiver mutability: unmodified, `readonly`, `mutable`, `frozen`

These control what the method may do to `this`, and which receivers it may be
called on. `mutable` and `readonly` methods are only legal in a `mutable class`
or a `trait`; `frozen` is legal on any class.

| Modifier | `this` may | Callable on |
| --- | --- | --- |
| *(unmodified)* | read | any immutable receiver — not `mutable`, not `readonly` |
| `readonly` | read | **any** receiver |
| `mutable` | read and write | `mutable` receivers only |
| `frozen` | read (`this` is deeply frozen) | *deeply* frozen receivers only |

The biggest trap in the system is that **the default is not the most permissive
option** — `readonly` is. On a `mutable class`, a plain `fun` cannot be called on
a mutable receiver, so this fails:

```skip
mutable class C() {
  fun parentFunc(): void { void }
  mutable fun childFunc(): void {
    this.parentFunc()  // error: Cannot call this method on a mutable object
  }                    // Try annotating 'parentFunc' method as 'readonly'
}
```

(That message is generated, and says `mutable` or `readonly` depending on the
receiver.)

`frozen` is stricter than the unmodified default, but by a different mechanism.
At the receiver-modality check the two are identical — both demand an immutable
receiver. The extra "deeply frozen" requirement is imposed as a *constraint* on
the class's type parameters, so it fails at a different point:

```skip
class Holder<T>(item: T) {
  frozen fun show(): String { "hi" }
  fun plain(): String { "hi" }
}

h = Holder(mutable Cell(1));  // immutable Holder, but a mutable Cell is
h.plain();                    // reachable through T: OK
h.show();                     // error: Constraint not satisfied
```

Because `readonly` accepts every receiver, it is also the direction in which
overrides may widen: a `readonly` child may override a `mutable` or unmodified
parent, but never the reverse.

`mutable` and `readonly` are also *type* prefixes (`mutable Vector<Int>`,
`readonly Bytes`). As prefixes they are shallow — they change only the outermost
modality, so `mutable Vector<mutable Vector<Int>>` needs the inner `mutable` too
— and they cannot be stacked (`mutable readonly Foo` is rejected). `frozen` is
different: as a type it is only valid as a *constraint* (`<T: frozen>`), and
`x: frozen Foo` does not parse.

### `overridable`

**Methods and class constants that have a body are final by default.** A child
may only override one that is declared `overridable`:

```text
Cannot override a final method. Class Cat attempted to override method speak from parent Animal
To override the method, Animal::speak must have the modifier 'overridable'
```

**Abstract members are the exact opposite.** A member with no body *must* be
overridden, so it needs no `overridable` — and declaring one `overridable` is an
error:

```text
Abstract methods cannot be declared as overridable since they MUST be overridden
```

`overridable` is only meaningful in a base class or trait.

Note that despite the wording of that error there is **no `final` method
modifier** — writing `final fun` is a parse error. Method finality is expressed
by *omitting* `overridable`. The `final` keyword exists, but it applies only to
a **constructor** (`base class B final (x: Int)`), where it stops subclasses from
adding fields to the inherited constructor:

```text
To add fields to an inherited constructor, it cannot be declared as final
```

### `untracked`

Functions are *tracked* by default. `untracked` marks a function, method or
lambda whose behaviour depends on external state or has side effects that must
not be reordered or merged.

Unlike an annotation, tracking is part of the function's **type**, so it is
enforced and it is transitive — the caller must itself be untracked:

```text
Cannot call an untracked function from a tracked context
```

Because it lives in the type, calls through function-typed values, overrides and
pipe (`|>`) applications all follow from ordinary subtyping. A tracked function
is usable where an untracked one is expected, but not the reverse. `untracked`
also appears in type position, where it must be followed by a lambda type:
`untracked () -> T`, `f: untracked T -> void`.

There are two escape hatches:

- `@allow_tracked_call` (below), on the declaration.
- `Unsafe.unsafe_untracked_call(f)`, which runs an `untracked () -> T` from
  tracked code. You take responsibility for correctness and invalidation.

A lambda's tracking context is snapshotted where the lambda is *written*, not
where it is solved, so solve order cannot silently change what is checked.

### `native`

Declares a function, method or constant with no body, implemented outside Skip.
A `native` declaration must also carry `@cpp_extern`, `@cpp_runtime` or
`@intrinsic`; if it does not, the compiler fails with an internal error rather
than a clean diagnostic:

```text
Internal error: Native functions must be declared with @cpp_extern, @cpp_runtime, or @intrinsic
```

(and the same with "methods" for a method). This is a back-end check, so
`skargo check` does not reach it.

`native` on a *class* means something else: the class gets an opaque constructor
and has no Skip-visible fields. You may not write a parameter list on it —
*"Cannot add parameters to a class marked 'native'"*. It does not make the
methods native either; each must still be marked `native` individually.

### `deferred`

Defers a member's definition to concrete subclasses; it may only be declared in a
base class. A deferred member is stripped from the class that declares it and the
marker is cleared when a *concrete* class inherits it. This is why a `deferred`
member resolves on a concrete class but not when the base class is named
directly.

### `macro`

Marks a body whose macro constructs are expanded at compile time — once per class
that inherits the method, which is why `#thisClassName` and `#ThisClass` resolve
differently per class. A `macro` function or method must have an expression body.

The macros are `#thisClassName`, `#ThisClass`, `#forEachField`,
`#forEachFunction`, `#env` and `#log`. They differ in what they need:

- `#thisClassName` and `#ThisClass` are bound only inside a **`macro` method** —
  they are the enclosing class's name and type.
- `#forEachField` iterates the enclosing class's fields, so it needs a method,
  but not necessarily a `macro` one.
- `#forEachFunction` and `#env` need neither a class nor, in most files, a
  `macro` body.

Since [#1182], `macro` is also allowed on top-level functions.

`#forEachFunction (@annotation, #f)` — or with an optional third argument,
`#forEachFunction (@annotation, #f, #name)` — enumerates **top-level functions**
(not methods) **by annotation**, across the program. This is the mechanism behind
user-defined annotations; see below.

### `async`

> **`async` is not currently usable.** It parses and type-checks, but it does not
> codegen: actually calling and awaiting an async function fails with an internal
> compiler error. There is no `Awaitable` class in the standard library, and the
> async compiler tests are disabled (`tests/Typechecking/Async*.disabled_async`).
> The rest of this section describes the intended design.

An `async fun` returns an awaitable type, written `^T`, and its result is
consumed with `await`. Using `await` outside an async context gives *"Cannot
await outside an async context"*. Besides the declaration modifier there is also
an `async { ... }` **block** expression, which re-enables `await` inside it.
There is no async lambda.

All parameters of an `async` function must be frozen:

```text
Invalid parameter. All parameters to a 'async' function must be frozen
```

That check is deliberately **skipped** when the function is also `untracked` or
`deferred`.

### Generators (`yield`)

There is no `generator` modifier: a function, method or lambda becomes a
generator purely by containing `yield` or `yield break`. A generator must return
exactly `mutable Iterator<T>` — not a subclass, not `readonly`, not a bare
`Iterator<T>` — because the back end generates an `Iterator` subclass for it.
Unlike `async`, generators work.

## Annotations

An annotation is `@name`, optionally with a single string argument,
`@name("param")`. They are stored as raw strings and matched exactly.

### Annotations are not validated

The parser accepts `@` followed by any identifier, and there is no whitelist and
no "unknown annotation" diagnostic. **A misspelled annotation is silently
accepted and does nothing.** This compiles without a warning:

```skip
@totally_bogus_annotation
@debbug                    // typo for @debug — silently does nothing
fun helper(): Int { 42 }
```

This matters because several annotations are load-bearing for correctness — a
typo in `@debug` silently restores CSE, and a missing `@may_alloc` is a silent
wrong-code risk (see below).

The openness is deliberate, though: the compiler indexes every function by the
annotations it carries, and `#forEachFunction (@foo, ...)` enumerates them. That
is how a library defines its own annotation without any compiler support —
sktest's `@test` is exactly this, and is not known to the compiler at all.

### Tracking and optimization

| Annotation | Effect |
| --- | --- |
| `@debug` | Prevents CSE of calls to this function. |
| `@allow_tracked_call` | Lets an `untracked` declaration be called from tracked code. |
| `@no_inline` | Prevents inlining. |
| `@always_inline` | Suppresses the inliner's size heuristic. |
| `@cpp_virtual` | Prevents devirtualization of a method. |

**`@debug`** does exactly one thing: it stops the optimizer from merging two
identical calls to the function. It has no effect on inlining, dead code,
codegen or the type checker. It matters because two calls with frozen arguments
and a frozen return type are otherwise assumed to produce identical results and
may be merged into one — which for a side-effecting function silently drops an
execution. It is what keeps `Random.next()` from folding `next() + next()` into a
single draw, and what keeps the I/O entry points in `Posix`, `FileSystem` and
`System` intact.

Crucially, `@debug` is **non-transitive**. Per the compiler's own comment, *"it
is not legal to eliminate a `@debug` call, but it is legal to CSE two calls to a
function that call a `@debug` function"* — the intent being to support
debug-by-print *"without the heavyweight transitive implications of 'important'
side effects like writing to an external database"*. So a plain wrapper around a
`@debug` call can still be merged. If you need the transitive guarantee, you need
`untracked`, not `@debug`. For a dynamic dispatch, CSE is allowed only when
*every* implementation the call might reach is CSE-able.

Note the name is misleading: `@debug` is not only for printing. It is the marker
for any function the optimizer must not merge.

**`@allow_tracked_call`** makes an `untracked` declaration *appear* tracked to
the type checker, so tracked code can call it. It is rejected on a declaration
that is not `untracked`. The back end deliberately ignores it and still treats
the function as untracked, so it still does not CSE.

**`@always_inline`** is not a guarantee — it only suppresses the size/`returns`
heuristic, and is still subject to the normal legality check, so `@no_inline` or
`@gc` silently defeat it.

### Native declarations

| Annotation | Effect |
| --- | --- |
| `@cpp_extern` / `@cpp_extern("SYM")` | Function is implemented in C++; body (if any) is discarded. |
| `@cpp_runtime` | As `@cpp_extern`, plus registers the function so later compiler phases can find it by name. Registration additionally requires the `native` keyword and a non-generic signature. |
| `@intrinsic` | Satisfies the `native` requirement; expansion itself is name-driven. |

The argument to `@cpp_extern("SYM")` is used **verbatim** as the linker symbol —
it is not mangled, which is what lets the prelude bind LLVM intrinsics directly:

```skip
@cpp_extern("llvm.sin.f64")
native fun sin(val: Float): Float;
```

If the argument is omitted, the symbol defaults to `SKIP_` plus the mangled
function name, so bare `@cpp_extern native fun replaceExn(...)` binds to
`SKIP_replaceExn`.

Both `@cpp_extern` and `@cpp_runtime` mark the function native **even without the
`native` keyword**, and any Skip body is then silently discarded. The prelude
relies on this deliberately, keeping a body as a readable fallback for other back
ends.

`@intrinsic` does not itself trigger any expansion — it only satisfies the rule
that a `native` declaration must carry one of the three. The actual intrinsic
expansion is keyed off the function's *name*.

#### `@cpp_extern` vs `@cpp_runtime`

These two overlap almost entirely, and the prelude uses `@cpp_extern` about
twenty times as often (≈130 vs ≈7), so `@cpp_extern` is the one to reach for by
default. They share everything that matters at the call site: both mark the
function native, discard any Skip body, emit an external LLVM *declaration*
rather than a definition, default the symbol to `SKIP_` + the mangled name, and
count as roots so the declaration is never dead-code eliminated.

There is exactly one behavioural difference. A `@cpp_runtime` function that is
also `native` and **non-generic** is registered in an internal name → function
table, so a *later compiler pass can synthesise a call to it by its Skip name*
even when nothing in the program visibly calls it. The comment at the
registration site (`OuterIstToIR.sk`) states the intent:

> Guarantee we create Functions for all native runtime functions, so later
> stages of the compiler can look them up by name even if they aren't obviously
> used until later (e.g. lowering).

Only a handful of functions actually depend on this, and they are runtime hooks
the compiler emits itself: coroutine lowering looks up `Awaitable.awaitableSuspend`,
and const lowering looks up `print_last_exception_stack_trace_and_exit`. If one
of those carried `@cpp_extern` instead, the pass that needs it would not find it.

So, choosing between them:

- Binding a plain external C, C++ or LLVM symbol — which is almost every native
  declaration — use **`@cpp_extern`**.
- A function the **compiler itself** must be able to call by name from a later
  pass (a coroutine/const/lowering runtime hook) — use **`@cpp_runtime`**, and it
  must be `native` and non-generic for the registration to take effect.

Beyond that one mechanism, `@cpp_runtime` also reads as a convention marker for
"this belongs to the Skip runtime library, and its Skip body is a portable
reference implementation that the native back end replaces." `intern` (identity
fallback) and `multiThreadedTabulate` (*"replaced in the native back end with one
that actually uses threads"*) are written this way. Both are generic, so they get
*only* the convention, not the registration — which is a good reminder that on a
generic function `@cpp_runtime` and `@cpp_extern` are behaviourally identical, and
the choice is purely stylistic.

One shared gotcha worth repeating: because either annotation makes the function
native, a Skip body on a `@cpp_runtime`/`@cpp_extern` function is silently
discarded in this back end. That is exactly what makes the "portable fallback"
pattern work — the body documents the semantics and serves other back ends — but
it means the body you see is not the code that runs.

### Contracts on native functions

| Annotation | Effect | Default if absent |
| --- | --- | --- |
| `@may_alloc` | The function may allocate without bound. | **Allocates nothing** |
| `@no_throw` | The function cannot throw. | May throw |
| `@no_return` | The function never returns. | Returns |

These three are **only read for functions with no body** — that is, `native`,
`@cpp_extern` or `@cpp_runtime` declarations. On a function with a body they are
silently ignored, and the compiler derives the answer from the body instead. The
prelude contains dead examples of exactly this: `print_string` carries `@no_throw`
and `skipExit` carries `@no_return`, but both have bodies, so both annotations do
nothing.

`@no_throw` and `@no_return` default to the safe answer when absent.
**`@may_alloc` does not.** A native function without it is assumed to allocate
nothing, so forgetting it on an allocating runtime function is a silent
wrong-code risk with no diagnostic.

### Exports

| Annotation | Effect |
| --- | --- |
| `@export("NAME")` | Exported on **both** native and wasm targets. |
| `@cpp_export("NAME")` | Exported on native targets only. |
| `@wasm_export("NAME")` | Exported on wasm targets only. |

All three force external linkage and keep the function alive through dead-code
elimination. The target-specific ones take precedence over `@export` when both
carry a name. `@wasm_export` is a **no-op on native targets** — a function marked
only `@wasm_export` is not exported in a native build and may be eliminated.

`@cpp_export` on a **class** means something different: it pins the field layout
(declaration order, naturally aligned) instead of letting the compiler choose,
and keeps the object a real heap object. Such a class must be final and may not
extend a base class — violating that is a back-end internal error rather than a
clean diagnostic, so `skargo check` does not catch it.

### Garbage collection

| Annotation | Effect |
| --- | --- |
| `@gc` | Collect at every return and throw of this function. |
| `@no_gc` | Suppress automatic collection for this function. |

> **These have no runtime effect today.** The collection primitives are disabled
> in the runtime — `obstack.c` carries a *"Collection primitive (disabled)"*
> section, `SKIP_Obstack_collect` is an empty function, and the inline
> entrypoints in the preamble return without doing anything. The compiler still
> runs the whole local-GC pass and emits the calls; they lower to no-ops. What
> follows describes what the annotations tell the *compiler*.

By default a function is given automatic local GC if it is inferred to allocate
an unbounded amount — in practice, if it allocates in a loop or recurses while
allocating.

`@no_gc` beats `@gc`: given both, you get neither, with no error. `@gc` also
makes the function permanently ineligible for inlining, which is why real uses
pair it with `@no_inline`.

### Diagnostics and tooling

**`@synonym("name")`** registers an alternate name for a method, used *only* by
the "Did you mean ...?" suggestion when a lookup fails. It has no effect on name
resolution or dispatch — it does not create a callable alias. It is read only for
class methods; on a top-level function it does nothing.

**`@disasm`** marks a function for disassembly. It does nothing unless the
compiler is invoked with `--disasm-annotated`, in which case the function is
force-compiled and emitted with machine-readable markers.

### Not annotations

`@anything` and `@param` look like annotations but are not, and cannot be
written:

- `@anything` is how the pretty-printer renders the type checker's internal
  "unconstrained" type. You only ever see it in a compiler type dump.
- `@param0`, `@param1`, ... are synthesized names for unnamed positional
  parameters. The leading `@` is deliberate: no user identifier can start with
  `@`, so the names cannot collide.

Writing either one parses as an unknown annotation and is silently ignored.

[#1182]: https://github.com/SkipLabs/skip/issues/1182
