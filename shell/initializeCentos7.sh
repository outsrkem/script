#!/bin/bash
# CentOS-7.4.1708
# 20180809
echo
echo https://www.cnblogs.com/outsrkem/
echo '──────────────────────────────'
rm -rf /etc/yum.repos.d/*
curl -sSo /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo 
yum clean all && yum makecache
echo "export PS1='\[\e[1;32m\][\u@\h \W]\\$ \[\e[0m\]'" >> /etc/bashrc
echo "export TIME_STYLE='+%Y-%m-%d %H:%M:%S'" >> /etc/bashrc

sed -i "s/^#UseDNS.*/UseDNS no/g" /etc/ssh/sshd_config 
sed -i "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
systemctl stop firewalld && systemctl disable firewalld && rpm -e --nodeps firewalld

#
yum -y install iptables-services
systemctl start iptables && iptables -F && service iptables save

yum -y install lrzsz net-tools bash-completion vim tree kernel-tools kernel-devel \
wget dos2unix ntpdate unzip psmisc tcpdump mailx patch

cat >> ~/.vimrc <<EOF
set ts=4
EOF

# 配置私有CA
curl -sSo /etc/pki/ca-trust/source/anchors/private-ca-root.pem \
  https://gitee.com/outsrkem/my_private_ca_pem/raw/main/pki/ca.pem && /bin/update-ca-trust
