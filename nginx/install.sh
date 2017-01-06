#!/bin/bash
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
install -Dm644 files/website.conf /etc/nginx/sites-enabled/00_website.conf

# run nginx as ubuntu user
sed -e 's/^user.*/user ubuntu;/' -i /etc/nginx/nginx.conf

systemctl restart nginx

cd "$nginx_calldir"
