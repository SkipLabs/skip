---
title: Discussion with Lucas, a SkipLabs engineer
description: An in-depth conversation with a SkipLabs engineer about reactive programming, performance optimization, and the technical challenges of building scalable data synchronization tools.
slug: interview_lucas
date: 2025-06-21
authors: hubyrod
---

Ever wondered what it's like to work on cutting-edge reactive programming? This chat with a Lucas, SkipLabs engineer, gives you the inside scoop on building tools that tackle gnarly data synchronization problems. We have created something called the Skip Framework, which runs on our own programming language, SkipLang, pretty cool stuff. What makes this interview particularly interesting is how it bounces between the nuts and bolts of performance testing (like figuring out why stream creation was too slow) and the bigger picture of where tech is headed. You'll get a feel for SkipLabs' laid-back engineering culture where people work independently but always have each other's backs, plus some thoughtful takes on everything from open source development to why we still edit code like it's 1995. Whether you're into the technical weeds of load testing or curious about how small teams tackle ambitious projects, there's something here for you.

{/* trunctate */}

## How long have you been working at SkipLabs?

I joined SkipLabs in November 2022, so it's been a little over two and a half years now.

## In a few words, what do you do at SkipLabs?

At SkipLabs, we develop tools focused on reactive programming. Our goal is to solve complex data synchronization problems while making this approach accessible and cost-effective in terms of infrastructure.
In practical terms, reactive programming is a declarative way of expressing computations: instead of manually handling state transitions, you simply describe state as a function of multiple inputs.
To make this approach tangible and usable on a daily basis, we created the Skip Framework—a reactive programming framework designed to be both powerful and easy to adopt.

## How would you describe the engineering culture at SkipLabs?

I’d say the engineering culture at SkipLabs is built first and foremost on trust and individual responsibility. Everyone pulls their weight and doesn’t hesitate to get their hands dirty when needed—even with tasks that may be a bit thankless. There’s a real collective drive to move things forward, and it shows in the general vibe: everyone is experienced, which allows us to work in parallel in a smooth and efficient way.

We operate in a fairly open and independent manner, with very few meetings. And despite this autonomy, there’s a lot of mutual support—whenever a question arises, someone is always there to help. Our expertise is quite diverse, which is a real strength. Several people on the team have a strong background in programming languages and a deep interest in low-level systems—especially compilers and LLVM, which sit at the heart of our stack.

On the tech side, the Skip Framework is currently exposed via a TypeScript API, and soon also via a native API in SkipLang. At the core of it all is a programming language, SkipLang, designed by Julien (previously at Facebook). The language was built to provide strong guarantees about data mutability—making it clear what can and cannot change, to enable safe and efficient cache invalidation.
We use this language today. It has its own compiler, written in SkipLang itself, which targets LLVM as a backend. This gives us strong performance while maintaining high portability: the framework can be compiled natively or to WebAssembly, which makes it possible, for example, to run it directly in a browser. In addition to SkipLang and TypeScript, we also use some Python and Bash—classic tools to keep everything running smoothly.

## So how do you approach scalability challenges?

For me, scalability starts with the ability to accurately measure performance. Before even thinking about optimization, you need reliable metrics—and ideally, with minimal manual intervention. Manual handling quickly becomes a source of errors, especially in systems as complex as ours.

It’s crucial to measure what you actually want to observe—not just loosely correlated metrics. Once you have a solid measurement foundation, you can start large-scale analysis, deep profiling, pinpoint real bottlenecks, and invest where it really matters. Right now, we’re specifically working on load testing SkipLang to better understand how our system behaves under different loads, and to validate our horizontal scalability. It’s a progressive process, but essential to ensuring strong performance in varied environments.

## And in your latest tests, what were the main bottlenecks you identified?

One of the first bottlenecks we found was in the creation of streams. Once a stream is set up, performance is excellent, even with multiple users subscribing in parallel. But the initial creation phase can be a bit too slow. We’re currently working on a fix to improve that.

This kind of issue really shows how important fine-grained, automated tracing is—to avoid local changes negatively affecting other parts of the system. Working as a team also means writing code that helps—or at least doesn’t hinder—others’ work. This is why we’re implementing recurring load tests that run automatically in our CI. The goal is to detect performance regressions early and make sure different optimizations continue to work well together, even as the codebase evolves.

## And in those load tests, what metrics do you prioritize?

There are several, but the most important is: how many users can we serve under acceptable conditions for a given budget? We aim to stay close to real-world use cases. Depending on the services being tested, some loads involve heavy writing, others are mostly read-heavy. Some may involve lots of shared data, others significant server-side computation before results are pushed out.

The key metric is replication time: when a client writes data, how long does it take for that data to be visible to all other affected clients? This delay depends on the associated computation graph, so it can vary a lot—but it’s an essential metric for us.
Once we’ve defined what counts as an acceptable client-side response time, we check how many clients we can serve with a single instance. Then we measure how that capacity scales when adding more servers—that’s our horizontal scalability curve.

## And on the server side, what do you measure?

There, we focus on how well we’re using available resources. For example: how many server instances can we run efficiently on a given machine? Are we fully utilizing RAM, CPU cores, I/O? There’s no point in paying for unused capacity. We complement that with regular profiling to ensure there are no avoidable bottlenecks in our server stack. It’s an ongoing effort, but it gives us real visibility into the system’s actual performance.

## Beyond technical challenges, what do you see as the bigger issues in this field?

I see three fundamental challenges:

- **Correctness** – We want clients to receive data that is both fresh and accurate, with mathematical guarantees that what they see is consistent with the system’s state. That’s non-negotiable.

- **Performance** – All of that has to happen as fast as possible, even at large scale. Offering low-latency reactivity is a bold promise—and a serious technical challenge.

- **Developer ergonomics** – This is often underestimated but just as crucial. Our goal is for developers to express business logic as declaratively and clearly as possible. Ideally, they focus only on what they want to produce, not how data will sync or update. It’s our job to ensure that works smoothly behind the scenes.

To achieve this, we need a sound and efficient computation model, solid implementation, and a clean codebase. That’s what we’re building with Skip: a technical foundation that lets you offload complexity without compromising rigor.

## What do you enjoy most about your work right now?

Benchmarking itself isn’t necessarily what excites me most—but right now it’s pretty thrilling, because we’re entering a new phase of the project. After months of prototyping and refining the core of the framework, we’re finally putting it through real-world load testing. Now we can truly measure how far this new paradigm can go under real conditions. It’s gratifying to see that what we’ve built—brick by brick—is starting to hold up at scale, and that the choices we’ve made are beginning to pay off.

## Taking a step back, what would you like to see evolve in computing today?

There are quite a few things I’d like to see change, but if I had to summarize, I’d highlight three key areas that matter most to me:

### Valuing open source as a shared public good:

I believe open source—or more broadly, digital commons—are still vastly underdeveloped relative to their importance. These are software foundations that benefit everyone and deserve more collective investment.

At SkipLabs, we work in open source under MIT license, and that’s one of the reasons I joined the team.

### Rethinking how we interact with code:

Today, as developers, our interaction with code is still quite “primitive”: we’re just editing letters on a page. Even though modern editors add powerful features, it’s still largely syntax-level work.
I’d like us to move toward tools that support semantic interaction with code—like version control that understands the intent behind a change, not just a diff of characters. That would unlock deeper collaboration, better understanding, and smarter analysis tools. It’s a major area for innovation.

### Mainstreaming cryptography in the digital public sphere:

I think we should make broader use of asymmetric cryptography for things involving public speech, traceability, or authorship—without necessarily resorting to blockchain. Digital signatures alone are enough in many cases.

Right now, these tools are still largely inaccessible to the general public, which is a real problem. I think it’s crucial to defend a web architecture that respects individual freedoms—and that includes broad adoption of tools like encrypted email, and digital signatures, ideally within an open-source ecosystem.

## Thanks, Lucas
Thanks to you !