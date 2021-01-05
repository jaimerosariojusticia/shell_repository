#!/bin/bash
{
MEGACLITABLE ()
    {
    cv_code=$(grep "cv_code" /etc/hospital.conf | cut -d '"' -f2)
    MEGACLIPDLIST=$(megacli -PDLIST -AALL | grep -iE " Device ID:|Slot Number:|state:|alert")
    echo "$cv_code :: $(hostname)" | tr '[:lower:]' '[:upper:]'; echo -e "$(printf '%.s=' {1..90})";
        {   echo -e "$MEGACLIPDLIST" | head -5  | cut -d ':' -f1 | sed 's|^\s||g;s|Drive has flagged a ||g;s|Enclosure ||g' | sed -e ':a' -e 'N' -e '$!ba' -e 's|\n|\|\t|g';
            echo -e "$MEGACLIPDLIST" | head -5  | cut -d ':' -f2 | sed 's|^\s||g' | sed -e ':a' -e 'N' -e '$!ba' -e 's|\n|\|\t|g';
            echo -e "$MEGACLIPDLIST" | head -10 | tail -5 | cut -d ':' -f2 | sed 's|^\s||g' | sed -e ':a' -e 'N' -e '$!ba' -e 's|\n|\|\t|g';
            echo -e "$MEGACLIPDLIST" | head -15 | tail -5 | cut -d ':' -f2 | sed 's|^\s||g' | sed -e ':a' -e 'N' -e '$!ba' -e 's|\n|\|\t|g';
            echo -e "$MEGACLIPDLIST" | tail -5  | cut -d ':' -f2 | sed 's|^\s||g' | sed -e ':a' -e 'N' -e '$!ba' -e 's|\n|\|\t|g';
        } | column -tx -s:'|'; echo -e "$(printf '%.s=' {1..90})\n";
    }
    export -f MEGACLITABLE
#### Check for root. if not, executing as sudo.
    if [ $EUID -eq 0 ];
        then MEGACLITABLE;
        else SUMEGACLITABLE=$(declare -f MEGACLITABLE);
        sudo bash -c "$SUMEGACLITABLE; MEGACLITABLE";
    fi
}