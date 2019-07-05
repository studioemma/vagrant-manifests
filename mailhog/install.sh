#!/bin/bash
mailhog_basedir=$(dirname $(readlink -f $0))
mailhog_calldir=$(pwd)

cd "$mailhog_basedir"

set -e

# install mailhog
wget -O /usr/local/bin/mailhog \
    https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
wget -O /usr/local/bin/mhsendmail \
    https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64

chmod +x /usr/local/bin/{mailhog,mhsendmail}

install -Dm644 files/mailhog.systemd.service \
    /etc/systemd/system/mailhog.service

if which php > /dev/null 2>&1; then
    phpversion=$(php -v | sed -rn 's/PHP ([0-9]+\.[0-9]+).*/\1/p')
    echo "sendmail_path = /usr/bin/env $(which mhsendmail)" \
        >> /etc/php/$phpversion/mods-available/mailhog.ini
    phpenmod mailhog

    systemctl restart php${phpversion}-fpm
fi

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/mailhog.nginx.conf \
        /etc/nginx/sites-enabled/mailhog.conf
    systemctl restart nginx
fi

systemctl enable mailhog
systemctl restart mailhog

cd "$mailhog_calldir"
