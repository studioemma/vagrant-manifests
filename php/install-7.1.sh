#!/bin/bash
php_basedir=$(dirname $(readlink -f $0))
php_calldir=$(pwd)

cd "$php_basedir"

set -e

add-apt-repository -y ppa:ondrej/php
apt-get update

##
# WARNING: mcrypt is deprecated must be checked if magento still needs it
##

# php fpm
apt-get install -y \
    php7.1-cli php7.1-fpm php7.1-curl php7.1-gd php7.1-common php7.1-intl \
    php7.1-json php7.1-mbstring php7.1-mcrypt php7.1-mysql php7.1-readline \
    php7.1-soap php7.1-xsl php7.1-zip php7.1-xdebug php7.1-dev php7.1-bcmath

cat >> /etc/php/7.1/mods-available/xdebug.ini <<-EOF
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.max_nesting_level=500
EOF

install -Dm644 files/custom.ini /etc/php/7.1/mods-available/custom.ini
install -Dm644 files/opcache_settings.ini /etc/php/7.0/mods-available/opcache_settings.ini

phpenmod mcrypt
phpenmod xdebug
phpenmod custom
phpenmod opcache_settings

# php-fpm as ubuntu user and listen on tcp
sed -e 's/^user = .*/user = ubuntu/' \
    -e 's/^group = .*/group = ubuntu/' \
    -e 's/^listen.owner = .*/listen.owner = ubuntu/' \
    -e 's/^listen.group = .*/listen.group = ubuntu/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php/7.1/fpm/pool.d/www.conf

systemctl restart php7.1-fpm

# install composer
curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer
chmod +x /usr/local/bin/composer

# composer cronjob
install -Dm644 files/cron.composer /etc/cron.d/composer

cd "$php_calldir"
