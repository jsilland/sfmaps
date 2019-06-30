map (
  {
    type: "Feature",
    geometry: {
      type: "Point",
      coordinates: (."Location" | ltrimstr("(") | rtrimstr(")") | split(",") | map(tonumber) | reverse)
    },
    properties: {
      address: .Address,
      date: (."File Date"[6:10] + "-" + ."File Date"[0:2] + "-" + ."File Date"[3:5] + "T00:00:00-08:00"),
      lat: ((."Location" | ltrimstr("(") | rtrimstr(")") | split(","))[0] | tonumber),
      lng: ((."Location" | ltrimstr("(") | rtrimstr(")") | split(","))[1] | tonumber),
      non_payment: ."Non Payment",
      breach: ."Breach",
      nuisance: ."Nuisance",
      illegal_use: ."Illegal Use",
      failure_to_sign_removal: ."Failure to Sign Renewal",
      access_denial: ."Access Denial",
      unapproved_subtenant: ."Unapproved Subtenant",
      owner_move_in: ."Owner Move In",
      demolition: ."Demolition",
      capital_improvement: ."Capital Improvement",
      substantial_rehab: ."Substantial Rehab",
      ellis_act_withdrawal: ."Ellis Act WithDrawal",
      condo_conversion: ."Condo Conversion",
      roommate_same_unit: ."Roommate Same Unit",
      other_cause: ."Other Cause",
      late_payments: ."Late Payments",
      lead_remediation: ."Lead Remediation",
      development: ."Development",
      good_samaritan_ends: ."Good Samaritan Ends"
    }
  }
)
|
sort_by(.properties.date)
|
{
  type: "FeatureCollection",
  features: .
}
