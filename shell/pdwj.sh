#!/bin/bash
# 2018‎年‎8‎月‎14‎日
for i in $@
do
	if [ -L "$i" ];then
		printf  "\e[36m%-50s[软链接文件]\e[0m\n" "$i"

	elif [ -f "$i" ];then
		printf  "\e[37m%-50s[普通文件]\e[0m\n" "$i"

	elif [ -d "$i" ];then
		printf  "\e[34m%-50s[目录文件]\e[0m\n" "$i"

	elif [ -c "$i" ];then
		printf  "\e[33m%-50s[字符设备文件]\e[0m\n" "$i"

	elif [ -b "$i" ];then
		printf  "\e[33m%-50s[设备块文件]\e[0m\n" "$i"

	elif [ -p "$i" ];then
		printf  "\e[33m%-50s[管道文件]\e[0m\n" "$i"

	elif [ -S "$i" ];then
		printf  "\e[35m%-50s[套接字文件]\e[0m\n" "$i"

	else
		printf  "\e[32m%-50s[其他格式文件]\e[0m\n" "$i"
	fi
done
