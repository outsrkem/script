#!/bin/bash
log_file=/tmp/log
function __log_error() {
    local log_time=`date "+[%F %T %z]"`
    echo -e "\033[31m${log_time} [E]\033[0m $@"
    echo "${log_time} [E] $@"  >> $log_file
}
function __log_info() {
    local log_time=`date "+[%F %T %z]"`
    echo -e "\033[32m${log_time} [I]\033[0m $@"
    echo "${log_time} [I] $@"  >> $log_file
}
function __log_warn() {
    local log_time=`date "+[%F %T %z]"`
    echo -e "\033[33m${log_time} [W]\033[0m $@"
    echo "${log_time} [W] $@"  >> $log_file
}

__log_info "[$LINENO][系统资源信息]"
__log_warn "[$LINENO][系统资源信息]"
__log_error "[$LINENO][系统资源信息]"

