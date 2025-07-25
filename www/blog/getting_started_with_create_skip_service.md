---
title: Getting Started with create-skip-service: From Zero to Running Service
description: A practical walkthrough of using create-skip-service to quickly bootstrap a Skip service with the cache invalidation example
slug: getting_started_with_create_skip_service
date: 2025-07-25
authors: hubyrod
image: /img/skip.png
---

Building reactive services can feel overwhelming when you're starting from scratch. Fortunately, the [`create-skip-service`](/blog/announcing_create_skip_service_cli) CLI tool makes it incredibly easy to get up and running with a fully functional Skip service in minutes. Today, we'll walk through using it to create a service based on our [cache invalidation example](/blog/cache_invalidation), demonstrating how reactive systems handle the complex caching challenges we discussed earlier.

In this practical guide, you'll see exactly how to go from an empty directory to a running distributed system that showcases Skip's reactive caching capabilities.

{/* truncate */}

## The Three-Command Journey

Getting started with Skip services has never been simpler. Here's literally all you need to do:

```bash
npx create-skip-service myproj --example cache_invalidation --verbose
cd myproj
docker compose up --build
```

That's it. In just three commands, you'll have a fully functional reactive service running locally with all the infrastructure pieces you need.

## What's Happening Under the Hood

Let's break down what each command accomplishes:

### Step 1: Project Generation
```bash
npx create-skip-service myproj --example cache_invalidation --verbose
```

The `--example cache_invalidation` flag tells the CLI to use the cache invalidation template instead of the default basic template. This gives you a complete working example that demonstrates:

- **Reactive caching in action**: See how data updates automatically propagate through the system
- **Multi-service architecture**: A realistic setup with multiple components working together
- **Database integration**: PostgreSQL backend with reactive queries
- **Frontend integration**: A web interface to interact with your service
- **Container orchestration**: Docker Compose configuration for easy local development

The `--verbose` flag shows you exactly what's happening during the setup process, which is particularly helpful when you're learning how the pieces fit together.

### Step 2: Enter Your Project
```bash
cd myproj
```

Simple enough - navigate into your newly created project directory.

### Step 3: Launch Everything
```bash
docker compose up --build
```

This single command orchestrates your entire distributed system:
- Builds the reactive service container
- Starts a PostgreSQL database
- Launches the web frontend
- Sets up a reverse proxy to route traffic
- Connects all the pieces together

## What You Get Out of the Box

The cache invalidation example creates a complete distributed system that demonstrates the concepts we covered in our [earlier article about cache invalidation](/blog/cache_invalidation). Here's what you'll find running:

### The Reactive Service
A Skip service that handles data processing and caching automatically. Unlike traditional systems where you'd need to manually manage cache invalidation, this service uses Skip's reactive architecture to keep everything in sync.

### Database Integration
A PostgreSQL database with sample data and schemas. The reactive service connects to this database and automatically updates its computed results whenever the underlying data changes.

### Web Interface
A user-friendly frontend where you can:
- View real-time data updates
- Trigger changes to see reactive updates in action
- Monitor system performance and behavior

### Infrastructure Components
- **Reverse proxy**: Routes traffic between your frontend and backend services
- **Container networking**: Everything configured to work together seamlessly
- **Volume persistence**: Your database data persists between container restarts

## Seeing Reactivity in Action

Once your system is running, you can observe the reactive caching behavior that makes Skip special:

1. **Make a change** in the database through the web interface
2. **Watch as computed results update automatically** without any manual cache invalidation
3. **See consistent data** across all parts of your application instantly

This is exactly the kind of automatic cache management we discussed in our [cache invalidation article](/blog/cache_invalidation) - no more worrying about stale data or complex invalidation logic.

## Beyond the Example

The cache invalidation example serves as more than just a demo - it's a foundation you can build upon:

### For Learning
- Study the code to understand reactive patterns
- Experiment with different data changes to see how updates propagate
- Monitor performance characteristics of incremental updates

### For Development
- Use it as a starting point for your own reactive services
- Replace the sample data with your own domain models
- Add new reactive computations and watch them integrate seamlessly

### For Production
- The containerized architecture scales from development to production
- Add monitoring, logging, and security as needed
- Deploy to your favorite container orchestration platform

## Why This Approach Works

The combination of `create-skip-service` and the cache invalidation example demonstrates several key advantages:

**Immediate Gratification**: You can see a complex reactive system working within minutes, not hours or days of setup.

**Real-World Patterns**: This isn't a toy example - it shows you production-ready patterns for building reactive services.

**Learning by Doing**: Instead of reading about reactive concepts in the abstract, you can interact with a running system and see the benefits firsthand.

**Foundation for Growth**: Every piece of the generated code is meant to be customized for your specific needs.

## Troubleshooting Common Issues

### Port Conflicts
If you're already running services on the default ports, you can modify the `docker-compose.yml` file to use different port mappings.

### Docker Resources
The cache invalidation example spins up several containers. Make sure Docker has sufficient memory allocated (at least 4GB recommended).

### Verbose Logging
If something goes wrong during setup, re-run the `create-skip-service` command with `--verbose` to see detailed logging that can help identify the issue.

## What's Next?

Now that you have a running reactive service, you might want to:

1. **Explore the code**: Look at how the reactive computations are structured
2. **Modify the data model**: Add your own tables and see how the system adapts
3. **Add new features**: Create additional reactive endpoints or computations
4. **Deploy to production**: Use the containerized setup as a foundation for cloud deployment

The beauty of starting with `create-skip-service` is that you get all the boilerplate and infrastructure setup out of the way immediately, letting you focus on the interesting parts of building reactive applications.

## Connecting the Dots

This practical walkthrough demonstrates the concepts we covered in our previous articles:

- The [create-skip-service announcement](/blog/announcing_create_skip_service_cli) showed you the tool's capabilities
- The [cache invalidation deep dive](/blog/cache_invalidation) explained the theoretical benefits of reactive caching
- This article shows you how to experience those benefits firsthand in just three commands

## Wrapping Up

The journey from zero to a running reactive service doesn't have to be complicated. With `create-skip-service` and the cache invalidation example, you can have a sophisticated distributed system running locally in minutes.

More importantly, you get to experience firsthand how reactive systems solve the cache invalidation challenges that plague traditional architectures. Instead of reading about the benefits of automatic cache updates, you can see them working in your own environment.

Give it a try, and let us know what you build! The reactive paradigm opens up new possibilities for how we think about data consistency and performance in distributed systems.

## What Would You Like to See Next?

Now that you've got a reactive service running, what aspects would you like us to dive deeper into?

- Adding authentication and user-specific data to reactive services?
- Scaling reactive architectures across multiple machines?
- Integrating with modern frontend frameworks like React or Vue?
- Monitoring and observability for reactive systems?
- Migration strategies from traditional caching architectures?

Drop us a line in our [Discord server](https://discord.com/channels/1093901946441703434/1093901946441703437) and let us know what you'd find most valuable!