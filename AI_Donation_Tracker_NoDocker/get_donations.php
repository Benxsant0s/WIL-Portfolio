<?php
require __DIR__ . '/config.php';

$rows = $pdo->query('SELECT id, donor_name, amount, purpose, cardano_tx_id, created_at FROM donations ORDER BY id DESC LIMIT 1000')
            ->fetchAll(PDO::FETCH_ASSOC);

$total = 0; $largest = 0; $byPurpose = array_fill_keys(PURPOSES, 0);
foreach ($rows as &$r) {
    $r['amount'] = (float)$r['amount'];
    $total += $r['amount'];
    $largest = max($largest, $r['amount']);
    $byPurpose[$r['purpose']] = ($byPurpose[$r['purpose']] ?? 0) + $r['amount'];
}
unset($r);
$count = count($rows);

json_out([
    'donations' => $rows,
    'total'     => round($total, 2),
    'count'     => $count,
    'average'   => $count ? round($total / $count, 2) : 0,
    'largest'   => $largest,
    'byPurpose' => $byPurpose,
]);
