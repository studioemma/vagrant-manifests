#!/bin/bash
php_basedir=$(dirname $(readlink -f $0))
php_calldir=$(pwd)

cd "$php_basedir"

set -e

add-apt-repository -y ppa:ondrej/php
apt-get update

# php fpm
apt-get install -y \
    php5.5-cli php5.5-fpm php5.5-curl php5.5-gd php5.5-common php5.5-intl \
    php5.5-json php5.5-mcrypt php5.5-mysql php5.5-readline php5.5-soap \
    php5.5-xsl php5.5-xdebug php5.5-dev

cat >> /etc/php/5.5/mods-available/xdebug.ini <<-EOF
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.max_nesting_level=400
EOF

install -Dm644 files/custom.ini /etc/php/5.5/mods-available/custom.ini

phpenmod mcrypt
phpenmod xdebug
phpenmod custom

# php-fpm as vagrant user and listen on tcp
sed -e 's/^user = .*/user = vagrant/' \
    -e 's/^group = .*/group = vagrant/' \
    -e 's/^listen.owner = .*/listen.owner = vagrant/' \
    -e 's/^listen.group = .*/listen.group = vagrant/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php/5.5/fpm/pool.d/www.conf

service php5.5-fpm restart

# install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# composer cronjob
install -Dm644 files/cron.composer /etc/cron.d/composer

cd "$php_calldir"
