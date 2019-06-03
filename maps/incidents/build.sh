#!/usr/bin/env sh

set -e

mkdir -p /data/sources/incidents

curl -SL https://data.sfgov.org/api/views/wg3w-h783/rows.csv\?accessType\=DOWNLOAD -o /data/sources/incidents/raw.csv

mlr --icsv --ojson --jlistwrap filter 'is_not_null($Latitude) && is_not_null($Longitude)' then \
    cut -f 'Incident Datetime,Incident Category,Incident Subcategory,Latitude,Longitude' /data/sources/incidents/raw.csv \
    > /data/sources/incidents/filtered.json

jq --compact-output --from-file incidents/filter.jq < /data/sources/incidents/filtered.json
