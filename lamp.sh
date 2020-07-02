#!/bin/bash
#***************************************
#   LAMP install v.1.8
#
#   Bijianyong <981789763@qq.com>
#
#   2018-07-31 
#***************************************
#================================================================
touch /tmp/lamp_install_log
log=/tmp/lamp_install_log
#================================================================
yum -y install gcc* || exit 2
# 1 安装 libxml2
yum -y install libxml2-devel || exit 3
yum -y install python-devel || exit 4
cd /lamp/libxml2-2.9.1
./configure --prefix=/usr/local/libxml2/ && make && make install || exit 5
echo "1--> libxml2 install ok" >> $log

# 2 安装 libmcrypt 
cd /lamp/libmcrypt-2.5.8
./configure --prefix=/usr/local/libmcrypt/ && make && make install || exit 6
echo "2--> libmcrypt install ok" >> $log

# 3 安装 libltdl，也在 libmcrypt 源码目录中，非新软件
cd /lamp/libmcrypt-2.5.8/libltdl
./configure --enable-ltdl-install && make &&  make install || exit 7
echo "3--> libltdl install ok" >> $log

# 4 安装 mhash
cd /lamp/mhash-0.9.9.9
./configure && make && make install || exit 8
echo "4--> mhash install ok" >> $log

# 5 安装 mcrypt
cd /lamp/mcrypt-2.6.8
LD_LIBRARY_PATH=/usr/local/libmcrypt/lib:/usr/local/lib \
./configure --with-libmcrypt-prefix=/usr/local/libmcrypt && make && make install || exit 9
echo "5--> mcrypt install ok" >> $log

# 6 安装 zlib
cd  /lamp/zlib-1.2.3
./configure
sed -i "s/^CFLAGS=-O.*/CFLAGS=-O3 -DUSE_MMAP -fPIC/g" Makefile
make && make install || exit 13
echo "6--> zlib install ok" >> $log

# 7 安装libpng
cd /lamp/libpng-1.2.31
./configure --prefix=/usr/local/libpng && make && make install || exit 14
echo "7--> libpng install ok" >> $log
 
# 8 安装jpeg6
mkdir /usr/local/jpeg6	
mkdir /usr/local/jpeg6/bin
mkdir /usr/local/jpeg6/lib
mkdir /usr/local/jpeg6/include
mkdir -p /usr/local/jpeg6/man/man1
yum -y install libtool* || exit 16
cd /lamp/jpeg-6b
\cp /usr/share/libtool/config/config.sub ./
\cp /usr/share/libtool/config/config.guess ./
cd /lamp/jpeg-6b
./configure --prefix=/usr/local/jpeg6/ --enable-shared --enable-static && make && make install || exit 17
echo "8--> jpeg6 install ok" >> $log

# 9 安装freetype
 cd /lamp/freetype-2.3.5
./configure --prefix=/usr/local/freetype/ && make && make install || exit 18
echo "9--> freetype install ok" >> $log

# 10 安装Apache
\cp  -a  /lamp/apr-1.4.6  /lamp/httpd-2.4.7/srclib/apr
\cp  -a  /lamp/apr-util-1.4.1  /lamp/httpd-2.4.7/srclib/apr-util
cd /lamp/pcre-8.34  
./configure && make && make install || exit 19

yum -y install openssl-devel || exit 20

cd /lamp/httpd-2.4.7
./configure --prefix=/usr/local/apache2 \
--sysconfdir=/usr/local/apache2/etc \
--with-included-apr \
--enable-so \
--enable-deflate=shared \
--enable-expires=shared \
--enable-rewrite=shared || exit 21

make && make install || exit 22
echo "10--> Apache install ok" >> $log

# 11 安装ncurses
yum -y install ncurses-devel || exit 23
cd /lamp/ncurses-5.9
./configure --with-shared \
--without-debug \
--without-ada \
--enable-overwrite && make && make install || exit 24
echo "11--> ncurses install ok" >> $log

# 12 安装cmake和bison
yum -y install cmake bison || exit 25
echo "12--> cmake and bison install ok" >> $log

# 13 安装MySQL
useradd -r -s /sbin/nologin mysql || exit 26
cd /lamp/mysql-5.5.48
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_USER=mysql \
-DMYSQL_TCP_PORT=3306 || exit 28

make && make install || exit 29
echo "13--> MySQL install ok" >> $log

cd /usr/local/mysql/
chown -R root .
chown -R mysql data

\cp support-files/my-medium.cnf /etc/my.cnf
/usr/local/mysql/scripts/mysql_install_db --user=mysql || exit 30

/usr/local/mysql/bin/mysqld_safe --user=mysql >/dev/null 2>&1 & 
[ -d /usr/local/mysql/bin/ ] || exit 31
sleep 6
/usr/local/mysql/bin/mysqladmin -uroot password 123456 || exit 32

# 14  安装PHP	
cd /lamp/php-7.0.7
./configure --prefix=/usr/local/php/ \
--with-config-file-path=/usr/local/php/etc/ \
--with-apxs2=/usr/local/apache2/bin/apxs \
--with-libxml-dir=/usr/local/libxml2/ \
--with-jpeg-dir=/usr/local/jpeg6/ \
--with-png-dir=/usr/local/libpng/ \
--with-freetype-dir=/usr/local/freetype/ \
--with-mcrypt=/usr/local/libmcrypt/ \
--with-mysqli=/usr/local/mysql/bin/mysql_config \
--enable-soap \
--enable-mbstring=all \
--enable-sockets \
--with-pdo-mysql=/usr/local/mysql \
--with-gd \
--with-zlib \
--without-pear || exit 33
make && make install || exit 34
mkdir -p /usr/local/php/etc/
\cp /lamp/php-7.0.7/php.ini-production /usr/local/php/etc/php.ini

echo "AddType application/x-httpd-php .php .phtml" >> /usr/local/apache2/etc/httpd.conf
echo "AddType application/x-httpd-php-source .phps" >> /usr/local/apache2/etc/httpd.conf

touch /usr/local/apache2/htdocs/test.php
echo "<?php" >> /usr/local/apache2/htdocs/test.php
echo "   phpinfo();" >> /usr/local/apache2/htdocs/test.php
echo "?>" >> /usr/local/apache2/htdocs/test.php

sed -i "s/^#ServerName.*/ServerName $HOSTNAME:80/g" /usr/local/apache2/etc/httpd.conf || exit 35
/usr/local/apache2/bin/apachectl start || exit 36

echo "14--> PHP install ok" >> $log

# 15  安装 openssl 
yum -y install openssl-devel || exit 37
cd /lamp/php-7.0.7/ext/openssl
mv config0.m4 config.m4
/usr/local/php/bin/phpize || exit 38
./configure --with-openssl --with-php-config=/usr/local/php/bin/php-config || exit 39
make && make install || exit 40
echo "15--> openssl install ok" >> $log

# 16 编译安装 memcache
cd /lamp/pecl-memcache-php7
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config || exit 41
make && make install || exit 42
echo 'extension_dir = "/usr/local/php/lib/php/extensions/no-debug-zts-20151012/"' >> /usr/local/php/etc/php.ini
echo 'extension="openssl.so";' >> /usr/local/php/etc/php.ini
echo 'extension="memcache.so";' >> /usr/local/php/etc/php.ini
echo "16--> memcache configure ok" >> $log

# 17 安装 memcache 源代码
yum -y install libevent-devel || exit 44

cd /lamp/memcached-1.4.17
./configure --prefix=/usr/local/memcache && make && make install || exit 46
useradd -r -s /sbin/nologin memcache

/usr/local/memcache/bin/memcached -umemcache & 
[ -d /usr/local/memcache/bin/ ] || exit 48
echo "17--> memcache install ok" >> $log

# 18 安装 phpMyAdmin，使用phpMyAdmin-4.8.2-all-languages新版本
\cp -a /lamp/phpMyAdmin-4.8.2-all-languages /usr/local/apache2/htdocs/phpmyadmin
echo "18--> phpMyAdmin install ok" >> $log
#===================================================
echo "/usr/local/mysql/bin/mysqld_safe --user=mysql &>/dev/null &" >> /etc/rc.d/rc.local
echo "/usr/local/apache2/bin/apachectl start &>/dev/null" >> /etc/rc.d/rc.local
echo "/usr/local/memcache/bin/memcached -umemcache &>/dev/null &" >> /etc/rc.d/rc.local
#===================================================
sed -i "s/[^#]DirectoryIndex .*/DirectoryIndex index.php index.html/g" /usr/local/apache2/etc/httpd.conf
/usr/local/apache2/bin/apachectl stop
sleep 1
/usr/local/apache2/bin/apachectl start


ht=$(netstat -nutl | grep ':80')
sq=$(netstat -nutl | grep ':3306')
me=$(netstat -nutl | grep ':11211')
if [ -z "$ht" ];then
   /usr/local/apache2/bin/apachectl start
fi

if [ -z "$sq" ];then
   /usr/local/mysql/bin/mysqld_safe --user=mysql >/dev/null 2>&1 &
fi

if [ -z "$me" ];then
   /usr/local/memcache/bin/memcached -umemcache &
fi

echo "脚本执行结束,安装日志：/tmp/lamp_install_log"


