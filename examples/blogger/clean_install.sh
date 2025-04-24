#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to process a directory
process_directory() {
    local dir="$1"
    local has_package_json=false

    # Check if directory has package.json
    if [ -f "$dir/package.json" ]; then
        has_package_json=true
        echo -e "${YELLOW}Processing $dir${NC}"
        
        # Try to change directory, if fails, skip this directory
        if ! cd "$dir"; then
            echo -e "${RED}Error: Failed to enter directory $dir${NC}"
            return 1
        fi
        
        # Clean and install
        echo -e "${YELLOW}Cleaning $dir...${NC}"
        if ! npm run clean; then
            echo -e "${RED}Error: Clean failed in $dir${NC}"
            cd - || return 1
            return 1
        fi
        
        echo -e "${YELLOW}Installing dependencies in $dir...${NC}"
        if ! npm install; then
            echo -e "${RED}Error: Install failed in $dir${NC}"
            cd - || return 1
            return 1
        fi
        
        cd - || return 1
    fi
}

# Process the current directory
process_directory "."

# Process only immediate subdirectories
for subdir in */; do
    if [ -d "$subdir" ]; then
        process_directory "$subdir"
    fi
done

if [ $? -eq 0 ]; then
    echo -e "${GREEN}All projects processed successfully!${NC}"
else
    echo -e "${RED}Some projects failed to process. Check the error messages above.${NC}"
    exit 1
fi 