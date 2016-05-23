#!/bin/bash
rabbitmq_basedir=$(dirname $(readlink -f $0))
rabbitmq_calldir=$(pwd)

cd "$rabbitmq_basedir"

set -e

apt-get install -y rabbitmq-server

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')
    apt-get install -y php${phpversion}-amqp

    service php${phpversion}-fpm restart
fi

rabbitmq-plugins enable rabbitmq_management

service rabbitmq-server restart

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/rabbitmq.nginx.conf \
        /etc/nginx/sites-enabled/rabbitmq.conf
    service nginx restart
fi

cd "$rabbitmq_calldir"
