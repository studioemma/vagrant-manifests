#!/bin/bash
init_basedir=$(dirname $(readlink -f $0))
init_calldir=$(pwd)

cd "$init_basedir"

set -e

# get up2date list of packages in apt
apt-get update

# set timezone
echo "Europe/Brussels" > /etc/timezone
timedatectl set-timezone Europe/Brussels
dpkg-reconfigure --frontend noninteractive tzdata 2>&1

# default packages
apt-get install -y vim htop curl git-core ant nfs-common portmap

# disable apt-daily, this causes issues with vagrant some vagrant plugins
systemctl disable apt-daily-upgrade.timer
systemctl disable apt-daily.timer
rm /etc/cron.daily/apt-compat

cd "$init_calldir"
