FROM php:7.2-apache-stretch

WORKDIR /var/www/html

COPY ./docker/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY ./docker/init/apache.sh /docker-init-apache.sh

RUN apt-get update && apt-get install -y libzip-dev zlib1g-dev unzip \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install pdo_mysql bcmath zip \
  && a2enmod rewrite \
  && apt-get clean && rm -r /var/lib/apt/lists/* \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
  && chmod +x /docker-init-apache.sh

ENTRYPOINT ["/docker-init-apache.sh"]