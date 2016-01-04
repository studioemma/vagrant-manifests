#!/bin/bash
mysql_basedir=$(dirname $(readlink -f $0))
mysql_calldir=$(pwd)

cd "$mysql_basedir"

set -e

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

cd "$mysql_calldir"
