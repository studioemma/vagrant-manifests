#!/bin/bash
grunt_basedir=$(dirname $(readlink -f $0))
grunt_calldir=$(pwd)

cd "$grunt_basedir"

set -e

# requires nodejs
npm install -g grunt-cli

cd "$grunt_calldir"
