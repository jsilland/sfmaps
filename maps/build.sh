#!/usr/bin/env bash

RELEASE=$(date "+%Y.%-m")

echo "Building maps in releases/${RELEASE}"

mkdir -p releases/${RELEASE}

BASE_URL="https://raw.githubusercontent.com/jsilland/sfmaps/master/maps/releases/${RELEASE}"

if [ -n "$1" ]
then
    BASE_URL=$1
fi

docker build . -t sfmaps:${RELEASE}
docker run \
    -v $(pwd)/releases/${RELEASE}:/release \
    sfmaps:${RELEASE} \
    ./maps.sh $BASE_URL
