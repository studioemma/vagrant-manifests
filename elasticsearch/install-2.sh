#!/bin/bash
elastic_basedir=$(dirname $(readlink -f $0))
elastic_calldir=$(pwd)

cd "$elastic_basedir"

set -e

wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" | sudo tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
#wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
#echo "deb https://artifacts.elastic.co/packages/2.x/apt stable main" > /etc/apt/sources.list.d/elastic-2.x.list
apt-get update
apt-get install -y elasticsearch python3-pip

sed -e 's/^-Xms.*/-Xms1g/' \
    -e 's/^-Xmx.*/-Xmx1g/' \
    -i /etc/elasticsearch/jvm.options

systemctl enable elasticsearch.service
systemctl restart elasticsearch.service

(
    cd /var/www
    git clone https://github.com/ElasticHQ/elasticsearch-HQ.git elastichq
    cd elastichq
    pip3 install -r requirements.txt
)
chown vagrant:vagrant -R /var/www/elastichq
install -Dm644 files/elastichq.systemd.service \
    /etc/systemd/system/elastichq.service
systemctl enable elastichq.service
systemctl restart elastichq.service

if which nginx > /dev/null 2>&1; then
    install -Dm644 files/elastichq.nginx.conf \
        /etc/nginx/sites-enabled/elastichq.conf
    systemctl restart nginx
fi

cd "$elastic_calldir"
