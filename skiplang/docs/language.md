# Skiplang Core Language Reference

Dense, compiler-grounded reference for writing Skip (`.sk`) code. Sources of truth: `skiplang/compiler/src/`, `skiplang/compiler/{tests,invalid_tests}/`, and [modifiers-and-annotations.md](modifiers-and-annotations.md).

Companion docs:
- [modifiers-and-annotations.md](modifiers-and-annotations.md) — full modifier & `@annotation` semantics
- [stdlib.md](stdlib.md) — `std` prelude primitives, traits, collections, I/O, first-party packages
- [tooling-and-ffi.md](tooling-and-ffi.md) — `skargo`, `sktest`, `skfmt`, `skc`, C/Wasm FFI
- [SKStore.md](SKStore.md) — incremental reactive engine & efficiency rules

---

## 1. Quick-Hit Rules (Common Agent Mistakes)

- **No `let` / `var` / `val`, no `public`, no `fn`/`function`**: bind with `x = expr`, reassign with `!x = expr`. Everything is public by default.
- **Semicolons separate expressions** in a block (`e1; e2`), even after `if`/`match`/`for`/`while`. A trailing `;` does **not** suppress the block's return value. Empty block is `{ void }`, never `{}`.
- **The `void` literal is `void`**, never `()`.
- **Unused locals and unused positional parameters are compile errors** — prefix unused names with `_` (`_x`). Reading an unbound `_`-prefixed name is a compile error.
- **Methods & class constants are final by default** — mark `overridable` in base classes/traits to allow overriding. Abstract methods (no body, ending in `;`) cannot be marked `overridable`.
- **Plain `fun` on a `mutable class` cannot be called on `mutable` or `readonly` receivers** — use `readonly fun` for read-only helpers, `mutable fun` for mutators.
- **Pure `~>` closures cannot capture mutable locals** — use `->` when capturing/mutating locals.
- **`while (true)` is a compile error** — use `loop { ... }`.
- **No `return`, `break`, or `continue` directly inside `try { ... } catch { ... }`** — return a value from `try`/`catch` instead.
- **Collection literals require the type prefix**: `Array[1, 2]`, `mutable Vector[1, 2]`, `Map["a" => 1]`; bare `[1, 2]` is a syntax error.
- **Match guards use `if (cond)`** (not `when`/`where`). **Pattern as-bindings use `x @ Pat`** (not `as`; `expr as Pat` is a runtime-checked cast).
- **`freeze()` and `async`/`await` (`^T`) are unavailable in the current backend**: use `.chill()` / `.collect(Array)` instead of `freeze()`; do not call `async fun`.

---

## 2. Lexical Rules & Literals

### Identifiers & Case Significance

Identifiers match `[A-Za-z_][A-Za-z0-9_]*`. Leading `$` is a lexer error.

| Form | Meaning |
| --- | --- |
| Uppercase-initial (`Foo`, `T`) | Classes, traits, modules, type parameters, type aliases, type constants, uppercase pattern constants |
| Lowercase / `_`-initial (`x`, `_unused`) | Locals, parameters, fields, functions, methods, lowercase constants |
| `#`-prefixed (`#ThisClass`, `#forEachField`) | Macro type or value identifiers |

Comments: `// line` and `/* non-nested block */`.

### Keywords

- **Hard keywords**: `as`, `async`, `await`, `break`, `catch`, `children`, `class`, `const`, `continue`, `do`, `else`, `extends`, `false`, `for`, `fun`, `if`, `in`, `loop`, `macro`, `module`, `mutable`, `native`, `private`, `protected`, `readonly`, `return`, `static`, `this`, `throw`, `trait`, `true`, `try`, `uses`, `void`, `while`, `yield`, `overridable`, `frozen`, `deferred`, `untracked`, `final`, `#forEachField`, `#forEachFunction`, `#log`, `#env`.
- **Contextual keywords**: `alias`, `base`, `default`, `end`, `extension`, `from`, `inst`, `is`, `match`, `nonNullable`, `type`, `value`, `with`, `_`.
- **Rejected non-keywords**: `public`, `let`, `var`, `val`, `fn`, `func`, `function`, `===`, `!==`, `**`.

### Literals

| Type | Syntax & Rules |
| --- | --- |
| `Int` (64-bit signed) | `42`, `-9223372036854775808`, `0xff`, `0o755`. No binary literals, no `_` separators. |
| `Float` (64-bit IEEE 754) | `1.0`, `1e5`, `1.5e-3`. |
| `Bool` | `true`, `false`. |
| `Void` (`void`) | `void`. |
| `Char` (Unicode scalar) | `'a'`, `'\n'`, `'\x41'`, `'\u0041'`, `'\U0001F600'`. No raw newlines, no `''`. |
| `String` (UTF-8) | `"hello\n"`. Same escapes as `Char`. No raw strings, no unescaped newlines. |
| Template string | `` `sum = ${a + b}` ``. Multiline allowed. `${...}` takes any block expression whose result supports `.toString()`. Literal `$` when not followed by `{`. |
| Tuple (2..10 elements) | `(a, b)`, `(a, b, c)` (`Tuple2`..`Tuple10`, fields `.i0`..`.i9`). No 0-tuple or 1-tuple. |
| Collection literal | `Array[1, 2]`, `mutable Vector<Int>[]`, `Map["a" => 1]`. Desugars to `C::createFromItems(Array[...])` or `C::mcreateFromItems(...)`. |

---

## 3. Operators, Bindings & Control Flow

### Operator Precedence (Highest to Lowest)

All binary operators are left-associative. There are no bitwise operators (use `Int` methods `.and()`, `.or()`, `.xor()`, `.shl()`, `.shr()`, `.ushr()`, `.not()`), no ternary `?:`, and no `+=`.

| Prec | Form | Notes |
| --- | --- | --- |
| 1 | `e<T>(...)`, `e(...)`, `e{k => v}`, `e[i]`, `e.m`, `E::m`, `e?` | `e?` propagates failure via `.liftFailure()` (`Option`, `Result`); binds tighter than `match` so wrap `(e match { ... })?` |
| 2 | `!e`, `-e`, `mutable e` | Right-associative unary prefix |
| 3 | `e match { ... }`, `e is Pat`, `e as Pat` | Matching & type test/cast |
| 4 | `*`, `/`, `%` | Overloadable |
| 5 | `+`, `-` | Overloadable |
| 6 | `<`, `>`, `<=`, `>=` | Overloadable |
| 7 | `==`, `!=` | Overloadable |
| 8 | `&&` | Short-circuiting; overloadable |
| 9 | `\|\|` | Short-circuiting; overloadable |
| 10 | `\|>` | Pipe: `x \|> f` ≡ `f(x)` |
| 11 | `e with { field => val, ... }` | Shallow functional record copy |
| 12 | `lval [: T] = expr`, `lval =. method(...)` | Binding / reassignment |

### Bindings & Reassignment

- **Fresh binding**: `x = 1`, `x: Int = 1`, `(a, b) = pair`. Rebinding `x = 2` in the same scope is a compile error.
- **Reassignment (`!`)**:
  - `!x = 2` — reassign local `x` (expression type is `void`).
  - `obj.!field = v` — mutate a `mutable` field in place on a `mutable` receiver.
  - `!obj.field = v` / `!obj.a.b = v` — functional copy via `with` + local reassignment.
  - `arr![i] = v` — in-place mutable index set (`set(i, v)`).
  - `!arr[i] = v` — functional update + local reassignment.
  - `vec![] = v` — append element.
  - `(a, !b) = pair` — mix fresh binding and reassignment in tuple destructuring.
- **Method-update shorthand**: `!x =. foo(1)` desugars to `!x = x.foo(1)`.
- **`mutable` prefix**: valid only directly before a constructor call (`mutable Box(1)`), collection literal (`mutable Vector[]`), or static factory (`mutable Map::mcreate()`).

```skip
fun bindingsDemo(): Int {
  x = 1;
  !x = x + 2;
  v = mutable Vector[10, 20];
  v![0] = 30;
  v.push(40);
  (a, !x) = (v[0], v[2]);
  a + x
}
```

### Control Flow (All Expressions)

- **`if`**: `if (cond) e1 else e2`. Condition must be parenthesized. Omitting `else` implies `else void`, so `e1` must be `void`.
- **`loop`**: `loop { ...; break value }`. Type is the join of all `break` expressions.
- **`while` / `do ... while`**: `while (cond) body [else noBreakExpr]`, `do body while (cond) [else noBreakExpr]`. `while (true)` is rejected (use `loop`). The `else` branch runs only when the loop terminates normally without `break`.
- **`for`**: `for (binding in coll) body [else noBreakExpr]`:
  - `for (x in coll)` iterates `coll.values()`.
  - `for ((a, b) in pairs)` destructures tuples from `.values()`.
  - `for (k => v in map)` iterates `map.items()`.
  - No C-style `for (;;)`.
- **`break expr` / `continue` / `return expr`**: `break` and `return` always take an explicit value (`break void`, `return void`).
- **`try` / `catch` / `throw`**:
  - `try { body } catch { | MyExn(m) -> handle(m) | e -> fallback(e) }`
  - `throw expr` takes any `Exception` subclass (bottom type).
  - **Restriction**: `return`, `break`, and `continue` are forbidden directly inside `try`/`catch`.
- **Generators (`yield` / `yield break`)**:
  - Any function, method, or lambda containing `yield expr` (or `yield break`) is a generator and must return `mutable Iterator<T>`. An implicit `yield break` is appended at the end.

```skip
fun findFirstPositive(xs: Array<Int>): ?Int {
  for (x in xs) {
    if (x > 0) break Some(x);
  } else {
    None()
  }
}

fun evensUpTo(n: Int): mutable Iterator<Int> {
  i = 0;
  while (i <= n) {
    if (i % 2 == 0) yield i;
    !i = i + 1;
  }
}

fun safeDiv(a: Int, b: Int): Int {
  try {
    a / b
  } catch {
  | DivisionByZeroException() -> 0
  | exn -> throw exn
  }
}
```

---

## 4. Modules & Visibility

```skip
module alias T = SKTest; // aliases MUST precede all declarations in the file

module MathUtil;

const kBase: Int = 10;

private fun helper(x: Int): Int {
  x + kBase
}

fun scaled(x: Int): Int {
  helper(x) * 2
}

module end;
```

- **Flat modules**: `module Name; ... module end;` (no braces, no nesting). Reopening `module Name;` in multiple files merges declarations.
- **Access**: `Module.member` (`.`), `Class::staticMember` (`::`), `.GlobalName` (leading `.` reaches global scope).
- **Global hoisting**: prefixing a declaration inside a module with `.` (e.g. `class .Foo`, or `class .` inside `module Foo`) places it in the global namespace.
- **Visibility**:
  - Default is public (no `public` keyword).
  - **`private` at module scope**: accessible only inside the declaring module (enforced by compiler). Illegal at global scope or on `.`-hoisted declarations.
  - **`private` on class member**: accessible only inside the declaring class (not subclasses). Cannot be abstract.
  - **`protected` on class member**: declaring class and all descendants. Illegal at module/global scope.
  - **Constructor visibility**: gates construction, `with`-updates, and `!x.field = v`. May widen in subclasses; method/const visibility must match exactly when overriding.
  - Private fields may still be initialized through a public constructor.

---

## 5. Classes, Inheritance, Traits & Type Aliases

### Class Kinds

| Declaration | Semantics & Constraints |
| --- | --- |
| `class C(...)` | Concrete, final (cannot be extended). |
| `base class B(...)` | Abstract/extensible base class; cannot be instantiated directly. |
| `value class V(...)` | Unboxed by-value concrete class. Cannot be `base`, cannot `extend` a base class, cannot have `mutable` fields (an immutable field holding `mutable T` is allowed). Can `use` traits. |
| `mutable class M(...)` | Allows `mutable M(...)` instances, `mutable` fields, `mutable`/`readonly` methods. A `mutable` child cannot extend a non-mutable `base class`. |
| `native class N` | Opaque runtime-backed class; cannot declare constructor parameters. |
| `extension class C { ... }` | Adds methods, constants, types, `extends`, `uses`, `children`, named fields to existing class/base class/trait in the same module. Cannot add generics or change class kind. |

### Constructors, Fields & `with`-Updates

- **Positional**: `class Point(x: Int, y: Int = 0)` — called `Point(1, 2)` or `Point(1)`. Defaulted positional parameters must appear at the end. Unnamed positional fields (`class Wrap(Int)`) can only be extracted by pattern matching.
- **Named (record)**: `class Config{host: String, port: Int = 8080}` — called `Config{host => "localhost"}` (shorthand `Config{host}` when local `host` is in scope). Defaulted named parameters may appear in any order.
- **Mixed**: `class Entry(id: Int){label: String}` or `class Entry{label: String}(id: Int)`.
- **Constructor inheritance**: `base class B final (id: Int)` prevents subclasses from adding fields. Without `final`, child fields are prepended before parent fields.
- **`with`-update**: `cfg with {port => 9090}` copies with updated named fields (works on positional or named classes whose fields are named).

### Algebraic `children =` & Algebraic Methods

```skip
base class Expr {
  children =
  | Lit(Int)
  | Add{lhs: Expr, rhs: Expr}

  fun eval(): Int
  | Lit(n) -> n
  | Add{lhs, rhs} -> lhs.eval() + rhs.eval()
}
```

- `children = | ...` (only inside `base class`) desugars each variant into a top-level concrete `class` extending the base class, inheriting `private`, `mutable`, and type parameters.
- Algebraic methods dispatch directly by pattern arms (no `if` guards on algebraic method arms; use explicit `this match { ... }` if guards are needed).

### Inheritance, Traits & Conflicts

- **Classes** `extend` `base class`es and `use` `trait`s: `class C extends B uses T1, T2`.
- **Traits** `extend` other traits only (`trait T2 extends T1`); traits cannot `use` traits or `extend` classes.
- **Conditional trait usage**: `class Box<+T>(value: T) uses Equality[T: Equality], Show[T: readonly Show]` (not allowed if the trait defines `const` or `type` constants).
- **Overriding**:
  - Concrete methods/consts are final by default; add `overridable` in the base class or trait to allow overriding.
  - Abstract methods (`fun f(): Int;`) have no body and must not be marked `overridable`.
  - Resolve diamond conflicts explicitly: `fun foo from ParentA;` or `const k from ParentA;`.
  - **`deferred`**: marks a base-class/trait member whose body is re-checked against each concrete subclass (`deferred static fun` can construct `this`).

### Type Aliases & Associated Types

- **Module/global alias**: `type StrMap<V> = Map<String, V>;` (no variance annotations on alias type parameters).
- **Associated type (`type` constant)** inside a class or trait (no visibility/static modifiers):
  - Concrete: `type Elem = Int;`
  - Abstract: `type Elem;` or `type Elem: Orderable;`
  - Default in `base class`: `type Elem: Orderable default Int;` (never combine `: Constraint` with `= Type`; use `default`).
  - Access via `::`: `this::Elem`, `MyClass::Elem`. Type constants and class `const`s cannot reference enclosing class type parameters.

---

## 6. Type System: Generics, Variance, Mutability & Purity

### Generics, Constraints & Method `when` Clauses

- Bounds use `:` and `&`: `fun sort<T: Orderable & Show>(xs: Array<T>): Array<T>`.
- **Constraint-only keywords**:
  - `frozen` — deeply immutable (contains no mutable references anywhere).
  - `nonNullable` — excludes `Option` (`?T`).
- **Method-level `when` clause** `[T: Bound]` appears after `<MethodTParams>` and before `(`/`{`, constraining an enclosing class type parameter only when that method is called:

```skip
class Wrapper<+T>(value: T) {
  fun describe[T: readonly Show](): String {
    `Wrapper(${this.value})`
  }
}
```

### Variance

Allowed only on class/trait type parameters (not functions, methods, or type aliases):
- `T` — invariant (default).
- `+T` — covariant (output positions and immutable constructor fields).
- `-T` — contravariant (input positions).

Variance checking is bypassed inside `mutable` methods, and `static` methods ignore class type parameter variance.

### Special Types

| Type | Meaning |
| --- | --- |
| `?T` | Sugar for `Option<T>` (`Some(x)` / `None()`). |
| `this` | Dynamic receiver type (covariant self type in class/trait). |
| `inst` | Valid **only inside a `trait`**; substituted with the using class (use in contravariant positions like `fun ==(other: inst): Bool`). |
| `_` | Fresh anonymous type parameter in signatures; inferred type wildcard in type arguments/annotations. |

### Mutability, `readonly`, `frozen` & `const`

Three shallow reference modalities (cannot stack, e.g. no `mutable readonly T`; `frozen T` is invalid type syntax):

| Type | Allows | Subtyping |
| --- | --- | --- |
| `T` (chilled / immutable) | `fun`, `readonly fun`, `frozen fun` (if deeply frozen) | `T <: readonly T` |
| `mutable T` | `mutable fun`, `readonly fun`, `obj.!field = v` | `mutable T <: readonly T` |
| `readonly T` | `readonly fun` only | Supertype of `T` and `mutable T` |

Receiver modifiers on methods (`static`, `mutable`, `readonly`, `frozen` are mutually exclusive):
- `fun` — chilled receiver **only** (cannot be called on `mutable` or `readonly` objects!).
- `readonly fun` — callable on immutable, `mutable`, and `readonly` receivers. **Only valid on `mutable class` or `trait`** (writing `readonly fun` on a non-mutable `class`/`value class` is a compile error; plain `fun` already implements a trait's `readonly fun`).
- `mutable fun` — callable on `mutable` receivers only; can mutate `this.!field`.
- `frozen fun` — implicitly adds `[T: frozen]` for every enclosing class type parameter `T`.

Chilling & constants:
- Convert mutable collections to immutable with `.chill()` or `.collect(Array)`. Do **not** call `freeze(x)` (disabled in embedded mode).
- `const name: Type = expr;` requires an explicit type annotation and a deeply `frozen` value.

### Closures, Purity (`~>` vs `->`) & Tracking

- **Lambda syntax**: `x -> expr`, `x ~> expr`, `() -> expr`, `(a, b) -> expr`, `(a: Int, b: Int) -> expr`, `{k} -> expr`, `untracked () -> expr`.
  - Lambda parameters must be **all typed or all untyped**, and **cannot have default values**.
- **Function types**: `(A, B) -> R` (impure), `(A, B) ~> R` (pure), `A -> R`, `{k: A} -> R`, `untracked (A) -> R`.
- **Subtyping**:
  - Pure `~>` <: impure `->`. A `~>` lambda is deeply `frozen` and **cannot capture mutable variables** or reassign outer locals. An impure `->` lambda cannot satisfy `frozen` or `readonly`.
  - Tracked (default) <: `untracked`. Calling `untracked` code from tracked code requires `@allow_tracked_call` (on an `untracked` function) or `Unsafe.unsafe_untracked_call(f)`.

### Numeric Types

- `Int` (64-bit signed), `Float` (64-bit IEEE 754), `Bool`, `Char` (Unicode scalar), `Void` (`void`), `String` (UTF-8).
- Fixed-width integers (in prelude): `Int8`, `Int16`, `Int32`, `UInt8`, `UInt16`, `UInt32` — constructed via `::create(n)` (checked) or `::truncate(n)` (wrapping). Arithmetic/bitwise operators on `Integral` widen to `Int`.

---

## 7. Pattern Matching

```skip
base class Tree {
  children =
  | Leaf(value: Int)
  | Node{left: Tree, right: Tree}
}

fun summarize(t: Tree): String {
  t match {
  | Leaf(0) -> "zero"
  | Leaf(n) if (n < 0) -> `neg(${n})`
  | leaf @ Leaf(n) -> `pos(${n}): ${leaf.value}`
  | Node{left => Leaf(a), right => Leaf(b)} -> `pair(${a},${b})`
  | Node{left, right} -> `${summarize(left)}+${summarize(right)}`
  }
}
```

### Supported Patterns

| Form | Example | Notes |
| --- | --- | --- |
| Wildcard | `_`, `_x` | Matches anything without binding. |
| Binding | `x` | Lowercase; no duplicate bindings in one pattern. |
| As-binding (`@`) | `n @ Leaf(x)` | Binds `n` to the matched value and destructures `Leaf(x)`. |
| Literal | `void`, `true`, `42`, `-1`, `3.14`, `'a'`, `"hi"` | Matched by value. |
| Constant | `MyConst`, `Mod.MyConst`, `Cls::K` | Uppercase constant name, matched by value equality. |
| Tuple | `(a, (b, _))` | 2..10 elements. |
| Constructor | `Some(x)`, `Node{left => l, right}`, `Mix(a){b}` | Named patterns may omit fields; shorthand `right` ≡ `right => right`. |
| Type test wildcard | `MyClass _`, `Int _`, `#ThisClass _` | Matches type without destructuring fields. |
| Or-pattern | `\| A(x) \| B(x) -> ...` | All alternatives must bind the same variables. |
| Guard | `\| Some(x) if (x > 0) -> ...` | Parenthesized `if (cond)`. Excluded from exhaustiveness. |

- **Restrictions**: cannot pattern-match on a `trait` or a type parameter.
- **Exhaustiveness**: non-exhaustive `match` and `try ... catch` blocks, as well as redundant/unreachable arms, are compile errors (re-throw unmatched exceptions in `catch` with `| exn -> throw exn`).
- **Postfix `is` / `as`**: `e is Some _` returns `Bool`; `e as Some _` narrows the type or throws `InvalidCast`. Variable bindings and `@` are forbidden inside `is`/`as` patterns, and a provably redundant `is` check is a compile error.

---

## 8. Macros & Compile-Time Intrinsics

Mark a method or top-level function `macro fun` (must have an expression body — not abstract, native, or algebraic). `macro` methods expand and type-check inside each concrete inheriting class, allowing trait macros to access `private` fields of using classes.

| Construct | Scope | Semantics |
| --- | --- | --- |
| `#thisClassName` | Inside `macro` method | `String` literal of the enclosing class name. |
| `#ThisClass` | Inside `macro` method | Enclosing class type (valid in types, `#ThisClass _`, `#ThisClass::...`). |
| `#forEachField (#f [, #fName]) body` | Inside `macro` method | Unrolls `body` for every field of the enclosing class (`this.#f`, optional `String` `#fName`). |
| `#forEachFunction (@ann, #fn [, #fnName]) body` | Inside `macro` fun/method | Unrolls `body` for every top-level function annotated `@ann` (`#fn(...)`, optional `String` `#fnName`). |
| `#env ("VAR")` | Anywhere | Compile-time `String` from build environment variable (compile error if unset). |
| `#log (loggerFn, msg)` | Anywhere | Desugars to `loggerFn(msg, Logger.Metadata::create(..., filename, line))`. |

```skip
trait FieldNames {
  macro readonly fun fieldNames(): Array<String> {
    out = mutable Vector[];
    #forEachField (#_field, #fieldName) {
      out.push(#fieldName);
    };
    out.collect(Array)
  }
}

class Record(id: Int, label: String) uses FieldNames
```

For compiler annotations (`@debug`, `@always_inline`, `@no_inline`, `@cpp_extern`, `@no_alloc`, `@may_alloc`, `@export`, `@wasm_export`, `@allow_tracked_call`, etc.), see [modifiers-and-annotations.md](modifiers-and-annotations.md) and [tooling-and-ffi.md](tooling-and-ffi.md). Note: typos close to compiler-known annotations are rejected at compile time; unknown custom annotations (such as `@test`) remain allowed for `#forEachFunction`.
