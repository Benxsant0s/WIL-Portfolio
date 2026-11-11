#!/usr/bin/env bash
# Starts the AI Donation Tracker with PHP's built-in server (no Docker needed).
cd "$(dirname "$0")"

if ! command -v php >/dev/null 2>&1; then
    echo "PHP is not installed."
    echo "  Mac:           brew install php"
    echo "  Ubuntu/Debian: sudo apt install php-cli php-sqlite3 php-curl"
    echo "  Fedora:        sudo dnf install php-cli php-pdo"
    exit 1
fi
if ! php -m | grep -qi pdo_sqlite; then
    echo "PHP is installed but the SQLite extension is missing."
    echo "  Ubuntu/Debian: sudo apt install php-sqlite3"
    exit 1
fi

echo "Starting... open http://localhost:8000 in your browser. Press Ctrl+C to stop."
php -S localhost:8000 router.php
