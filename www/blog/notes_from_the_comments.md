---
title: The apparatus, not the artifact
description: A follow-up to "Treat Agent Output Like Compiler Output" — addressing the responses, why determinism isn't the point, and what static analysis actually buys you.
slug: notes_from_the_comments
date: 2026-05-05
authors: hubyrod
image: /img/skip.png
---

*A follow-up to ["Treat Agent Output Like Compiler Output"](https://skiplabs.io/blog/codegen_as_compiler), published in March.*

That essay argued that the right response to AI-generated code isn't more code review — it's the same trick the industry already pulled with compilers: build the verification *into the process that produces the output*, then stop reviewing each artifact by hand.

The internet had thoughts. Or at least X had thoughts... a lot of them, often in flowery language, as you can imagine. I read every one. Most of them landed on three or four arguments worth addressing head-on.

Before I go through them, I want to restate the thesis, because most of the responses were answering a question I didn't ask.

{/* truncate */}

## Restating the take

The point of the original piece was not that LLMs *are* compilers. The point was that fifty years of compiler R&D — type systems, static analysis, formal semantics, abstract interpretation, symbolic execution, model checking — is exactly the apparatus I now need to wrap around coding agents.

Agents on their own cannot be trusted to ship code. They need a straightjacket. Static analysis is the straightjacket. The compiler community spent five decades building tools that prove things about code *before* it runs. That toolkit is the answer. Agents need it more than humans ever did, not less.

The model is stochastic. The pipe around it isn't.

The analogy isn't "agents are compilers." The analogy is "the R&D tradition that produced the trust apparatus around compilers is the R&D tradition I need to point at agents now."

With that on the table, let me go through what landed.

## What the critics got right

Two objections genuinely move the piece, and both of them make the case for static analysis *stronger*, not weaker.

### Hallucination has no compiler analogue

The cleanest version of the point, paraphrased from one of the more direct replies: compilers don't hallucinate, and they don't recommend functions that don't exist.

Right. This is the failure mode that doesn't exist in the compiler world, and I should have addressed it explicitly. A compiler translates a formally specified input into a formally specified output. An LLM produces semantics, sometimes out of thin air.

But notice what catches a hallucinated function call: static analysis. What catches a wrong arity: static analysis. What catches a reference to a nonexistent symbol: static analysis — name resolution and type checking specifically, passes that have shipped in every serious compiler since the 1970s. Hallucination is exactly the failure mode this machinery was built to catch. The agent will invent a function; a sound type system will reject the program before it runs. That's the apparatus doing its job.

### The reliability gap is real, and it's the entire engineering challenge

The gap between a modern C compiler and a frontier LLM isn't 1.5×, or 10×. It's many orders of magnitude. Compilers fail rarely enough that the failures get CVE numbers. LLMs fail often enough that "did the model hallucinate" is a routine line item in any agent pipeline.

This is not an argument against the analogy. It is the argument *for* aggressive static guarantees on agent output. When the author fails at parts-per-million, you can get away with light verification. When the author fails at parts-per-hundred, you cannot. The reliability gap is precisely why every tool the compiler community has produced — and several it hasn't yet — needs to be pointed at coding agents now.

Both of these objections are correct. Both of them strengthen the case for treating agent output as something to be verified by serious infrastructure, not eyeballed by a human.

## What the critics got right that doesn't touch the argument

A second cluster of objections is technically true and rhetorically beside the point.

**"Compilers have formal specifications. LLMs don't."** True. The analogy is not "LLMs are formally specified like compilers." The analogy is that the apparatus I built around compilers — much of which doesn't depend on the *compiler itself* being formally specified — is what agents need. Type checkers, sanitizers, fuzzers, model checkers: most of this apparatus operates on the *output* program, not on the source-to-machine translation. It would be useful even if the upstream artifact had no spec at all. Which is convenient, because in the agent case the upstream artifact doesn't.

**"Humans actually do read compiler output."** Yes — in embedded, GPU, security, and performance-critical contexts. The honest version of the original claim is narrower: *most code shipped in production today is not produced by a human reading the assembly first*, and that's possible because of the apparatus. I should have written the narrower version. But this correction is about scope, not about the structure of the argument.

**"Compilers are extremely reliable. LLMs constantly fail."** Already covered above. Yes — and this is why the apparatus matters more, not less.

These are real points. They're not the points the determinism arguments were trying to make.

## Where the critics missed

The single largest cluster of objections — and it was a *very* large cluster — was effectively one critique repeated three ways: *compilers are deterministic, LLMs aren't, therefore the analogy fails.*

This is arguing about a property of the artifact. The original piece was arguing about the apparatus around the artifact. They are different things, and conflating them is the actual category error.

You don't trust a compiled binary because the compiler is deterministic. You trust it because of types, tests, fuzzers, sanitizers, ABI checks, monitoring, and rollback. Most of that apparatus would be useful even if the compiler weren't deterministic — which is convenient, because in practice it often isn't. Compiler output shifts under PGO, LTO, parallel link order, optimization-level changes, GPU floating-point reordering, and timestamps. Nobody has decided compilers are therefore not analogous to themselves. The apparatus absorbs the non-determinism.

The validators, the type checkers, the test runners, the static analyzers, the CI gates: those are deterministic. *Build those.* The model is stochastic. The pipe around it isn't.

The "just use temperature zero" variant of the criticism misses in the other direction. Greedy decoding with a fixed seed gets you bit-identical output for a single prompt at a single checkpoint. It does not get you a deterministic function from natural-language intent to working code. The variance lives upstream, in the prompt, the retrieval context, the tool transcripts. You can pin the sampler and still get a different program tomorrow. Sampler determinism is not the determinism property anyone actually wants.

If your response to "build the verification apparatus" is "but LLMs aren't deterministic," you're describing why the apparatus is *harder* to build, not why you shouldn't build it.

Worth noting: since the original post went up, several of the people running the determinism critique have publicly walked it back. The strongest correction came from inside the LLVM community — the observation that real-world compilers are wildly non-deterministic by default. Internal passes use unordered containers keyed on pointer addresses, which shift every run thanks to ASLR. Non-stable sorting algorithms reorder things between invocations. Filesystem inode allocation dictates enumeration order. Reproducible builds are a massive engineering effort precisely because the underlying toolchain is so far from deterministic to begin with. The mathematical theory of a compiler is deterministic. The actual production toolchain is not. This is exactly the distinction the original piece was trying to make, made better by people who initially thought I was wrong about it.

The most rigorous version of the rebuttal came from outside the thread entirely. Isaac Van Doren's [*Nondeterminism's not the problem*](https://isaacvando.com/nondeterminisms-not-the-problem) makes the point cleanly: imagine a compiler that picks register assignments by `Math.random` — it would still be useful. Then set an LLM to temperature zero — it's still untrustworthy. Determinism is irrelevant. The real difference is that programming languages have semantics and prompts don't. I agree, and that reframe is the spine of the next section.

The position the debate has settled into is the right one: compilers are not deterministic, LLMs are *more* non-deterministic than compilers, and the gap is large. That gap is the engineering challenge. It is not a category boundary.

## What static analysis actually buys you

The argument so far is abstract. Here's the concrete version.

The underlying problem is straightforward: programming languages have semantics; prompts don't. The 892 pages of the Java Language Specification tell you exactly what promises the language makes about your code's behavior. A prompt makes no promises. To give a prompt the kind of guarantee a language gives you, you would need an external tool to validate that the output upholds the prompt's intended semantics — and the cost of doing that at the level of full theorem proving is famously prohibitive.

The honest version is more interesting. Programming languages don't actually specify everything either. Java doesn't tell you when the garbage collector runs. Haskell doesn't tell you what gets evaluated next — that's a function of the runtime, not the language. C doesn't tell you whether a variable lives on the stack or in a register. These languages succeed not because their specifications are exhaustive, but because the apparatus around them — the GC, the runtime, the register allocator — makes the underspecified parts irrelevant to the correctness of your program. The abstraction holds.

That's the move I need for agents. The prompt is underspecified, and at one level it always will be. The apparatus has to make that underspecification stop mattering — to enforce, at the level of the *output program*, the properties the prompt couldn't pin down.

You don't need full theorem proving to get most of the way there. The compiler R&D tradition has produced a layered stack of tools that impose semantic guarantees on programs without needing the *prompt* to be specified at all:

- **A sound type checker** rejects programs that reference functions that don't exist, that pass arguments of the wrong shape, that mix incompatible types. That's a hallucination-detection system, caught statically, no test runs required.
- **Data-flow analysis** catches uninitialized reads, use-after-free, leaked resources, and a long list of memory and ownership errors that no amount of LLM "review" will reliably find.
- **Abstract interpretation** proves bounds on values — array indices, integer overflow, null dereference — across all execution paths, not just the ones a test happened to exercise.
- **Symbolic execution** explores program paths a test suite would never reach, finding inputs that violate assertions.
- **Bounded model checking** proves the *absence* of specific bug classes, not just their absence in the cases you happened to test.

None of this is speculative. It is what has been shipping in industrial compilers and verifiers for decades — Coverity, Infer, Astrée, KLEE, CBMC, Frama-C, the seL4 verification effort. The agent era is not asking for new science. It is asking me to point existing science at a new producer of code.

The semantic ground that the prompt fails to establish gets re-established by analysis of the *output program*. The agent produces; the apparatus verifies; the program ships only if the apparatus signs off.

It's worth being precise about the topology here, because it's the place where the compiler analogy is genuinely loose. In the compiler world, verification is *intricated* in the production pipeline: the type checker runs before codegen, the optimizer is constrained to semantics-preserving transformations, the linker validates symbols. By the time you have an output, the apparatus has already done its work. In the agent world, the agent generates first, and the apparatus enforces immediately downstream. Different topology, same principle: the trust lives in the pipeline, not in the artifact. The asymmetry is real, and it's an argument for tighter integration over time — for static analysis that is no longer a checkpoint after the agent finishes, but a constraint the agent operates under while it's still generating.

This is what I am building at SkipLabs. SKJS is a TypeScript-compatible type checker that is *sound* — it doesn't have the escape hatches that make standard TypeScript ergonomic for humans and unreliable as a verification layer. The reactive runtime enforces explicit dependency contracts that an agent has to satisfy before code runs. This is pedantry that would feel like friction to a human author and is exactly right for an agent that needs to be held accountable for what it generates *before* anything reaches production.

The apparatus exists. Some of it ships today. More of it is being ported from the compiler world into the agent world right now. The point of the original piece — and the point I should have made more clearly — is that this is where the engineering work is. Not in scaling code review. Not in waiting for better models. In building the static guarantees that make trust warranted.