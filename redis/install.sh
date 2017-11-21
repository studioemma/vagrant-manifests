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

    apt-get install -y php-redis

    systemctl restart php${phpversion}-fpm

    # install phpredmin
    ( cd /var/www; git clone https://github.com/sasanrose/phpredmin.git )
    chown ubuntu:ubuntu -R /var/www/phpredmin
    if which nginx > /dev/null 2>&1; then
        install -Dm644 files/phpredmin.nginx.conf \
            /etc/nginx/sites-enabled/phpredmin.conf
        systemctl restart nginx
    fi
fi

systemctl restart redis-server

echo "127.0.0.1 redis" >> /etc/hosts

cd "$redis_calldir"
