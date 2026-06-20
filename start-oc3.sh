#!/bin/bash
set -e
cd /var/www/html/htdocs
# Install PHP extensions on first run (idempotent check)
if ! php -m | grep -q intl; then
  apt-get update -qq
  apt-get install -y -qq libicu-dev libzip-dev libxml2-dev libcurl4-openssl-dev libldap2-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libxpm-dev
  docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm
  docker-php-ext-install -j$(nproc) gd pdo_mysql intl zip bcmath soap ldap
  pecl install apcu
  docker-php-ext-enable apcu
  apt-get clean
fi
[ -f app/config/parameters.yml ] || cp app/config/parameters.yml.dist app/config/parameters.yml
[ -f config2/settings.inc.php ] || cp config2/settings-sample-dev.inc.php config2/settings.inc.php
composer install --no-interaction --no-dev --optimize-autoloader 2>/dev/null || true
a2enmod rewrite
exec apache2-foreground
