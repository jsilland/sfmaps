#!/usr/bin/env sh

set -e

echo "Building map of police incidents"
./incidents/build.sh > /release/incidents.geojson
cp ./incidents/config.json /release/incidents.json
cp ./incidents/image.png /release/incidents.png

echo "Building map metadata"
INCIDENTS_RECORDS_LENGTH=$(jq ".features | length" < /release/incidents.geojson)
jq --null-input \
    --argjson incidents $INCIDENTS_RECORDS_LENGTH \
    --arg baseurl $1 \
    --from-file maps.jq \
    > /release/maps.json
