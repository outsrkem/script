./configure \
--prefix=/usr/local/php7 \
--with-mhash \
--with-openssl \
--with-config-file-path=/usr/local/php7/etc \
--disable-short-tags \
--enable-fpm \
--with-fpm-user=nginx \
--with-fpm-group=nginx \
--enable-xml \
--with-libxml-dir \
--enable-sockets \
--enable-zip \

cd /root/php-7.2.8
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