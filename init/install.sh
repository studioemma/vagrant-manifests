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
systemctl disable --now apt-daily-upgrade.timer
systemctl disable --now apt-daily.timer
rm /etc/cron.daily/apt-compat

# disable unneeded services (for our purpose)
systemctl mask --now lxcfs.service lxd-containers.service lxd.socket
systemctl mask --now unattended-upgrades.service
systemctl mask --now snapd.autoimport.service snapd.core-fixup.service \
    snapd.seeded.service snapd.service snapd.snap-repair.timer \
    snapd.socket snapd.system-shutdown.service
systemctl mask --now lvm2-lvmetad.socket lvm2-lvmpolld.socket \
    lvm2-monitor.service

cd "$init_calldir"
