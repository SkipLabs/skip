---
title: A CLI to streamline the creation of Skip services
description: A CLI designed to streamline the creation and initialization of Skip services
slug: announcing_create_skip_service_cli
date: 2025-05-23
authors: hubyrod
image: /img/skip.png
---

Hello Skippers. Today, we are excited to announce the release of `create-skip-service`: A CLI Tool for Skip Service Development. It aims to simplify the development workflow by providing a convenient way to bootstrap new Skip services.

```bash
npx create-skip-service <project-name> <options>
```

{/* truncate */}

## What are we talking about?

`create-skip-service` is a CLI tool that helps developers quickly set up new Skip service projects with customizable templates, saving the time you'd need to write boilerplate code. It's designed to follow best practices and provide a consistent starting point for all Skip service development.

## Key Features

- **Quick Project Setup**: A one-liner to have a fully working service
- **Template System**: Pick the right template for you, ask us for templates you need
- **Git Integration**: Automatic Git repository initialization (optional)
- **Customizable**: Once installed, templates are meant to be enhanced for YOUR project
- **Verbose Logging**: Detailed output for debugging and understanding the setup process, so you know what's going on

## Getting Started

[KISS](https://en.wikipedia.org/wiki/KISS_principle) - here is the one-liner to get started:

```bash
npx create-skip-service my-service
```

### Basic Usage

Of course, we've kept in mind that not all projects are alike, so here are a few options to get what's right for you:

```bash
# Create a new service with default template
npx create-skip-service my-service

# Create a service with a postgres integration
npx create-skip-service my-service --template with_postgres

# Create a service without Git initialization
npx create-skip-service my-service --nogit

# Run with verbose logging
npx create-skip-service my-service --verbose
```

## Available Options

- `--template, -t`: Specify the template to use (default: "default")
- `--nogit`: To NOT initialize a Git repository, otherwise git is initialized with a first commit
- `--verbose, -v`: Run with verbose logging
- `--quiet, -q`: Run with minimal logging
- `--force, -f`: Force overwrite if directory exists

## Why create-skip-service?

We created this tool to address several common challenges in Skip service development:

1. **Efficiency**: Reduce the time spent on project setup and configuration
2. **Standardization**: Provide a unified way to create and manage Skip services
3. **Flexibility**: Support different templates and configurations while maintaining consistency

## Contributing

We welcome contributions to `create-skip-service`! Whether it's bug reports, feature requests, or code contributions, your input helps make this tool better for everyone.

- GitHub Repository: [SkipLabs/create-skip-service](https://github.com/SkipLabs/create-skip-service)
- Issues: [GitHub Issues](https://github.com/SkipLabs/create-skip-service/issues)

## What's Next?

We're actively working on improving `create-skip-service` with plans for:

- Additional template options
- Enhanced configuration options
- More detailed documentation
- Community-driven template contributions

## Try It Out!

Give it a go! And keep us posted on what you are building. Feedback is bliss, right?

```bash
npx create-skip-service my-service
```

## Wrapping Up

`create-skip-service` represents our commitment to making Skip service development more efficient and enjoyable. By handling the boilerplate setup automagically[^1], we believe this tool will help developers focus on what matters most - building great services.

As of today, we are already on our way to improving and augmenting the number of options and templates. Come back and help us sort priorities!

[^1]: not a typo ;-)

We have a [Discord server](https://discord.gg/2nzP2PZj), why don't you swing by and say hi?

## What's Next?

For the next Skip article, what should I tackle first? You tell me!
- Scaling your Skip service horizontally?
- Integrating with frontend frameworks like React?
- Managing authorization and privacy per user?
- What else would be most useful to you *now*?

