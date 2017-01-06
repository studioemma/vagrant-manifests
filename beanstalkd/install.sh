#!/bin/bash
beanstalkd_basedir=$(dirname $(readlink -f $0))
beanstalkd_calldir=$(pwd)

cd "$beanstalkd_basedir"

set -e

apt-get install -y beanstalkd

if which php > /dev/null 2>&1; then
    # install phpbeanstalkdadmin
    ( cd /var/www; git clone https://github.com/mnapoli/phpBeanstalkdAdmin.git phpbeanstalkdadmin )
    chown ubuntu:ubuntu -R /var/www/phpbeanstalkdadmin
    if which nginx > /dev/null 2>&1; then
        install -Dm644 files/phpbeanstalkdadmin.nginx.conf \
            /etc/nginx/sites-enabled/phpbeanstalkdadmin.conf
        systemctl restart nginx
    fi
fi

systemctl restart beanstalkd

cd "$beanstalkd_calldir"
