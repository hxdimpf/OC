FROM php:8.4-apache
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfreetype-dev libjpeg-dev libpng-dev libwebp-dev \
    libxpm-dev libzip-dev libicu-dev libldap2-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql intl zip bcmath soap ldap \
    && pecl install apcu redis imagick \
    && docker-php-ext-enable apcu redis imagick \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*
RUN echo '<VirtualHost *:80>' > /etc/apache2/sites-available/000-default.conf \
    && echo '  DocumentRoot /var/www/html/public' >> /etc/apache2/sites-available/000-default.conf \
    && echo '  <Directory /var/www/html/public>' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf \
    && echo '  </Directory>' >> /etc/apache2/sites-available/000-default.conf \
    && echo '  RewriteEngine On' >> /etc/apache2/sites-available/000-default.conf \
    && echo '  RewriteCond %{REQUEST_FILENAME} !-f' >> /etc/apache2/sites-available/000-default.conf \
    && echo '  RewriteRule ^(.*)$ /index.php [QSA,L]' >> /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
WORKDIR /var/www/html
CMD ["/entrypoint.sh"]
