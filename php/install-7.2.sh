#!/bin/bash
php_basedir=$(dirname $(readlink -f $0))
php_calldir=$(pwd)

cd "$php_basedir"

set -e

add-apt-repository -y ppa:ondrej/php
apt-get update

# php fpm
apt-get install -y \
    php7.2-cli php7.2-fpm php7.2-curl php7.2-gd php7.2-common php7.2-intl \
    php7.2-json php7.2-mbstring php7.2-mysql php7.2-readline php-redis \
    php7.2-soap php-sodium php7.2-xsl php7.2-zip php7.2-xdebug php7.2-dev \
    php7.2-bcmath

cat >> /etc/php/7.2/mods-available/xdebug.ini <<-EOF
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.max_nesting_level=500
EOF

install -Dm644 files/custom.ini /etc/php/7.2/mods-available/custom.ini
install -Dm644 files/opcache_settings.ini /etc/php/7.2/mods-available/opcache_settings.ini

phpenmod xdebug
phpenmod custom
phpenmod opcache_settings

# php-fpm as vagrant user and listen on tcp
sed -e 's/^user = .*/user = vagrant/' \
    -e 's/^group = .*/group = vagrant/' \
    -e 's/^listen.owner = .*/listen.owner = vagrant/' \
    -e 's/^listen.group = .*/listen.group = vagrant/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php/7.2/fpm/pool.d/www.conf

systemctl restart php7.2-fpm

# install composer
curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer
chmod +x /usr/local/bin/composer

# composer cronjob
install -Dm644 files/cron.composer /etc/cron.d/composer

cd "$php_calldir"
