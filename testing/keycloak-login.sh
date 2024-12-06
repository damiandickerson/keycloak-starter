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
USERNAME=`cat $1 | jq -r .username`
PASSWORD=`cat $1 | jq -r .password`
CLIENTID=`cat $1 | jq -r .clientid`
CLIENTSECRET=`cat $1 | jq -r .client_secret`

curl -X POST \
    https://$HOST/realms/$REALM/protocol/openid-connect/token \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d username=$USERNAME \
    -d password=$PASSWORD \
    -d grant_type=password \
    -d client_id=$CLIENTID \
    -d client_secret=$CLIENTSECRET \
    --insecure
