#!/bin/bash

Kernel_version=`uname -r`
Login_user=`last -a | grep "logged in" | wc -l`
Up_lastime=`date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S"`
Up_runtime=`cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%d:%d:%d:%d",run_days,run_hour,run_minute,run_second)}'`
Last_user=`last | awk '(/pts/) && (/-/){print "User: "$1" - ""OlineTime: "$NF" - ""IP: "$3" - ""LoginTime: "$4" "$5" "$6" " $7}'| head -1 | sed -e 's/(//g' -e 's/)//g'`

cat << EOF > /tmp/.loginmail
    邮件提示: 未知身份来源使用${USER}用户登录系统 
    -------------------------------------------------------------
                            System information
    主机名: $HOSTNAME
    内核版本: `uname -r`
    系统已运行时间: `cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf("%d:%d:%d:%d",run_days,run_hour,run_minute,run_second)}'`
    上一次重启时间: `date -d "$(awk -F. '{print $1}' /proc/uptime) second ago" +"%Y-%m-%d %H:%M:%S"`
    当前登入用户数: `last -a | grep "logged in" | wc -l`
    上一次登入用户: `last | awk '(/pts/) && (/-/){print "User: "$1" - ""OlineTime: "$NF" - ""IP: "$3" - ""LoginTime: "$4" "$5" "$6" " $7}'| head -1 | sed -e 's/(//g' -e 's/)//g'`
    -------------------------------------------------------------
EOF
 
 
smtp='smtp.163.com'
smtp_auth_user='outsrkem@163.com'
smtp_auth_password='b35f9f00d32'
from='outsrkem@163.com'
title="主机:`echo $HOSTNAME`登录提示 (`date "+%F %T"`)"
body=`cat /tmp/.loginmail`
to='981789763@qq.com'

sendEmail -s "$smtp" -xu "${smtp_auth_user}" -xp "${smtp_auth_password}" -f "$from" -t "$to" -u "$title" -m "$body"

sendEmail \
-f outsrkem@163.com \
-t xhdascnf@126.com \
-s smtp.163.com \
-u "我是邮件主题" \
-o message-content-type=html \
-o message-charset=utf8 \
-xu outsrkem \
-xp b35f9f00d32 \
-m "$body"



sendEmail \
-f outsrkem@163.com \
-t 981789763@qq.com \
-s smtp.163.com \
-u "我是邮件主题" \
-o message-content-type=html \
-o message-charset=utf8 \
-xu outsrkem -\
xp b35f9f00d32 -m "我是邮件内容"






