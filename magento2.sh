#!/bin/sh
basedir=$(dirname $(readlink -f $0))
calldir=$(pwd)

if [ "/tmp" = "$basedir" ]; then
    cd /vagrant/manifests
else
    cd "$basedir"
fi

set -e

export DEBIAN_FRONTEND=noninteractive

# install 'modules'
init/install.sh
bash/install.sh
nginx/install.sh
php/install.sh
mysql/install-5.6.sh
grunt/install.sh
mailcatcher/install.sh
magento/install.sh
mountdependency/install.sh -m '/var/www/website' -s 'nginx' -s 'php5-fpm'

if [ "/tmp" != "$basedir" ]; then
    cd "$calldir"
fi
