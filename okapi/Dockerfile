FROM php:8.2-apache
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev libicu-dev libcurl4-openssl-dev libxml2-dev \
    && docker-php-ext-install -j$(nproc) pdo_mysql intl zip curl soap \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*
RUN echo '<VirtualHost *:80>' > /etc/apache2/sites-available/000-default.conf \
    && echo '  DocumentRoot /var/www/html/okapi' >> /etc/apache2/sites-available/000-default.conf \
    && echo '  <Directory /var/www/html/okapi>' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf \
    && echo '  </Directory>' >> /etc/apache2/sites-available/000-default.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
