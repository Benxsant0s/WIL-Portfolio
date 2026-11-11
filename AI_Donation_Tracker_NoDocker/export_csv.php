<?php
require __DIR__ . '/config.php';
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename="donations-' . date('Y-m-d') . '.csv"');

// Prefix cells starting with = + - @ to stop spreadsheet formula injection.
$safe = fn($v) => preg_match('/^[=+\-@\t\r]/', (string)$v) ? "'" . $v : $v;

$out = fopen('php://output', 'w');
fwrite($out, "\xEF\xBB\xBF"); // UTF-8 BOM so Excel reads it correctly
fputcsv($out, ['ID', 'Donor', 'Amount (R)', 'Purpose', 'Cardano TX', 'Date (UTC)']);
foreach ($pdo->query('SELECT * FROM donations ORDER BY id DESC') as $r) {
    fputcsv($out, [$r['id'], $safe($r['donor_name']), $r['amount'], $r['purpose'], $r['cardano_tx_id'], $r['created_at']]);
}
