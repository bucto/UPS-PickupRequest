#!/bin/bash
# ==============================================================================
# UPS Pickup Request – Main Script
# Automates UPS returns using the UPS API
# Repository: https://github.com/bucto/UPS-Pickup-Anfrage/
# ==============================================================================

set -euo pipefail
IFS=$'\n\t'

PROJECT_FOLDER="$(cd "$(dirname "$0")" && pwd)"
PROJECT_NAME="UPS-Pickup-Anfrage"

echo "Projektpfad erkannt: $PROJECT_FOLDER"

# --- Load configuration ---
CONFIG_FILE="$PROJECT_FOLDER/Config/config.sh"
if [ -r "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "ERROR -> Config file not found at: $CONFIG_FILE"
    exit 1
fi

# --- Load functions ---
FUNCTIONS_DIR="$PROJECT_FOLDER/Functions"
if [ -d "$FUNCTIONS_DIR" ]; then
    for file in "$FUNCTIONS_DIR"/*.sh; do
        [ -e "$file" ] || continue
        echo "Loading function: $file"
        source "$file"
    done
else
    echo "ERROR -> Functions directory not found: $FUNCTIONS_DIR"
    exit 1
fi



# =============================== Main Job ===================================
echo "Starting UPS Pickup Job at $(date +%Y-%m-%d\ %H:%M:%S)" | tee -a "$LOG_FILE"

# Step 1: Optimize database
echo "Optimizing database..." | tee -a "$LOG_FILE"
mysql -u"$SQL_DB_USERNAME" -p"$SQL_DB_PASSWORD" -h"$SQL_DB_HOSTNAME" "$SQL_DB_DATABASE" < "$PROJECT_FOLDER/sql/00_Optimize.sql"

# Step 2: Load new jobs
echo "Loading new jobs..." | tee -a "$LOG_FILE"
JOB_LIST_FILE="$PROJECT_FOLDER/temp/job_list.txt"
mysql --skip-column-names -u"$SQL_DB_USERNAME" -p"$SQL_DB_PASSWORD" -h"$SQL_DB_HOSTNAME" "$SQL_DB_DATABASE" < "$PROJECT_FOLDER/sql/01_LoadNewJobs.sql" > "$TEMP_JOB_LIST"

readarray -t jobs < "$TEMP_JOB_LIST"

# Step 3: Process jobs
for job_id in "${jobs[@]}"; do
    echo "Processing job: $job_id" | tee -a "$LOG_FILE"

    # Load data from DB
    get_data "$job_id"

    # Create JSON for UPS API
    create_json "$job_id"

    # Get authentication token
    get_token

    # Post request to UPS API
    post_return_request_json

    # Optional delay to avoid rate limits
    sleep 2

    # Check response
    check_return_request_json
done

echo "UPS Pickup Job finished at $(date +%Y-%m-%d\ %H:%M:%S)" | tee -a "$LOG_FILE"

exit 0
