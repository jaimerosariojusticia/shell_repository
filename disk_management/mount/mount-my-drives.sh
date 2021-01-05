#!/bin/bash

# Script to mount drives using UUID on linux server.
# I like to manually mount them instead of auto-mount on every boot.

MOUNT () {
    mount -t ext4 -o noatime,rw,noauto /dev/disk/by-uuid/7f8dc72c-2759-4dfa-9a59-6a9f0b6f6506 /STORAGE/HDD-1TB
    mount -t ext4 -o noatime,rw,noauto /dev/disk/by-uuid/fcba70c7-81e9-488f-9aa2-345e3ec07057 /STORAGE/SSD-960M
    mount -t ext4 -o noatime,rw,noauto /dev/disk/by-uuid/a3bb53a8-ea1e-43b0-bba0-c486433b84fb /STORAGE/SSD-480M
}
export -f MOUNT
# Check for root. if not, executing as sudo.
if [ $EUID -eq 0 ];
then MOUNT;
else SUDOMOUNT=$(declare -f MOUNT);
sudo bash -c "$SUDOMOUNT; MOUNT";
fi