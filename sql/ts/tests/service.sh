
#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Must provide SDKMAN_INIT" 1>&2
    exit 1
fi

if [[ -z "$2" ]]; then
    echo "Must provide SKGW_DIR" 1>&2
    exit 1
fi

if [[ -z "$3" ]]; then
    echo "Must provide configuration file" 1>&2
    exit 1
fi

if [[ -z "$4" ]]; then
    echo "Must provide SKDB_DATABASES file" 1>&2
    exit 1
fi

[ -e "$4/skdb_service_mgmt.db" ] && rm "$4/skdb_service_mgmt.db" 1>&2
[ -e "$4/test.db" ] && rm "$4/test.db" 1>&2

mkdir -p $4
source $1
cd $2

gradle --console plain -q run "--args=--DANGEROUS-no-encryption --init --config $3 &> $4/init.tmp.log" &> $4/init.log

exec gradle --console plain -q run "--args=--DANGEROUS-no-encryption --dev --config $3 &> $4/server.tmp.log" &> $4/server.log & 
echo "sknpm.process=$!" 1>&2
exec gradle --console plain -q runMuxTestServer "--args=8090 &> $4/test_server.tmp.log" &> $4/test_server.log & 
echo "sknpm.process=$!" 1>&2
sleep 5