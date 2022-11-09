#!/bin/bash
# 2019年8月6日
#
PROCNAME=infoweb
SHHOME=$(cd `dirname $0`; pwd)
SCNAME=$(basename $0)
SC=${SHHOME}/${SCNAME}
APP=${SHHOME}/infoweb.py
SLEEPTIME=10
port=`grep 'PORT =' $APP |tr -cd "[0-9]"`
function getpid() {
    PID=`ps aux | grep ${PROCNAME} | grep -v "grep" | grep -v "${SCNAME}" | awk '{print $2}'`
    echo $PID
}
function getbgpid() {
    PID=`ps aux | grep "$SCNAME daemon $PROCNAME" | grep -v "grep" | awk '{print $2}'`
    echo $PID
}
function getcode(){
    code=`curl -I -m 10 -o /dev/null -s -w %{http_code} 127.0.0.1:$port`
    echo $code
}
function bg_kill() {
    PID=`getbgpid`
    if [ ! -z "$PID" ] ; then
        kill ${PID}
        echo "shutdown bg daemon(${PID})."
    else
        echo "$PROCNAME daemon is stopped."
    fi
}
function bg_run() {
    PID=`getbgpid`
    if [ -z "$PID" ] ; then
        nohup $SC daemon $PROCNAME > /dev/null 2>&1 &
        echo "start $PROCNAME daemon($!)."
    else
        echo "$PROCNAME daemon($PID) is running..."
    fi
}
function run() {
    echo "Serving HTTP on 0.0.0.0 port $port"
    PID=`getpid`
    if [ -z $PID ] ; then
        /usr/bin/python $APP &>/dev/null &
        echo "start $PROCNAME($!)"
    else
        echo "$PROCNAME($PID) is running..."
    fi
}
function rerun() {
    PID=`getpid`
    if [ ! -z "$PID" ] ; then
        kill $PID
    fi
    while true; do
        PID=`getpid`
        if [ ! -z $PID ] ; then
            kill -9 $PID
            sleep 1
        else
            break
        fi
    done
    run
}
function bg_daemon() {
    while true; do
        code=`getcode`
        #echo $code >> aaaa
        if [ $code != 200 ] ; then
           rerun
        fi
        sleep $SLEEPTIME
    done
}
function start() {
    run
    bg_run
}
function stop() {
    bg_kill
    PID=`getpid`
    if [ ! -z "$PID" ] ; then
        kill $PID
        echo "shutdown $PROCNAME($PID)."
    else
        echo "$PROCNAME is stopped."
    fi
    while true; do
        PID=`getpid`
        if [ ! -z $PID ] ; then
            kill -9 $PID
            sleep 1
        else
            break
        fi
    done
}
function restart() {
    stop
    start
}
function status() {
    ps aux | grep ${PROCNAME} | grep -v "grep"
}

case "$1" in
    "start")
        start ;;
    "stop")
        stop ;;
    "restart")
        restart ;;
    "status")
        status ;;
    "daemon")
        bg_daemon ;;
    *)
        echo "start|stop|restart|status";;
esac