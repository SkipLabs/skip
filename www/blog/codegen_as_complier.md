---
title: Treat Agent Output Like Compiler Output
description: Why our discomfort with AI-generated code reveals exactly what we haven't built yet, and what the compiler analogy teaches us about trusting coding agents.
slug: codegen_as_compiler
date: 2026-03-09
authors: hubyrod
image: /img/skip.png
---

Philip Su's recent post argues that code reviews are not just impractical in the age of coding agents, they're headed toward being *irresponsible*. He's right on trend. But I think the framing of "lights-out codebases" skips over the more interesting and uncomfortable question: **why does lights-out feel so scary**, and what does that fear actually tell us?

The answer, I think, is hiding in something we already used once before and then promptly forgot we did: the compiler.

{/* truncate */}

## Nobody Reviews Compiler Output

Think about how you relate to your compiler. You write C++, Rust, Go, and the toolchain spits out a binary. Do you open that binary and read through the assembly? Do you schedule a meeting with a colleague to review the object code before shipping?

Of course not. That would be absurd. And not because you blindly trust compilers, you don't. Compilers have bugs. Compilers have had famously catastrophic bugs. But you've constructed an entire apparatus that makes reviewing the output *unnecessary*: you write tests against observable behavior, you have type systems that constrain what the output can do, you have reproducible builds, you have fuzzing and sanitizers and formal verification in high-stakes domains. You trust the *process*, not the artifact.

We haven't built that apparatus for coding agents. And that, not the output itself, is what's actually missing.

## The Real Diagnosis

Consider that a developer like Michael Novati landed 417 PRs in a single day in February. That's enough to argue that reviewing AI-generated code is volumetrically impossible. And it is. But I'd push the diagnosis further: **the volume isn't the problem, it's a symptom that exposes the problem**.

The problem is that we're still treating agent output the way we used to treat junior developer output, as something that needs a human to eyeball it before it's real. That made sense when code reviews were the primary quality gate. It makes no sense when they can't be.

The compiler analogy is clarifying here not because it tells us to trust agents blindly, but because it shows us what a mature pipeline looks like once you stop treating artifacts as things to be *read* and start treating them as things to be *verified*. We don't review compiled binaries. We run them against test suites, we check them against specifications, we instrument them in production. We moved the quality control upstream (type systems, linters, formal specs) and downstream (testing, monitoring, rollback), and eliminated the manual middle.

That's exactly the move we need to make with agents. We're not there yet. And the reason the lights-out framing makes engineers nervous isn't irrationality, it's that the upstream and downstream apparatus barely exists.

## What's Actually Missing

If compiler output requires no human review because of what surrounds it, then agent output will require no human review when we've built the equivalent. What does that actually mean?

**Upstream:** Compilers have type systems, formal contracts about what code *means* before it runs. For agents, this equivalent is still primitive. We have prompts, we have some scaffolding, but we don't yet have robust formal specifications that an agent is verifiably executing against. The closest analogs, TDD, contract testing, design-by-specification, exist but are not yet standard practice when *agents* are the author.

**The verification layer:** Compilers are deterministic. Given the same source, you get the same output. Agents are not. This means the test suite that used to catch *human* mistakes needs to be substantially more comprehensive when the author can produce plausible-but-subtly-wrong code at 50x the rate. The idea of using AI to check AI, pre- and post-action reviews, dedicated security agents, is the right direction. But it's nascent, and we're nowhere near treating it as infrastructure.

**Downstream:** The production monitoring and rollback culture that makes deploying compiled binaries safe is reasonably mature. Canary deploys, feature flags, observability tooling, this stuff works. Applying it rigorously to agent-generated changes is tractable. It just isn't yet habitual.

## The Uncomfortable Part

Here's the contrarian edge: the engineers most resistant to lights-out codebases are often the same engineers who would resist, if they could time-travel back, the idea that you don't need to review your linker's output. The intuition feels protective. It is actually just unfamiliarity with where the trust has been relocated.

Trusting compiler output isn't naïve. It's the result of decades of investment in making that trust warranted. We didn't skip the hard work, we did the hard work in a different place. The same logic applies here. The question isn't "should we trust agent output?" It's "have we built the infrastructure that makes that trust reasonable?"

Right now, mostly, we haven't. That's not an argument against moving toward lights-out codebases, we're being pushed there regardless. It's an argument for being honest about what "moving there responsibly" actually requires.

Hardware chip companies already work with black-box components verified by acceptance tests rather than human review. That's the model. But notice: chip verification is a *discipline*, with tooling, with formal methods, with teams of people whose entire job is designing the test harness. We are going to need the software equivalent, and it is probably going to be harder, because software has far less formal specification culture than hardware.

## What To Build

The lights-out codebase is coming. Su is right about that. But rather than simply accepting it as an inevitability to brace for, we should treat it as a *design target*, one that tells us exactly what we need to build:

- Formal specification layers that agents execute against, not just prompts
- Test infrastructure robust enough to substitute for the code comprehension that reviews provide
- AI-checks-AI pipelines as first-class CI infrastructure, not bolt-on curiosity
- Production instrumentation good enough that bad agent behavior is caught fast and rolled back faster

The compiler didn't make us stop caring about correctness. It moved where correctness is enforced. That's the project in front of us. The scary part isn't the lights-out codebase. The scary part is how few teams are treating what replaces the review as serious engineering work.

*This post was written in response to Philip Su's "[No More Code Reviews: Lights-Out Codebases Ahead](https://molochinations.substack.com/p/no-more-code-reviews-lights-out-codebases)"*