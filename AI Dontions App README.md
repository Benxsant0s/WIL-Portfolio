# AI Donation Tracker 11 SEPTEMBER 2026

A small web app for recording and tracking charity donations. It includes an AI assistant that answers questions about the donation data, and a checker for Cardano transaction IDs.

It is built to be portable: no database server, no manual setup, and with Docker you do not even need PHP installed.

## Features

* **Donation form**: donor name, amount (R) and purpose (Food, Education, Health, Shelter, Other).
* **Live summary**: total donated and a table of recent donations, loaded from the database.
* **AI assistant**: ask about totals, counts, averages, the largest donation, or a breakdown by purpose.
* **Cardano checker**: validates a transaction ID and can optionally look it up on-chain.

## Tech stack

* Frontend: HTML, CSS, vanilla JavaScript (`fetch`)
* Backend: PHP 8+
* Database: SQLite (a single file, created automatically)
* Optional: Docker, Claude API, Blockfrost API

## Quick start

### Option 1: Docker (recommended, no PHP needed)

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
2. In the project folder run:

```
   docker compose up --build
   ```

3. Open **http://localhost:8000/website.html**

Or double-click `start.sh` (Mac/Linux) or `start.bat` (Windows). They use Docker if it is available and fall back to local PHP.

Stop with `Ctrl+C` or `docker compose down`.

### Option 2: Local PHP

1. Install PHP 8 or later:

   * Windows: [XAMPP](https://www.apachefriends.org/) or https://windows.php.net/download/
   * Mac: `brew install php`
   * Debian/Ubuntu: `sudo apt install php php-sqlite3 php-curl`
2. Check SQLite support: `php -m | grep -i sqlite` (should list `pdo\\\_sqlite`).
3. From the project folder run:

```
   php -S localhost:8000
   ```

4. Open **http://localhost:8000/website.html**

No database setup is needed. `data/donations.db` is created on first use.

## Using the app

1. **Add a donation**: fill in the name, amount and purpose, then press *Save Donation*.
2. The **summary and table** update automatically.
3. **AI assistant**: type a question such as "How much has been donated?" and press *Ask AI*.
4. **Cardano**: paste a 64-character transaction ID and press *Verify Transaction*.

## Optional configuration

Everything works without API keys. To upgrade the two smart features, set environment variables:

|Variable|Effect|
|-|-|
|`ANTHROPIC\\\_API\\\_KEY`|AI assistant uses the Claude API instead of built-in rules|
|`BLOCKFROST\\\_API\\\_KEY`|Cardano checker looks the transaction up on-chain (free key at blockfrost.io)|

With Docker, put them in a `.env` file next to `docker-compose.yml`:

```
ANTHROPIC\\\_API\\\_KEY=your-key-here
BLOCKFROST\\\_API\\\_KEY=your-key-here
```

Without Docker, set them in your terminal before running `php -S localhost:8000`.

## API endpoints

|File|Method|Purpose|
|-|-|-|
|`save\\\_donation.php`|POST (form data)|Save a donation|
|`get\\\_donations.php`|GET|Return all donations and the total as JSON|
|`ai\\\_assistant.php`|POST (JSON `question`)|Answer a question about the data|
|`verify\\\_transaction.php`|POST (JSON `transactionId`)|Check a Cardano transaction ID|

## Project structure

```
website.html            main page
style.css               styling
app.js                  frontend logic
index.html              redirects to website.html
config.php              database connection, creates the table automatically
save\\\_donation.php       add a donation
get\\\_donations.php       list donations and total
ai\\\_assistant.php        AI assistant endpoint
verify\\\_transaction.php  Cardano checker endpoint
data/                   SQLite database lives here
Dockerfile              PHP with the required extensions
docker-compose.yml      one-command Docker setup
start.sh / start.bat    convenience launch scripts
```

## Troubleshooting

* **"Error connecting to the server"**: the PHP server is not running, or `website.html` was opened directly from the file system. Always use `http://localhost:8000/website.html`.
* **Port 8000 already in use**: use another port, e.g. `php -S localhost:8080`, or change the port mapping in `docker-compose.yml`.
* **"could not find driver"**: enable `pdo\\\_sqlite` in `php.ini` (uncomment `extension=pdo\\\_sqlite`) or use the Docker option.
* **Cannot write to database**: make sure the `data/` folder is writable.
* **Reset all data**: stop the app and delete `data/donations.db`.

