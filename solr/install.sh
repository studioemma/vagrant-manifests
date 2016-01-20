#!/bin/bash
solr_basedir=$(dirname $(readlink -f $0))
solr_calldir=$(pwd)

cd "$solr_basedir"

SOLR_VERSION=4.10.4

set -e

apt-get install -y openjdk-7-jdk
#mkdir /usr/java
#ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default

(
mkdir -p /opt/solr
cd /opt/solr
curl -s -o solr-$SOLR_VERSION.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz
tar -zxf solr-$SOLR_VERSION.tgz

# make magento2 collection
cd solr-$SOLR_VERSION/example/solr
cp -a collection1 magento2
cp "$solr_basedir/files/conf/"* magento2/conf/
)

sed -e 's/^\(name=\).*/\1magento2/' \
    -i /opt/solr/solr-$SOLR_VERSION/example/solr/magento2/core.properties

install -Dm644 files/solr.upstart.conf \
    /etc/init/solr.conf

sed -e "s/SOLR_VERSION/$SOLR_VERSION/g" -i /etc/init/solr.conf

service solr restart

cd "$solr_calldir"
