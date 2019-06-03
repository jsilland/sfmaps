#!/usr/bin/env sh

set -e

mkdir -p /data/sources/incidents

curl -SL https://data.sfgov.org/api/views/wg3w-h783/rows.csv\?accessType\=DOWNLOAD -o /data/sources/incidents/raw.csv

mlr --icsv --ojson --jlistwrap filter 'is_not_null($Latitude) && is_not_null($Longitude)' then \
    cut -f 'Incident Datetime,Incident Category,Incident Subcategory,Latitude,Longitude' /data/sources/incidents/raw.csv \
    > /data/sources/incidents/filtered.csv

jq 'map(."Incident Datetime" = ."Incident Datetime"[0:4]+"-"+."Incident Datetime"[5:7]+"-"+."Incident Datetime"[8:10]+"T"+(if ."Incident Datetime"[-2:] == "AM" then ."Incident Datetime"[11:13] else (((."Incident Datetime"[11:13] | tonumber) % 12) + 12 | tostring) end)+":"+."Incident Datetime"[14:16]+":00") | map({type: "Feature", geometry: {type: "Point", coordinates: [.Longitude, .Latitude]}, properties: {lat: .Latitude, lng: .Longitude, category: ."Incident Category", subcategory: ."Incident Subcategory", datetime: ."Incident Datetime"}}) | sort_by(.properties.datetime) | {type: "FeatureCollection", features: .}' \
    < /data/sources/incidents/filtered.csv
