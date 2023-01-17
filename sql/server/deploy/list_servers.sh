#! /bin/bash

set -e

if [[ -z $1 ]] || [[ $1 == "--help" ]]; then
    echo "Usage: $0 role"
    echo "role may be:"
    echo "replication-server"
    echo "replication-proxy"
    exit 1
fi

ROLE=$1

# assumes you have the aws cli installed and configured

aws ec2 describe-instances \
    --filters "Name=tag:role,Values=$ROLE" \
    --query 'Reservations[].Instances[].PrivateDnsName' |
    jq -cr .[]
