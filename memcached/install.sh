#!/bin/bash
memcached_basedir=$(dirname $(readlink -f $0))
memcached_calldir=$(pwd)

cd "$memcached_basedir"

set -e

apt-get install -y memcached

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]{1}).*/\1/p')
    if [[ $phpversion -eq 7 ]]; then
        apt-get install -y php7.0-memcached

        service php7.0-fpm restart
    else
        apt-get install -y php5-memcache php5-memcached
        php5enmod memcache
        php5enmod memcached

        service php5-fpm restart
    fi

    # install memcacheadmin
    ( cd /var/www; git clone https://github.com/hgschmie/phpmemcacheadmin.git )
    chown vagrant:vagrant -R /var/www/phpmemcacheadmin
    if which nginx > /dev/null 2>&1; then
        install -Dm644 files/phpmemcacheadmin.nginx.conf \
            /etc/nginx/sites-enabled/phpmemcacheadmin.conf
        service nginx restart
    fi
fi

service memcached restart

cd "$memcached_calldir"
