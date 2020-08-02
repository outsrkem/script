
# https://blog.csdn.net/peng314899581/article/details/88845213
# https://www.openssl.org/source/old/1.0.2/

yum -y install perl perl-devel gcc gcc-c++ zlib-devel
./config -fPIC --prefix=/usr/local/openssl enable-shared
make -j4
make install -j4
    # 注释：
    # --prefix：指定安装目录
    # -fPIC:编译openssl的静态库
    # enable-shared:编译动态库 ，在编译openssh需要用道

# 加载共享库文件
echo '/usr/local/openssl/lib' >> /etc/ld.so.conf
ldd /usr/local/openssl/bin/openssl
ldconfig -v
#版本查看
openssl version -a


# https://curl.haxx.se/download/
./configure --prefix=/usr/local/curl --without-nss --with-ssl=/usr/local/openssl
make -j4 
make install -j4