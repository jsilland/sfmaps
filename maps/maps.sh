#!/usr/bin/env sh

set -e

echo "Building map of SFPD police incidents"
./incidents/build.sh > /release/incidents.geojson || { echo "Failed to fetch or process SFPD incidents" ; exit 1; }
cp ./incidents/config.json /release/incidents.json || { echo "Failed to copy SFPD incidents configuration into release directory" ; exit 2; }
cp ./incidents/image.png /release/incidents.png || { echo "Failed to copy SFPD incidents preview image into release directory" ; exit 3; }

echo "Building map of eviction notices"
./evictions/build.sh > /release/evictions.geojson || { echo "Failed to fetch or process eviction notices" ; exit 1; }
cp ./evictions/config.json /release/evictions.json || { echo "Failed to copy eviction notices configuration into release directory" ; exit 2; }
cp ./evictions/image.png /release/evictions.png || { echo "Failed to copy eviction notices preview image into release directory" ; exit 3; }

echo "Building map metadata"
INCIDENTS_RECORDS_LENGTH=$(jq ".features | length" < /release/incidents.geojson)
EVICTIONS_RECORDS_LENGTH=$(jq ".features | length" < /release/evictions.geojson)

jq --null-input \
    --argjson incidents $INCIDENTS_RECORDS_LENGTH \
    --argjson evictions $EVICTIONS_RECORDS_LENGTH \
    --arg baseurl $1 \
    --from-file maps.jq \
    > /release/maps.json || { echo "Failed to build root maps metadata configuration" ; exit 4; }
