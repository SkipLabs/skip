#!/bin/bash

#
# start the server
#

if [ -f ~/.skdb/config.prop ];then
  file=$(realpath ~/.skdb/config.prop)
  while IFS='=' read -r key value
  do
    eval ${key}="\${value}"
  done < "$file"
  if [[ $# -gt 0 ]]; then
    server_args="$* --config $file"
  else
    server_args="--config $file"
  fi
else
  if [[ $# -gt 0 ]]; then
    server_args="$*"
  else
    server_args=
  fi
fi

if [ -d ~/.sdkman ]
then
    SDKMAN=$(realpath ~/.sdkman)
else
    SDKMAN=/root/.sdkman
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$SDKMAN/bin/sdkman-init.sh"

cd "$SCRIPT_DIR/../skgw" || exit 1

mkdir -p /var/db || exit 1

if [[ -z "$server_args" ]];then
    exec gradle --console plain run 
else
    exec gradle --console plain run "--args=$server_args"
fi
