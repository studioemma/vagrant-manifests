#!/bin/bash
redis_basedir=$(dirname $(readlink -f $0))
redis_calldir=$(pwd)

cd "$redis_basedir"

set -e

add-apt-repository -y ppa:chris-lea/redis-server
apt-get update
apt-get install -y redis-server

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]{1}).*/\1/p')
    if [[ $phpversion -eq 7 ]]; then
        mkdir build
        cd build
        git clone https://github.com/phpredis/phpredis.git
        cd phpredis
        git checkout php7
        phpize
        ./configure --prefix=/usr
        make
        make install
        echo "extension=redis.so" > /etc/php/7.0/mods-available/redis.ini
        phpenmod redis

        service php7.0-fpm restart
        cd ../..
    else
        pecl install redis
        echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
        php5enmod redis

        service php5-fpm restart
    fi
fi

service redis-server restart

cd "$redis_calldir"
