#!/bin/bash
cleanup_basedir=$(dirname $(readlink -f $0))
cleanup_calldir=$(pwd)

cd "$cleanup_basedir"

set -e

# get up2date list of packages in apt
apt-get clean -y

cd "$cleanup_calldir"
