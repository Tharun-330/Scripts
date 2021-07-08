#!/bin/bash
# A simple shell to Wake Up nas devices / home servers 
# Tested on RHEL, Debian and Ubuntu base desktop systems.
# ----------------------------------------------------------------------------
# Written by Vivek Gite <http://www.cyberciti.biz/>
# (c) 2012 nixCraft under GNU GPL v2.0+
# ----------------------------------------------------------------------------
# Last updated: 14/May/2012
# ----------------------------------------------------------------------------
 
# add your nas devices mac address here #
_nas03="00:xx:yy:zz:aa:aa"
_nas02="xx:yy:zz:aa:bb"
_nas01="00:xx:yy:zz:aa:cc"
 
 
# path to wakeonlan #
__wakeupserver="/usr/bin/wakeonlan"
 
# who am I ? #
_me="${0##*/}"
 
# send magic packet #
__wakeup(){
   local n="$1"
   [[ "$n" == "" ]] &&  { echo "$_me ($FUNCNAME#$LINENO) error: Mac address not set."; exit 1; } || $__wakeupserver $n
}
 
## main logic ##
case $_me in
   wakeup.nas03) __wakeup $_nas03;;
   wakeup.nas02) __wakeup $_nas02;;
   wakeup.nas01) __wakeup $_nas01;;
	*) echo "$_me I can not understnad the request."
esac


#How do I use this script?
#First, install Wake-on-LAN (WOL) client under Unix or Linux operating systems.

#Next, download this script and put in your home directory as master.wol.sh
#wget -O 558.sh.zip 'http://bash.cyberciti.biz/dl/558.sh.zip?id=82aa046ab4872920e2fb0c9add0bd169'
#unzip 558.sh.zip
#mv 558.sh ~/bin/master.wol.sh
#chmod +x ~/bin/master.wol.sh

#Edit the script and set nas server mac address. Finally, create a symbolic link using ln command:
#ln -s master.wol.sh wakeup.nas01
#ln -s master.wol.sh wakeup.nas02
#ln -s master.wol.sh wakeup.nas03

#To wake up nas01 using WOL, enter:
#/path/to/wakeup.nas01
