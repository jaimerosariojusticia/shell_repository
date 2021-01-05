#!/bin/bash
{
    MEGACLISTATUS() {
    megacli -PDList -aAll | grep -E 'Slot\ Number|Device\ Id|Inquiry\ Data|Raw|Firmware\ state' | sed 's/Slot/\nSlot/g'
    }
    export -f MEGACLISTATUS
    ##### Check for root. If not, executing as sudo.
    if [ $EUID -eq 0 ];
        then MEGACLISTATUS;
        else SUMEGACLISTATUS=$(declare -f MEGACLISTATUS);
            sudo bash -c "$SUMEGACLISTATUS; MEGACLISTATUS";
    fi
}
