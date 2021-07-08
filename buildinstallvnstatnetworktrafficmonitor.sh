#!/bin/bash
# A Shell Script To Build vnstat software which is act as a console-based 
# network traffic monitor without using 3rd party repo.
# -------------------------------------------------------------------------
# Tested under CentOS / RHEL / Fedora Linux only.
# -------------------------------------------------------------------------
# Copyright (c) 2008 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
# Last updated on Mar/05/2010
# -------------------------------------------------------------------------
# Software Home page: http://humdi.net/vnstat/
# -------------------------------------------------------
VERSION="-1.10"
URL="http://humdi.net/vnstat/vnstat${VERSION}.tar.gz"
FILE="${URL##*/}"
DLHOME="/opt"
SOFTWARE="vnstat"
DEST="${FILE%.tar.gz}"
ETH="eth0"
 
[[ "$2" != "" ]] && ETH="$2"
 
[[ `id -u` -ne 0 ]] && { echo "$0: You must be root user to run this script. Run it as 'sudo $0'"; exit 1; }
 
case "$1" in
    download) 
        wget $URL -O "${DLHOME}/$FILE"
        ;;
    build) 
        echo "Building ${SOFTWARE}...."
        [[ ! -f "${DLHOME}/$FILE" ]] &&  wget $URL -O "${DLHOME}/$FILE"
        cd "${DLHOME}"
        tar -zxvf $FILE
        cd "$DEST"
        make
        make install
        [[ ! -f /etc/cron.d/vnstat.cron ]] && /bin/cp -f example/vnstat.cron /etc/cron.d/vnstat
        for i in $ETH
        do
            /usr/bin/vnstat -u -i "$i"
        done
        ;;
    *) echo "Usage: $0 {download|build} [eth0|eth1|eth2|ppp0]"
esac
