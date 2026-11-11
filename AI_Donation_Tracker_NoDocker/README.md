# AI Donation Tracker (no Docker version)

A web app for recording and tracking charity donations, with summary statistics, search and filtering, CSV export, an AI assistant and a Cardano transaction checker.

**Docker is not needed.** You only need PHP, which runs the app directly. There is no database server to install: the data is stored in one file (`data/donations.db`) that is created automatically.

## Setup

### Step 1: Install PHP (one time only)

**Windows**
1. Go to https://windows.php.net/download/ and download the latest **PHP 8.x, Thread Safe, x64 ZIP**.
2. Extract it to `C:\php`.
3. Add PHP to your PATH: press the Windows key, search **"Edit the system environment variables"**, click *Environment Variables*, select **Path**, click *Edit*, *New*, type `C:\php`, then OK on every window.
4. Close and reopen any Command Prompt, then check with: `php -v`

*(Easier alternative: install [XAMPP](https://www.apachefriends.org/) and see "Using XAMPP" below.)*

**Mac:** install [Homebrew](https://brew.sh), then run `brew install php`

**Ubuntu / Debian:** `sudo apt install php-cli php-sqlite3 php-curl`

### Step 2: Switch on the required extensions (Windows only)

1. In `C:\php`, copy `php.ini-development` and rename the copy to `php.ini`.
2. Open `php.ini` in Notepad and remove the `;` at the start of these lines:
   ```
   extension=pdo_sqlite
   extension=sqlite3
   extension=curl
   ```
3. Save the file.

Check it worked: `php -m` should list `pdo_sqlite`. (Mac and Linux users can skip this step.)

### Step 3: Run the app

- **Windows:** double-click **`start.bat`**. Your browser opens automatically.
- **Mac / Linux:** open a terminal in the project folder and run `./start.sh`, then open http://localhost:8000

Keep the window open while you use the app. Press `Ctrl+C` to stop it.

That's it. Add a donation to see it appear in the table.

## Using XAMPP instead (Windows)

1. Install XAMPP and start **Apache** in the XAMPP Control Panel.
2. Copy this project folder into `C:\xampp\htdocs\donations`.
3. Open http://localhost/donations/ in your browser.

The included `.htaccess` protects the database in this mode. If Apache ignores it, set `AllowOverride All` for `htdocs`. (Not tested on every XAMPP version, so run `start.bat` instead if you hit problems.)

## Using the app

1. **Add a donation:** name, amount (R), purpose, and an optional Cardano transaction ID.
2. **Stat cards and chart** update automatically.
3. **Search and filter** the table, or **Export CSV**.
4. **AI assistant:** click a suggested question or type your own.
5. **Verify transaction:** paste a 64-character Cardano ID and check it.
6. Use the ◐ button to switch between light and dark themes.

## Optional: smarter AI and on-chain checks

Everything works without keys. To upgrade the two smart features, copy `.env.example` to `.env` and add a key:

```
ANTHROPIC_API_KEY=your-key-here
BLOCKFROST_API_KEY=your-key-here
```

| Key | Effect |
|---|---|
| `ANTHROPIC_API_KEY` | AI assistant uses the Claude API instead of built-in rules |
| `BLOCKFROST_API_KEY` | Cardano checker looks up the transaction on-chain (free key at blockfrost.io) |

Restart the app after editing `.env`. Never share this file.

## Project structure

```
website.html / style.css / app.js   the user interface
index.html                          redirects to website.html
config.php                          database + .env loader
save_donation.php, get_donations.php, export_csv.php
ai_assistant.php, verify_transaction.php
router.php                          protects private files (used by start scripts)
.htaccess                           same protection for Apache/XAMPP
start.bat / start.sh                one-click launchers
data/                               SQLite database lives here
```

## Troubleshooting

| Problem | Fix |
|---|---|
| `'php' is not recognized` | Step 1 incomplete. Re-check the PATH entry and reopen the terminal |
| `could not find driver` | Step 2: enable `pdo_sqlite` in `php.ini` |
| Page says it cannot load donations | Open it via http://localhost:8000, not by double-clicking the HTML file |
| Port 8000 in use | Edit the port (8000) in `start.bat` / `start.sh`, e.g. to 8080 |
| Cannot write to database | Make sure the `data` folder is writable |
| Reset all data | Stop the app and delete `data/donations.db` |
