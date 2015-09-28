#!/bin/sh
memcached_basedir=$(dirname $(readlink -f $0))
memcached_calldir=$(pwd)

cd "$memcached_basedir"

set -e

apt-get install -y memcached

if which php > /dev/null 2>&1; then
    apt-get install -y php5-memcache php5-memcached
    php5enmod memcache
    php5enmod memcached

    service php5-fpm restart
fi

service memcached restart

cd "$memcached_calldir"
