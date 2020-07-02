# nginx-1.15.2.tar.gz 安装



useradd -r -s /sbin/nologin nginx


# 基本依赖
yum -y install gcc* pcre pcre-devel perl perl-devel openssl openssl-devel 

./configure --prefix=/usr/local/nginx \
--user=nginx \
--group=nginx \
--with-http_ssl_module \
--with-http_stub_status_module && make && make install


# 开启http2.0
./configure --user=nginx --group=nginx \
--prefix=/usr/local/nginx \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-openssl=/root/openssl-1.0.2h  #指定该软件位置，且软件版本高于 1.0.1




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




