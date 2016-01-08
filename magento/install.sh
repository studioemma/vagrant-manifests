#!/bin/bash
magento_basedir=$(dirname $(readlink -f $0))
magento_calldir=$(pwd)

cd "$magento_basedir"

set -e

# magento2 specific stuff
install -Dm644 files/cron.magento2 /etc/cron.d/magento2

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]{1}).*/\1/p')
    if [[ $phpversion -eq 7 ]]; then
        echo "env[MAGE_MODE] = developer" >> /etc/php/7.0/fpm/pool.d/www.conf

        service php7.0-fpm restart
    else
        echo "env[MAGE_MODE] = developer" >> /etc/php5/fpm/pool.d/www.conf

        service php5-fpm restart
    fi
fi

cd "$magento_calldir"
