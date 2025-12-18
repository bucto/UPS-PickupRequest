#!/bin/bash
# ==============================================================================
# Configuration File for UPS Pickup Request Automation
# Project: UPS-Pickup-Anfrage
# Description:
#   Central configuration file for logs, temporary files,
#   UPS API credentials, and endpoint URLs.
# ==============================================================================



# ================================ DB SETTINGS ================================

# --- Load Shared DB Settings ---
INI_FILE="$(dirname "$0")/../../config/db.ini"

if [ -f "$INI_FILE" ]; then
    # Werte extrahieren und in deine Variablen schreiben
    SQL_DB_USERNAME=$(grep "^user" "$INI_FILE" | cut -d'"' -f2)
    SQL_DB_PASSWORD=$(grep "^pass" "$INI_FILE" | cut -d'"' -f2)
    SQL_DB_HOSTNAME=$(grep "^host" "$INI_FILE" | cut -d'"' -f2)
    SQL_DB_DATABASE=$(grep "^name" "$INI_FILE" | cut -d'"' -f2)
else
    echo "ERROR -> db.ini not found"
    exit 1
fi

# ================================ UPS SETTINGS ================================

# UPS Account configuration
UPS_ACCOUNT="YOUR_UPS_ACCOUNT_NUMBER"       # e.g., "A1B2XX"
UPS_ACCOUNT_COUNTRY="DE"                    # e.g., "DE", "AT"

# UPS OAuth 2.0 Credentials (replace with your own)
UPS_CLIENT_ID="ENTER_YOUR_CLIENT_ID"
UPS_CLIENT_SECRET="ENTER_YOUR_CLIENT_SECRET"

# Token file for cached access tokens
UPS_TOKEN_FILE="$TEMP_FOLDER/ups_token.json"


# UPS OAuth token endpoint (production)
UPS_TOKEN_URL="https://onlinetools.ups.com/security/v1/oauth/token"

# UPS Pickup Creation endpoint (production)
UPS_PICKUP_URL="https://onlinetools.ups.com/api/pickupcreation/v1/pickups"



# ================================ PATHS =======================================

# Base project directory (must be defined in the main script)
: "${PROJECT_FOLDER:?PROJECT_FOLDER not defined!}"

# Logging directories
LOG_FOLDER="$PROJECT_FOLDER/logs"
mkdir -p "$LOG_FOLDER"

LOG_JOB="$LOG_FOLDER/job.log"
LOG_TEMP="$LOG_FOLDER/job_temp.log"
LOG_ERROR="$LOG_FOLDER/job_error.log"

# Temporary folder
TEMP_FOLDER="$PROJECT_FOLDER/temp"
mkdir -p "$TEMP_FOLDER"

# Temporary files
TEMP_JOB_LIST="$TEMP_FOLDER/job_list.txt"
TEMP_SQLJOB="$TEMP_FOLDER/temp_sqljob.sql"
TEMP_VALUE="$TEMP_FOLDER/temp_value.txt"

# JSON files
JSON_PICKUP_REQUEST="$TEMP_FOLDER/pickup_request.json"
JSON_PICKUP_RESULT="$TEMP_FOLDER/pickup_result.json"

# XML files (legacy support)
XML_PICKUP_REQUEST="$TEMP_FOLDER/pickup_request.xml"
XML_PICKUP_RESULT="$TEMP_FOLDER/pickup_result.xml"





# ================================ LOGGING =====================================

# Simple logging helper
log() {
    local level="$1"
    local message="$2"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_JOB"
}

log "INFO" "Configuration loaded successfully."
