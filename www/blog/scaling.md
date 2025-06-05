---
title: Dynamically scaling your Skip services
description: How to horizontally scale Skip services with Kubernetes
slug: horizontal-scaling
date: 2025-06-06
authors: benno
---

Skip makes it fast and easy to build reactive services which efficiently update
their outputs in response to input changes, powering real-time features and
saving resources by avoiding unnecessary recomputations.

The technical foundation that makes this possible is Skip's hyper-efficient
reactive computation graph, which is written in the Skip programming language,
runs natively, and takes great pains to efficiently represent and manipulate
the data underlying your reactive system.

However, that still requires memory, compute, and other resources -- so what do
you do when traffic spikes or grows beyond the capacity of even a powerful
single machine? Scale out and distribute your reactive service across more
machines, of course!

<!--truncate-->

We've recently built out some capabilities to make this easy, using a
distributed leader/follower architecture to dramatically increase the number of
concurrent resource instances that a Skip service can support.

# What

- we've built out some infra and configs to make this easy, using a
  leader/follower architecture to spread requested resources out 
  
  < diagram here >
  
- Using this design and standard tools, you can now just run `kubectl scale
  --replicas=$X` (or the GUI/dashboard equivalent from your provider/host) to
  allocate more resources
  
# How

- stick a reverse proxy ingress controller in front of your kubernetes cluster

- key thing is idempotent self-registration of skip instances with the reverse
  proxy (make sure you don't expose this port publicly!)

- Your application can now scale up and down with traffic spikes!


## Wrap-up

Everyone's infrastructure and application are different, so let us know if there
are other frameworks or tools you'd like to see supported or used in our
examples and demos!

We're also happy to help you scale out your reactive service using Skip, either
by adapting these tools to your environment or advising on your setup.  Reach
out and show us what you're building!
