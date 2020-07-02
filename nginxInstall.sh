#!/bin/bash
# Nginx 1.17.5
#
SHHOME=$(cd `dirname $0`; pwd)
function log_error() {
    echo -e "\033[31m [ERROR] \033[0m $@ "
}
function log_info() {
    echo -e "\033[32m [INFO] \033[0m $@ "
}
function log_warn() {
    echo -e "\033[33m [WRIN] \033[0m $@ "
}

useradd -r -s /sbin/nologin nginx
yum -y install gcc* pcre pcre-devel perl perl-devel openssl openssl-devel zlib-devel wget
wget http://nginx.org/download/nginx-1.17.5.tar.gz

tar xvf nginx-1.17.5.tar.gz
cd nginx-1.17.5
./configure --user=nginx --group=nginx \
--prefix=/usr/local/nginx \
--with-http_stub_status_module \
--with-http_ssl_module 

make && make install

find . -type d -name vim -exec cp -a {} ~/.vim \;

curl -sS https://gitee.com/Outsrkem/systemctl/raw/master/nginx.service |sh

log_info "Current execution directory $SHHOME"
log_info 'https://www.cnblogs.com/outsrkem/'
log_info 'Nginx 安装路径 /usr/local/nginx '
log_info '优化 Nginx 配置文件高亮'
log_info '生成 systenctl 管理脚本 /usr/lib/systemd/system/nginx.service'
log_info '相关操作命令 
            systemctl daemon-reload
            systemctl start nginx.service
            systemctl status nginx.service
            systemctl enable nginx.service'


