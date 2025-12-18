<?php
// 1. Pfad zur zentralen Config-Datei (liegt einen Ordner höher)
$config_path = __DIR__ . '/../config/db.ini';

// 2. Prüfen, ob die Config existiert
if (!file_exists($config_path)) {
    die("Fehler: Konfigurationsdatei db.ini wurde nicht gefunden.");
}

// 3. INI-Datei einlesen
$db_settings = parse_ini_file($config_path);

// 4. Verbindung zur Datenbank aufbauen
$conn = new mysqli(
    $db_settings['host'], 
    $db_settings['user'], 
    $db_settings['pass'], 
    $db_settings['name']
);

// Verbindung prüfen
if ($conn->connect_error) {
    die("Verbindung fehlgeschlagen: " . $conn->connect_error);
}

// 5. Abfrage der ersten 5 Einträge
$sql = "SELECT description FROM UPS_ErrorCodes LIMIT 5";
$result = $conn->query($sql);

?>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>UPS Error Codes</title>
    <style>
        body { font-family: sans-serif; margin: 20px; }
        ul { background: #f4f4f4; padding: 20px; border-radius: 5px; }
        li { margin-bottom: 10px; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
    </style>
</head>
<body>
    <h1>Erste 5 UPS Error Codes</h1>

    <?php if ($result->num_rows > 0): ?>
        <ul>
            <?php while($row = $result->fetch_assoc()): ?>
                <li><?php echo htmlspecialchars($row["description"]); ?></li>
            <?php endwhile; ?>
        </ul>
    <?php else: ?>
        <p>Keine Einträge gefunden.</p>
    <?php endif; ?>

    <?php $conn->close(); ?>
</body>
</html>