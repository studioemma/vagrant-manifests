#!/bin/bash
init_basedir=$(dirname $(readlink -f $0))
init_calldir=$(pwd)

cd "$init_basedir"

set -e

# get up2date list of packages in apt
apt-get update

# set timezone
echo "Europe/Brussels" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata 2>&1

# default packages
apt-get install -y vim htop curl git-core ant python-software-properties

# osx does not understand locale so dont accept their wrong LANG shit
sed -e 's/\(.*AcceptEnv.*\)/# \1/' -i /etc/ssh/sshd_config
systemctl restart ssh

cd "$init_calldir"
