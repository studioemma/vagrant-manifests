#!/bin/bash
varnish_basedir=$(dirname $(readlink -f $0))
varnish_calldir=$(pwd)

cd "$varnish_basedir"

set -e

apt-get install -y varnish

rm /etc/varnish/default.vcl
install -m644 files/default.vcl /etc/varnish/default.vcl

systemctl restart varnish

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/varnish.nginx.conf \
        /etc/nginx/sites-enabled/varnish.conf
    systemctl restart nginx
fi


cd "$varnish_calldir"
