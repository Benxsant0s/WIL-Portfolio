<?php
// Router for PHP's built-in server: blocks the database and source/config files.
$path = rawurldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
if (preg_match('#^/(data/|\.)|\.(db|md|sh|bat|yml)$|^/(Dockerfile|router\.php|config\.php)$#i', $path)) {
    http_response_code(403);
    echo 'Forbidden';
    return true;
}
return false; // serve normally
