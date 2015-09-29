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
apache2/install.sh
php/install.sh
mysql/install-oracle.sh
grunt/install.sh
mailcatcher/install.sh
magento/install.sh

if [ "/tmp" != "$basedir" ]; then
    cd "$calldir"
fi
