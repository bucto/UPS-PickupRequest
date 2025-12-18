# UPS Return Service Portal

Dieses System ist eine integrierte Lösung zur Automatisierung von UPS-Abholaufträgen. Es kombiniert ein kundenorientiertes Web-Portal mit einer robusten Bash-Middleware zur Kommunikation mit der UPS Shipping API.

## 📋 System-Architektur

Das Projekt ist in drei logische Ebenen unterteilt:

1.  **Web-Frontend (PHP/JS):** Erfassung der Retourendaten durch den Kunden.
2.  **Datenbank (MySQL):** Zentrale Steuerung und Datenspeicher für Aufträge und UPS-Fehlermeldungen.
3.  **Backend-Automation (Bash):** Ein modulares Framework, das neue Aufträge verarbeitet und an UPS übermittelt.

## 📂 Projektstruktur

```text
├── database/
│   ├── ups_retoure_job.sql    # Tabellenstruktur für Aufträge
│   └── ups_error_codes.sql    # Katalog der UPS-API Fehlermeldungen
├── public/
│   ├── images/                # Branding & Partner-Logos
│   ├── lang.php               # Multi-Language Definitionen (DE, EN, NL)
│   └── retoure.php            # Kunden-Portal zur Datenerfassung
├── scripts/
│   ├── ups_pickup_job.sh      # Haupt-Automatisierungsskript
│   ├── config/                # Konfigurations-Templates
│   │   └── config.sh.example  # Vorlage für API- & DB-Credentials
│   └── functions/             # Modulare Bash-Logik
│       ├── check_return_request_json.sh
│       ├── create_json.sh
│       ├── get_data.sh
│       ├── get_token.sh
│       └── post_return_request_json.sh
├── temp/                      # Temporäre JSON-Files und Prozess-Logs
└── README.md