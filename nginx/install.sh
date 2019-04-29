#!/bin/bash
nginx_basedir=$(dirname $(readlink -f $0))
nginx_calldir=$(pwd)

cd "$nginx_basedir"

set -e

# nginx
apt-get install -y nginx

# create log folder in case it does not exist
mkdir -p /var/log/nginx/website/
chown vagrant:vagrant -R /var/log/nginx/website/

# install config
rm -f /etc/nginx/sites-enabled/*
install -Dm644 files/website.conf /etc/nginx/sites-enabled/00_website.conf

# run nginx as vagrant user
sed -e 's/^user.*/user vagrant;/' -i /etc/nginx/nginx.conf

systemctl restart nginx

cd "$nginx_calldir"
