<?php
require_once 'lang.php';

// Datenbank Konfiguration
$config_path = '/usr/home/returv/config/db.ini';
$db_settings = parse_ini_file($config_path);

// Sprache: 0=EN, 1=DE, 2=NL
$L = isset($_GET['L']) ? (int)$_GET['L'] : 0; 
$txt = $langs[$L] ?? $langs[0];

$conn = new mysqli($db_settings['host'], $db_settings['user'], $db_settings['pass'], $db_settings['name']);
if ($conn->connect_error) { die("DB Connection failed"); }

$success_msg = "";

// Formularverarbeitung
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $secureKey = bin2hex(random_bytes(16));
    $sql = "INSERT INTO tx_ups_retoure_job (
                company, lastname, address, postcode, city, country, gender, email, phone, 
                pickup_date, ready_time, close_time, 
                tracking_number_1, tracking_number_2, tracking_number_3, tracking_number_4, 
                return_reason, secure, tstamp, crdate
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, UNIX_TIMESTAMP(), UNIX_TIMESTAMP())";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssssssssssssssss", 
        $_POST['company'], $_POST['lastname'], $_POST['address'], $_POST['postcode'], 
        $_POST['city'], $_POST['countryselection'], $_POST['gender'], $_POST['email'], $_POST['phone'], 
        $_POST['pickup_date'], $_POST['ready_time'], $_POST['close_time'], 
        $_POST['tn1'], $_POST['tn2'], $_POST['tn3'], $_POST['tn4'], 
        $_POST['return_reason'], $secureKey
    );
    if ($stmt->execute()) { $success_msg = $txt['success']; }
    $stmt->close();
}

// Vorausfüllung aus DB
$pre = array_fill_keys(['company','lastname','address','postcode','city','email','phone','country', 'gender'], '');
if (isset($_GET['jobID'], $_GET['secureKEY'])) {
    $stmt = $conn->prepare("SELECT company, lastname, address, postcode, city, email, phone, country, gender FROM tx_ups_retoure_job WHERE uid = ? AND secure = ?");
    $stmt->bind_param("is", $_GET['jobID'], $_GET['secureKEY']);
    $stmt->execute();
    $res = $stmt->get_result();
    if ($row = $res->fetch_assoc()) { $pre = $row; }
    $stmt->close();
}

function renderTimeOptions() {
    for ($h = 8; $h <= 18; $h++) {
        foreach (['00', '30'] as $m) {
            $time = sprintf('%02d:%s', $h, $m);
            echo "<option value='$time'>$time Uhr</option>";
        }
    }
}
?>
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AMADA UPS Return Service</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <style>
        :root { --amada-red: #da291c; --amada-grey: #333; --amada-light: #f4f4f4; }
        body { font-family: "Helvetica Neue", Arial, sans-serif; background: var(--amada-light); margin: 0; padding: 10px; color: #000; }
        .form-card { background: white; max-width: 650px; margin: 10px auto; border-radius: 4px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); border-top: 5px solid var(--amada-red); overflow: hidden;}
        .logo-area { display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid #eee; background: #fff; }
        .logo-area img.amada { height: 40px; }
        .logo-area img.ups { height: 50px; }
        .info-box { padding: 25px; border-bottom: 1px solid #eee; background: #fff; font-size: 0.9rem; line-height: 1.6; }
        .info-box h3 { color: var(--amada-red); margin-top: 0; text-transform: uppercase; font-size: 1rem; }
        .instruction-list { list-style: none; padding: 0; margin: 15px 0; }
        .weight-warning { background: #fff3f3; border: 1px solid var(--amada-red); padding: 12px; margin: 15px 0; font-weight: bold; text-align: center; }
        .header-bar { background: var(--amada-grey); color: white; padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; }
        .lang-switch a { color: white; text-decoration: none; margin-left: 10px; font-size: 0.75rem; border: 1px solid #555; padding: 4px 8px; border-radius: 4px; }
        .active-lang { background: var(--amada-red); border-color: var(--amada-red) !important; }
        .content { padding: 25px; }
        .row { display: flex; gap: 15px; margin-bottom: 15px; flex-wrap: wrap; }
        .col { flex: 1; min-width: 200px; }
        .full-width { flex: 0 0 100%; }
        label { display: block; font-size: 0.75rem; font-weight: bold; margin-bottom: 5px; text-transform: uppercase; color: #555; }
        input, select { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 0; font-size: 1rem; box-sizing: border-box; }
        .radio-group { display: flex; gap: 20px; margin-top: 5px; }
        .radio-group label { font-weight: normal; text-transform: none; display: flex; align-items: center; cursor: pointer; font-size: 0.95rem; }
        .radio-group input { width: auto; margin-right: 8px; accent-color: var(--amada-red); }
        .tn-area { background: #fafafa; padding: 15px; border: 1px solid #eee; margin-top: 20px; }
        button { width: 100%; background: #000; color: white; border: none; padding: 18px; font-size: 1.1rem; font-weight: bold; cursor: pointer; text-transform: uppercase; transition: 0.2s; }
        button:hover { background: var(--amada-red); }
        .success-banner { background: #d4edda; color: #155724; padding: 15px; text-align: center; margin-bottom: 20px; font-weight: bold; }
        .footer-legal { background: #fafafa; padding: 15px; border-top: 1px solid #eee; text-align: center; font-size: 0.75rem; }
        .footer-legal a { color: #888; text-decoration: none; margin: 0 10px; }
    </style>
</head>
<body>

<div class="form-card">
    <div class="logo-area">
        <img src="/images/amada_logo.png" alt="AMADA" class="amada">
        <img src="/images/ups_logo.jpg" alt="UPS" class="ups">
    </div>

    <div class="info-box">
        <h3><?php echo $txt['info_title']; ?></h3>
        <ul class="instruction-list">
            <li style="margin-bottom:10px;"><?php echo $txt['step_1']; ?></li>
            <li><strong><?php echo $txt['step_2']; ?></strong></li>
        </ul>
        <p style="font-size: 0.85rem; color: #555;"><?php echo $txt['shipping_note']; ?></p>
        <div class="weight-warning">
            <?php echo $txt['weight_limit']; ?><br>
            <small style="font-weight:normal;"><?php echo $txt['volume_calc']; ?></small>
        </div>
        <p style="color: var(--amada-red); font-weight: bold; text-align: center; font-size: 0.85rem;"><?php echo $txt['contact_note']; ?></p>
    </div>

    <div class="header-bar">
        <span><?php echo $txt['title']; ?></span>
        <div class="lang-switch">
            <?php 
                $p = isset($_GET['jobID']) ? "&jobID=".$_GET['jobID']."&secureKEY=".$_GET['secureKEY'] : "";
                echo "<a href='?L=0$p' class='".($L==0?'active-lang':'')."'>EN</a>";
                echo "<a href='?L=1$p' class='".($L==1?'active-lang':'')."'>DE</a>";
                echo "<a href='?L=2$p' class='".($L==2?'active-lang':'')."'>NL</a>";
            ?>
        </div>
    </div>

    <div class="content">
        <?php if($success_msg) echo "<div class='success-banner'>$success_msg</div>"; ?>

        <form method="post">
            <div class="row">
                <div class="col full-width">
                    <label><?php echo $txt['reason']; ?> *</label>
                    <select name="return_reason" required>
                        <option value="">---</option>
                        <?php foreach($txt['reasons'] as $val => $display) echo "<option value='$val'>$display</option>"; ?>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col full-width"><label><?php echo $txt['company']; ?> *</label><input type="text" name="company" value="<?php echo htmlspecialchars($pre['company']); ?>" required></div>
            </div>

            <div class="row">
                <div class="col full-width">
                    <label><?php echo $txt['gender_mr']; ?> / <?php echo $txt['gender_mrs']; ?> *</label>
                    <div class="radio-group">
                        <label><input type="radio" name="gender" value="mr" <?php echo ($pre['gender']=='mr'?'checked':''); ?> required> <?php echo $txt['gender_mr']; ?></label>
                        <label><input type="radio" name="gender" value="mrs" <?php echo ($pre['gender']=='mrs'?'checked':''); ?>> <?php echo $txt['gender_mrs']; ?></label>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col"><label><?php echo $txt['lastname']; ?> *</label><input type="text" name="lastname" value="<?php echo htmlspecialchars($pre['lastname']); ?>" required></div>
                <div class="col">
                    <label><?php echo $txt['country']; ?> *</label>
                    <select name="countryselection" required>
                        <option value="">---</option>
                        <?php foreach($txt['countries'] as $code => $name) { $s = ($pre['country'] == $code) ? 'selected' : ''; echo "<option value='$code' $s>$name</option>"; } ?>
                    </select>
                </div>
            </div>

            <div class="row"><div class="col full-width"><label><?php echo $txt['address']; ?> *</label><input type="text" name="address" value="<?php echo htmlspecialchars($pre['address']); ?>" required></div></div>

            <div class="row">
                <div class="col"><label><?php echo $txt['postcode']; ?> *</label><input type="text" name="postcode" value="<?php echo htmlspecialchars($pre['postcode']); ?>" required></div>
                <div class="col"><label><?php echo $txt['city']; ?> *</label><input type="text" name="city" value="<?php echo htmlspecialchars($pre['city']); ?>" required></div>
            </div>

            <div class="row">
                <div class="col"><label><?php echo $txt['email']; ?> *</label><input type="email" name="email" value="<?php echo htmlspecialchars($pre['email']); ?>" required></div>
                <div class="col"><label><?php echo $txt['phone']; ?> *</label><input type="text" name="phone" value="<?php echo htmlspecialchars($pre['phone']); ?>" required></div>
            </div>

            <hr style="border:0; border-top:1px solid #eee; margin:25px 0;">

            <div class="row">
                <div class="col"><label><?php echo $txt['date']; ?> *</label><input type="text" id="pickup_date" name="pickup_date" required style="background: white;"></div>
            </div>
            <div class="row">
                <div class="col"><label><?php echo $txt['ready']; ?> *</label><select name="ready_time"><?php renderTimeOptions(); ?></select></div>
                <div class="col"><label><?php echo $txt['close']; ?> *</label><select name="close_time"><?php renderTimeOptions(); ?></select></div>
            </div>

            <div class="tn-area">
                <label>Trackingnummern (1Z...)</label>
                <input type="text" name="tn1" placeholder="Nr. 1 *" style="margin-bottom:10px" required>
                <input type="text" name="tn2" placeholder="Nr. 2" style="margin-bottom:10px">
                <input type="text" name="tn3" placeholder="Nr. 3" style="margin-bottom:10px">
                <input type="text" name="tn4" placeholder="Nr. 4">
            </div>

            <div class="row" style="margin-top: 20px;">
                <div class="col full-width" style="display: flex; align-items: flex-start; gap: 10px;">
                    <input type="checkbox" name="privacy_accept" id="privacy_accept" required style="width: 20px; height: 20px; accent-color: var(--amada-red);">
                    <label for="privacy_accept" style="font-weight: normal; text-transform: none; line-height: 1.4; color: #666; font-size: 0.85rem;"><?php echo $txt['privacy_notice']; ?></label>
                </div>
            </div>

            <button type="submit"><?php echo $txt['submit']; ?></button>
        </form>
    </div>

    <div class="footer-legal">
        <a href="https://www.amada.eu/de-de/impressum/" target="_blank"><?php echo $txt['legal_impressum']; ?></a> |
        <a href="https://www.amada.eu/de-de/datenschutz/" target="_blank"><?php echo $txt['legal_privacy']; ?></a> |
        <a href="https://www.amada.eu/de-de/allgemeine-geschaeftsbedingungen/" target="_blank"><?php echo $txt['legal_agb']; ?></a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>
    flatpickr("#pickup_date", {
        dateFormat: "Y-m-d",
        minDate: (new Date()).fp_incr(3),
        disable: [ function(date) { return (date.getDay() === 0 || date.getDay() === 6); } ],
        locale: { firstDayOfWeek: 1 }
    });
</script>
</body>
</html>