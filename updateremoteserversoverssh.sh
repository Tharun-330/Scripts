#!/bin/bash
# A simply shell script to update all remote Redhat Enterprise Linux 5 / CentOS Linux 5 servers
# You must have ssh public and private key installed. This will save a lot of time if you
# have 5-7 servers. The last example shows how to login as a normal user and run sudo 
# to update the same.
# -------------------------------------------------------------------------
# Copyright (c) 2008 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# -------------------------------------------------------------------------
 
# an array to store all ssh commands
hosts=(
	"ssh root@server1.nixcraft.in -p222 yum update -y"
	"ssh root@server2.nixcraft.in -p333 yum update -y"
	"ssh root@server3.nixcraft.in yum update -y"
	"ssh user1@192.168.1.254 -t sudo  '/usr/bin/yum update -y' "
      )
# simply run array item
for c in "${hosts[@]}"
do
	$c
done
