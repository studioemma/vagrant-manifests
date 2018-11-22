#!/bin/bash
memcached_basedir=$(dirname $(readlink -f $0))
memcached_calldir=$(pwd)

cd "$memcached_basedir"

set -e

apt-get install -y memcached

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')

    apt-get install -y php-memcached

    systemctl restart php${phpversion}-fpm

    # install memcacheadmin
    ( cd /var/www; git clone https://github.com/hgschmie/phpmemcacheadmin.git )
    chown vagrant:vagrant -R /var/www/phpmemcacheadmin
    if which nginx > /dev/null 2>&1; then
        install -Dm644 files/phpmemcacheadmin.nginx.conf \
            /etc/nginx/sites-enabled/phpmemcacheadmin.conf
        systemctl restart nginx
    fi
fi

systemctl restart memcached
systemctl enable memcached

echo "127.0.0.1 memcached" >> /etc/hosts

cd "$memcached_calldir"
