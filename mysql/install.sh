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

echo "[mysqld]" > /etc/mysql/mysql.conf.d/se.cnf
echo "sql_mode=NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/se.cnf
echo "performance_schema = 0" >> /etc/mysql/mysql.conf.d/se.cnf
echo "bind-address = 0.0.0.0" >> /etc/mysql/mysql.conf.d/se.cnf
echo "innodb_doublewrite = 0" >> /etc/mysql/mysql.conf.d/se.cnf # increase perf in dev

systemctl stop mysql
sleep 2
systemctl start mysql

echo "127.0.0.1 mysql" >> /etc/hosts

mysql -uroot -ptoor -e \
    "grant all on *.* to 'root'@'%' identified by 'toor'; flush privileges;"

cd "$mysql_calldir"
