
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

mkdir -p $4

source $1/bin/sdkman-init.sh

sdk list java > $4/list.log

if [ ! -d "$1/candidates/java/20.0.2-tem" ]
then
    sdk install java 20.0.2-tem 1>&2 > $4/install.log
fi

if [ ! -d "$1/candidates/gradle" ]
then
    echo "Installing gradle" 1>&2
    sdk install gradle 8.3 1>&2 > $4/install.log
fi

cd $2
if [ ! -d "$2/.gradle" ] 
then
    ./gradlew jar --no-daemon --console plain
fi

while IFS='=' read -r key value
do
eval ${key}="\${value}"
done < "$3"

echo "Running local server"
exec gradle --console plain -q run "--args=--DANGEROUS-no-encryption --dev --config $3 &> /dev/null" &> $4/server.log & 
pid1=$!
echo -e "sknpm.process=$pid1"

host="http://localhost:$skdb_port"

i=0
while [[ $i -lt 10 ]];
do
    if curl $host >/dev/null 2>&1; then
        echo "Server is running on port $skdb_port" 1>&2
        break;
    fi
    sleep 1
    i=$((i+1))
done

if [ $i -lt 10 ]; then
  i=0
  while ! [ -f ~/.skdb/credentials ];
  do
    sleep 1
    i=$((i+1))
  done
fi

sleep 2

key=$(jq -r ".[\"ws://localhost:$skdb_port\"].skdb_service_mgmt.root" < ~/.skdb/credentials)

echo -e "sknpm.env:SKDB_CREDENTIAL=$key"

if [ "$key" = "null" ]; then
    echo "Credential not found for $host." 1>&2
    kill $pid1
    exit 1
fi

exec gradle --console plain -q runMuxTestServer "--args=8090 &> /dev/null" &> $4/test_server.log & 
echo -e "sknpm.process=$!"

thost="http://localhost:8090"
i=0
while [[ $i -lt 10 ]];
do
    if curl $thost >/dev/null 2>&1; then
        echo "Test server is running on port 8090" 1>&2
        break;
    fi
    sleep 1
    i=$((i+1))
done
