#!/bin/bash
package_basedir=$(dirname $(readlink -f $0))
package_calldir=$(pwd)

cd "$package_basedir"

set -e

su ubuntu -c files/clone.sh

cd "$package_calldir"
