#!/bin/sh
basedir=$(dirname $(readlink -f $0))
calldir=$(pwd)

cd "$basedir"

set -e

# get up2date list of packages in apt
apt-get update

# set timezone
echo "Europe/Brussels" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata 2>&1

# default packages
apt-get install -y vim htop curl git-core ant python-software-properties

# install 'modules'
bash/install.sh
apache2/install.sh
php/install.sh
mysql/install.sh
grunt/install.sh
mailcatcher/install.sh

cd "$calldir"
