# Skiplang Standard Library (`std`) Reference

Dense, source-verified reference for `std` (`skiplang/prelude/src/`) and first-party packages under `skiplang/`.

Companion docs:
- [language.md](language.md) — core language grammar, types, mutability, patterns, macros
- [modifiers-and-annotations.md](modifiers-and-annotations.md) — modifier & `@annotation` details
- [tooling-and-ffi.md](tooling-and-ffi.md) — `skargo`, `sktest`, `skfmt`, `skc`, C/Wasm FFI
- [SKStore.md](SKStore.md) — reactive directory store & incremental efficiency

---

## 1. Quick-Hit Gotchas

- **No `UMap` / `USet` in `std`**: the unordered hash collections are **`UnorderedMap`** and **`UnorderedSet`** (`UMap` is compiler-internal).
- **Never build an `Array` with `.append()` in a loop** (O(n²)): push into a `mutable Vector` and finish with `.collect(Array)` (or `.toArray()`).
- **`uses Orderable, Equality` conflicts on `==`**: both traits define `==`. Override `fun ==(other: MyClass): Bool` explicitly; `!=` is inherited from `Equality`.
- **`Hashable.hash()` is NOT `readonly`**: it requires an immutable receiver. Global `hash<T>(v: T): Int` works on any value via runtime `SKIP_hash`.
- **`String` has no `[]` indexing**: `s.length()` is O(n) Unicode scalar count; byte size is `String.byteSize(s): UInt32` or `s.bytes().size()`. `toInt()`/`toFloat()` crash on invalid input — use `toIntOption()` / `toFloatOption()`.
- **Iterator consumption**: `.values()`/`.items()`/`.keys()` return a single-use `mutable Iterator`. Materialize with `.collect(Array)`, `.collect(Vector)`, `.collect(Map)`, or `.toArray()`.
- **`List` and `SortedMap` do not declare `uses FromIterator`**: `iter.collect(List)` and `iter.collect(SortedMap)` fail typechecking — use `List::createFromIterator(iter)` / `SortedMap::createFromIterator(iter)` instead.
- **`Result` does not declare `uses Equality`/`Orderable`/`Show`** in its header (even though it defines `==`, `!=`, and `compare`).
- **`print_error(s)` already appends `\n`**; `print_error_ln(v)` appends two newlines on native. Use `print_error_raw(s)` for no newline.
- **No built-in `Regex` engine**: `Regex.sk` in prelude is empty.

---

## 2. Core Primitives & Language Types

### Primitives (`skiplang/prelude/src/core/primitives/`, `stdlib/int/`)

| Type | Kind & Traits | Key Methods & Notes |
| --- | --- | --- |
| `Void` (`void`) | `native value class` (`Orderable`, `Hashable`, `Show`) | Literal `void`; `toString()` -> `"void"`. |
| `Bool` | `native value class` (`Hashable`, `Orderable`, `Show`) | `!`, `==`, `!=`, `<`, `>`, `<=`, `>=`, `toString()`. |
| `Int` | 64-bit signed `native value class` (`Number`, `Integral`) | `Int::min`, `Int::max`; `/` & `%` throw `DivisionByZeroException`; bitwise: `and`, `or`, `xor`, `not`, `shl`, `shr`, `ushr`; unsigned compare: `ult`/`ugt`/`ule`/`uge`; `clz`, `ctz`, `popcount`, `toFloat()`, `toStringHex()`, `toStringBinary()`, `chr(): Char`. |
| `Int128` / `UInt128` | 128-bit signed (`native value class`) / unsigned (`value class`) (`Orderable`, `Hashable`, `Show`) | Native LLVM `i128` (8-byte aligned in Skip objects). Construction: `fromInt` (sign-extend), `fromUInt64` (zero-extend), `fromHalves(lo, hi)`, `lo()`, `hi()`, `toInt()`. Constants are static methods (`zero()`, `one()`, `min()`, `max()`). Full 128-bit `+`, `-`, `*`, `/`, `%`, `udiv`/`urem`, bitwise `and`/`or`/`xor`/`not`/`shl`/`shr`/`ushr`, signed & unsigned compares, `clz`/`ctz`/`popcount`, `toString()`, `toStringHex()`, `toStringBinary()`. |
| `Int8`/`16`/`32`, `UInt8`/`16`/`32` | `Integral` (`min`, `max`; `UInt8`/`UInt32` have `zero`) | `::create(n)` (checked, throws `InvalidIntegralCastError`) vs `::truncate(n)` (wrapping). **All arithmetic/bitwise ops widen to 64-bit `Int`**. |
| `Float` | 64-bit IEEE 754 `native value class` (`Number`) | `Float::inf`, `Float::nan`, `isNaN()`, `toBits(): Int`, `toInt()` (UB on NaN/inf/overflow), `isEqual(other)` (bitwise: `NaN` equals `NaN`, `-0.0 != 0.0`), `==` (IEEE 754), `compare` (`NaN` is `GT()`). |
| `Char` | Unicode scalar `native value class` (`Hashable`, `Orderable`, `Show`, `Equality`) | `code(): Int`, `Char::fromCode(Int)`, `Char::isValidCharCodePoint(Int)`, `utf8Encode()`, `capitalize()`/`uncapitalize()` (ASCII only), `repeat(n)`. Helper module `Chars`: `isDigit`, `isHexDigit`, `isWhitespace`, `isPrintableAscii`. |
| `String` | Immutable UTF-8 `native class` (`Hashable`, `Show`, `Orderable`, `AsBytes`) | `String::fromChars`, `String::fromUtf8`, `String::tabulate`; `+` accepts any `readonly Show`; `length()` (O(n)), `String.byteSize(s)`, `isEmpty`, `startsWith`, `endsWith`, `stripPrefix`, `stripSuffix`, `contains`, `replace`, `split(delim, maxCount?)`, `splitFirst`/`splitLast`, `trim`/`trimLeft`/`trimRight`, `uppercase()`/`lowercase()` (ASCII only), `toIntOption()`, `toFloatOption()`, `chars()`, `utf8()`, `bytes()`, `getIter()`, `values()`. |
| `Bytes` / `MutableBytes` | `extends Sequence<UInt8>` (`Show`) | `size()`, `get(i)`, `slice(start, end?)`, `toArray()`, `ptr(): Unsafe.Ptr<UInt8>`. `Bytes.Cursor` / `Bytes.MutableCursor` implement `IO.Read`/`IO.Write`/`IO.Seek`. |
| `Tuple2`..`Tuple10` | `value class` (conditional `Show`, `Hashable`, `Orderable`, `Equality`, `XXHashable`) | Syntax `(a, b)`; fields `.i0`..`.i9`; `.values()` when all elements share a supertype. |
| `Ref<+T>` | `mutable class Ref<+T>(mutable value: T)` | `get()`, `set(v)`. Note: immutable `Ref(42)` const-folds to a shared constant; use `mutable Ref(42)` for distinct mutable boxes. |
| `Box<T>` | `class Box<T>(value: T)` | Heap-boxed reference wrapper (useful across FFI); `unbox(): T`. |
| `Class<+T>` | `native base class` (`Concrete` \| `Base`) | Runtime class token used by `iter.collect(Array)` and `class(expr)`. |

### Language Types (`skiplang/prelude/src/core/`)

- **`Option<+T>` (`?T`)** — `Some(value: T) | None()`. Conditional `Show`, `Hashable`, `Orderable`, `Equality`; `IntoIterator<T>`.
  - Methods: `isSome()`, `isNone()`, `default(fallback)`, `fromSome(msg?)` (crashes on `None`), `map(f)`, `flatMap(f)`, `maybe(nothing, just)`, `test(pred)`, `each(f)`. Supports postfix `?` propagation.
- **`Result<+T, +E>`** — `Success(value: T) | Failure(error: E)`.
  - Methods: `Result::guard(() -> expr)` (catches `Exception` into `Result<T, Exception>`), `isSuccess()`, `isFailure()`, `fromSuccess()`, `fromFailure()`, `maybeSuccess()`, `maybeFailure()`, `map(f)`, `flatMap(f)`. Supports postfix `?` propagation.
- **`Order`** — `LT() | EQ() | GT()`, with `isLT`/`isLTE`/`isEQ`/`isGT`/`isGTE`.
- **`InclusiveOr<+A, +B>`** — `Left(A) | Right(B) | Both(A, B)` (returned by `Iterator.zipSorted`).
- **`Range(start: Int, end: Int)`** — half-open `[start, end)`, `extends Sequence<Int>`. `Range::create{start, length}`, `size()`, `inRange(i)`, `values()`, `reversedValues()`, `sumInt()`.
- **`Exception`** — `base class Exception uses HasClassName { overridable fun getMessage(): String }`.
  - Built-ins: `OutOfBounds()`, `Duplicate()`, `KeyNotFound()`, `ContainerChanged()`, `InvalidCast`, `RuntimeError(msg)`, `CRuntimeError(code)`, `EndOfFile()`, `DivisionByZeroException()`, `InvariantViolation(msg)`.
- **`Parallel`** — `Parallel.tabulate<T>(count: Int, f: Int ~> T): mutable Array<T>` (and `Array.parallelMap`).

```skip
fun parsePositive(s: String): Result<Int, String> {
  s.toIntOption() match {
  | Some(v) if (v > 0) -> Success(v)
  | _ -> Failure(`invalid positive int: ${s}`)
  }
}

fun parsePositiveSum(items: Array<String>): Result<Int, String> {
  total = 0;
  for (s in items) {
    n = parsePositive(s)?;
    !total = total + n;
  };
  Success(total)
}
```

---

## 3. Core Traits & Macro Deriving

| Trait | Required Method(s) | Auto-Derived Macro Default? | Notes |
| --- | --- | --- | --- |
| `Equality` | — | Yes (`macro readonly fun ==(other: inst): Bool`, plus `!=`) | Structural field-by-field via `#forEachField`. Override `fun ==(other: BaseClass): Bool` on base classes when custom equality is needed. |
| `Orderable` | — | Yes (`macro readonly fun compare(other: inst): Order`, `<`, `>`, `<=`, `>=`, `==`) | `extends Equality, HasClassName`. Compares class names across subclasses, then fields. Conflicts with explicit `uses Equality` on `==`. |
| `Hashable` | — | Yes (`macro fun hash(): Int`) | Combines `#thisClassName.hash()` with `#forEachField`. **Not `readonly`**. |
| `XXHashable` | — | Yes (`macro fun xxhash(): XXHash`) | Deterministic 64-bit hash (`XXHash(value: Int)`). Implemented for primitives, `Option`, `Array`, `Vector`, `Map`, tuples. |
| `Show` | `readonly fun toString(): String` | **No** | Required for string interpolation `` `${x}` `` and `print_string(x)`. |
| `HasClassName` | — | Yes (`macro readonly fun getClassName(): String`) | Inherited by `Orderable` and `Exception`. |
| `IntoIterator<+T>` | `readonly fun iterator(): mutable Iterator<T>` | No | — |
| `FromIterator<+T>` | `static fun createFromIterator<I: mutable Iterator<T>>(I): inst` | No | Enables `iter.collect(MyCollection)`. |

There is no `Inspectable` trait: `inspect<T>(x: T): Inspect` is a compiler intrinsic that calls a class's `fun inspect(): Inspect` if defined, or auto-generates a structural representation.

```skip
value class Point(x: Int, y: Int) uses Orderable, Hashable, Show {
  fun toString(): String {
    `(${this.x}, ${this.y})`
  }
}
```

---

## 4. Iterators, Sequences & Collections

### `Iterator<+T>` & `Sequence<+T>`

- **`mutable base class Iterator<+T>`**:
  - Core: `next(): ?T`, `sizeHint(): ?Int`, `collect(Concrete<C>)`, `toArray(): Array<T>`.
  - Lazy combinators: `map`, `flatMap`, `flatten`, `concat`, `filter`, `filterNone`, `filterMap`, `unique`, `zip`, `zipLongest`, `zipWith`, `zipSorted`, `zipSortedBy`, `drop`, `dropWhile`, `take`, `takeWhile`, `enumerated()`.
  - Consumers: `each`, `eachWithIndex`, `find`, `findMap`, `all`, `any`, `reduce(f, init)`, `min{default}`.
- **`mutable base class Sequence<+T> uses IntoIterator<T>`**:
  - Provides `size()`, `isEmpty()`, `values()`, `collect(C)`, `toArray()`, `map`, `mapWithIndex`, `mapAcc`, `flatMap`, `filter`, `filterNone`, `zip`, `zipWith`, `unzip`, `reversed`, `sorted`, `sortedBy`, `isSorted`, `find`, `findMap`, `findIndex`, `all`, `any`, `reduce`, `sumInt`, `sumFloat`, `min`, `minBy`, `max`, `maxBy`, `join`, `first`.

### Concrete Collections Comparison

| Collection | Ordering / Backing | Complexity | Mutable & Conversion Notes |
| --- | --- | --- | --- |
| `Array<+T>` | Fixed contiguous array | O(1) index; O(n) `clone`/`chill`/`append` | `Array[1, 2]`, `mutable Array::mfill(n, v)`, `Array::fillBy(n, i -> ...)`. Extends `Sequence<T>` (not `IndexedSequence`). Has `zip`, `slice` (supports negative indices), `sort`/`sortBy`, `parallelMap`. |
| `Vector<+T>` | Growable contiguous array | O(1) index, amort. O(1) `push`/`pop`; O(n) `insert`/`delete` | `Vector[1, 2]`, `mutable Vector[]`. `MutableIndexedSequence`, `FromIterator`. Fail-fast iterator check (`ContainerChanged`). Prefer for building sequences, then `.chill()` or `.collect(Array)`. |
| `Map<+K, +V>` | Insertion-ordered Robin Hood hash table (`K: Hashable & Equality`) | O(1) lookup/update/amort. insert | `Map["a" => 1]`, `mutable Map[]`. `MutableKeyedSequence`, `FromIterator<(K, V)>`. Methods: `get`/`[k]`, `maybeGet`, `set`/`![k] = v`, `add` (throws `Duplicate`), `maybeSet`, `getOrAdd`, `setWith`, `remove`, `maybeRemove`, `items()`, `keys()`, `values()`. |
| `UnorderedMap<+K, +V>` | Unordered Robin Hood hash table | O(1) lookup/update/amort. insert (faster & smaller than `Map`) | Same `MutableKeyedSequence` API as `Map`. |
| `Set<+T>` | Insertion-ordered hash set (`T: Hashable & Equality`) | O(1) lookup/amort. insert | `Set[1, 2]`, `mutable Set[]`. `UniqueSequence`, `FromIterator`. `contains`, `add`, `insert`, `remove`, `maybeRemove`, `union`, `intersection`, `difference`, `subtract`. |
| `UnorderedSet<+T>` | Unordered hash set | O(1) lookup/amort. insert | Same `UniqueSequence` API as `Set`. |
| `SortedMap<+K, +V>` | Persistent balanced BST (`K: Orderable`) | O(log n) `get`/`set`/`remove`/`min`/`max` | Purely persistent (`set`/`remove` return a new `SortedMap`). Has `itemsAfter(start)`, `minimum()`, `maximum()`, `merge`, `mergeWith`. **Does not declare `FromIterator`/`IntoIterator`**; use `SortedMap::createFromItems` / `SortedMap::createFromIterator`. |
| `SortedSet<+T>` | Persistent balanced BST (`T: Orderable`) | O(log n) ops | Purely persistent; `uses IntoIterator<T>, FromIterator<T>`. `add`, `set`, `remove`, `min`, `max`. |
| `List<+T>` | Singly linked list (`Nil() \| Cons(head, tail)`) | O(1) cons/head/tail; O(n) `size()` | `List[1, 2]`. **Does not declare `FromIterator`**; use `List::createFromIterator`. |
| `Queue<+T>` | Persistent two-list FIFO queue | Amort. O(1) `push`/`pop` | `Queue::empty()`, `push(x)`, `pop(): ?(this, T)`. |
| `Persistent.RadixTreeVector<+T>` | 32-way persistent radix tree | O(log₃₂ n) ops; **O(1) `clone()` and `chill()`** | Implements `MutableIndexedSequence<T>`. |
| `Rope<+T>` (`skstore/Rope.sk`) | Tree rope (`Nil \| Union \| Cons`) | O(1) `+` / `union` / `append` | Immutable; `values()`, `toArray()`. |

```skip
fun wordCounts(words: Array<String>): Map<String, Int> {
  counts = mutable Map<String, Int>[];
  for (w in words) {
    counts![w] = counts.maybeGet(w).default(0) + 1;
  };
  counts.chill()
}

fun topKeys(m: Map<String, Int>, minCount: Int): Array<String> {
  m.items()
    .filter(kv -> kv.i1 >= minCount)
    .map(kv -> kv.i0)
    .collect(Array)
}
```

---

## 5. Global Functions, I/O, Filesystem, Processes & JSON

### Global Functions (`System.sk`, `Debug.sk`, `Util.sk`)

- **Assertions & exits**: `invariant(cond, msg = "assert")`, `invariant_violation(msg)`, `assert(cond)`, `exit(code)`, `skipExit(code)` (`@no_return`).
- **Stdout / stderr / stdin**: `print_string(v)` (appends `\n`), `print_raw(s)`, `print_newline()`, `print_error(s)` (appends `\n`), `print_error_raw(s)`, `flushStdout()`, `read_line(): ?String`, `read_to_end(): String`.
- **Debug**: `debug(x)`, `debug_json(x)`, `inspect(x): Inspect`, `print_stack_trace()`.
- **Utilities**: `min(a, b)`, `max(a, b)`, `id(x)`, `ignore(x)`, `intern(x)`, `localGC()`.
- **Low-level identity**: `Runtime.phys_eq(a, b): Bool`, `native_eq(a, b): Int` (`0` means equal).

### Filesystem, Path, Environment & Processes

| Module | Key APIs |
| --- | --- |
| `FileSystem` | `readTextFile(path)`, `writeTextFile(path, s)`, `appendTextFile(path, s)`, `exists(path)`, `isDirectory(path)`, `readDirectory(path): Array<String>`, `readFilesRecursive(dir, filter?, dirFilter?): Vector<String>`, `findNearestFile(dir, filename): ?String`, `stat(path): ?FileStat`, `realpath(path): ?String`, `getLastModificationTime(path): Int`. |
| `Path` | `join(p1, p2, p3 = "")` (max 3 args), `resolve(p1, p2?, p3?)`, `dirname`, `basename`, `extname`, `split`, `normalize`, `isAbsolute`, `isRelative`, `relativeTo{path, base}`. |
| `Environ` | `args(): mutable Iterator<String>`, `vars()`, `varOpt(name): ?String`, `var(name)` (throws `Environ.VarError`), `set_var`, `remove_var`, `current_exe()`, `current_dir()`, `set_current_dir`, `temp_dir()`. |
| `System` | `System.subprocess(args, stdout?, stderr?)`, `System.popen{args, env?, clear_env?, stdout?, stderr?, cwd?}: Result<System.CompletedProcess, IO.Error>`. |
| `IO` | `IO.stdin()`/`stdout()`/`stderr()`, `IO.File`, `IO.BufferedReader`, `IO.OpenOptions`, `IO.Error`, `IO.copy`, traits `IO.Read`/`Write`/`Seek`/`BufRead`/`IsTerminal`. |
| `Posix` | Low-level syscalls (`open`, `close`, `read`, `write`, `pipe`, `dup2`, `execvp`, `spawnp`, `waitpid`, `poll`, `kill`, `isatty`, `mkstemp`). |
| Other `stdlib/other/` | `Math`, `Random` (`Random.next()`, `class Random` Xoroshiro128+), `Time` (`time`, `time_ms`, `time_ns`, `sleep_ms`, `strftime`), `Base64`, `Ksuid`, `DirectedGraph`, `IndentedWriter`, `TermColor`, `Logger`. |

### Parsing & Prelude `JSON` / `Serialization`

- **Parsing (`stdlib/parsing/`)**: `Position` (0-based `line()`/`column()`), `TextRange{start, end}`, `mutable Lexer.LexingPosition` (`create`, `peek`, `peekChar`, `next`, `advance`, `saveState`, `getRange`, `getText`).
- **`JSON` (`stdlib/serialization/JSON.sk`)**:
  - AST: `JSON.Value` (`JSON.Null()`, `JSON.Bool(Bool)`, `JSON.IntNumber(Int)`, `JSON.FloatNumber(Float)`, `JSON.String(String)`, `JSON.Array(Vector<JSON.Value>)`, `JSON.Object(Map<String, JSON.Value>)`).
  - Literals: `JSON.Object["k" => JSON.IntNumber(1)]`, `JSON.Array[JSON.Null()]`.
  - Parse/encode: `JSON.decode(str): JSON.Value`, `val.encode(): String`, `val.print(space = 2)`.
  - Typed accessors: `expectObject`/`Array`/`Int`/`Float`/`String`/`Bool`; `obj.getString(k)` / `obj.maybeGetString(k)`.
  - **Gotcha**: `JSON.decode`'s `eatWhitespace` skips only `' '` and `'\n'` (not `'\t'` or `'\r'`), and `JSON.Object` throws `InvalidJSONError` on duplicate keys.
  - Typed serde: `JSON.serialize(v, serializer)` / `JSON.deserialize(s, serializer)` using `T::meta` (`Int::meta`, `String::meta`, `Option::meta`, `Array::meta`, `Map::meta`, etc.).
- **Testing in prelude (`stdlib/testing/`)**: `Assert.sk` (`assertEqual`, `assertTrue`, `assertThrows`, …) and `QuickCheck` (`QuickCheck.assert(gen, prop)`). Prefer `sktest` (`@test`, `SKTest.expectEq`) for package test suites — see [tooling-and-ffi.md](tooling-and-ffi.md).

---

## 6. First-Party Packages (`skiplang/`)

Add to `Skargo.toml` via `{ path = "../<pkg>" }`:

| Package | Module | Purpose & Key Gotchas |
| --- | --- | --- |
| `sktest` | `SKTest` | Standard unit test harness (`@test`, `expectEq`/`expectNe`/`expectTrue`/`expectFalse`/`expectThrow`, parallel runner, JUnit XML). |
| `skjson` | `SKJSON` | Compact, `Orderable`, schema-typed `CJSON` for SKStore/SQL (`SKJSON.decode(s, internFields)`, `toJSON()`, `toType()`, `flatten`, `pathMatch`). |
| `skbigint` | `SKBigInt` | Pure-Skip arbitrary-precision `BigInt` / `UBigInt` (`fromInt`, `fromString`, `fromStringRadix`, `add`, `sub`, `mul`, `div`, `mod`, `divMod`, `pow`, `gcd`). **Uses named methods (`add`/`sub`/…), not `+`/`-` operators.** |
| `skdate` | `SKDate` | Calendar/date/time/timezone (`Date`, `Time`, `Calendar`, `TimeZone`, `SKDate.utc`, `format`, `parseFullDate`). |
| `cli` | `Cli` | Builder CLI parser (`Cli.Command`, `Cli.Arg::string/int/bool`, `.help()`, `.runtimeArgs()`, `.parseArgs()`). |
| `toml` | `TOML` | TOML v1.0.0 decoder (`TOML.decode(s): TOML.Table`, `expect*`, `get*`/`maybeGet*`). Decoder-only. |
| `semver` | `Semver` | SemVer 2.0 `Version` & `VersionReq` (`Version::fromString`, `VersionReq::fromString`, `matches`). Use `compare_precedence` (ignores build metadata) rather than `compare`. |
| `cc` / `pkg-config` | `Cc` / `PkgConfig` | Build-script (`build.sk`) helpers for compiling C/C++ libraries and probing system packages. |
