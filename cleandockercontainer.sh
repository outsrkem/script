﻿#!/bin/bash
# 删除docker已退出的容器
# 配合定时任务，实现秒级别的清理

function clean(){
    CONTAINERID=()
    unset CONTAINERID

    CONTAINERID[${#CONTAINERID[*]}]=`/usr/bin/docker ps -a |grep Exited |awk '{print $1}'`

    if [ -n "${CONTAINERID[*]}" ];then
        for element in ${CONTAINERID[@]};do
            /usr/bin/docker rm $element >/dev/null 2>&1 && \
            echo "[`date +%Y-%m-%d\ %H:%M:%S`] [DELETE] $element" >> /var/log/cleandocker.log
        done
    fi
}

for x in `seq 0 58`;do
    clean
    sleep 1
done