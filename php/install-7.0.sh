#!/bin/bash
php_basedir=$(dirname $(readlink -f $0))
php_calldir=$(pwd)

cd "$php_basedir"

set -e

add-apt-repository -y ppa:ondrej/php
apt-get update

# php fpm
apt-get install -y \
    php7.0-cli php7.0-fpm php7.0-curl php7.0-gd php7.0-common php7.0-intl \
    php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-readline \
    php7.0-soap php7.0-xsl php7.0-zip php7.0-xdebug php7.0-dev php7.0-bcmath

cat >> /etc/php/7.0/mods-available/xdebug.ini <<-EOF
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.max_nesting_level=500
EOF

install -Dm644 files/custom.ini /etc/php/7.0/mods-available/custom.ini
install -Dm644 files/opcache_settings.ini /etc/php/7.0/mods-available/opcache_settings.ini

phpenmod mcrypt
phpenmod xdebug
phpenmod custom
phpenmod opcache_settings

# php-fpm as vagrant user and listen on tcp
sed -e 's/^user = .*/user = vagrant/' \
    -e 's/^group = .*/group = vagrant/' \
    -e 's/^listen.owner = .*/listen.owner = vagrant/' \
    -e 's/^listen.group = .*/listen.group = vagrant/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php/7.0/fpm/pool.d/www.conf

systemctl restart php7.0-fpm

# install composer
curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer
chmod +x /usr/local/bin/composer

# composer cronjob
install -Dm644 files/cron.composer /etc/cron.d/composer

cd "$php_calldir"
