#!/bin/bash

BASE_SERVER=192.168.10.102	#下载软件的服务器
JDK_LINK=$BASE_SERVER/soft/jdk-8u112-linux-x64.tar.gz	#JDK下载链接


yum install -y wget
wget $JDK_LINK
tar -zxvf jdk-8u112-linux-x64.tar.gz -C /usr/local
cat >> /etc/profile << EOF
export JAVA_HOME=/usr/local/jdk1.8.0_112
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

