#!/bin/bash
set -e
cd /var/www/html
if ! php -m | grep -q intl; then
  apt-get update -qq
  apt-get install -y -qq libicu-dev libzip-dev libxml2-dev libcurl4-openssl-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev libxpm-dev
  docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm
  docker-php-ext-install -j$(nproc) gd pdo_mysql intl zip bcmath soap
  pecl install apcu
  docker-php-ext-enable apcu
  apt-get clean
fi
composer install --no-interaction --no-dev --optimize-autoloader
php bin/console doctrine:migrations:migrate -n --allow-no-migration || true
php bin/console cache:clear || true
a2enmod rewrite
exec apache2-foreground
