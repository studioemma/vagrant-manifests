#!/bin/bash
memcached_basedir=$(dirname $(readlink -f $0))
memcached_calldir=$(pwd)

cd "$memcached_basedir"

set -e

apt-get install -y memcached

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]{1}).*/\1/p')
    if [[ $phpversion -eq 7 ]]; then
        mkdir build
        cd build
        git clone https://github.com/php-memcached-dev/php-memcached.git
        cd php-memcached
        phpize
        ./configure --prefix=/usr
        make
        make install
        echo "extension=memcached.so" > /etc/php/7.0/mods-available/memcached.ini
        phpenmod memcached

        service php7.0-fpm restart
        cd ../..
    else
        apt-get install -y php5-memcache php5-memcached
        php5enmod memcache
        php5enmod memcached

        service php5-fpm restart
    fi
fi

service memcached restart

cd "$memcached_calldir"
