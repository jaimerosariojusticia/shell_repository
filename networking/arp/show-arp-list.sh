#!/bin/bash

SHOWARPLIST()
{ arp -an | grep -vE "incomplete" | sort -V | column -tx; }
export -f SHOWARPLIST
# Check for root. if not, executing as sudo.
	if [ $EUID -eq 0 ];
		then SHOWARPLIST;
		else SUSHOWARPLIST=$(declare -f SHOWARPLIST);
		sudo bash -c "$SUSHOWARPLIST; SHOWARPLIST";
	fi
