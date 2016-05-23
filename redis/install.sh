#!/bin/bash
redis_basedir=$(dirname $(readlink -f $0))
redis_calldir=$(pwd)

cd "$redis_basedir"

set -e

add-apt-repository -y ppa:chris-lea/redis-server
apt-get update
apt-get install -y redis-server

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')

    apt-get install -y php${phpversion}-redis

    service php${phpversion}-fpm restart

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
