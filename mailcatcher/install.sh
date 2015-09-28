#!/bin/sh
mailcatcher_basedir=$(dirname $(readlink -f $0))
mailcatcher_calldir=$(pwd)

cd "$mailcatcher_basedir"

set -e

# install mailcatcher
apt-get install -y build-essential libsqlite3-dev ruby-dev

gem install mailcatcher

echo "sendmail_path = /usr/bin/env $(which catchmail)" \
    >> /etc/php5/mods-available/mailcatcher.ini
php5enmod mailcatcher

install -Dm644 files/mailcatcher.upstart.conf \
    /etc/init/mailcatcher.conf

service php5-fpm restart
service mailcatcher restart

cd "$mailcatcher_calldir"
