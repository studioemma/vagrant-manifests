#!/bin/sh
redis_basedir=$(dirname $(readlink -f $0))
redis_calldir=$(pwd)

cd "$redis_basedir"

set -e

add-apt-repository -y ppa:chris-lea/redis-server
apt-get update
apt-get install -y redis-server

if which php > /dev/null 2>&1; then
    pecl install redis
    echo "extension=redis.so" > /etc/php5/mods-available/redis.ini
    php5enmod redis

    service php5-fpm restart
fi

service redis-server restart

cd "$redis_calldir"
