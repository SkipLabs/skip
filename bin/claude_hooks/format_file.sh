#!/bin/bash

# Format a single file based on its extension.
# Called by Claude Code PostToolUse hook with JSON on stdin.
# Keep in sync with bin/git_hooks/check_format.sh

file_path=$(jq -r '.tool_input.file_path // empty')

if [ -z "$file_path" ]; then
    exit 0
fi

PRETTIER_VERSION=$(jq -r '.devDependencies.prettier' "$CLAUDE_PROJECT_DIR/package.json")
BLACK_VERSION=$(grep '^black==' "$CLAUDE_PROJECT_DIR/requirements-dev.txt" | cut -d'=' -f3)

case "$file_path" in
    *.sk)
        if command -v skfmt &>/dev/null; then
            skfmt -i "$file_path"
        else
            DOCKER_IMAGE="${DOCKER_IMAGE:-skiplabs/skip:latest}"
            REL_PATH="${file_path#"$CLAUDE_PROJECT_DIR"/}"
            docker run --rm \
                -v "$CLAUDE_PROJECT_DIR:/work/skip" \
                -w /work/skip \
                "$DOCKER_IMAGE" \
                skfmt -i "$REL_PATH"
        fi
        ;;
    *.c|*.cc|*.cpp|*.h|*.hh|*.hpp)
        if command -v clang-format &>/dev/null; then
            clang-format -i "$file_path"
        fi
        ;;
    *.css|*.html|*.js|*.json|*.mjs|*.ts|*.tsx)
        npx -y prettier@"$PRETTIER_VERSION" --write "$file_path"
        ;;
    *.py)
        black --quiet --line-length 80 "$file_path"
        ;;
esac
