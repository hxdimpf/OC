#!/bin/bash
cd /var/www/html/htdocs
[ -f app/config/parameters.yml ] || cp app/config/parameters.yml.dist app/config/parameters.yml
[ -f config2/settings.inc.php ] || cp config2/settings-sample-dev.inc.php config2/settings.inc.php
composer install --no-interaction --no-dev --optimize-autoloader 2>/dev/null || true
apache2-foreground
