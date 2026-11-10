# leanArray allocation attribution

Read-only analysis of the 20-step, elaboration-only capture in
`build/profiling/2026-11-10-refresh/cache-sampled`, executable build ID
`47416933818fbca62445456d526abdbe4b888aed`. No execution, compilation, source,
compiler or runtime changes. `evidence.json` records input hashes and raw PC/LR
counts; the adjacent `.asm` files are disassembly excerpts from that executable.

## Finding

`leanArray` allocates a 16-byte captured-local cell on **every invocation**, before
examining the LeanValue variant. The actual fill callback is a separate 16-byte
object allocated only in the persistent-array arm. This is not evidence of hot
persistent materialization: all 167 flat leanArray samples lie outside that arm.

Source is `src/Support/Primitives.sk:3`: ordinary LeanArray returns its existing
array; LeanPersistentArray calls `Array::fillBy(values.size(), i -> values[i])`.
The same pattern-local spelling `values` is present in both arms.

The instructions in `lean-array.asm` establish the object roles:

* `0x407ee8` loads allocation size 16; `0x407eec` calls SKIP_Obstack_alloc.
  `0x407efc` stores cell vtable `0xc0ded0`; `0x407f00` initializes its sole payload
  to null and advances the object pointer to that payload. Only then does
  `0x407f04` read the incoming variant tag.
* In the persistent arm, `0x407f18` loads its vector, `0x407f1c` saves the first
  cell pointer, and `0x407f20` stores that vector into the cell.
* `0x407f34` allocates the actual closure (another 16 bytes). Its vtable is
  `0xc09a80`; the first vtable entry is `0x9c050c`, the symbol
  `sk.leanArray__Closure0__call`. `0x407f48` stores the **cell pointer**, not the
  vector, into the closure payload.
* The closure body at `0x9c050c` loads the cell pointer, then loads its vector,
  then tail-calls Persistent_RadixTreeVector.get. Thus the first object is the
  captured-local/merge-variable box used by `i -> values[i]`, not the callback.
* The persistent result allocation is separate again: `0x407f58` computes
  `16 + 8 * vector.size()`, followed by SKIP_Obstack_calloc at `0x407f5c`.
  Ordinary-array return is the payload load at `0x407fac`.

This matches the installed Skip compiler's existing representation, inspected
without modification: `skiplang/compiler/src/OuterIstToIR.sk:27` names
Runtime.LocalVariable; its `CCByRef` logic loads the captured `value`, and
`emitBind` at line 4882 allocates a LocalVariable holder for updated bindings.
`skiplang/prelude/src/native/Runtime.sk:30` defines that one-field mutable class.
Assembly proves the payload dataflow independently of that implementation note.

## Capture evidence and limits

Among 8,803 retained elaboration samples, leanArray has 167 flat samples and 248
visible-inclusive samples. The two cell-initialization stores receive 120 flat
samples (76 at `0x407efc`, 44 at `0x407f00`). Another 81 samples outside leanArray
have LR-4 equal to its unconditional allocation at `0x407eec`. No sampled LR
points to the persistent closure allocation (`0x407f34`) or materialization
allocation (`0x407f5c`); no flat PC lies in `0x407f18..0x407fa4`.

All 167 flat records have only two PCs. In 141, LR is `0x407ef0`, the return
address from leanArray's own entry allocation; its real caller LR is saved on
the stack, not recoverable through a frame pointer. This must not be reported
as recursive leanArray calls. Remaining observed direct callers are array read
(15), array write (5), inference-cache find (2), inference-cache insert (1),
array push (1), Array.usize (1), and Array.size (1).

Two read sites are particularly concrete: `0x43aa78` calls leanArray for a size
read, and `0x43ad44` calls it for a bounded element read. They correspond to the
ordinary fallback in leanValueArraySize/read; persistent size/get already have
direct paths. The samples contain no argument registers or object values, so
they cannot establish persistent lengths, materialization counts, or copied
bytes. Zero persistent-arm samples does not prove it never runs.

## Bounded source experiment supported by this evidence

Move the persistent `fillBy` expression to a private `@no_inline` helper, retaining
the existing variant order/errors and return representation. That confines its
captured-local setup to the materialization path. The ownership and correctness
of the materializer remain unchanged. Inspect the resulting release disassembly
to establish removal of the unconditional cell, then use the existing array and
proof probes and a fresh uninstrumented benchmark. This report proposes no
compiler/runtime or persistent-vector redesign and predicts no measured speedup.
