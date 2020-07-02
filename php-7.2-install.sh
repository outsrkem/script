useradd -r -s /sbin/nologin nginx

yum -y install libxml2 libxml2-devel \
openssl openssl-devel curl-devel libjpeg-devel \
libpng-devel freetype-devel libmcrypt-devel \
libxslt libicu-devel libxslt-devel

cd /lnmp/php-7.2.8/
./configure \
--prefix=/usr/local/php7 \
--with-mhash \
--with-openssl \
--with-apxs2=/usr/local/apache2/bin/apxs \
--with-config-file-path=/usr/local/php7/etc \
--disable-short-tags \
--enable-fpm \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--enable-xml \
--with-libxml-dir \
--enable-bcmath \
--enable-calendar \
--enable-intl \
--enable-mbstring \
--enable-pcntl \
--enable-shmop \
--enable-soap \
--enable-sockets \
--enable-zip \
--enable-mbregex \
--enable-mysqlnd \
--enable-mysqlnd-compression-support \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-gd \
--enable-ftp \
--with-curl \
--with-xsl \
--with-iconv \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--enable-sysvsem \
--enable-inline-optimization \
--with-xmlrpc \
--with-gettext && make -j 4 && make install

cd /lnmp/php-7.2.8/
cp php.ini-development /usr/local/php7/etc/php.ini
cd /usr/local/php7/etc/php-fpm.d/
cp -a www.conf.default www.conf

ln -s /usr/local/php7/bin/* /usr/local/bin/
ln -s /usr/local/php7/sbin/* /usr/local/sbin/

cd /usr/local/php7/etc/
cp -a php-fpm.conf.default php-fpm.conf

/usr/local/sbin/php-fpm #启动
netstat -lnt | grep 9000
killall php-fpm








