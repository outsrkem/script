#!/bin/bash

#监控阈值
DISK_space_warn=90
CPU_load_wran=1
CPU_use_wran=50
MEM_use_wran=50
Net_SYN_count_warn=200

now=`date -u -d"+8 hour" +'%Y-%m-%d %H:%M:%S'`

localip=`hostname -I | tr ' ' '\n' | grep -E '(^10\.|^172\.(1[6-9]|2[0-9]|31)|^192\.168)' | head -n 1`
#send cpu mail
#send_wran () {
 #   echo "$msq" | mail -s "cpu info" linuxly0808@163.com
#}

#监控cpu相关信息
function sub_cpu () {
    cpu_num=`grep -c 'model name' /proc/cpuinfo`
        #cpu15分钟负载
        load_15=`cat /proc/loadavg  | awk '{print $3}'`
        #average_load=`echo "scale=2;a=$load_15/$cpu_num;if(length(a)==scale(a)) print 0;print a" | bc`
        average_int=`echo $load_15 | cut -f 1 -d "."`
        if [ "${average_int}" -ge "${CPU_load_wran}" ];then
        #msq="${average_int}" "${localip}" system load average of 15 minutes  more than 1!
        echo ""${now}"  more than 1 ave="${load_15}"" | mail -s "cpu info" linuxly0808@163.com && echo  ""${now}"  more than 1 ave="${load_15}"">>/usr/local/scripts/cpu.log
fi
}

#监控cpu使用率
function  cpu_use () {
    cpu_idle=`top -b -n 1 | grep Cpu | awk '{print $8}' | cut -f 1 -d "."`  #空闲cpu百分比
        CPU_use=`expr 100 - $cpu_idle`
        if [ "${CPU_use}" -ge "${CPU_load_wran}" ];then
        msg=""${HOSTNAME}" "${localip}" CPU utilization is "${CPU_use}"% more than "${CPU_use_warn}"%"
		[-d /usr/local/scripts ] || mkdir -p /usr/local/scripts
         echo "${now}${msg}">>/usr/local/scripts/cpu_use.log && echo "${now}${msg}" | mail -s "disk info " linuxly0808@163.com
        fi
}

#监控磁盘
function sub_disk () {
    for DISK_space in `df -P | grep /dev | grep -v -E '(tmp|boot)' | awk '{print $5}' | cut -f 1 -d "%"`
        do
           if [ "$DISK_space" -ge "$DISK_space_warn" ];then
          msg=""${HOSTNAME}" "${localip}" Hard disk space :"${DISK_space}"% more than "${DISK_space_warn}"%"
          echo "${now}${msg}">>/usr/local/scripts/disk.log && echo "${now}${msg}" | mail -s "disk info " linuxly0808@163.com
        fi
        done
}

#监控内存
function sub_mem () {
    MEM_use=`free | grep "Mem" | awk '{printf("%d", $3*100/$2)}'`
        if [ "$MEM_use" -ge "$MEM_use_wran" ];then
        msg=""${HOSTNAME}" "${localip}" Mem_used:"${MEM_use}"% more than "${MEM_use_wran}"%"
        echo "${now}${msg}">>/usr/local/scripts/mem.log && echo "${now}${msg}" | mail -s "mem info " linuxly0808@163.com
        fi
}

#监控网络相关--syn办连接数
function  sub_net () {
    net_syn_count=`ss -an | grep -ic syn`
        if [ "${net_syn_count}" -ge "${Net_SYN_count_warn}" ];then
        msg=""${HOSTNAME}" "${localip}" net syn count :"${net_syn_count}" more than "${Net_SYN_count_warn}""
         echo "${now}${msg}">>/usr/local/scripts/net_syn.log && echo "${now}${msg}" | mail -s "disk info " linuxly0808@163.com
        fi
}
sub_cpu
cpu_use
sub_disk
sub_mem
sub_net

