#!/bin/sh
grunt_basedir=$(dirname $(readlink -f $0))
grunt_calldir=$(pwd)

cd "$grunt_basedir"

set -e

# install grunt
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs

npm install -g grunt-cli

cd "$grunt_calldir"
