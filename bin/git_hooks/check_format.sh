#!/bin/bash

# check that all staged files are well-formatted

exec 1>&2

PRETTIER_VERSION=$(jq -r '.devDependencies.prettier' package.json)
BLACK_VERSION=$(grep '^black==' requirements-dev.txt | cut -d'=' -f3)

# `check-file` runs under `parallel`, which executes the exported function in a
# child shell that inherits only *exported* variables. Without this export,
# $PRETTIER_VERSION is empty inside check-file and the command becomes
# `npx prettier@`, which silently pulls the *latest* prettier instead of the
# pinned one and then reports spurious formatting diffs whenever they disagree.
export PRETTIER_VERSION
if [ -z "$PRETTIER_VERSION" ] || [ "$PRETTIER_VERSION" = "null" ]; then
    echo "Error: could not read prettier version from package.json devDependencies"
    exit 1
fi

# Check black version (run `pip install -r requirements-dev.txt` if wrong version)
if ! black --version 2>/dev/null | grep -q "$BLACK_VERSION"; then
    echo "Error: black==$BLACK_VERSION required. Run: pip install -r requirements-dev.txt"
    exit 1
fi

# check that a single staged file is well-formatted
check-file () {
    file=$1
    # select formatter based on filename extension, must transform stdin to stdout
    if [[ "$file" == *.sk ]]; then # keep in sync with fmt-sk in Makefile
        fmt="skfmt --assume-filename=$file"
    elif [[ "$file" =~ .*\.(c|cc|cpp|h|hh|hpp)$ ]]; then # keep in sync with fmt-c in Makefile
        fmt="clang-format --assume-filename=$file"
    elif [[ "$file" =~ .*\.(css|html|js|json|mjs|ts|tsx)$ ]]; then # keep in sync with .prettierignore
        fmt="npx -y prettier@$PRETTIER_VERSION --stdin-filepath $file --loglevel debug"
    elif [[ "$file" == *.py ]]; then # keep in sync with fmt-py in Makefile
        fmt="black - --quiet --line-length 80 --stdin-filename $file"
    else
        exit 0;
    fi
    # read the staged source
    code=$(git show :"$file");
    # check if formatting changes code
    diff=$(echo "$code" | $fmt | diff <(echo "$code") -)
    if [ -n "$diff" ]; then
        # report file and diff
        echo -e "\n$file\n$diff";
        # fail
        exit 1;
    fi
}
export -f check-file

# get list of staged files (excluding deletions) and check them in parallel
git diff-index --cached --name-only --diff-filter=d HEAD | parallel check-file {}
