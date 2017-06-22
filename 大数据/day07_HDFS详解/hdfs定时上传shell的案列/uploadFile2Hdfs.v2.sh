#!/bin/bash

#set java env
export JAVA_HOME=/home/hadoop/app/jdk1.8.0_131
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

#set hadoop env
export HADOOP_HOME=/home/hadoop/app/hadoop-3.0.0-alpha3
export PATH=${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH


#版本1的问题：
#虽然上传到Hadoop集群上了，但是原始文件还在。如何处理？
#日志文件的名称都是xxxx.log1,再次上传文件时，因为hdfs上已经存在了，会报错。如何处理？

#如何解决版本1的问题
#       1、先将需要上传的文件移动到待上传目录
#		2、在讲文件移动到待上传目录时，将文件按照一定的格式重名名
#		/home/hadoop/log/hadoop.log1   /export/data/click_log/xxxxx_click_log_{date}


#日志文件存放的目录
log_src_dir=/home/hadoop/log/

#日志文件基础名(click.log click.log1 click.log2的基础名为click.log)
log_base_name=qdgxytr.log

#待上传文件存放的目录
log_upload_dir=/home/hadoop/log/upload/

#日志文件上传到hdfs的根路径
hdfs_root_dir=/data/clickLog/`date +%Y%m%d`/
hadoop fs -mkdir -p $hdfs_root_dir

#打印环境变量信息
echo "【envs】"
echo "JAVA_HOME: $JAVA_HOME"
echo "hadoop_home: $HADOOP_HOME"

#读取日志文件的目录，判断是否有需要上传的文件
echo "log_src_dir:"$log_src_dir
ls $log_src_dir | while read fileName
do
	if [[ $fileName == $log_base_name* ]]; then
		#将文件移动到待上传目录并重命名
		#打印信息
		
		date=`date +%Y_%m_%d_%H_%M_%S`
		log_file=$log_src_dir$fileName	# 需要上传的文件
		log_upload_file=$log_upload_dir"click_log_$fileName."$date # 待上传目录
		
		echo "moving [$log_file] to [$log_upload_file]"
		mv $log_file $log_upload_file
		
		#将待上传的文件path写入一个列表文件willDoing
		echo $log_upload_file >> $log_upload_dir"willDoing."$date
	fi
done

#找到列表文件willDoing
ls $log_upload_dir | grep will |grep -v "_COPY_" | grep -v "_DONE_" | while read line
do
	#打印信息
	echo "upload is in file:"$line
	#将待上传文件列表willDoing改名为willDoing_COPY_
	mv $log_upload_dir$line $log_upload_dir$line"_COPY_"
	#读列表文件willDoing_COPY_的内容（一个一个的待上传文件名）  ,此处的line 就是列表中的一个待上传文件的path
	cat $log_upload_dir$line"_COPY_" |while read line
	do
		#打印信息
		echo "puting [$line] to hdfs [$hdfs_root_dir]"
		hadoop fs -put $line $hdfs_root_dir
	done
	mv $log_upload_dir$line"_COPY_"  $log_upload_dir$line"_DONE_"
done

