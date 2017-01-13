#!/bin/bash
magento_basedir=$(dirname $(readlink -f $0))
magento_calldir=$(pwd)

cd "$magento_basedir"

set -e

# magento2 specific stuff
install -Dm644 files/cron.magento2 /etc/cron.d/magento2

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')
    echo "env[MAGE_MODE] = developer" >> /etc/php/$phpversion/fpm/pool.d/www.conf
    service php${phpversion}-fpm restart
fi

# install magerun
wget https://files.magerun.net/n98-magerun2-latest.phar -O /usr/local/bin/magerun
chmod +x /usr/local/bin/magerun

cd "$magento_calldir"
