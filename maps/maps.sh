#!/usr/bin/env sh

set -e

echo "Building map of SFPD police incidents"
./incidents/build.sh > /release/incidents.geojson || { echo "Failed to fetch or process SFPD incidents" ; exit 1; }
cp ./incidents/config.json /release/incidents.json || { echo "Failed to copy SFPD incidents configuration into release directory" ; exit 2; }
cp ./incidents/image.png /release/incidents.png || { echo "Failed to copy SFPD incidents preview image into release directory" ; exit 3; }

echo "Building map metadata"
INCIDENTS_RECORDS_LENGTH=$(jq ".features | length" < /release/incidents.geojson)
jq --null-input \
    --argjson incidents $INCIDENTS_RECORDS_LENGTH \
    --arg baseurl $1 \
    --from-file maps.jq \
    > /release/maps.json || { echo "Failed to build root maps metadata configuration" ; exit 4; }
