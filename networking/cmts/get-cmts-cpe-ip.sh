#!/bin/bash

# SNMP Community
SNMPCOMM="private"

# Inventory file
CMTSLIST="/etc/cnames/cmts"

# This script will get the CPE ip addresses from two different
# vendor CMTS (BSR 2000 and CASA Systems).
# The CPE IP Addresses are the "Customer Premise Equipment",
# or commonly known as "edge devices".
#
# The script requires snmpwalk.


cat $CMTSLIST | sort -V -u | \
while read -r CMTSIP
    do GetCMTSVendor=$(snmpwalk -v 2c -c "$SNMPCOMM" "$CMTSIP" SNMPv2-MIB::sysDescr.0 | cut -d " " -f4-5)
    if [[ "$GetCMTSVendor" == "BSR 2000(tm)" ]];
        then IPMIB="IP-MIB::ipNetToMediaPhysAddress.8323072"
    elif [[ "$GetCMTSVendor" == "CASA DCTS" ]];
        then IPMIB="IP-MIB::ipNetToMediaPhysAddress.2000001"
    fi

    snmpwalk -t 3 -v 2c -c "$SNMPCOMM" "$CMTSIP" "$IPMIB" | sed 's| = STRING: |;|g' | cut -d "." -f3-6 | \
    while read -r LINE; 
        do IPADDR=$(echo "$LINE" | cut -d ";" -f1);
        PREMACADDR=$(echo "$LINE" | cut -d ";" -f2);
        MACADDR="$(printf "%02x:%02x:%02x:%02x:%02x:%02x" 0x${PREMACADDR//:/ 0x})";
        echo -e "0 $MACADDR $IPADDR * *";
        done
done