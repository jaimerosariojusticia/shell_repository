#!/bin/bash

# This is a quick and dirty attempt to network automation
# back in the day, when I worked with a team deploying
# hundreds of ip phones in a facility.
# The phones where manufactured by VTech.
# The iplist5.txt stored the ip addresses of the phones
# and it telnets to each phone, and downloads configuration files.

IPLIST=./iplist5.txt
cat $IPLIST | while read -r IP_ADDRESS
do TFTP_SERVER="10.36.17.209"
( echo -e "root"
echo -e "admin_123"
echo -e "cd /mnt/flash/ApplicationData/storage/sc14450_fs/configfile"
echo -e "tftp -g -r audio_settings_1.cfg $TFTP_SERVER"
echo -e "tftp -g -r audio_settings_2.cfg $TFTP_SERVER"
echo -e "tftp -g -r autodial_settings.cfg $TFTP_SERVER"
echo -e "tftp -g -r call_settings_1.cfg $TFTP_SERVER"
echo -e "tftp -g -r dial_plans.cfg $TFTP_SERVER"
echo -e "tftp -g -r SIP_settings.cfg $TFTP_SERVER"
echo -e "tftp -g -r SIP_account_2cfg $TFTP_SERVER"
echo -e "\r" ) | nc "$IP_ADDRESS" 23
echo "$IP_ADDRESS - done!"
done