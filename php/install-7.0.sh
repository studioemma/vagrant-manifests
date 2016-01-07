#!/bin/bash
php_basedir=$(dirname $(readlink -f $0))
php_calldir=$(pwd)

cd "$php_basedir"

set -e

add-apt-repository -y ppa:ondrej/php-7.0
apt-get update

# php fpm
apt-get install -y \
    php-cli php-fpm php-curl php-gd php-intl php-json php-mysql php-pear \
    php-dev php-mcrypt php-xsl

# missing form php7
# php-mcrypt php-readline php-xsl php-xdebug

## build XDEBUG
git clone https://github.com/xdebug/xdebug.git
cd xdebug
phpize
./configure --prefix=/usr --enable-xdebug
make
cd debugclient
./buildconf
./configure --prefix=/usr
make
make install
cd ..
make install
cd ..
rm -rf xdebug

cat >> /etc/php/mods-available/xdebug.ini <<-EOF
zend_extension=xdebug.so
xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.max_nesting_level=400
EOF

install -Dm644 files/custom.ini /etc/php/mods-available/custom.ini

(
    cd /etc/php/7.0/cli/conf.d/
    ln -s /etc/php/mods-available/xdebug.ini 20-xdebug.ini
    ln -s /etc/php/mods-available/custom.ini 20-custom.ini
    cd /etc/php/7.0/fpm/conf.d/
    ln -s /etc/php/mods-available/xdebug.ini 20-xdebug.ini
    ln -s /etc/php/mods-available/custom.ini 20-custom.ini
)

# php-fpm as vagrant user and listen on tcp
sed -e 's/^user = .*/user = vagrant/' \
    -e 's/^group = .*/group = vagrant/' \
    -e 's/^listen.owner = .*/listen.owner = vagrant/' \
    -e 's/^listen.group = .*/listen.group = vagrant/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php/7.0/fpm/pool.d/www.conf

service php7.0-fpm restart

# install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# composer cronjob
install -Dm644 files/cron.composer /etc/cron.d/composer

cd "$php_calldir"
