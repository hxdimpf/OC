#!/bin/bash
cd /var/www/html
composer install --no-interaction --no-dev --optimize-autoloader
php bin/console doctrine:migrations:migrate -n --allow-no-migration
php bin/console cache:clear
apache2-foreground
