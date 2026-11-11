<?php
/**
 * verify_transaction.php
 *
 * Checks a Cardano transaction ID.
 *
 * With no configuration at all, it validates that the ID is correctly
 * formatted (a Cardano tx hash is 64 hex characters) so the feature works
 * immediately with zero setup.
 *
 * If you set a BLOCKFROST_API_KEY environment variable (a free key from
 * https://blockfrost.io), it will look the transaction up on-chain for a
 * real yes/no answer - see README.md.
 */

require __DIR__ . '/config.php';
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'error', 'message' => 'Only POST requests are allowed.']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);
$txId  = trim(is_array($input) ? ($input['transactionId'] ?? '') : '');

if ($txId === '') {
    echo json_encode(['status' => 'error', 'message' => 'Please enter a transaction ID.']);
    exit;
}

$isWellFormed = (bool) preg_match('/^[a-fA-F0-9]{64}$/', $txId);

if (!$isWellFormed) {
    echo json_encode([
        'status'  => 'invalid',
        'message' => 'That does not look like a valid Cardano transaction ID (should be 64 hex characters).',
    ]);
    exit;
}

$blockfrostKey = getenv('BLOCKFROST_API_KEY');
if ($blockfrostKey) {
    $ch = curl_init("https://cardano-mainnet.blockfrost.io/api/v0/txs/{$txId}");
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 15,
        CURLOPT_HTTPHEADER     => ["project_id: {$blockfrostKey}"],
    ]);
    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($httpCode === 200) {
        echo json_encode(['status' => 'confirmed', 'message' => 'Transaction found on-chain.']);
        exit;
    }
    if ($httpCode === 404) {
        echo json_encode(['status' => 'not_found', 'message' => 'No transaction with that ID was found on-chain.']);
        exit;
    }
    // any other error falls through to the format-only response below
}

echo json_encode([
    'status'  => 'format_ok',
    'message' => 'The ID is correctly formatted. On-chain verification is not configured - see README.md to enable it.',
]);
