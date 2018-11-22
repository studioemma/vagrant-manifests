#!/bin/bash
rabbitmq_basedir=$(dirname $(readlink -f $0))
rabbitmq_calldir=$(pwd)

cd "$rabbitmq_basedir"

set -e

apt-get install -y rabbitmq-server

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')
    apt-get install -y php-amqp php${phpversion}-bcmath

    systemctl restart php${phpversion}-fpm
fi

rabbitmq-plugins enable rabbitmq_management

systemctl restart rabbitmq-server
systemctl enable rabbitmq-server

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/rabbitmq.nginx.conf \
        /etc/nginx/sites-enabled/rabbitmq.conf
    systemctl restart nginx
fi

cd "$rabbitmq_calldir"
