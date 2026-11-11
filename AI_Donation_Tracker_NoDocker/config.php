<?php
/**
 * config.php - shared SQLite connection + constants.
 * The database is a single file (data/donations.db), created automatically.
 */
const PURPOSES = ['Food', 'Education', 'Health', 'Shelter', 'Other'];
const MAX_AMOUNT = 10000000;

// Optional: load API keys from a .env file (see .env.example). Blocked from web access.
if (is_readable(__DIR__ . '/.env')) {
    foreach (file(__DIR__ . '/.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        if ($line[0] !== '#' && str_contains($line, '=')) putenv(trim($line));
    }
}

$dataDir = __DIR__ . '/data';
if (!is_dir($dataDir)) mkdir($dataDir, 0775, true);

function json_out(array $payload, int $code = 200): void {
    http_response_code($code);
    header('Content-Type: application/json');
    echo json_encode($payload, JSON_INVALID_UTF8_SUBSTITUTE);
    exit;
}

try {
    $pdo = new PDO('sqlite:' . $dataDir . '/donations.db');
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->exec("CREATE TABLE IF NOT EXISTS donations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        donor_name TEXT NOT NULL,
        amount REAL NOT NULL,
        purpose TEXT NOT NULL,
        cardano_tx_id TEXT,
        created_at TEXT NOT NULL DEFAULT (datetime('now'))
    )");
} catch (PDOException $e) {
    json_out(['error' => 'Database connection failed.'], 500);
}
