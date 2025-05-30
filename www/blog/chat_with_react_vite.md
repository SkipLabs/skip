---
title: React + Vite in front of a Skip Service - the template
description: Build a modern chat app with real-time updates using Skip's reactive data system, React, and Vite
slug: skip_with_react_vite
date: 2025-05-30
authors: hubyrod
---

Hello skippers. Today, we are introducing a new template to our collection: React + Vite. While our previous blog posts focused on building skip services, this new template represents our first step into the frontend, bringing together the best of both worlds: front and back.

```bash
npx create-skip-service my-skip-chat --template with_react_vite
```

{/* trunctate */}

## What's Inside the Template?

Our React + Vite template for Skip Services comes with everything you need to get started on building a modern web application: an easy to manipulate end-to-end data flow from the user interface to the backend, and vice-versa (reactive programming enthusiasts, I have your attention now).

## Getting Started

To create a new project with our React + Vite template, simply run:

```bash
npx create-skip-service my-skip-chat --template with_react_vite --verbose

cd my-skip-chat   # enter the project directory
./setup.sh        # and set up the project
```

Setting up the project will end up with:
```bash
✅ Setup complete!

To run the application:
1. Start the reactive service:
   cd reactive_service && pnpm start

2. In a new terminal, start the frontend:
   cd frontend && pnpm dev

The frontend will be available at http://localhost:5173
```

This could hardly ever be simpler :-p

## If you open the project directory

In both subprojects, `frontend` and `reactive_service`, we've hardcoded some values, and taken shortcuts here and there in order to be straight to the point: making reactive programming easy to get, easy to grasp, easy to adopt, easy to embrace. easy to marry... ok, one step too far. 

One or two cool things you will want to try:
 - plugging into a DB from the backend, we can give you some help : [Building a Real-time Blog with Skip and PostgreSQL](https://skiplabs.io/blog/postgresql_and_skip)
 - having several conversations on screen, one per tab
 - integrating your user-management system
 - integrating an AI agent to discuss into the chat

We have a [Discord server](https://discord.com/channels/1093901946441703434/1093901946441703437), why don't you swing by and say hi, ask a question or two?


## What's Next?

For the next Skip article, what should I tackle first? You tell me!
- Scaling your Skip service horizontally?
- Having an AI agent interacting in the chat ?
- Managing authorization and privacy per user?
- What else would be most useful to you now?
