
# https://blog.csdn.net/peng314899581/article/details/88845213
# https://www.openssl.org/source/old/1.0.2/

yum -y install perl perl-devel gcc gcc-c++ zlib-devel

# 编译openssl
tar xf openssl-1.0.2k.tar.gz
cd openssl-1.0.2k
./config -fPIC --prefix=/usr/local/openssl enable-shared
make -j4
make install -j4
    # 注释：
    # --prefix：指定安装目录
    # -fPIC:编译openssl的静态库
    # enable-shared:编译动态库 ，在编译openssh需要用道
    # -j4 则是告诉处理器同时处理4个编译任务,make -j不用加任何其他参数应该会默认使用所有的核心进行并行编译
    # 在多核CPU上，适当的进行并行编译还是可以明显提高编译速度的。但并行的任务不宜太多，一般是以CPU的核心数目的两倍为宜。

# 加载共享库文件
echo '/usr/local/openssl/lib' >> /etc/ld.so.conf
ldd /usr/local/openssl/bin/openssl
ldconfig -v
# 版本查看
openssl version -a


# 编译curl
tar xf curl-7.55.1.tar.gz
cd curl-7.55.1
# https://curl.haxx.se/download/
./configure --prefix=/usr/local/curl --without-nss --with-ssl=/usr/local/openssl
make -j4 
make install -j4
