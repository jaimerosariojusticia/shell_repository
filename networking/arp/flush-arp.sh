#!/bin/bash

# Flush MAC Address tables
# Useful to detect IP / MAC Addresses conflicts

FLUSHARP()
{ bash -c 'ip -s -s neigh flush all; systemctl restart nscd.service'; }
export -f FLUSHARP
# Check for root. if not, executing as sudo.
	if [ $EUID -eq 0 ];
		then FLUSHARP;
		else SUFLUSHARP=$(declare -f FLUSHARP);
		sudo bash -c "$SUFLUSHARP; FLUSHARP";
	fi
