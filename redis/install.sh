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
        git clone https://github.com/phpredis/phpredis.git
        cd phpredis
        git checkout php7
        phpize
        ./configure --prefix=/usr
        make
        make install
        cd ..
        rm -rf phpredis
        echo "extension=redis.so" > /etc/php/mods-available/redis.ini
        (
            cd /etc/php/7.0/cli/conf.d/
            ln -s /etc/php/mods-available/redis.ini 20-redis.ini
            cd /etc/php/7.0/fpm/conf.d/
            ln -s /etc/php/mods-available/redis.ini 20-redis.ini
        )

        service php7.0-fpm restart
    else
        pecl install redis
        echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
        php5enmod redis

        service php5-fpm restart
    fi
fi

service redis-server restart

cd "$redis_calldir"
