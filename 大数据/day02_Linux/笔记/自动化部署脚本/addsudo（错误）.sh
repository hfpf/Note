#!/bin/bash
#需要传入用户名

HOSTLIST="centos01 centos02"	#需要添加sudo的主机
SUDOFILE="/etc/sudoers"
#
for HOST  in $HOSTLIST
do
	ssh root@$HOST 'grep "''" '${SUDOFILE}'' > /dev/null  grep "root" /etc/sudoers
	if [ "$?" != 0 ]
	then
		echo "User $1 on ${HOST} not have sudo!"
		ssh root@$HOST 'echo "'$1' ALL=(ALL) NOPASSWD:ALL,!/bin/su"' >> $SUDOFILE 
			&& echo "User $1 add sudo success!"
	else
		echo "User $1 already have sudo!"
	fi
done