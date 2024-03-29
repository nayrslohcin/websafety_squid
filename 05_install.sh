#!/bin/bash

# all packages are installed as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# set squid version
source squid.ver

# get arch
ARCH="amd64"
cat /proc/cpuinfo | grep -m 1 ARMv7 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    ARCH="armhf"
fi

# decend into working directory
pushd build/squid

# install squid packages
sudo apt-get install squid-langpack
dpkg --install squid-common_${SQUID_PKG}_all.deb
dpkg --install squid_${SQUID_PKG}_${ARCH}.deb
dpkg --install squidclient_${SQUID_PKG}_${ARCH}.deb

# and revert
popd

# put the squid on hold to prevent updating
apt-mark hold squid squidclient squid-common squid-langpack
