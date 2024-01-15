#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Must provide SDKMAN_DIR" 1>&2
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

if [[ -z "$5" ]]; then
    echo "Must provide SERVER_JAR file" 1>&2
    exit 1
fi

[ -e "$4/skdb_service_mgmt.db" ] && rm "$4/skdb_service_mgmt.db" 1>&2
[ -e "$4/test.db" ] && rm "$4/test.db" 1>&2
[ -e "$4/test_node_worker.db" ] && rm "$4/test_node_worker.db" 1>&2
[ -e "$4/test_firefox.db" ] && rm "$4/test_firefox.db" 1>&2
[ -e "$4/test_firefox_worker.db" ] && rm "$4/test_firefox_worker.db" 1>&2
[ -e "$4/test_chrome.db" ] && rm "$4/test_chrome.db" 1>&2
[ -e "$4/test_chrome_worker.db" ] && rm "$4/test_chrome_worker.db" 1>&2

while IFS='=' read -r key value
do
eval ${key}="\${value}"
done < "$3"

source $1/bin/sdkman-init.sh
cd $2

run_server () {
    java -jar $4 --config $2 &> $3/server.log &
    pid1=$!

    host="http://localhost:$1"

    i=0
    while [[ $i -lt 10 ]];
    do
        if curl --max-time 5 "$host" >/dev/null 2>&1; then
            echo "Server is running on port $1" 1>&2
            break;
        fi
        sleep 1
        i=$((i+1))
    done
    if [[ $i -ge 10 ]]; then
        echo "Gave up waiting for server $pid1 to start at $host" 1>&2;
        echo "Config:" 1>&2
        cat "$2" 1>&2
    fi

    exists=$(kill -0 $pid1);
    if [[ -z "$exists" ]]; then
        echo "$pid1"
    else
        return 1
    fi
}

pid1=""
i=0
while [[ $i -lt 10 ]];
do
    echo "Running local server ($i)"
    pid1=$(run_server $skdb_port $3 $4 $5)
    if [[ -n "$pid1" ]]; then
        echo "sknpm.process=$pid1"
        break;
    fi
    i=$((i+1))
done

if [ $i -ge 10 ]; then
  exit 2
fi
