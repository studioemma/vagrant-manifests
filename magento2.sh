#!/bin/sh

set -e

# get up2date list of packages in apt
apt-get update

# set timezone
echo "Europe/Brussels" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata 2>&1

# bashrc
tail -n 10 /etc/skel/.bashrc >> /etc/bashrc

install -Dm644 /vagrant/manifests/bashrc/bashrc /etc/bash.bashrc.local
printf "\n[ -e /etc/bash.bashrc.local ] && . /etc/bash.bashrc.local\n" \
    >> /etc/bash.bashrc

echo 'PSCOL=${BLD}${COLWHT}' > /etc/bashrc.config
echo 'USRCOL=${BLD}${COLCYN}' >> /etc/bashrc.config
echo 'HSTCOL=${BLD}${COLRED}' >> /etc/bashrc.config
echo 'SCMENABLED=0' >> /etc/bashrc.config
echo 'SCMDIRTY=0' >> /etc/bashrc.config

tail -n 19 /etc/skel/.bashrc | head -n 8 > /root/.bashrc
tail -n 19 /etc/skel/.bashrc | head -n 8 > /home/vagrant/.bashrc

install -Dm644 /vagrant/manifests/bash/bash_aliases \
    /home/vagrant/.bash_aliases
chown --reference /home/vagrant /home/vagrant/.bash_aliases

# default packages
apt-get install -y vim htop curl git-core ant python-software-properties

# apache
apt-get install -y apache2

a2dismod mpm_prefork
a2dismod mpm_event
a2dismod auth_basic
a2dismod authn_file

a2enmod mpm_worker
a2enmod proxy_fcgi

a2enmod rewrite
a2enmod headers
a2enmod deflate
a2enmod alias
a2enmod status

# create log folder in case it does not exist
mkdir -p /var/www/website/var/log

# install config
rm -f /etc/apache2/sites-enabled/*
cp /vagrant/manifests/apache2/website.conf /etc/apache2/sites-enabled/

service apache2 restart

# php fpm
apt-get install -y \
    php5-cli php5-fpm php5-curl php5-gd php5-mcrypt php5-intl php5-json \
    php5-mcrypt php5-mysql php5-readline php5-xsl php5-xdebug php-pear

printf "xdebug.remote_enable = 1\nxdebug.remote_connect_back = 1" \
    >> /etc/php5/mods-available/xdebug.ini

php5enmod mcrypt
php5enmod xdebug

# php-fpm as vagrant user and listen on tcp
sed -e 's/^user = .*/user = vagrant/' \
    -e 's/^group = .*/group = vagrant/' \
    -e 's/^listen.owner = .*/listen.owner = vagrant/' \
    -e 's/^listen.group = .*/listen.group = vagrant/' \
    -e 's/^listen = .*/listen = 127.0.0.1:9000/' \
    -i /etc/php5/fpm/pool.d/www.conf

service php5-fpm restart

# install composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
chmod +x /usr/local/bin/composer

# install mysql
echo 'mysql-server  mysql-server/root_password password toor' \
    | debconf-set-selections
echo 'mysql-server  mysql-server/root_password_again password toor' \
    | debconf-set-selections

apt-get install -y mysql-server mysql-client

echo "[mysqld]" > /etc/mysql/conf.d/se.cnf
echo "sql_mode=NO_ENGINE_SUBSTITUTION" >> /etc/mysql/conf.d/se.cnf
echo "performance_schema = 0" >> /etc/mysql/conf.d/se.cnf
echo "bind-address = 0.0.0.0" >> /etc/mysql/conf.d/se.cnf

service mysql stop
sleep 2
service mysql start

mysql -uroot -ptoor -e \
    "grant all on *.* to 'root'@'%' identified by 'toor'; flush privileges;"

# create a default magento2 database
mysql -uroot -ptoor -e \
    "CREATE DATABASE magento2 DEFAULT CHARSET utf8;"

# install grunt
add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install -y nodejs

npm install -g grunt-cli

# install mailcatcher
apt-get install -y build-essential libsqlite3-dev ruby-dev

gem install mailcatcher

echo "sendmail_path = /usr/bin/env $(which catchmail)" \
    >> /etc/php5/mods-available/mailcatcher.ini
php5enmod mailcatcher

install -Dm644 /vagrant/manifests/upstart/mailcatcher.upstart.conf \
    /etc/init/mailcatcher.conf

service php5-fpm restart
service mailcatcher restart
