#!/bin/bash
sshd_basedir=$(dirname $(readlink -f $0))
sshd_calldir=$(pwd)

cd "$sshd_basedir"

set -e

# osx does not understand locale so dont accept their wrong LANG shit
sed -e 's/\(.*AcceptEnv.*\)/# \1/' -i /etc/ssh/sshd_config
systemctl restart ssh

# insert the insecure key
wget https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/ubuntu/.ssh/authorized_keys
chmod 700 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

cd "$sshd_calldir"
