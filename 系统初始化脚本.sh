# CentOS-7.4.1708
rm -rf /etc/yum.repos.d/*
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo 
yum clean all && yum makecache
echo "export PS1='\[\e[1;32m\][\u@\h \W]\\$ \[\e[0m\]'" >> /etc/bashrc
echo "export TIME_STYLE='+%Y-%m-%d %H:%M:%S'" >> /etc/bashrc
echo "export HISTTIMEFORMAT='%F %T  '" >> /etc/profile
sed -i "s/^#UseDNS.*/UseDNS no/g" /etc/ssh/sshd_config 
sed -i "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
systemctl stop firewalld && systemctl disable firewalld && rpm -e --nodeps firewalld
# systemctl disable chronyd 
systemctl stop chronyd
yum -y install iptables-services
systemctl start iptables && iptables -F && service iptables save
yum -y install lrzsz net-tools bash-completion vim tree wget dos2unix ntpdate unzip psmisc  kernel-tools  tcpdump 
cat >> ~/.vimrc <<EOF
set ts=4
set expandtab
set paste
EOF



echo 'export PS1="[\$?]${PS1}"' >> /etc/bashrc


#

将 Centos7 网卡命名方式关闭：
    net.ifnames=0
    biosdevname=0
centos6  init   串行启动
centos7 systemd  流启动
service network restart
systemctl restart/start network
systemctl stop firewalld && systemctl disable firewalld
# rpm -e --nodeps firewalld
# yum -y install iptables-services
# systemctl start iptables
# systemctl enable iptables
补全包 
bash-completion
关闭蜂鸣
vi /etc/inputrc
然后将set bell-style none前面的#删掉
vi /etc/bashrc  在开始的地方加上一句:
setterm -blength 0
永久修改主机名www.123.cn
hostnamectl set-hostname  www.yonge.ser