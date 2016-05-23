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
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]{1}).*/\1/p')
    if [[ $phpversion -eq 7 ]]; then
        modpath='/etc/php/7.0'
        fpmservice='php7.0-fpm'
    else
        modpath='/etc/php5'
        fpmservice='php5-fpm'
    fi

    echo "sendmail_path = /usr/bin/env $(which catchmail) -f magento2-devbox@studioemma.com --smtp-port 25" \
        >> $modpath/mods-available/mailcatcher.ini
    if [[ $phpversion -eq 7 ]]; then
        (
            cd /etc/php/7.0/cli/conf.d/
            ln -s $modpath/mods-available/mailcatcher.ini 20-mailcatcher.ini
            cd /etc/php/7.0/fpm/conf.d/
            ln -s $modpath/mods-available/mailcatcher.ini 20-mailcatcher.ini
        )
    else
        php5enmod mailcatcher
    fi

    service $fpmservice restart
fi

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/mailcatcher.nginx.conf \
        /etc/nginx/sites-enabled/mailcatcher.conf
    service nginx restart
fi

service mailcatcher restart

cd "$mailcatcher_calldir"
