# Automated Cache Invalidation Example

A demonstration of Skip runtime's automated cache invalidation capabilities, showcasing how database changes automatically trigger cache updates without manual intervention, ensuring data consistency across distributed systems.

## Overview

This example demonstrates automated cache invalidation using a blogging application where:

- **Skip cache service** (`edge_service/`) - Automatically invalidates cached data when database changes occur
- **Flask web service** (`web_service/`) - Triggers cache updates through database operations
- **Vue.js frontend** (`www/`) - Receives real-time updates via automated cache invalidation
- **PostgreSQL database** (`db/`) - Source of truth that triggers automatic cache invalidation
- **HAProxy reverse proxy** (`reverse_proxy/`) - Distributes load across cache nodes

## Quick Start

### Single Service Mode
```bash
docker compose up --build
```

### Distributed Mode (Leader-Follower)
```bash
docker compose -f compose.distributed.yml up --build
```

The distributed configuration runs one *leader* handling writes and database operations, with three *followers* serving reactive streams to clients in a round-robin fashion. This configuration is transparent to clients and requires only configuration changes.

### Clean Installation
```bash
./clean_install.sh
```

## Key Features

### Automated Cache Invalidation
- **Zero manual intervention** - Cache automatically updates when database changes
- **Eventual consistency** - Updates propagate quickly but not instantaneously
- **Near real-time propagation** - Changes reflected across cache nodes with minimal delay
- **Reactive streams** - Clients receive updates without polling

### Technical Capabilities
- **Distributed invalidation** - Works seamlessly across leader-follower architecture
- **Granular updates** - Only affected cache entries are invalidated
- **Event-driven architecture** - Database changes trigger immediate cache updates
- **Scale-out ready** - Add cache nodes without changing invalidation logic

## How Automated Cache Invalidation Works

1. **Database Write** - User creates/updates/deletes a blog post
2. **Automatic Detection** - Skip runtime monitors PostgreSQL changes
3. **Cache Invalidation** - Affected cache entries are automatically invalidated
4. **Stream Updates** - Connected clients receive updates via Server-Sent Events
5. **UI Refresh** - Frontend automatically displays fresh data

No cache keys to manage, no TTLs to configure, no manual invalidation calls!

**Note**: This system provides eventual consistency. There may be brief moments where different nodes see different data during propagation.

## Port Configuration

- **Frontend**: Served by HAProxy on ports 80/443
- **Flask API**: Internal service communication
- **Skip cache service**: Ports 8080 (streaming) and 8081 (control)
- **PostgreSQL**: Port 5432 (internal)
