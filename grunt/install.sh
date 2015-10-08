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
npm install -g underscore
npm install -g node-minify
npm install -g glob
npm install -g time-grunt
npm install -g load-grunt-config
npm install -g imagemin-svgo
npm install -g jit-grunt
npm install -g grunt-contrib-watch

cd "$grunt_calldir"
