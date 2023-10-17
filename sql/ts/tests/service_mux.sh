
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
    echo "Must provide SKDB_DATABASES file" 1>&2
    exit 1
fi

source $1/bin/sdkman-init.sh
cd $2

run_test_server () {
    exec gradle --console plain -q runMuxTestServer "--args=8090 &> /dev/null" &> $1/test_server.log & 
    pid2=$!

    thost="http://localhost:8090"
    i=0
    while [[ $i -lt 10 ]];
    do
        if wget -q -o /dev/null $thost 2>&1; then
            echo "Test server is running on port 8090" 1>&2
            break;
        fi
        sleep 1
        i=$((i+1))
    done
    if [[ $i -ge 10 ]]; then
        echo "Gave up waiting for server $pid2 to start at $thost" 1>&2;
    fi
    exists=$(kill -0 $pid2);
    if [[ -z "$exists" ]]; then
        echo "$pid2"
    else
        return 1
    fi
}

i=0
while [[ $i -lt 10 ]];
do
    echo "Running mux server ($i)"
    pid=$(run_test_server $3)
    if [[ -n "$pid" ]]; then
        echo -e "sknpm.process=$pid"
        break;
    fi
    i=$((i+1))
done

if [ $i -ge 10 ]; then
  kill $pid1
  exit 2
fi
