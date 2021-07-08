#!/bin/bash
# Linux shell script to check BIND named domain serial numbers across all name servers
# Tested on RHEL, Fedora, Centos and Debian Linux
# Requires named-checkzone, host utilities, and BIND server.
# -------------------------------------------------------------------------
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
# -------------------------------------------------------------------------
### Set me ###
CZBASE=/etc/bind/zones
NAMED_CHKZON=/usr/sbin/named-checkzone
NS1=ns1.nixcraft.net
NS2=ns2.nixcraft.net
NS3=ns3.nixcraft.net
ZPREF=master
if [ $# -eq 0 ]
then
	echo "$0 domain-name"
	exit 1
fi
d=$1
ZONEFILE=${CZBASE}/${ZPREF}.${d}
if [  -f $ZONEFILE ] 
then
		S1=$(host -t soa $d $NS2 | grep "^$d" | awk '{ print $7 }')
		S2=$(host -t soa $d $NS3 | grep "^$d" | awk '{ print $7 }')
		M=$($NAMED_CHKZON -t $CZBASE $d ${ZPREF}.${d}| grep "$d" | awk '{ print $5 }')
		echo -e "$NS1 # $S1\n$NS2 # $S2\n$NS3 # $M"
		$NAMED_CHKZON -q -t $CZBASE $d ${ZPREF}.${d}
		[ $? -eq 0 ] && echo "$d : OK"
		[ $S1 -eq $S2 -a $S1 -eq $M -a $S2 -eq $S1 -a $S2 -eq $M -a $M -eq $S1 -a $M -eq $S2 ] \
			&& echo "$d : Serial numbers same!" || echo "$d : Serial number different, reload named!"
else
		echo "Error - $d domain or $ZONEFILE zone file does not exits!"
fi
