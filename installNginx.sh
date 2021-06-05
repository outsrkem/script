#!/bin/bash
# Nginx 1.17.5
# 本地安装
SHHOME=$(cd `dirname $0`; pwd)

function log_error() {
    echo -e "\033[31m[ERROR] \033[0m $@ "
}
function log_info() {
    echo -e "\033[32m[INFO] \033[0m $@ "
}
function log_warn() {
    echo -e "\033[33m[WRIN] \033[0m $@ "
}

if [ -z "$1" ];then
  log_error '请指定nginx源码包'
  echo $0 nginx-1.20.1.tar.gz
  exit 100
fi

nginx_name=$1

useradd -r -s /sbin/nologin nginx
yum -y install gcc* pcre pcre-devel perl perl-devel openssl openssl-devel zlib-devel policycoreutils-python

tar xvf $nginx_name
cd ${nginx_name%%.tar.gz*}


./configure --user=nginx --group=nginx \
--prefix=/usr/local/nginx \
--pid-path=/usr/local/nginx/run/nginx.pid \
--with-http_stub_status_module \
--with-http_ssl_module 
make -j && make install

find . -type d -name vim -exec cp -a {} ~/.vim \;

cd /usr/local/ && chown -R  nginx.nginx ./nginx/

log_info "Current execution directory $SHHOME"
log_info 'https://www.cnblogs.com/outsrkem/'
log_info 'Nginx 安装路径 /usr/local/nginx '
log_info '优化 Nginx 配置文件高亮'
log_info '修改nginx目录属主和属组为nginx'
log_info '生成 systenctl 管理脚本 /etc/systemd/system/nginx.service'
log_info '相关操作命令 
            systemctl daemon-reload
            systemctl start nginx.service
            systemctl status nginx.service
            systemctl enable nginx.service'

cat << EOF > /etc/systemd/system/nginx.service
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
PIDFile=/usr/local/nginx/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
PrivateTmp=true
Restart=on-failure
RestartSec=2s
[Install]
WantedBy=multi-user.target
EOF


chcon system_u:object_r:httpd_unit_file_t:s0 /etc/systemd/system/nginx.service
chcon system_u:object_r:bin_t:s0 /usr/local/nginx/sbin


semanage fcontext -a -t httpd_config_t '/usr/local/nginx/conf(/.*)?'
semanage fcontext -a -t httpd_var_run_t '/usr/local/nginx/run(/.*)?'
semanage fcontext -a -t httpd_log_t '/usr/local/nginx/logs(/.*)?'
semanage fcontext -a -t httpd_sys_content_t '/usr/local/nginx/html(/.*)?'
semanage fcontext -a -t bin_t '/usr/local/nginx/sbin'
semanage fcontext -a -t httpd_exec_t '/usr/local/nginx/sbin/nginx'

restorecon -Frvv /usr/local/nginx/*


