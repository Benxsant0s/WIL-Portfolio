@echo off
REM Starts the AI Donation Tracker with PHP's built-in server (no Docker needed).
cd /d "%~dp0"

where php >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo PHP was not found. Please follow "Step 1" in README.md to install it,
    echo then run this file again.
    pause
    exit /b 1
)

php -m | findstr /i "pdo_sqlite" >nul
if %ERRORLEVEL% NEQ 0 (
    echo PHP is installed but the SQLite extension is switched off.
    echo Open php.ini and remove the semicolon before these lines:
    echo     extension=pdo_sqlite
    echo     extension=sqlite3
    echo     extension=curl
    echo See "Step 2" in README.md.
    pause
    exit /b 1
)

echo Starting... open http://localhost:8000 in your browser.
echo Keep this window open. Press Ctrl+C to stop.
start "" http://localhost:8000
php -S localhost:8000 router.php
pause
