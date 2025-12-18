#!/bin/bash
# ==============================================================================
# Function: create_json
# Description: Creates the JSON payload for UPS Pickup Creation Request.
# ==============================================================================

create_json() {
  TEMP_JSON_PICKUPREQUEST="$PROJECT_FOLDER/JSON_REQUEST/$x.json"

  cat > "$TEMP_JSON_PICKUPREQUEST" <<EOF
{
  "PickupCreationRequest": {
    "RatePickupIndicator": "N",
    "Shipper": {
      "Account": {
        "AccountNumber": "$UPS_ACCOUNT",
        "AccountCountryCode": "$UPS_ACCOUNT_COUNTRY"
      }
    },
    "PickupDateInfo": {
      "CloseTime": "$CLOSETIME",
      "ReadyTime": "$READYTIME",
      "PickupDate": "$PICKUPDATE"
    },
    "PickupAddress": {
      "CompanyName": "$COMPANY",
      "ContactName": "$NAME",
      "AddressLine": "$ADRESS",
      "City": "$CITY",
      "PostalCode": "$ZIP",
      "CountryCode": "$COUNTRY",
      "Phone": { "Number": "$PHONE" }
    },
    "AlternateAddressIndicator": "N",
    "PickupPiece": [{
      "ServiceCode": "011",
      "Quantity": "1",
      "DestinationCountryCode": "$COUNTRY",
      "ContainerCode": "01"
    }],
    "TotalWeight": {
      "Weight": "1",
      "UnitOfMeasurement": "LBS"
    },
    "ReturnTrackingNumber": [
      "$TRACKINGNUMBER1", "$TRACKINGNUMBER2", "$TRACKINGNUMBER3", "$TRACKINGNUMBER4"
    ],
    "PaymentMethod": "01",
    "ServiceCategory": "03",
    "SpecialInstruction": "Created by UPS Automation Script",
    "ReferenceNumber": "Job $x",
    "Notification": {
      "ConfirmationEmailAddress": "$EMAIL",
      "UndeliverableEmailAddress": "$EMAIL"
    }
  }
}
EOF

  echo "JSON request created: $TEMP_JSON_PICKUPREQUEST"
}



