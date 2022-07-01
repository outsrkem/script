# 2019-07-02
# 生成随机密码
    for _ in {1..30};do tr -dc '~`!@#$%^&*()_+-={}:"<>?[];,./A-Za-z0-9"'"'" </dev/urandom |head -c 25;echo ;done |grep ^[a-zA-Z0-9]

    for _ in {1..30};do tr -dc '(!@&%^-_=+[{}]:,./?~#*)A-Za-z0-9' </dev/urandom |head -c 25;echo ;done |grep -P \
    "^[a-zA-Z0-9](?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[\!@&%\^\-_=\+\[{}\]:,\./\?~#\*]).{20,30}$"

# 将套接字监听为tcp或udp端口
    socat -d -d TCP-LISTEN:8080,fork UNIX:/var/run/nginx.sock

# 正则匹配Centos命令提示符：
    \[[a-zA-Z0-9]+@[a-zA-Z0-9-_]+\s(~|[a-zA-Z0-9-./+_]+)\](#|\$)

# 定时任务常用写法
    * * * * *       # 每分钟
    */5 * * * *     # 每5分钟
    0 17 * * 1-5    # 周一到周五每天 17:00
    30 8 * * 1,3,5  # 每周一、三、五的 8 点 30 分
    0 8-18/2 * * *  # 8 点到 18 点之间每隔 2 小时
    0 0 */3 * *     # 每隔 3 天
    0 */2 * * *     # 每两小时
    @reboot#        # Run once,at startup.
    @yearly         # Run once a year, "0 0 1 1 *".
    @annually       # (same as @yearly)
    @monthly        # Run once a month, "0 0 1 * *".
    @weekly         # Run once a week, "0 0 * * 0".
    @daily          # Run once a day, "0 0 * * *".
    @midnight       # (same as @daily)
    @hourly         # Run once an hour, "0 * * * *". /usr/local/www/awstats/cgi-bin/awstats.sh


# bash 命令行的 url 中出现特殊字符的处理方式：
    export http_proxy=http://zhangsan:123@zs!@172.16.2.17:8787
    export https_proxy=http://zhangsan:@MingHou233!@172.16.2.17:8787
    # 如果直接输入 BASH 会报错 或者代理无法使用。
    # 解决办法就是将特殊字符转换成 ASIIC 码形式输入, 以 % + 十六进制(Hex)形式(0x忽略).
    # 比如常见的会出现在密码中的特殊字符:
    #  ~ : 0x7E,         ! : 0x21
    #  @ : 0x40,         # : 0x23
    #  $ : 0x24,         % : 0x25
    #  ^ : 0x5E,         & : 0x26
    #  * : 0x2A,         ? : 0x3F
    # 替换后如下:
    export HTTP_PROXY=http://zhangsan:123%40zs%21@172.16.2.17:8787
    export HTTPS_PROXY=http://zhangsan:123%40zs%21@172.16.2.17:8787

# 历史命令记录到messages日志文件中 >> vi /etc/profile
    export PROMPT_COMMAND='{ msg=$(history 1|{ read x y; echo $y; });logger -t "[${SHELL}]" [`pwd`] "[$msg]" [code=`echo $?`] "[$(whoami)(uid=$(id -ur $user))]" [$(who am i)];}'

# 获取当前目录名
    echo $(basename `pwd`)
    zcy=`pwd |awk -F '/' '{print $NF}'` && echo ${zcy:-'/'}


# 列出所有用户的 cron 定时任务任务
    for user in $(cut -f1 -d: /etc/passwd); do echo $user; crontab -u $user -l 2>/dev/null; done

# 查看是否插网线，1表示有，0表示无
    cat /sys/class/net/eth0/carrier

# 常亮网卡灯
    ethtool -p eth0

# 生成字符集
    localedef -v -c -i en_US -f UTF-8 en_US.UTF-8

# 设置时区
    timedatectl set-timezone "Asia/Shanghai"
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  # (功能同上)
    timedatectl 

# 使用 ps 命令查看进程启动的精确时间和启动后所流逝的时间
    ps -eo pid,lstart,etime,cmd | grep nginx

# open files值修改
cat << EOF>> /etc/security/limits.conf
* soft nofile 65535
* hard nofile 65535
EOF

# Linux之awk实现ls显示数值权限
    ls -l | awk '{k=0;s=0;for(i=0;i<=8;i++ ){k+=((substr($1,i+2,1)~/[rwxst]/)*2^(8-i))}j=4;for(i=4;i<=10;i+=3){s+=((substr($1,i,1)~/[stST]/)*j);j/=2}if(k){printf("%0o%0o ",s,k)}print}'

# 系统负载查看（ps命名）
    ## 内存占比统计
        ps aux|awk '{s += $4} END {print s}'

    ## 内存使用量统计
        ps aux|awk '{s += $6} END {print s}'

    ## cpu使用量统计
        ps aux|awk '{s += $3} END {print s}'
        top -n 1 | awk -F '[ %]+' 'NR==3 {print $3}'

    ## 获取总磁盘大小
        sum=0;for x in `df  -m |grep ^/dev |awk '{print $2}'` ;do let sum=$sum+$x ;done ;echo $sum

    ## 获取已使用大小
        sum=0;for x in `df  -m |grep ^/dev |awk '{print $3}'` ;do let sum=$sum+$x ;done ;echo $sum

    ## 剩余内存磁盘查看命令
        sum=0;for x in `df  -m |grep -v docker |grep ^/dev |awk '{print $3}'` ;do let sum=$sum+$x ;done
        total=`cat /proc/meminfo |egrep "MemTotal"|awk '{print $2}'`
        used=`cat /proc/meminfo |egrep "MemFree"|awk '{print $2}'`
        let free=$total-$used
        awk -v m1=$free -v m2=1024 'BEGIN{print "内存使用 G: "m1/m2/m2}' ;awk -v m1=$sum -v m2=1024 'BEGIN{print "硬盘使用 G: "m1/m2}'

# 修改文件和目录权限
    find -type d  |xargs -i chmod 755 {}
    find -type f  |xargs -i chmod 644 {}
    
# 查看tcp连接状态数量
    netstat -an|awk '/tcp/ {print $6}'|sort|uniq -c

# 显示进程的PID
    ps -C java -o pid,cmd

# 查看所有用户创建的进程数
    ps h -Led -o user | sort | uniq -c | sort -n

# 生成秘钥串
    openssl rand -base64 32
    tr -dc A-Za-z0-9_ </dev/urandom | head -c 32 | xargs
    dd if=/dev/urandom bs=128 count=1 2>/dev/null | base64 | tr -d "=+/" | dd bs=32 count=1 2>/dev/null

# 控制台直接循环
    while :; do ps -aux | sort -n -k5,6 | grep my_script; free; sleep 5; done

# 检查端口
    checkPort() {
        timeout 1 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/$1" &>/dev/null
        return $?
    }
    tcpPort=22
    checkPort $tcpPort
    if [ $? -eq 0 ]; then
        echo "TcpPort:[$tcpPort] ok."
    else 
        echo "TcpPort:[$tcpPort] failed"
    fi

# 修改主机名
    hostnamectl set-hostname  xx.xx.xx    //这种方法大写会变小写
    还有一种方法，直接修改 /etc/hostname文件，这个可以保证大写不变
    注意，最好在 /etc/hosts 中增加主机名与IP的映射
    否则可能导致各种问题。
    重启后生效
    

# 获取http状态码,"\n" 是换行
    curl -I -m 10 -o /dev/null -s -w %{http_code}"\n" 127.0.0.1:8080 

# 删除当前目录下包含tar.gz的文件
    ls | grep  tar.gz|xargs rm -rf 


# 查看系统开机时间
    date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S"


# 获取系统时间
    date +%Y%m%d%H%M%S                      获取当天时间
    echo `date +%Y-%m-%d\ %H:%M:%S`         获取当天年月日时分秒
    echo `date +%Y%m%d`	                    获取当天日期	
    echo `date -d yesterday +%Y%m%d`        获取昨天日期	
    echo `date -d -2day +%Y%m%d`            获取前两天的日期			
    echo `date -d -3day +%Y%m%d`            获取前三天的日期
    echo `date -d '-100 days' "+%Y-%m-%d"` 	获取前100天	


# 获取毫秒时间戳
    # 秒，毫秒，微秒，纳秒
    # 使用 date +%s%N 可以获得一个纳秒级的unix时间戳(当前时间)，然后根据需要截取一部分即可得到毫秒级的精度
    # 如下即为毫秒级时间戳
    echo $[$(date +%s%N)/1000000]

# 定义PS1变量
    NORMAL="\[\e[0m\]"
    RED="\[\e[1;31m\]"
    GREEN="\[\e[1;32m\]"
    export PS1="$RED\u@\h [ $NORMAL\w$RED ]# $NORMAL"
    export PS1='\[\e[1;32m\][\u@\h \W]\$ \[\e[0m\]'
    
    #将上次命令执行是否成功的返回值放到提示符里面去
    export PS1="[\$?]${PS1}"
    
    # Linux 状态码的意义
    0              命令成功结束
    1              通用未知错误
    2              误用shell命令
    126            命令不可执行
    127            没找到命令
    128            无效退出参数
    128+x          Linux 信号 x 的严重错误
    129            表示命令被信号 1 杀死
    130            Linux 信号 2 的严重错误，即命令通过SIGINT（Ctrl＋Ｃ）终止
    137            表示命令被信号 9 杀死
    255            退出状态码越界

# 查看网卡型号
    yum -y install pciutils
    lspci | grep -i ethernet

# 添加新硬盘
    #查看主机总线号
        ls /sys/class/scsi_host/
    
    #依次扫描总线号
        echo "- - -" > /sys/class/scsi_host/host0/scan
        echo "- - -" > /sys/class/scsi_host/host1/scan
        echo "- - -" > /sys/class/scsi_host/host2/scan
    
    #如果有多个，则使用循环
        for i in /sys/class/scsi_host/host*/scan;do echo "- - -" > $i;done
    
