#!/bin/bash
# Purpose: Mirror remote server backup using rsync command
# Author: Vivek Gite {https://www.cyberciti.biz/}
# License: GPL ver 2.x+
# Note: Tested on Debian/Ubuntu and CentOS only.
# ------------------------------------------------------------
 
## change me ##
_mnt="/dev/mapper/offsite-backups"
_user="vivek"
_host="server1.cyberciti.biz" 
_dir="/backups"
_dest="/offsite-backups/mirror.${_host}"
 
# Make sure offsite backup directory mounted
mount | grep -q ${_mnt}
if [ $? -eq 0 ]
then
  # Make dir if not found
  [ ! -d "$_dest" ] && mkdir -p "${_dest}"
  # alright mirror it. make sure you setup ssh-keys
  rsync --bwlimit 10000 --delete  -P -az -H --numeric-ids ${_user}@{_host}:${_dir} ${_dest}
else
  echo "$0: Error '${_dest}' not mounted." 
  exit 999
fi
