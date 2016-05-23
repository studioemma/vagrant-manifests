#!/bin/bash
php_basedir=$(dirname $(readlink -f $0))
php_calldir=$(pwd)

cd "$php_basedir"

set -e

add-apt-repository -y ppa:ondrej/php
apt-get update

# php fpm
apt-get install -y \
    php5.6-cli php5.6-fpm php5.6-curl php5.6-gd php5.6-common php5.6-intl \
    php5.6-json php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-readline \
    php5.6-soap php5.6-xsl php5.6-zip php5.6-xdebug php5.6-dev

cat >> /etc/php/5.6/mods-available/xdebug.ini <<-EOF
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.max_nesting_level=400
EOF

install -Dm644 files/custom.ini /etc/php/5.6/mods-available/custom.ini

phpenmod mcrypt
phpenmod xdebug
phpenmod custom

# php-fpm as vagrant user and listen on tcp
sed -e 's/^user = .*/user = vagrant/' \
    -e 's/^group = .*/group = vagrant/' \
    -e 's/^listen.owner = .*/listen.owner = vagrant/' \
    -e 's/^listen.group = .*/listen.group = vagrant/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php/5.6/fpm/pool.d/www.conf

service php5.6-fpm restart

# install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# composer cronjob
install -Dm644 files/cron.composer /etc/cron.d/composer

cd "$php_calldir"
