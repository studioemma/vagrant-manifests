#!/bin/sh
grunt_basedir=$(dirname $(readlink -f $0))
grunt_calldir=$(pwd)

cd "$grunt_basedir"

set -e

# install grunt
add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install -y nodejs

npm install -g grunt-cli

cd "$grunt_calldir"
