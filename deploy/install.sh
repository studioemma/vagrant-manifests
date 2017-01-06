#!/bin/bash
deploy_basedir=$(dirname $(readlink -f $0))
deploy_calldir=$(pwd)

cd "$deploy_basedir"

set -e

su ubuntu -c files/clone.sh

cd "$deploy_calldir"
