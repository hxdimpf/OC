#!/bin/bash
cd /var/www/html/okapi
composer install --no-interaction --no-dev --optimize-autoloader 2>/dev/null || true
apache2-foreground
