# UPS Return Service Portal

A comprehensive end-to-end solution for automating UPS pickup requests. This system integrates a customer-facing web portal with a robust Bash-based middleware to communicate with the UPS Shipping API.

## 📋 System Architecture

The project is divided into three logical layers:

1.  **Web-Frontend (PHP/JS):** A multilingual portal for customers to enter return shipment data.
2.  **Database (MySQL):** Central control unit and data storage for pickup jobs and UPS error mappings.
3.  **Backend Automation (Bash):** A modular framework that processes new jobs and transmits them to UPS via REST API.

## 📂 Project Structure

```text
├── database/
│   ├── ups_retoure_job.sql    # Table schema for pickup jobs
│   └── ups_error_codes.sql    # Catalog of UPS API error codes
├── public/
│   ├── images/                # Branding & partner logos
│   ├── lang.php               # Multi-language definitions (DE, EN, NL)
│   └── retoure.php            # Web portal for customer data entry
├── scripts/
│   ├── ups_pickup_job.sh      # Main automation script (Entry point)
│   ├── config/                # Configuration templates
│   │   └── config.sh.example  # Template for API & DB credentials
│   └── functions/             # Modular Bash logic
│       ├── check_return_request_json.sh
│       ├── create_json.sh
│       ├── get_data.sh
│       ├── get_token.sh
│       └── post_return_request_json.sh
├── temp/                      # Temporary JSON files and process logs
└── README.md

🚀 Key Features
Multilingual Support: Seamlessly supports German, English, and Dutch.

Dynamic Pre-filling: Customer links with jobID and secureKEY automatically populate the form.

Intelligent Validation: Calendar control with 3-day lead time and weekend blocking.

Modular Backend: Uses OAuth2 for authentication and handles JSON payloads for the UPS Pickup API.

Error Management: Automatically maps API responses to the local ups_error_codes table for fast diagnosis.

⚙️ Installation & Setup
1. Database
Import the SQL files from the /database folder into your MySQL database.

2. Web Portal
Place the db.ini (database credentials) securely outside the web root or in the scripts/config/ folder.

Configure your web server to point to the public/ directory.

3. Backend Automation
Navigate to scripts/config/ and copy config.sh.example to config.sh.

Enter your UPS API credentials (Client ID, Secret, Account Number).

Ensure jq (JSON processor) is installed on your system.

Set up a cron job for scripts/ups_pickup_job.sh.

🛡 Privacy & Security
The portal is designed to be GDPR (DSGVO) compliant:

No tracking cookies: Minimal data collection approach.

Consent workflow: Active acceptance of the privacy policy required.

Secure transmission: Uses Prepared Statements and verified parameter links.

Technologies: PHP, Bash, MySQL, UPS REST API