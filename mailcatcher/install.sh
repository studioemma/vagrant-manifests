#!/bin/bash
mailcatcher_basedir=$(dirname $(readlink -f $0))
mailcatcher_calldir=$(pwd)

cd "$mailcatcher_basedir"

set -e

# install mailcatcher
apt-get install -y build-essential libsqlite3-dev ruby-dev

gem install mailcatcher

install -Dm644 files/mailcatcher.systemd.service \
    /etc/systemd/system/mailcatcher.service

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')
    echo "sendmail_path = /usr/bin/env $(which catchmail) -f magento2-devbox@studioemma.com --smtp-port 25" \
        >> /etc/php/$phpversion/mods-available/mailcatcher.ini
    phpenmod mailcatcher

    systemctl restart php${phpversion}-fpm
fi

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/mailcatcher.nginx.conf \
        /etc/nginx/sites-enabled/mailcatcher.conf
    systemctl restart nginx
fi

systemctl enable mailcatcher
systemctl restart mailcatcher

cd "$mailcatcher_calldir"
