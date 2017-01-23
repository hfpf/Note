#!/bin/bash
#本脚本功能为配置ssh，执行安装脚本
#需要做初始化工作：
#ssh-keygen				#生成ssh密匙
#yum install expect		#安装except命令

SERVERS="centos05"								#每个主机名
PASSWORD=123456									#每个主机密码
INSTALL_FILE=install_jdk.sh						#安装脚本

#单个设置ssh免密登录过程
auto_ssh_copy_id() {
    expect -c "set timeout -1; #设置一直等待
        spawn ssh-copy-id $1;
        expect {
            *(yes/no)* {send -- yes\r;exp_continue;}
            *password:* {send -- $2\r;exp_continue;}
            eof        {exit 0;}
        }";
}

#设置ssh免密登录
ssh_copy_id_to_all() {
    for SERVER in $SERVERS
    do
        auto_ssh_copy_id $SERVER $PASSWORD
    done
}

#向每个主机发送公钥
ssh_copy_id_to_all	

#复制hosts文件
scp /etc/hosts root@$SERVER:/etc/hosts				

#安装JDK
for SERVER in $SERVERS
do
    scp $INSTALL_FILE root@$SERVER:/root			#复制安装脚本
	ssh root@$SERVER chmod +x /root/$INSTALL_FILE	
    ssh root@$SERVER /root/$INSTALL_FILE			#执行安装脚本
done