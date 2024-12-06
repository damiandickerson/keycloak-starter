#!/bin/sh

set -e

# Argument validation check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <json file>"
    exit 1
fi

# File exist check
if [ ! -f $1 ]; then
    echo "File not found!"
    exit 1
fi

HOST=`cat $1 | jq -r .host`
REALM=`cat $1 | jq -r .realm`

curl -X GET \
    https://$HOST/realms/$REALM/protocol/openid-connect/certs \
    --insecure
