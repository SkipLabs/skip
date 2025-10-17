#!/bin/bash

# Complete integration test for sharding service adapter
# This script:
# 1. Sets up a clean test database with sample data
# 2. Starts the sharding service
# 3. Tests the Skip Runtime adapter with initial data load
# 4. Performs real-time database updates and verifies streaming
# 5. Cleans up all resources

set -e

# Configuration
TEST_DB="sharding_adapter_complete_test"
SERVICE_PORT="8080"
BACKEND_DIR="$HOME/skipper/backend"
ADAPTER_DIR="$HOME/skip/skipruntime-ts/adapters/sharding-service"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

cleanup() {
    log "Cleaning up test environment..."
    
    # Kill sharding service if running
    if pgrep -f "sharding_service.*$SERVICE_PORT" > /dev/null; then
        warn "Stopping sharding service..."
        pkill -f "sharding_service.*$SERVICE_PORT" || true
        sleep 2
    fi
    
    # Kill any test processes
    pkill -f "node.*test" || true
    
    # Remove test database
    if psql -lqt | cut -d \| -f 1 | grep -qw "$TEST_DB"; then
        warn "Dropping test database $TEST_DB..."
        dropdb "$TEST_DB" || true
    fi
    
    log "Cleanup completed"
}

# Trap cleanup on script exit
trap cleanup EXIT

start_test() {
    log "Starting complete sharding service adapter test"
    log "Test database: $TEST_DB"
    log "Service port: $SERVICE_PORT"
}

setup_database() {
    log "Setting up test database..."
    
    # Create test database
    if psql -lqt | cut -d \| -f 1 | grep -qw "$TEST_DB"; then
        warn "Test database exists, dropping it first..."
        dropdb "$TEST_DB"
    fi
    
    createdb "$TEST_DB" || error "Failed to create test database"
    
    # Create host_map table and sample data
    log "Creating host_map table..."
    psql -d "$TEST_DB" -c "
        CREATE TABLE host_map (
            id TEXT PRIMARY KEY,
            hostname TEXT NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
    " || error "Failed to create host_map table"
    
    # Create tasks table and sample data
    log "Creating tasks table with sample data..."
    psql -d "$TEST_DB" -c "
        CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            partition_id TEXT NOT NULL,
            title TEXT NOT NULL,
            status TEXT NOT NULL,
            priority TEXT NOT NULL,
            assigned_to TEXT NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
        );
        
        INSERT INTO host_map (id, hostname) VALUES 
            ('host-1', 'test-host-1.example.com'),
            ('host-2', 'test-host-2.example.com');
            
        INSERT INTO tasks (id, partition_id, title, status, priority, assigned_to) VALUES
            ('task-1', 'user-1', 'Implement login system', 'pending', 'high', 'Alice Johnson'),
            ('task-2', 'user-1', 'Add user authentication', 'in_progress', 'high', 'Alice Johnson'),
            ('task-3', 'user-2', 'Design mobile UI', 'pending', 'medium', 'Bob Smith'),
            ('task-4', 'user-2', 'Setup push notifications', 'completed', 'low', 'Bob Smith'),
            ('task-5', 'user-3', 'Write API documentation', 'in_progress', 'medium', 'Charlie Brown'),
            ('task-6', 'user-4', 'Configure data sources', 'pending', 'medium', 'Diana Prince');
    " || error "Failed to create tasks table and sample data"
    
    log "Database setup completed"
}

start_sharding_service() {
    log "Starting sharding service..."
    
    cd "$BACKEND_DIR/sharding" || error "Cannot find sharding directory"
    
    # Build the service if needed
    if [ ! -f "./sharding_service" ]; then
        log "Building sharding service..."
        go build -o sharding_service . || error "Failed to build sharding service"
    fi
    
    # Start the service in background
    DATABASE_URL="postgres://localhost/$TEST_DB?sslmode=disable" \
    PORT="$SERVICE_PORT" \
    ./sharding_service > /tmp/sharding_service.log 2>&1 &
    
    local service_pid=$!
    log "Sharding service started with PID $service_pid"
    
    # Wait for service to be ready
    log "Waiting for sharding service to be ready..."
    for i in {1..30}; do
        if curl -s "http://localhost:$SERVICE_PORT/health" > /dev/null 2>&1; then
            log "Sharding service is ready"
            return 0
        fi
        sleep 1
    done
    
    error "Sharding service failed to start within 30 seconds"
}

compile_adapter() {
    log "Compiling adapter test..."
    
    cd "$ADAPTER_DIR" || error "Cannot find adapter directory"
    
    # Install dependencies if needed
    if [ ! -d "node_modules" ]; then
        log "Installing adapter dependencies..."
        npm install || error "Failed to install dependencies"
    fi
    
    # Compile test file
    npx tsc src/test.ts --outDir dist --module esnext --target es2020 --moduleResolution node --esModuleInterop --allowSyntheticDefaultImports || error "Failed to compile test"
    
    log "Adapter compilation completed"
}

test_initial_load() {
    log "Testing initial data load..."
    
    cd "$ADAPTER_DIR" || error "Cannot find adapter directory"
    
    # Create a test script that exits after initial load
    cat > /tmp/test_initial.js << 'EOF'
import { ShardingServiceExternalService } from './dist/test.js';

async function testInitialLoad() {
    console.log("Testing initial data load...");
    
    const adapter = new ShardingServiceExternalService({
        host: "localhost",
        port: 8080,
        protocol: "http"
    });
    
    const isHealthy = await adapter.isHealthy();
    if (!isHealthy) {
        console.error("Service not healthy");
        process.exit(1);
    }
    console.log("Service health check: PASSED");
    
    let receivedInitial = false;
    
    await adapter.subscribe(
        "test-initial", 
        "tasks", 
        {
            origin: "test-host-1.example.com",
            partitionColumn: "partition_id",
            syncHistoricData: true
        }, 
        {
            update: async (updates, isInit) => {
                if (isInit) {
                    console.log("Initial data received:", updates.length, "partition groups");
                    console.log("Partitions:", updates.map(([key, _]) => key));
                    receivedInitial = true;
                    
                    // Verify we got the expected partitions
                    const partitions = updates.map(([key, _]) => key).sort();
                    const expected = ['user-1', 'user-2', 'user-4'].sort();
                    
                    if (JSON.stringify(partitions) === JSON.stringify(expected)) {
                        console.log("Initial load test: PASSED");
                    } else {
                        console.error("Initial load test: FAILED");
                        console.error("Expected partitions:", expected);
                        console.error("Received partitions:", partitions);
                        process.exit(1);
                    }
                    
                    setTimeout(() => {
                        adapter.shutdown();
                        process.exit(0);
                    }, 1000);
                }
            },
            error: (error) => {
                console.error("Adapter error:", error);
                process.exit(1);
            }
        }
    );
    
    // Timeout after 10 seconds
    setTimeout(() => {
        if (!receivedInitial) {
            console.error("Timeout waiting for initial data");
            process.exit(1);
        }
    }, 10000);
}

testInitialLoad().catch(console.error);
EOF
    
    # Run initial load test
    timeout 15s node --input-type=module /tmp/test_initial.js || error "Initial load test failed"
    
    log "Initial load test completed successfully"
}

test_realtime_updates() {
    log "Testing real-time updates..."
    
    cd "$ADAPTER_DIR" || error "Cannot find adapter directory"
    
    # Create a test script that monitors for updates
    cat > /tmp/test_realtime.js << 'EOF'
import { ShardingServiceExternalService } from './dist/test.js';

async function testRealtimeUpdates() {
    console.log("Testing real-time updates...");
    
    const adapter = new ShardingServiceExternalService({
        host: "localhost",
        port: 8080,
        protocol: "http"
    });
    
    let receivedInitial = false;
    let receivedUpdate = false;
    
    await adapter.subscribe(
        "test-realtime", 
        "tasks", 
        {
            origin: "test-host-1.example.com",
            partitionColumn: "partition_id",
            syncHistoricData: true
        }, 
        {
            update: async (updates, isInit) => {
                if (isInit) {
                    console.log("Initial data received for real-time test");
                    receivedInitial = true;
                } else {
                    console.log("Real-time update received:", updates);
                    receivedUpdate = true;
                    
                    setTimeout(() => {
                        adapter.shutdown();
                        if (receivedUpdate) {
                            console.log("Real-time update test: PASSED");
                            process.exit(0);
                        } else {
                            console.error("Real-time update test: FAILED");
                            process.exit(1);
                        }
                    }, 1000);
                }
            },
            error: (error) => {
                console.error("Adapter error:", error);
                process.exit(1);
            }
        }
    );
    
    // Timeout after 30 seconds
    setTimeout(() => {
        console.error("Timeout waiting for real-time updates");
        process.exit(1);
    }, 30000);
}

testRealtimeUpdates().catch(console.error);
EOF
    
    # Start monitoring in background
    timeout 35s node --input-type=module /tmp/test_realtime.js &
    local monitor_pid=$!
    
    # Wait for initial connection
    sleep 3
    
    # Make database changes to trigger updates
    log "Making database changes to trigger real-time updates..."
    
    # Insert new task
    psql -d "$TEST_DB" -c "
        INSERT INTO tasks (id, partition_id, title, status, priority, assigned_to) VALUES
        ('task-new-1', 'user-1', 'New real-time task', 'pending', 'high', 'Alice Johnson');
    " || error "Failed to insert new task"
    
    sleep 2
    
    # Update existing task
    psql -d "$TEST_DB" -c "
        UPDATE tasks SET status = 'completed', updated_at = CURRENT_TIMESTAMP 
        WHERE id = 'task-1';
    " || error "Failed to update task"
    
    # Wait for the monitoring process
    wait $monitor_pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        log "Real-time update test completed successfully"
    else
        error "Real-time update test failed"
    fi
}

run_complete_test() {
    start_test
    setup_database
    start_sharding_service
    compile_adapter
    test_initial_load
    test_realtime_updates
    
    log "All tests completed successfully!"
    log "The sharding service adapter is working correctly with:"
    log "- Initial data loading from database"
    log "- Real-time streaming of database changes"
    log "- Proper partitioning by partition_id column"
    log "- Skip Runtime collection format compliance"
}

# Run the complete test
run_complete_test