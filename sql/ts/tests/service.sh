
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

[ -e "$4/skdb_service_mgmt.db" ] && rm "$4/skdb_service_mgmt.db" 1>&2
[ -e "$4/test.db" ] && rm "$4/test.db" 1>&2
[ -e "$4/test_node_worker.db" ] && rm "$4/test_node_worker.db" 1>&2
[ -e "$4/test_firefox.db" ] && rm "$4/test_firefox.db" 1>&2
[ -e "$4/test_firefox_worker.db" ] && rm "$4/test_firefox_worker.db" 1>&2
[ -e "$4/test_chrome.db" ] && rm "$4/test_chrome.db" 1>&2
[ -e "$4/test_chrome_worker.db" ] && rm "$4/test_chrome_worker.db" 1>&2

mkdir -p $4

source $1/bin/sdkman-init.sh

if [ ! -d "$1/candidates/java/20.0.2-tem" ]
then
    sdk install java 20.0.2-tem 1>&2 > $4/install_java.log
    sleep 2
fi

if [ ! -d "$1/candidates/gradle" ]
then
    echo "Installing gradle" 1>&2
    sdk install gradle 8.3 1>&2 > $4/install_gradle.log
    sleep 2
fi


cd $2
if [ ! -d "$2/.gradle" ] 
then
    ./gradlew jar --no-daemon --console plain
    sleep 2
fi


while IFS='=' read -r key value
do
eval ${key}="\${value}"
done < "$3"

echo "Running local server"
run_server () {
    exec gradle --console plain -q clean run "--args=--DANGEROUS-no-encryption --dev --config $2 &> /dev/null" &> $3/server.log & 
    pid1=$!

    host="http://localhost:$1"
    
    i=0
    while [[ $i -lt 10 ]];
    do
        if wget -q -o /dev/null $host 2>&1; then
            echo "Server is running on port $1" 1>&2
            break;
        fi
        sleep 1
        i=$((i+1))
    done

    exists=$(kill -0 $pid1);
    if [[ -z "$exists" ]]; then
        echo "$pid1"
    else
        return 1
    fi
}

run_test_server () {
    exec gradle --console plain -q clean runMuxTestServer "--args=8090 &> /dev/null" &> $1/test_server.log & 
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

    exists=$(kill -0 $pid2);
    if [[ -z "$exists" ]]; then
        echo "$pid2"
    else
        return 1
    fi
}

pid1=""
i=0
while [[ $i -lt 10 ]];
do
    pid1=$(run_server $skdb_port $3 $4)
    if [[ -n "$pid1" ]]; then
        echo -e "sknpm.process=$pid1"
        break;
    fi
    sleep 1
    i=$((i+1))
done

if [ $i -ge 10 ]; then
  exit 2
fi

i=0
while ! [ -f ~/.skdb/credentials ];
do
  sleep 2
  i=$((i+1))
  if [ $i -eq 30 ]; then
    kill $pid1
    exit 2
  fi
done

sleep 2

key=$(jq -r ".[\"ws://localhost:$skdb_port\"].skdb_service_mgmt.root" < ~/.skdb/credentials)

echo -e "sknpm.env:SKDB_CREDENTIAL=$key"

if [ "$key" = "null" ]; then
    echo "Credential not found for $host." 1>&2
    kill $pid1
    exit 1
fi

i=0
while [[ $i -lt 10 ]];
do
    pid=$(run_test_server $4)
    if [[ -n "$pid" ]]; then
        echo -e "sknpm.process=$pid"
        break;
    fi
    sleep 1
    i=$((i+1))
done

if [ $i -ge 10 ]; then
  kill $pid1
  exit 2
fi
