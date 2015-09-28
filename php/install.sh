#!/bin/sh
php_basedir=$(dirname $(readlink -f $0))
php_calldir=$(pwd)

cd "$php_basedir"

set -e

# php fpm
apt-get install -y \
    php5-cli php5-fpm php5-curl php5-gd php5-mcrypt php5-intl php5-json \
    php5-mcrypt php5-mysql php5-readline php5-xsl php5-xdebug php-pear php5-dev

echo -e "xdebug.remote_enable = 1\n"\
    "xdebug.remote_connect_back = 1\n"\
    "xdebug.max_nesting_level=400\n"\
    >> /etc/php5/mods-available/xdebug.ini

install -Dm644 files/custom.ini /etc/php5/mods-available/custom.ini

php5enmod mcrypt
php5enmod xdebug
php5enmod custom

# php-fpm as vagrant user and listen on tcp
sed -e 's/^user = .*/user = vagrant/' \
    -e 's/^group = .*/group = vagrant/' \
    -e 's/^listen.owner = .*/listen.owner = vagrant/' \
    -e 's/^listen.group = .*/listen.group = vagrant/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php5/fpm/pool.d/www.conf

service php5-fpm restart

# install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

cd "$php_calldir"
