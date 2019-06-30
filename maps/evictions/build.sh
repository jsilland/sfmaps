#!/usr/bin/env sh

set -e

mkdir -p /data/sources/evictions

curl -SL https://data.sfgov.org/api/views/5cei-gny5/rows.csv\?accessType\=DOWNLOAD -o /data/sources/evictions/raw.csv

mlr --icsv --ojson --jlistwrap \
    filter 'is_not_null($Location)' then \
    cut -f 'Address,File Date,Location,Non Payment,Breach,Nuisance,Illegal Use,Failure to Sign Renewal,Access Denial,Unapproved Subtenant,Owner Move In,Demolition,Capital Improvement,Substantial Rehab,Ellis Act WithDrawal,Condo Conversion,Roommate Same Unit,Other Cause,Late Payments,Lead Remediation,Development,Good Samaritan Ends' \
    /data/sources/evictions/raw.csv \
    > /data/sources/evictions/processed.json

jq --compact-output --from-file evictions/filter.jq < /data/sources/evictions/processed.json
