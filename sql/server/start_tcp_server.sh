#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
tcpserver 0 3048 $SCRIPT_DIR/exec_command.sh
