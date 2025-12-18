#!/bin/bash
# ==============================================================================
# Function: get_data 
# Description: Loads all job-related values from the MySQL database into variables.
# ==============================================================================

get_data() {
  echo "Reading data for Job ID: $x"

  local query_fields=(
    "company"
    "lastname"
    "gender_Text"
    "address"
    "postcode"
    "city"
    "country"
    "phone"
    "email"
    "close_time_ups"
    "ready_time_ups"
    "pickup_date_ups"
    "tracking_number_1"
    "tracking_number_2"
    "tracking_number_3"
    "tracking_number_4"
  )

  for field in "${query_fields[@]}"; do
    echo "SELECT \`${field}\` FROM \`tx_ups_retoure_job\` WHERE \`uid\` = $x;" > "$TEMP_SQLJOB"
    value=$(mysql --skip-column-names -u"$SQL_DB_USERNAME" -p"$SQL_DB_PASSWORD" -h"$SQL_DB_HOSTNAME" "$SQL_DB_DATABASE" < "$TEMP_SQLJOB")
    eval "${field^^}=\"\$value\""
  done
}


