map(
  ."Incident Datetime" =
    ."Incident Datetime"[0:4] + "-" +
    ."Incident Datetime"[5:7] + "-" +
    ."Incident Datetime"[8:10] +"T" +
    (
      if ."Incident Datetime"[-2:] == "AM" then
        ."Incident Datetime"[11:13]
      else
        (((."Incident Datetime"[11:13] | tonumber) % 12) + 12 | tostring)
      end
    ) + ":" +
    ."Incident Datetime"[14:16] + ":00"
  )
  |
  map(
    {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [.Longitude, .Latitude]
      },
      properties: {
        lat: .Latitude,
        lng: .Longitude,
        category: ."Incident Category",
        subcategory: ."Incident Subcategory",
        datetime: ."Incident Datetime"
      }
    }
  )
  |
  map(
    select(.properties.datetime | strptime("%Y-%m-%dT%H:%M:%S") | mktime > (now - 31557600))
  )
  |
  sort_by(.properties.datetime)
  |
  {
    type: "FeatureCollection",
    features: .
  }
