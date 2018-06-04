#!/bin/bash

[[ -z $1 ]] && echo "must give a startdir" && exit 1

[[ ! -f "$1/id_rsa" ]] && echo "please add your private key as id_rsa" && exit 2

#[[ ! -e "$startdir/id_rsa.pub" ]] && echo "please add your public key as id_rsa.pub" && exit 3

cp -a "$1"/id_rsa /home/vagrant/.ssh/
chown vagrant:vagrant /home/vagrant/.ssh/id_rsa
chmod 0600 /home/vagrant/.ssh/id_rsa
