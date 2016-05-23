#!/bin/bash
mailcatcher_basedir=$(dirname $(readlink -f $0))
mailcatcher_calldir=$(pwd)

cd "$mailcatcher_basedir"

set -e

# install mailcatcher
apt-get install -y build-essential libsqlite3-dev ruby2.0 ruby2.0-dev

gem2.0 install mailcatcher

install -Dm644 files/mailcatcher.upstart.conf \
    /etc/init/mailcatcher.conf

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')
    echo "sendmail_path = /usr/bin/env $(which catchmail) -f magento2-devbox@studioemma.com --smtp-port 25" \
        >> /etc/php/$phpversion/mods-available/mailcatcher.ini
    phpenmod mailcatcher

    service php${phpversion}-fpm restart
fi

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/mailcatcher.nginx.conf \
        /etc/nginx/sites-enabled/mailcatcher.conf
    service nginx restart
fi

service mailcatcher restart

cd "$mailcatcher_calldir"
