#!/bin/bash
memcached_basedir=$(dirname $(readlink -f $0))
memcached_calldir=$(pwd)

cd "$memcached_basedir"

set -e

apt-get install -y memcached

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]{1}).*/\1/p')
    if [[ $phpversion -eq 7 ]]; then
        apt-get install -y pkg-config libmemcached-dev
        git clone https://github.com/php-memcached-dev/php-memcached.git
        cd php-memcached
        # we need the php7 branch
        git checkout php7
        phpize
        ./configure --prefix=/usr
        make
        make install
        cd ..
        rm -rf php-memcached
        echo "extension=memcached.so" > /etc/php/mods-available/memcached.ini
        (
            cd /etc/php/7.0/cli/conf.d/
            ln -s /etc/php/mods-available/memcached.ini 20-memcached.ini
            cd /etc/php/7.0/fpm/conf.d/
            ln -s /etc/php/mods-available/memcached.ini 20-memcached.ini
        )

        service php7.0-fpm restart
    else
        apt-get install -y php5-memcache php5-memcached
        php5enmod memcache
        php5enmod memcached

        service php5-fpm restart
    fi
fi

service memcached restart

cd "$memcached_calldir"
