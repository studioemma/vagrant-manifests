#!/bin/sh
mailcatcher_basedir=$(dirname $(readlink -f $0))
mailcatcher_calldir=$(pwd)

cd "$mailcatcher_basedir"

set -e

# install mailcatcher
apt-get install -y build-essential libsqlite3-dev ruby-dev

gem install mailcatcher

install -Dm644 files/mailcatcher.upstart.conf \
    /etc/init/mailcatcher.conf

if which php > /dev/null 2>&1; then
    echo "sendmail_path = /usr/bin/env $(which catchmail)" \
        >> /etc/php5/mods-available/mailcatcher.ini
    php5enmod mailcatcher

    service php5-fpm restart
fi

service mailcatcher restart

cd "$mailcatcher_calldir"
