#!/bin/bash
bash_basedir=$(dirname $(readlink -f $0))
bash_calldir=$(pwd)

cd "$bash_basedir"

set -e

# bashrc
tail -n 10 /etc/skel/.bashrc >> /etc/bashrc

install -Dm644 bashrc/bashrc /etc/bash.bashrc.local
printf "\n[ -e /etc/bash.bashrc.local ] && . /etc/bash.bashrc.local\n" \
    >> /etc/bash.bashrc

echo 'PSCOL=${BLD}${COLWHT}' > /etc/bashrc.config
echo 'USRCOL=${BLD}${COLCYN}' >> /etc/bashrc.config
echo 'HSTCOL=${BLD}${COLRED}' >> /etc/bashrc.config
echo 'SCMENABLED=0' >> /etc/bashrc.config
echo 'SCMDIRTY=0' >> /etc/bashrc.config

tail -n 19 /etc/skel/.bashrc | head -n 8 > /root/.bashrc
tail -n 19 /etc/skel/.bashrc | head -n 8 > /home/vagrant/.bashrc

install -Dm644 files/bash_aliases \
    /home/vagrant/.bash_aliases
chown --reference /home/vagrant /home/vagrant/.bash_aliases


cd "$bash_calldir"
