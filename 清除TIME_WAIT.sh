vim /etc/sysctl.conf //添加如下参数
#清除time_wait
#
#开启TCP SYN cookie保护
net.ipv4.tcp_syncookies = 1
#允许僵尸进程重复使用
net.ipv4.tcp_tw_reuse = 1
#TIME_WAIT回收机制开启
net.ipv4.tcp_tw_recycle = 1
#系統默认的TIMEOUT时间
net.ipv4.tcp_fin_timeout = 30

# tcp_tw_recycle选项的工作机制：
# 当开启了tcp_tw_recycle选项后，当连接进入TIME_WAIT状态后，
# 会记录对应远端主机最后到达分节的时间戳。如果同样的主机有新的分节到达，
# 且时间戳小于之前记录的时间戳，即视为无效，相应的数据包会被丢弃。
#
#
# netstat -s | grep timestamp
#
# packets rejects in established connections because of timestamp
# 如果服务器身处NAT环境，安全起见，通常要禁止tcp_tw_recycle，
# 至于TIME_WAIT连接过多的问题，可以通过激活tcp_tw_reuse来缓解（只对客户端有作用）。
# 当然关闭tcp_timestamps选项也是可以避免这个问题的：
# 设置sysctl.conf里面tcp_timestamps=0也可以只用命令sysctl -w net.ipv4.tcp_timestamps=0
# 但个人建议关闭tcp_tw_recycle选项，而不是timestamp；
# 因为 在tcp timestamp关闭的条件下，开启tcp_tw_recycle是不起作用的；
# 而tcp timestamp可以独立开启并起作用。此外tcp timestamp还和其他选项起作用有关，如tcp_tw_reuse。


# 
#!/bin/bash
# 查看脚本
#Date1=$(date '+%Y-%m  %d_%H:%M')
Date1=$(date +%Y-%m-%d_%H:%M:%S)
TX1=/tmp/tcp.txt

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
