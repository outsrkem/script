# nginx安装笔记

useradd -r -s /sbin/nologin nginx

# 创建systenctl脚本，参照 systemctl/nginx.service 文件

# 基本依赖
yum -y install gcc* pcre pcre-devel perl perl-devel openssl openssl-devel

./configure --prefix=/usr/local/nginx \
--user=nginx \
--group=nginx \
--pid-path=/usr/local/nginx/run/nginx.pid \
--with-http_ssl_module \
--with-http_stub_status_module 
make && make install


# 开启http2.0
./configure --user=nginx --group=nginx \
--prefix=/usr/local/nginx \
--pid-path=/usr/local/nginx/run/nginx.pid \
--with-http_stub_status_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-openssl=/root/openssl-1.0.2h  #指定该软件位置，且软件版本高于 1.0.1


# 开启4层代理
# 编译需要添加 --with-stream模块
# --with-http_stub_status_module 开启静态资源 .gz 格式的压缩文件
# --with-http_gunzip_module 压缩模块网站的静态文件在互联网站传输会很大
# 启用file aio支持（一种APL文件传输格式）
./configure --prefix=/usr/local/nginx \
--user=nginx \
--group=nginx \
--pid-path=/usr/local/nginx/run/nginx.pid \
--with-http_ssl_module \
--with-http_gunzip_module \
--with-http_stub_status_module \
--with-file-aio \
--with-stream
make -j && make -j install

# 开启4层代理配置文件，与http区域同级,http区域可删除。
stream {
    log_format tcp-proxy '$remote_addr [$time_local]'
                     '$protocol $status $bytes_sent $bytes_received'
                     '$session_time "$upstream_addr" '
                     '"$upstream_bytes_sent" "$upstream_bytes_received" "$upstream_connect_time"';

    access_log  logs/tcp-access.log tcp-proxy;
    error_log  logs/tcp-error.log warn;

    upstream tcp_proxy {
        hash $remote_addr consistent; # 远程地址做个hash
        server 10.10.10.11:22;        # 这里只写IP：端口
    }

    server {
        listen 2222;
        proxy_connect_timeout 1s;   # 后端链接空闲超时断开
        proxy_timeout 10s;          # 后端连接超时时间
        proxy_pass tcp_proxy;       # 这里只写upstream的名称
    }
}
http {
	......
}




# 大多依赖
yum -y install pcre pcre-devel openssl \
openssl-devel gcc* autoconf automake zlib-devel \
libxml2 libxml2-dev libxslt-devel gd-devel perl-devel \
perl-ExtUtils-Embed GeoIP GeoIP-devel GeoIP-data make  \
GeoIP-devel GeoIP-update


./configure --prefix=/usr/local/nginx \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_realip_module \
--with-http_sub_module \
--with-stream \
--with-stream=dynamic && make && make install



# 与rpm模块一模一样功能的编译配置
yum install -y gcc gcc-c++ make \
    pcre pcre-devel \
    openssl openssl-devel \
    zlib zlib-devel \
    libxslt libxslt-devel \
    gd gd-devel \
    perl perl-devel \
    perl-ExtUtils-Embed \
    perl-IPC-Cmd

# 1.下载openssl
wget https://www.openssl.org/source/openssl-3.0.12.tar.gz
tar xf openssl-3.0.12.tar.gz -C /usr/local/src

# 2.编译Nginx
./configure \
--prefix=/usr/share/nginx \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib64/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/cache/nginx/client_body \
--http-proxy-temp-path=/var/cache/nginx/proxy \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi \
--http-scgi-temp-path=/var/cache/nginx/scgi \
--pid-path=/run/nginx.pid \
--lock-path=/run/lock/subsys/nginx \
--user=nginx \
--group=nginx \
--with-compat \
--with-debug \
--with-file-aio \
--with-http_addition_module \
--with-http_auth_request_module \
--with-http_dav_module \
--with-http_degradation_module \
--with-http_flv_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_image_filter_module=dynamic \
--with-http_mp4_module \
--with-http_perl_module=dynamic \
--with-http_random_index_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_v2_module \
--with-http_xslt_module=dynamic \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-openssl=/usr/local/src/openssl-3.0.12 \
--with-openssl-opt=enable-ktls \
--with-pcre \
--with-pcre-jit \
--with-stream=dynamic \
--with-stream_realip_module \
--with-stream_ssl_module \
--with-stream_ssl_preread_module \
--with-threads


make -j$(nproc)

# 3.检查编译结果
./objs/nginx -V
nginx version: nginx/1.30.1
built by gcc 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC)
built with OpenSSL 3.0.12 24 Oct 2023
TLS SNI support enabled
configure arguments: --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/cache/nginx/client_body --http-proxy-temp-path=/var/cache/nginx/proxy --http-fastcgi-temp-path=/var/cache/nginx/fastcgi --http-uwsgi-temp-path=/var/cache/nginx/uwsgi --http-scgi-temp-path=/var/cache/nginx/scgi --pid-path=/run/nginx.pid --lock-path=/run/lock/subsys/nginx --user=nginx --group=nginx --with-compat --with-debug --with-file-aio --with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_degradation_module --with-http_flv_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-http_xslt_module=dynamic --with-mail=dynamic --with-mail_ssl_module --with-openssl=/usr/local/src/openssl-3.0.12 --with-openssl-opt=enable-ktls --with-pcre --with-pcre-jit --with-stream=dynamic --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-threads
