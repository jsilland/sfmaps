[
  {
    "id": "incidents",
    "label": "Police Department Incident Reports",
    "queryType": "sample",
    "imageUrl": ($baseurl + "/incidents.png"),
    "description": "Location and categories of SFPD incident reports (limited to the past year)",
    "size": $incidents,
    "visible": true,
    "dataUrl": ($baseurl + "/incidents.geojson"),
    "configUrl": ($baseurl + "/incidents.json")
  },
  {
    "id": "evictions",
    "label": "Eviction notices filed with the San Francisco Rent Board",
    "queryType": "sample",
    "imageUrl": ($baseurl + "/evictions.png"),
    "description": "Eviction notices filed with the San Francisco Rent Board. A notice of eviction does not necessarily indicate that the tenant was eventually evicted.",
    "size": $evictions,
    "visible": true,
    "dataUrl": ($baseurl + "/evictions.geojson"),
    "configUrl": ($baseurl + "/evictions.json")
  }
]
