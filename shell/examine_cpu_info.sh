#!/bin/bash
#***************************************
#   Bijianyong <981789763@qq.com>
#   2018-07-11 
#   查看CPU信息
#***************************************
#物理CPU个数
aa=$(cat /proc/cpuinfo | grep "physical id" | sort -u | wc -l)
#逻辑CPU个数
bb=$(cat /proc/cpuinfo | grep "processor" | wc -l)
#每个物理CPU中Core的个数
cc=$(cat /proc/cpuinfo | grep "cpu cores" | uniq | awk -F: '{print $2}' |sed 's/ //g')
#查看core id的数量,即为所有物理CPU上的core的个数
dd=$(cat /proc/cpuinfo | grep "core id" | uniq |  wc -l)
echo -e "物理CPU总数: $aa 个, "
echo -e "逻辑CPU总数: $bb 个"
echo -e "每个物理CPU中核心(Core)的个数:$cc 个"
echo -e "所有物理CPU上核心(Core)的总数: $dd 个"