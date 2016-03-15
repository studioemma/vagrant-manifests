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
        apt-get install -y php-redis

        service php7.0-fpm restart
    else
        pecl install redis
        echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
        php5enmod redis

        service php5-fpm restart
    fi

    # install phpredmin
    ( cd /var/www; git clone https://github.com/sasanrose/phpredmin.git )
    chown vagrant:vagrant -R /var/www/phpredmin
    if which nginx > /dev/null 2>&1; then
        install -Dm644 files/phpredmin.nginx.conf \
            /etc/nginx/sites-enabled/phpredmin.conf
        service nginx restart
    fi
fi

service redis-server restart

cd "$redis_calldir"
