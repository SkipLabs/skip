#!/bin/bash

# check that all staged files are well-formatted

exec 1>&2

# check that a single staged file is well-formatted
check-file () {
    file=$1
    # select formatter based on filename extension, must transform stdin to stdout
    if [[ "$file" == *.sk ]]; then # keep in sync with fmt-sk in Makefile
        fmt="skfmt --assume-filename=$file"
    elif [[ "$file" =~ .*\.(c|cc|cpp|h|hh|hpp)$ ]]; then # keep in sync with fmt-c in Makefile
        fmt="clang-format --assume-filename=$file"
    elif [[ "$file" =~ .*\.(css|html|js|json|mjs|ts|tsx)$ ]]; then # keep in sync with .prettierignore
        fmt="npx prettier --stdin-filepath $file --loglevel debug"
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

# get list of staged files and check them in parallel
git diff-index --cached --name-only HEAD | parallel check-file {}
