#!/bin/bash
LogFile=/tmp/log
> $LogFile
function log_error() {
    echo -e "\033[31m [`date +%Y-%m-%d\ %H:%M:%S`] [E] $@ \033[0m"
    echo "[`date +%Y-%m-%d\ %H:%M:%S`] [E] $@"  >> $LogFile
}
function log_info() {
    echo -e "\033[32m [`date +%Y-%m-%d\ %H:%M:%S`] [I] $@ \033[0m"
    echo "[`date +%Y-%m-%d\ %H:%M:%S`] [I] $@"  >> $LogFile
}
function log_warn() {
    echo -e "\033[33m [`date +%Y-%m-%d\ %H:%M:%S`] [W] $@ \033[0m"
    echo "[`date +%Y-%m-%d\ %H:%M:%S`] [W] $@"  >> $LogFile
}
log_info "[系统资源信息]"
log_warn "[系统资源信息]"
log_error "[系统资源信息]"


#############################################################################
#!/bin/bash
function __log() {
	if [ "$1" == "info" ];then
		echo -e "\033[32m [INFO]  \033[0m${@:2} "
	elif [ "$1" == "warn" ];then
		echo -e "\033[33m [WARN]  \033[0m${@:2} "
	elif [ "$1" == "error" ];then
		echo -e "\033[31m [ERROR] \033[0m${@:2} "
	fi

}


__log info "asdasdasd"
__log warn "asdasdasd"
__log error "asdasdasd"