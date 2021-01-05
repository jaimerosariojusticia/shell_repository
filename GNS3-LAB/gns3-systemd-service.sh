#!/bin/bash

# Script to create systemctl service to manage
# GNS3 server process in a Linux server

GNS3SRVC () {
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
}

export -f GNS3SRVC
# Check for root. if not, executing as sudo.
if [ $EUID -eq 0 ];
	then GNS3SRVC;
	else SUGNS3SRVC=$(declare -f GNS3SRVC);
	sudo bash -c "$SUGNS3SRVC; GNS3SRVC";
fi