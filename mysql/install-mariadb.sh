#!/bin/sh
mysql_basedir=$(dirname $(readlink -f $0))
mysql_calldir=$(pwd)

cd "$mysql_basedir"

set -e

# install mariadb 10
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb [arch=amd64,i386] http://mariadb.mirror.nucleus.be/repo/10.0/ubuntu trusty main'

apt-get update

echo 'mariadb-server-10.0  mysql-server/root_password password toor' \
    | debconf-set-selections
echo 'mariadb-server-10.0  mysql-server/root_password_again password toor' \
    | debconf-set-selections

# apt-get install mariadb-server-10.0 mariadb-client-10.0 mariadb-server-core-10.0
apt-get install -y mariadb-server mariadb-client

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
