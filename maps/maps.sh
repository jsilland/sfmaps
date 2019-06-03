#!/usr/bin/env sh

set -e

echo "Building map of police incidents"
./incidents/build.sh > /release/incidents.geojson

echo "Building map metadata"
INCIDENTS_RECORDS_LENGTH=$(jq ".features | length" < /release/incidents.geojson)
jq --null-input --argjson incidents $INCIDENTS_RECORDS_LENGTH --from-file maps.jq > /release/maps.json
