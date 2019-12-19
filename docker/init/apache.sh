#!/bin/bash

set -e

# Create directories if they don't exist.
mkdir -p -m 777 /var/www/html/storage \
  && mkdir -p -m 777 /var/www/html/storage/framework \
  && mkdir -p -m 777 /var/www/html/storage/framework/cache \
  && mkdir -p -m 777 /var/www/html/storage/framework/cache/data \
  && mkdir -p -m 777 /var/www/html/storage/framework/sessions \
  && mkdir -p -m 777 /var/www/html/storage/framework/testing \
  && mkdir -p -m 777 /var/www/html/storage/framework/views \
  && mkdir -p -m 777 /var/www/html/storage/app \
  && mkdir -p -m 777 /var/www/html/storage/app/public \
  && mkdir -p -m 777 /var/www/html/storage/views \
  && mkdir -p -m 777 /var/www/html/storage/logs \
  && chmod -R 777 /var/www/html/storage

chmod -R 777 /var/www/html/storage \
  && chmod -R 777 /var/www/html/bootstrap/cache

if [ ! -f .env ]; then
  echo 'Copy .env.example to .env'
  cp -p .env.example .env
fi

# Require other packages
if [ ! -e /var/www/html/vendor/almasaeed2010 ]; then
  composer require "almasaeed2010/adminlte=~3.0"
fi

echo 'Running composer install'
composer install

# Do this after composer install, because vendor must exist
if [ ! `grep "^APP_KEY=base64:.*=$" .env` ]; then
  echo 'Generate key'
  php artisan key:generate
fi

# AdminLTE config
if [ ! -L public/adminlte ]; then
 echo 'Creating adminlte symlink from vendor to public'
 ln -s /var/www/html/vendor/almasaeed2010/adminlte /var/www/html/public/adminlte
fi

# create symlink van storage naar public/storage, does nothing if it already exist
if [ ! -L public/storage ]; then
  echo 'Running artisan storage:link'
  php artisan storage:link
fi

#This can fail when mysql is not ready yet,
#that's why we specify restart: on-failure in docker-compose.yml.
echo 'Running artisan migrate'
php artisan migrate

exec apache2-foreground