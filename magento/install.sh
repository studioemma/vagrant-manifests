#!/bin/bash
magento_basedir=$(dirname $(readlink -f $0))
magento_calldir=$(pwd)

cd "$magento_basedir"

set -e

# magento2 specific stuff
install -Dm644 files/cron.magento2 /etc/cron.d/magento2

# install magerun
wget https://files.magerun.net/n98-magerun2-latest.phar -O /usr/local/bin/magerun
chmod +x /usr/local/bin/magerun

cd "$magento_calldir"
