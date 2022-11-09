#!/bin/bash
# 2019年4月5日
TX1=/tmp/tcp.txt
#Date1=$(date '+%Y-%m  %d_%H:%M')
Date1=$(date +%Y-%m-%d_%H:%M:%S)

echo ''>$TX1
echo $Date1 >>$TX1
echo -e "TCP:">>$TX1
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}' >>$TX1
echo -e " " >>$TX1
echo -e "SYN_SENT    表示应用开始，打开一个连接;">>$TX1
echo -e "SYN_RECV    表示请求到达，等待确认;" >>$TX1
echo -e "ESTABLISHED 表示正常数据传输状态;" >>$TX1
echo -e "CLOSE_WAIT  表示两边同时尝试关闭;">>$TX1
echo -e "FIN_WAIT1   应用方表示已完成;">>$TX1
echo -e "FIN_WAIT2   另一方表示已同意释放;">>$TX1
echo -e "TIME_WAIT   表示处理完毕，等待超时结束的请求数;" >>$TX1
echo -e "LAST_ACK    表示等待所有分组死掉。">>$TX1
sleep 1
echo -e " " >>$TX1
echo -e "httpd进程数:" >> $TX1
ps -ef | grep httpd | grep -v httpd |wc -l >> $TX1

cat $TX1
