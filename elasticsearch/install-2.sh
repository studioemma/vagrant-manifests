#!/bin/bash
elastic_basedir=$(dirname $(readlink -f $0))
elastic_calldir=$(pwd)

cd "$elastic_basedir"

set -e

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/2.x/apt stable main" > /etc/apt/sources.list.d/elastic-2.x.list
apt-get update
apt-get install elasticsearch

systemctl enable elasticsearch.service
systemctl restart elasticsearch.service

cd "$elastic_calldir"
