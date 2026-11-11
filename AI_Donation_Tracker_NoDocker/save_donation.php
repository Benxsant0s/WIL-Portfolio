<?php
require __DIR__ . '/config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') json_out(['ok' => false, 'message' => 'Only POST requests are allowed.'], 405);

$name    = trim($_POST['donorName'] ?? '');
$amount  = $_POST['amount'] ?? '';
$purpose = trim($_POST['purpose'] ?? '');
$tx      = trim($_POST['cardanoTxId'] ?? '');

if ($name === '' || $amount === '' || $purpose === '') json_out(['ok' => false, 'message' => 'Please fill in all fields.'], 400);
if (strlen($name) > 200) json_out(['ok' => false, 'message' => 'Donor name is too long (max 200 bytes).'], 400);
if (!in_array($purpose, PURPOSES, true)) json_out(['ok' => false, 'message' => 'Invalid purpose.'], 400);
if (!is_numeric($amount) || !is_finite((float)$amount) || (float)$amount <= 0 || (float)$amount > MAX_AMOUNT)
    json_out(['ok' => false, 'message' => 'Amount must be a positive number up to R' . number_format(MAX_AMOUNT) . '.'], 400);
if ($tx !== '' && !preg_match('/^[a-fA-F0-9]{64}$/', $tx))
    json_out(['ok' => false, 'message' => 'Cardano transaction ID must be 64 hex characters.'], 400);

$pdo->prepare('INSERT INTO donations (donor_name, amount, purpose, cardano_tx_id) VALUES (?, ?, ?, ?)')
    ->execute([$name, round((float)$amount, 2), $purpose, $tx !== '' ? strtolower($tx) : null]);

json_out(['ok' => true, 'message' => 'Donation saved. Thank you, ' . $name . '!']);
