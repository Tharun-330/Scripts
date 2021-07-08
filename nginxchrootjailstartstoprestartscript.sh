#!/bin/bash
# Name : nginx.rc  
# URL: https://bash.cyberciti.biz/security/linux-nginx-start-stop-restart-chrooted-jail/
# Purpose: A simple shell script wrapper to chroot nginx in $_newroot under Linux
# ----------------------------------------------------------------------------
# Author: nixCraft - http://www.cyberciti.biz
# Copyright: 2011 nixCraft under GNU GPL v2.0+
# ----------------------------------------------------------------------------
# Last updated: 18/Dec/2012 - Added support for secure /tmp mount
# Last updated: 19/Dec/2012 - Bug fixed in ln 
# Last updated: 10/Mar/2013 - Bug fixed in status()
# ----------------------------------------------------------------------------
 
# jail location - must be up, see how to setup nginx using chroot
# https://www.cyberciti.biz/faq/howto-run-nginx-in-a-chroot-jail/
_newroot="/nginxjail"
 
# RHEL nginx and other binary paths
_nginx="/usr/sbin/nginx"
_chroot="/usr/sbin/chroot"
_killall="/usr/bin/killall"
 
# 0 turn off or # 1 turn on
_securetmp=0
_securetmproot="/path/to/images/nginx_jail_tmp.bin"
 
 
[ ! -d "$_newroot" ] &amp;# mount /tmp securely inside $_newroot
# see http://www.cyberciti.biz/faq/howto-mount-tmp-as-separate-filesystem-with-noexec-nosuid-nodev/
mounttmp(){
	if [ $_securetmp -eq 1 ]
	then
		mount | grep -q $_securetmproot
		if [ $? -eq  0 ]
		then
			echo "*** Secure root enabled and mounted ***"
		else
			echo "*** Turning on secure /tmp..."
			[ ! -f "$_securetmproot" ] &amp;mount -o loop,noexec,nosuid,rw "$_securetmproot" "$_newroot/tmp"
			chmod 1777 "$_newroot/tmp"
			rm -rf "$_newroot/var/tmp"
			ln -s ../tmp "$_newroot/var/tmp"
		fi
	fi
}
 
start(){
	echo -en "Starting nginx...\t\t\t"
	$_chroot $_newroot $_nginx &amp;&amp; echo -en "[ OK ]" || echo "[ Failed ]"
}
 
stop(){
	echo -en "Stoping nginx...\t\t\t"
	$_killall "${_nginx##*/}" &amp;&amp; echo -en "[ OK ]" || echo "[ Failed ]"
}
 
reload(){
	echo -en "Reloading nginx...\t\t\t"
	$_chroot $_newroot $_nginx -s reload &amp;&amp; echo -en "[ OK ]" || echo "[ Failed ]"
}
 
## Fancy status
status(){
	echo 
	pgrep -u ${_nginx##*/} ${_nginx##*/} &>/dev/null
	[ $? -eq 0 ] && echo "*** Nginx running on $(hostname) ***" || echo "*** Nginx not found on $(hostname) ***"
	echo 
	echo "*** PID ***"
	#pgrep -u ${_nginx##*/} ${_nginx##*/}
	ps aux | grep "${_nginx##*/}" | egrep -v 'grep|bash'
	echo
 
	echo "FD stats:"
	for p in $(pidof ${_nginx##*/}); do echo "PID # $p has $(lsof -n -a -p $p|wc -l) fd opend."; done
	echo
 
	echo "Jail dir location:"
	pwdx $(pgrep -u "root" "${_nginx##*/}") | grep  --color "$_newroot"
	echo 
 
	echo "*** PORT ***"
	netstat -tulpn | egrep --color  ':80|:443'
}
 
## Make sure /tmp is securely mounted inside jail ##
mounttmp
 
## main ##
case "$1" in
        start)
                start 
                ;;
        stop)
                stop 
                ;;
        restart)
                stop 
                start 
                ;;
        reload)
                reload
		;; 
        status)
                status
                ;;
        *)
                echo $"Usage: $0 {start|stop|restart|reload|status}"
                ;;
esac
 
# just send \n
echo
