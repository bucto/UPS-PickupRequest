#!/bin/bash
# ==============================================================================
# Function: check_return_request_json
# Description: Evaluates the UPS API response and updates the database.
# ==============================================================================

check_return_request_json() {
  echo "Evaluating UPS response..."

  local STATUS
  STATUS=$(jq -r '.PickupCreationResponse.Response.ResponseStatus.Description' "$TEMP_JSON_PICKUPRESULT" 2>/dev/null)

  if [[ "$STATUS" == "Success" ]]; then
    PRN=$(jq -r '.PickupCreationResponse.PRN' "$TEMP_JSON_PICKUPRESULT")
    echo "Pickup request successful. PRN: $PRN"
    mysql -u"$SQL_DB_USERNAME" -p"$SQL_DB_PASSWORD" -h"$SQL_DB_HOSTNAME" "$SQL_DB_DATABASE" \
      -e "UPDATE tx_ups_retoure_job SET transfered='1', response_status='TRANSMIT', response_information='$PRN', error='0', error_description='' WHERE uid=$x;"
  else
    ERROR_MSG=$(jq -r '.response.errors[0].message // "Unknown error"' "$TEMP_JSON_PICKUPRESULT")
    echo "Pickup request failed: $ERROR_MSG"
    mysql -u"$SQL_DB_USERNAME" -p"$SQL_DB_PASSWORD" -h"$SQL_DB_HOSTNAME" "$SQL_DB_DATABASE" \
      -e "UPDATE tx_ups_retoure_job SET transfered='1', response_status='ERROR', error='1', response_information='$ERROR_MSG' WHERE uid=$x;"
  fi
}


