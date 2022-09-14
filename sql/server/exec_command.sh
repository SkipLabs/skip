#!/bin/bash

rm -f /tmp/foo

read CMD

echo "$CMD" >> /tmp/foo

while read LINE; do
    echo "$LINE"
done | eval ${CMD} 2>&1

# while read LINE; do
#     if [ "$LINE" = "\r" ]; then
#         break;
#     fi;
#     echo "$LINE" | egrep -q "^Sec-WebSocket-Key"
#     if [ "$?" -eq "0" ]; then
#         str=`echo -n $LINE | sed 's/\r//g' | sed 's/Sec-WebSocket-Key: //'`
#         str+="258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
#         hash=`echo -n "$str" | openssl dgst -binary -sha1 | openssl base64 -A`
#     fi
# done 

# echo -e "HTTP/1.1 101 Switching Protocols\r"
# echo -e "Upgrade: websocket\r"
# echo -e "Connection: Upgrade\r"
# echo -e "Sec-WebSocket-Accept: $hash\r"
# echo -e "\r"
# echo -e "\r"

# while read LINE; do
#     echo "$LINE";
# done
