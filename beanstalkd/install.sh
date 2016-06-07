#!/bin/bash
beanstalkd_basedir=$(dirname $(readlink -f $0))
beanstalkd_calldir=$(pwd)

cd "$beanstalkd_basedir"

set -e

apt-get install -y beanstalkd

if which php > /dev/null 2>&1; then
    # install phpbeanstalkdadmin
    ( cd /var/www; git clone https://github.com/mnapoli/phpBeanstalkdAdmin.git phpbeanstalkdadmin )
    chown vagrant:vagrant -R /var/www/phpbeanstalkdadmin
    if which nginx > /dev/null 2>&1; then
        install -Dm644 files/phpbeanstalkdadmin.nginx.conf \
            /etc/nginx/sites-enabled/phpbeanstalkdadmin.conf
        service nginx restart
    fi
fi

service beanstalkd restart

cd "$beanstalkd_calldir"
