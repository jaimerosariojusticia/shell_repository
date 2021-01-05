#!/bin/bash

# Quick script to download and install VeraCrypt
# in Kali Linux ARM64.
# 
#
sudo su

apt update
apt install libwxgt* libfuse-dev libfuse3-dev python3-wxgtk4 build-essential

cd /usr/src
mkdir veracrypt; cd veracrypt;
wget -c 'https://launchpad.net/veracrypt/trunk/1.24-update7/+download/VeraCrypt_1.24-Update7_Source.tar.bz2'
tar -xvjf VeraCrypt_1.24-Update7_Source.tar.bz2
cd /usr/src/veracrypt/src/

make

copy ../Main/veracrypt /usr/bin/veracrypt