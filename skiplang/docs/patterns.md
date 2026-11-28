# Pattern matching

Skip supports pattern matching in `match` expressions, `try ... catch` blocks,
`is` predicates, and `as` runtime downcasts.

## Pattern forms

- **Wildcard & variable**: `_`, `x`
- **Literals**: `void`, `true`, `false`, integer (including negative), float,
  char, and string literals
- **Constants**: `MyConst`, `Module.CONST`, `Class::CONST`
- **Tuples**: `(p1, p2, ...)`
- **Class / constructor**:
  - Wildcard fields: `C _`
  - Positional: `C(p1, p2)`
  - Named: `C{x => p1, y}` (shorthand `y` binds field `y` to variable `y`)
  - Mixed: `C(p1){y => p2}`
- **As-binding (`@`)**: `x @ pat` binds `x` to the matched value while also
  matching `pat`. The right-hand side is an atomic pattern, so wrap or-patterns
  in parentheses: `x @ (A _ | B _)`.
- **Or-patterns (`|`)**: `p1 | p2 | ...` matches if any alternative matches.

## Nested or-patterns

Or-patterns are allowed both at the top level of `match` / `catch` branches and
nested inside any compound pattern — constructor arguments (positional, named,
or mixed), tuples, parenthesized patterns, `@`-patterns, `is`, and `as`:

```skip
x match {
| Some(1 | 2) -> "small"
| Some(n) -> n.toString()
| None() -> "none"
}
```

### Parentheses with `is`, `as`, and `@`

`is`, `as`, and `@` take an atomic pattern, so a top-level or-pattern in those
positions must be parenthesized:

```skip
x is (A() | B())
y = x as (A _ | B _)
```

Writing `x is A() | B()` without parentheses is a parse error.

### Variable bindings in or-patterns

Every alternative of an or-pattern must bind the exact same set of variable
names, and no variable may be bound more than once in the same pattern:

```skip
// Valid: both alternatives bind `v`
x match {
| Some(A(v) | B(v)) -> v
| None() -> 0
}

// Valid: outer `@` combined with inner shared binding
x match {
| w @ (A(v) | B(v)) -> (w, v)
| _ -> ...
}

// Invalid: `v` is only bound on one side
x match {
| Some(A(v) | B(_)) -> v
| None() -> 0
}
```

The type of a variable bound across alternatives is the join (least upper bound)
of its types in each alternative.

Bindings are disallowed inside `is` and `as` patterns, including inside nested
or-patterns (e.g. `x is (A(v) | B(v))` is a parse error).

Or-patterns are not allowed in `let` / assignment destructuring patterns.

## Exhaustiveness and unused patterns

`match` expressions are checked for exhaustiveness and redundant (unused)
patterns, including across nested or-patterns. If an alternative inside a
nested or-pattern is redundant (e.g. `Some(1 | 1)`), the compiler points
directly at the unused alternative.

`is` and `as` expressions also check that the pattern can actually fail: if the
value will always match the pattern (including an exhaustive nested or-pattern
like `x as (A() | B())` when `A` and `B` are the only children of `x`'s type),
the compiler reports an unnecessary `is` / `as` error.
