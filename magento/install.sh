#!/bin/sh
magento_basedir=$(dirname $(readlink -f $0))
magento_calldir=$(pwd)

cd "$magento_basedir"

set -e

# magento2 specific stuff
install -Dm644 files/cron.magento2 /etc/cron.d/magento2
echo "env[MAGE_MODE] = developer" >> /etc/php5/fpm/pool.d/www.conf

cd "$magento_calldir"
