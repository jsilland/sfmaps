#!/usr/bin/env bash

set -e

BASE_URL="http://localhost:49160/public"

if [ -n "$1" ]
then
    BASE_URL=$1
fi


SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
($SCRIPT_PATH/maps/build.sh $BASE_URL) || { echo 'Failed to assemble datasets' ; exit 1; }

docker build ${SCRIPT_PATH} -t sfmaps:latest  || { echo 'Failed to build Kepler app' ; exit 2; }
docker run \
    -v ${SCRIPT_PATH}/maps/releases/latest:/usr/src/app/public \
    -p 49160:8080 \
    sfmaps:latest
