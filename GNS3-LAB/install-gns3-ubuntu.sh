#!/bin/bash

# Script to create dedicated GNS3 server
# with GNS3 systemctl service at startup.

GNS3INSTALL () {

add-apt-repository ppa:gns3/ppa
apt update
apt install -y gns3-gui gns3-server

dpkg --add-architecture i386
apt update
apt install -y gns3-iou

apt remove -y docker docker-engine docker.io
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

for GROUP in {docker,kvm,libvirt,ubridge,wireshark}
    do usermod -aG "$GROUP" "$USER"
done

touch /etc/systemd/system/gns3server.service
#
cat <<EOF > /etc/systemd/system/gns3server.service
[Unit]
Description=GNS3 server
Wants=network-online.target
After=network.target network-online.target

[Service]
Type=forking
User=gns3
Group=gns3
PermissionsStartOnly=true
ExecStartPre=/bin/mkdir -p /var/log/gns3 /run/gns3
ExecStartPre=/bin/chown -R gns3:gns3 /var/log/gns3 /run/gns3
ExecStart=/usr/bin/gns3server --log /var/log/gns3/gns3.log --pid /run/gns3/gns3.pid --daemon
ExecReload=/bin/kill -s HUP $MAINPID
Restart=on-abort
PIDFile=/run/gns3/gns3.pid

[Install]
WantedBy=multi-user.target
EOF
#
systemctl daemon-reload
systemctl enable gns3server
systemctl status gns3server.service
systemctl start gns3server.service

shutdown -r -t 10
}

export -f GNS3INSTALL
# Check for root. if not, executing as sudo.
if [ $EUID -eq 0 ];
	then GNS3INSTALL;
	else SUGNS3INSTALL=$(declare -f GNS3INSTALL)
	sudo bash -c "$SUGNS3INSTALL; GNS3INSTALL"
fi