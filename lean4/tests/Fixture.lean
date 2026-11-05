import Init
namespace Fixture
inductive Bit where | off | on
inductive Pair where | mk (a b : Bit)
inductive ProofPair where | mk (a : Bit) (h : a = a) (b : Bit)
inductive PolyPair (α : Type) where | mk (a b : α)
inductive Bits where | nil | cons (head : Bit) (tail : Bits)

@[noinline] def flip : Bit → Bit | .off => .on | .on => .off
@[noinline] def first (p : Pair) : Bit := match p with | .mk a _ => a
@[noinline] def second (p : Pair) : Bit := match p with | .mk _ b => b
@[noinline] def choose (a b : Bit) : Bit := match a with | .off => b | .on => a
@[noinline] def run (f : Bit → Bit) (b : Bit) : Bit := f b
@[noinline] def make (b : Bit) : Bit → Bit := choose b
@[noinline] def higher (f : Bit → Bit → Bit) (a b : Bit) : Bit := f a b
@[noinline] def lengthParity : Bits → Bit
  | .nil => .off
  | .cons _ tail => flip (lengthParity tail)
@[noinline] def accumulator (xs : Bits) (a b : Bit) : Bit :=
  match xs with
  | .nil => a
  | .cons _ ys => accumulator ys b a
@[noinline] def joins (b : Bit) (p q : Pair) : Bit :=
  let r := match b with | .off => p | .on => q
  choose (first r) (second r)
@[noinline] def proofErased (n : Nat) (_h : n = n) (b : Bit) : Bit := b
@[noinline] def idPoly {α : Type} (x : α) : α := x
@[noinline] def text : String := "λ🙂\n\t\"\\\x00"
@[noinline] def huge : Nat := 184467440737095516160000000000
@[noinline] def external (a b : Nat) : Nat := a + b
@[noinline] def pickProof (x : ProofPair) : Bit := match x with | .mk _ _ b => b
@[noinline] def polyPair (x : PolyPair Bit) : Bit := match x with | .mk a b => choose a b
@[noinline] def resultPoly : Bit := polyPair (.mk .off .on)
@[noinline] def result : Bit := run (make .off) (flip .off)
end Fixture
-- Native Lean reference results, expressed using constructors only.
#eval match Fixture.result with | .off => "off" | .on => "on"
#eval match Fixture.joins .on (.mk .off .off) (.mk .off .on) with | .off => "off" | .on => "on"
#eval match Fixture.accumulator (.cons .off (.cons .off (.cons .off .nil))) .off .on with | .off => "off" | .on => "on"
