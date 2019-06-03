#!/usr/bin/env bash

RELEASE=$(date "+%Y.%-m")

echo "Building maps in releases/${RELEASE}"

mkdir -p releases/${RELEASE}

docker build --no-cache . -t sfmaps:${RELEASE}
docker run -v $(pwd)/releases/${RELEASE}:/release sfmaps:${RELEASE}
