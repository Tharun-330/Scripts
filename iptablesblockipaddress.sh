#!/bin/bash
# Simple iptables IP/subnet block script 
# -------------------------------------------------------------------------
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# ----------------------------------------------------------------------
IPT=/sbin/iptables
SPAMLIST="spamlist"
SPAMDROPMSG="SPAM LIST DROP"
BADIPS=$(egrep -v -E "^#|^$" /root/iptables/blocked.ips)
 
# create a new iptables list
$IPT -N $SPAMLIST
 
for ipblock in $BADIPS
do
   $IPT -A $SPAMLIST -s $ipblock -j LOG --log-prefix "$SPAMDROPMSG"
   $IPT -A $SPAMLIST -s $ipblock -j DROP
done
 
$IPT -I INPUT -j $SPAMLIST
$IPT -I OUTPUT -j $SPAMLIST
$IPT -I FORWARD -j $SPAMLIST
