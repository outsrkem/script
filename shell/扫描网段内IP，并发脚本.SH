#!/bin/bash
# 2019年6月12日
>~/ip.log
read -p "Please enter the section you want to scan:" network
[[ "$network" =~ ^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$ ]] || { echo "Please input alegal IP"; exit 50; }
#判断用户输入是否为正确的ip地址
net=`echo $network | cut -d. -f1-3 `            #以“.”作为分隔符，取ip地址前三段
for i in {1..254};do                            #展开列表
        {
        if ping -c1 -w1 $net.$i &>/dev/null;then #循环体ping命令ping 1次超时时间1秒，标准输出不显示
                echo $net.$i is up              #如果ping通了则打印 “$net$i is up”
                echo $net.$i >>~/ip.log      #将ping通的ip追加至ip.log文件中
        else                                    #否则打印“$net$i is down” 
                echo $net.$i is down
        fi
        }&      #使用“{}”将循环体并发执行
done
wait    #ping命令结束退出指令