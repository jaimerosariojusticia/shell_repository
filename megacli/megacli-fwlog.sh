#!/bin/bash

FWLOG() {
    megacli -FwTermLog -Dsply -aAll
}
export -f FWLOG



### ---------------------------------------------------------------- ###
##### Check for root. If not, executing as sudo.
if [ $EUID -eq 0 ];
    then FWLOG;
    else SUFWLOG=$(declare -f FWLOG);
        sudo bash -c "$SUFWLOG; FWLOG";
fi