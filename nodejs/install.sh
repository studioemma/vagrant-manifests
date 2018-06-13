#!/bin/bash
nodejs_basedir=$(dirname $(readlink -f $0))
nodejs_calldir=$(pwd)

cd "$nodejs_basedir"

set -e

# install nodejs
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

cd "$nodejs_calldir"
