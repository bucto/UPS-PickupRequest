#!/bin/bash
# ==============================================================================
# Function: post_return_request_json
# Description: Sends the pickup request JSON to the UPS API.
# ==============================================================================

post_return_request_json() {
  echo "Sending pickup request for job $x..."

  TEMP_JSON_PICKUPRESULT="$WORK_FOLDER/JSON_RESPONSE/$x.json"

  curl -s -X POST "$UPS_PICKUP_URL" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -d @"$TEMP_JSON_PICKUPREQUEST" \
    > "$TEMP_JSON_PICKUPRESULT"

  echo "UPS response saved: $TEMP_JSON_PICKUPRESULT"
}


