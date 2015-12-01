#!/bin/sh
apache_basedir=$(dirname $(readlink -f $0))
apache_calldir=$(pwd)

cd "$apache_basedir"

set -e

# apache
apt-get install -y apache2

a2dismod mpm_prefork
a2dismod mpm_event
a2dismod auth_basic
a2dismod authn_file

a2enmod mpm_worker
a2enmod proxy_fcgi

a2enmod rewrite
a2enmod headers
a2enmod deflate
a2enmod alias
a2enmod status

# create log folder in case it does not exist
mkdir -p /var/website/var/log

# install config
rm -f /etc/apache2/sites-enabled/*
cp files/website.conf /etc/apache2/sites-enabled/

service apache2 restart

cd "$apache_calldir"
