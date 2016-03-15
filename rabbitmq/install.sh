#!/bin/bash
rabbitmq_basedir=$(dirname $(readlink -f $0))
rabbitmq_calldir=$(pwd)

cd "$rabbitmq_basedir"

set -e

apt-get install -y rabbitmq-server

if which php > /dev/null 2>&1; then
    apt-get install -y librabbitmq-dev
    pecl install Amqp-1.4.0 # higher needs more recent versions of rabbitmq
    echo "extension=amqp.so" > /etc/php5/mods-available/amqp.ini
    php5enmod amqp

    service php5-fpm restart
fi

rabbitmq-plugins enable rabbitmq_management

service rabbitmq-server restart

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/rabbitmq.nginx.conf \
        /etc/nginx/sites-enabled/rabbitmq.conf
    service nginx restart
fi

cd "$rabbitmq_calldir"