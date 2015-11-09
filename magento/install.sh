#!/bin/sh
magento_basedir=$(dirname $(readlink -f $0))
magento_calldir=$(pwd)

cd "$magento_basedir"

set -e

# magento2 specific stuff
install -Dm644 files/cron.magento2 /etc/cron.d/magento2

# set env var for cli tools
echo "export MAGE_MODE=developer" >> /home/vagrant/.bashrc

if which php > /dev/null 2>&1; then
    echo "env[MAGE_MODE] = developer" >> /etc/php5/fpm/pool.d/www.conf
    service php5-fpm restart
fi

cd "$magento_calldir"
