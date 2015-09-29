#!/bin/sh
nginx_basedir=$(dirname $(readlink -f $0))
nginx_calldir=$(pwd)

cd "$nginx_basedir"

set -e

# nginx
apt-get install -y nginx

# create log folder in case it does not exist
mkdir -p /var/www/website/var/log

# install config
rm -f /etc/nginx/sites-enabled/*
install -Dm644 files/website.conf /etc/nginx/sites-enabled/

service nginx restart

cd "$nginx_calldir"