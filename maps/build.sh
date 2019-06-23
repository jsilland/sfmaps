#!/usr/bin/env bash

set -e

RELEASE=$(date "+%Y.%-m")

BUILD_MAPS_SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "Building maps in ${BUILD_MAPS_SCRIPT_PATH}/releases/${RELEASE}"

mkdir -p ${BUILD_MAPS_SCRIPT_PATH}/releases/${RELEASE} || { echo "Couldn't create release directory in ${BUILD_MAPS_SCRIPT_PATH}/releases/${RELEASE}" ; exit 1; }

BASE_URL="https://raw.githubusercontent.com/jsilland/sfmaps/master/maps/releases/${RELEASE}"

if [ -n "$1" ]
then
    BASE_URL=$1
fi

docker build ${BUILD_MAPS_SCRIPT_PATH} -t sfmapsdata:${RELEASE} || { echo "Failed to create dataset image" ; exit 2; }

docker run \
    -v ${BUILD_MAPS_SCRIPT_PATH}/releases/${RELEASE}:/release \
    sfmapsdata:${RELEASE} \
    ./maps.sh "${BASE_URL}"  || { echo "Failed to build dataset" ; exit 2; }

rm -f ${BUILD_MAPS_SCRIPT_PATH}/releases/latest
ln -s ${BUILD_MAPS_SCRIPT_PATH}/releases/${RELEASE} ${BUILD_MAPS_SCRIPT_PATH}/releases/latest
