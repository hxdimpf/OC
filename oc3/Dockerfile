FROM php:8.2-apache
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libwebp-dev \
    libxpm-dev libzip-dev libicu-dev libldap2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql intl zip bcmath soap ldap \
    && pecl install apcu redis imagick \
    && docker-php-ext-enable apcu redis imagick \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*
RUN { \
    echo '<VirtualHost *:80>'; \
    echo '  DocumentRoot /var/www/html/htdocs'; \
    echo '  <Directory /var/www/html/htdocs>'; \
    echo '    AllowOverride All'; \
    echo '    Require all granted'; \
    echo '  </Directory>'; \
    echo '  ErrorLog /dev/stderr'; \
    echo '  CustomLog /dev/stdout combined'; \
    echo '</VirtualHost>'; \
    } > /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /var/www/html/htdocs
CMD ["/entrypoint.sh"]
