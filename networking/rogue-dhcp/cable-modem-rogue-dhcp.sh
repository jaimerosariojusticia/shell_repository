#!/bin/bash
#=======================================================================================#
This script was used to detect rogue cable modems in hybrid network
devices (Cable Modem/Ethernet). Sometimes, the cable modem was not deactivated and
the device was not able to communicate with the DHCP server. This script allowed to
identify the device by MAC Address. This script work with most Arris cable modems.

Again, this script only works with a custom design hybrid device with Debian linux.
#----------
echo ":: Installing required packages...";
########
CMDHCPCHK ()
{
	apt-get -qq -y install iproute ncurses-term curl links > /dev/null 2>&1
#########################################################################################
### Adding ip address 192.168.100.57/24
	echo ":: Adding 192.168.100.57/24 IP Address..."
	ip -s -s neigh flush all &> /dev/null
	ip addr add 192.168.100.57/24 dev eth0 &> /dev/null
#########################################################################################
### Ping test to 192.168.100.1
	echo ":: Pinging 192.168.100.1 for active cable modem..."
	if ping -c1 192.168.100.1 &> /dev/null;
		then echo -e "IP Address 192.168.100.1 found. Checking for cable modem MAC Address.\\n"
#########################################################################################
### URL Test for cable modem web GUI
		TESTURL1=$(curl -sq "http://192.168.100.1/cmLogsData.htm" | grep CM-MAC | cut -d ";" -f2 | cut -d '=' -f2 | sort -u); # Arris Cable Modem
		TESTURL2=$(curl -sq "http://192.168.100.1/RgAddress.asp" | grep -a HFC | cut -d ">" -f6 | cut -d "<" -f1); # Arris Cable Modem
		#TESTURL3=$(curl -sq "http://192.168.100.1/");
#########################################################################################
### MAC Address lookup on cable modem coax interface
		echo ":: Testing for URLs ..."
			if [ ! -z $(echo $TESTURL1 | grep -E "[0-9]") ]; then export SHOWMAC="$(echo $TESTURL1)"; fi
			if [ ! -z $(echo $TESTURL2 | grep -E "[0-9]") ]; then export SHOWMAC="$(echo $TESTURL2)"; fi
			#if [ ! -z $(echo $TESTURL3 | grep -E "[0-9]") ]; then export SHOWMAC="$(echo $TESTURL3)"; fi
#########################################################################################
			if [ -z $SHOWMAC ]
				then echo -e "192.168.100.1 returned with unknown MAC Address.\\n"
				else echo -e "Cable Modem MAC Address is: \\033[1m${SHOWMAC}\\033[0m\\n"
			fi
### Output if no active cable modem has been found.
		else echo -e "IP Address 192.168.100.1 not found."
	fi
#########################################################################################
### Deleting 192.168.100.57/24 ip address
		ip addr del 192.168.100.57/24 dev eth0 &> /dev/null
		ip -s -s neigh flush all &> /dev/null
#########################################################################################
}
        export -f CMDHCPCHK
        ########
        if [ $EUID -eq 0 ]
        then CMDHCPCHK
        else SUCMDHCPCHK=$(declare -f CMDHCPCHK)
        sudo bash -c "$SUCMDHCPCHK; CMDHCPCHK"
        fi;
########