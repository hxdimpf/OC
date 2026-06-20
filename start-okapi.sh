#!/bin/bash
set -e
cd /var/www/html/okapi
if ! php -m | grep -q intl; then
  apt-get update -qq
  apt-get install -y -qq libicu-dev libzip-dev libxml2-dev
  docker-php-ext-install -j$(nproc) pdo_mysql intl zip
  apt-get clean
fi
composer install --no-interaction --no-dev --optimize-autoloader 2>/dev/null || true
a2enmod rewrite
exec apache2-foreground
