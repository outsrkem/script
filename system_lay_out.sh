#!/bin/bash
#****************************************
#	新系统部署
#
#	New system deployment
#
#	Bijianyong <981789763@qq.com>
#
#	2018-07-11
#***************************************
#
#******************************************************************************************************************************
#定义网卡路径
add=/etc/sysconfig/network-scripts/ifcfg-eth0
cp -a "$add" /tmp/
#add=/tmp/ifcfg-eth0
#重启网卡函数
network_restart (){
echo -ne "Restart network service [yes | default:no]:" ;read cq
if [ "$cq" == "yes" -o "$cq" == "y" ];then
	net="network service" #输出是调用，用于显示
	service network restart &>/dev/null #实际重启网卡，后期取消注释
	#lsd &>/dev/null #用于调试，临时设置，后期注释
	if [ $? -eq 0 ];then
		printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$net"
	else
		printf  "%-40s\t\t\e[31m[error]\e[0m\n" "$net"
		service network restart #再次重启网卡，将错误打印在屏幕上
	fi
fi
}
#IP获取方式
BOOTPROTO_fun (){
printf "\e[33mtarget file : %s\e[0m\n" "$add" #显示当前操作对象
mm=0
while true
do
	read -p "BOOTPROTO=[ none | static | dhcp ] :" aa
	if [ -z "$aa" -o "$aa" == "none" -o "$aa" == "static" -o "$aa" == "dhcp" ];then
		case $aa in
			none)
			read -p "[yes | default:no]" yn
			if [ "$yn" == "yes" -o "$yn" == "y" ];then		
				sed -i 's/BOOTPROTO.*/BOOTPROTO=none/g' $add
				mm=` grep "BOOTPROTO=" $add ` ;printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
				network_restart
			fi
			break
			;;
			static)
			read -p "[yes | default:no]" yn
			if [ "$yn" == "yes" -o "$yn" == "y" ];then
				sed -i 's/BOOTPROTO.*/BOOTPROTO=static/g' $add
				mm=` grep "BOOTPROTO=" $add ` ;printf  "%40s\t\t\e[32m[ok]\e[0m\n" "$mm"
				network_restart
			fi
			break
			;;
			dhcp)
			read -p "[yes | default:no]" yn
			if [ "$yn" == "yes" -o "$yn" == "y" ];then
				sed -i 's/BOOTPROTO.*/BOOTPROTO=dhcp/g' $add
				mm=` grep "BOOTPROTO=" $add ` ;printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
				grep "IPADDR=" $add &>/dev/null && sed -i "s/IPADDR=.*/IPADDR=/g" $add
				grep "NETMASK=" $add &>/dev/null && sed -i "s/NETMASK=.*/NETMASK=/g" $add
				grep "GATEWAY=" $add &>/dev/null && sed -i "s/GATEWAY=.*/GATEWAY=/g" $add
				grep "DNS1=" $add &>/dev/null && sed -i "s/DNS1=.*/DNS1=/g" $add
				grep "DNS2=" $add &>/dev/null && sed -i "s/DNS2=.*/DNS2=/g" $add
				network_restart
			fi
			break
			;;
			*)mm=` grep "BOOTPROTO=" $add ` ;printf  "%-40s\t\t\e[32m[default]\e[0m\n" "$mm"
			break
			;;
		esac
	else
		echo -e "\e[33minput error\e[0m"
	fi
done
}

#设置IP是否开机自启
ONBOOT_fun (){
printf "\e[33mtarget file : %s\e[0m\n" "$add" #显示当前操作对象
mm=0
while true 
do
	read -p "ONBOOT=[ yes | no ] :" aa
	if [ -z "$aa" -o "$aa" == "yes" -o "$aa" == "no" ];then
		case $aa in
			yes)
			read -p "[yes | default:no]" yn
			if [ "$yn" == "yes" -o "$yn" == "y" ];then
				sed -i 's/ONBOOT=.*/ONBOOT=yes/g' $add &>/dev/null
				mm=` grep "ONBOOT=" $add ` ;printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
				network_restart
			fi
			break
			;;
			no)
			read -p "[yes | default:no]" yn
			if [ "$yn" == "yes" -o "$yn" == "y" ];then
				sed -i 's/ONBOOT=.*/ONBOOT=no/g' $add &>/dev/null
				mm=` grep "ONBOOT=" $add ` ;printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
				network_restart
			fi
			break
			;;
			*)mm=` grep "ONBOOT=" $add ` ;printf  "%-40s\t\t\e[32m[default]\e[0m\n" "$mm"
			break 
			;;
		esac
	else 
		echo -e "\e[33minput error\e[0m"
	fi
done
}
#判断输入的IP是否正确，正确或空返回0，错误返回1
ip_pd (){
if [ -n "$1" ];then
echo "$1"| \
egrep "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$" &>/dev/null
	if [ $? -eq 0 ];then
		return 0
	else
		echo -e "\e[33minput error\e[0m"
		return 1
	fi
else
	return 0
fi
}
#设置具体IP
addip (){
#检测是否为dhcp模式
grep "BOOTPROTO=dhcp" $add &>/dev/null
if [ $? -eq 0 ];then
	printf "\e[33mBOOTPROTO=dhcp\e[0m\n"
else
#非dhcp模式设置ip
	printf "\e[33mtarget file : %s\e[0m\n" "$add" #显示当前操作对象
	mm=0
	while true
	do	
		echo -en "Please input IPADDR\t:" ; read  ip
		ip_pd "$ip"
		if [ $? -eq 0 ];then
			break 
		fi
	done
	while true
	do
		echo -en "Please input NETMASK\t:" ; read mask
		ip_pd "$mask"
		if [ $? -eq 0 ];then
			break
		fi
	done
	while true
	do
		echo -en "Please input GATEWAY\t:" ; read  eway
		ip_pd "$eway"
		if [ $? -eq 0 ];then
			break
		fi
	done
	while true
	do
		echo -en "Please input DNS1\t:" ; read dns1
		ip_pd "$dns1"
		if [ $? -eq 0 ];then
			break
		fi
	done
	while true
	do
		echo -en "Please input DNS2\t:" ; read dns2
		ip_pd "$dns2"
		if [ $? -eq 0 ];then
			break
		fi
	done

	echo -ne " [yes | default:no]:" ;read yn
	if [ "$yn" == "yes" -o "$yn" == "y" ];then
		grep "IPADDR=" $add &>/dev/null && sed -i "s/IPADDR=.*/IPADDR=$ip/g" $add || echo "IPADDR=$ip" >> $add
		grep "NETMASK=" $add &>/dev/null && sed -i "s/NETMASK=.*/NETMASK=$mask/g" $add || echo "NETMASK=$mask" >> $add
		grep "GATEWAY=" $add &>/dev/null && sed -i "s/GATEWAY=.*/GATEWAY=$eway/g" $add || echo "GATEWAY=$eway" >> $add
		grep "DNS1=" $add &>/dev/null && sed -i "s/DNS1=.*/DNS1=$dns1/g" $add || echo "DNS1=$dns1" >> $add
		grep "DNS2=" $add &>/dev/null && sed -i "s/DNS2=.*/DNS2=$dns2/g" $add || echo "DNS2=$dns2" >> $add
	fi

	mm=`grep "IPADDR=" $add`  && printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
	mm=`grep "NETMASK=" $add` && printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
	mm=`grep "GATEWAY=" $add` && printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
	mm=`grep "DNS1=" $add`    && printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
	mm=`grep "DNS2=" $add`    && printf  "%-40s\t\t\e[32m[ok]\e[0m\n" "$mm"
		
	network_restart
fi
}
#******************************************************************************************************************
#iptables
close_iptables (){

	iptables -F
	service iptables stop
	chkconfig iptables off
}
#******************************************************************************************************************
close_selinux (){
echo -ne "close_selinux"
echo -ne "\e[36m[q]\e[0mquit \e[36m[m]\e[0mmenu \e[36m[1]\e[0mtemporary\e[36m[2]\e[0mpermanent:" ; read in

temporary (){
	echo -ne " [yes | default:no]:" ;read yn1
	if [ "$yn1" == "yes" -o "$yn1" == "y" ];then
		setenforce 0
	fi
#setenforce 0
}
permanent (){
	echo -ne "[yes | default:no]:" ;read yn2
	if [ "$yn2" == "yes" -o "$yn2" == "y" ];then
		sed -i "s/SELINUX=.*/SELINUX=disabled/g" /etc/selinux/config
	fi
}
case $in in
	1) temporary
	;;
	2) permanent
	;;
	q) exit
	;;
	m) menu
	;;
	*) close_selinux
	;;
esac
echo -ne "now reboot system [yes | default:no]:" ;read yn3
if [ "$yn3" == "yes" -o "$yn3" == "y" ];then
	shutdown -r now
fi
}
open_selinux (){
echo -ne "[yes | default:no]:" ;read oyn
if [ "$oyn" == "yes" -o "$pyn" == "y" ];then
	sed -i "s/SELINUX=.*/SELINUX=enforcing/g" /etc/selinux/config
fi

echo -ne "now reboot system [yes | default:no]:" ;read ynn
if [ "$ynn" == "yes" -o "$ynn" == "y" ];then
	shutdown -r now
fi
}
#===================网卡二级主菜单===============================
menu_network (){
while true
do
printf "MENU_network \e[36m[q]\e[0mquit \e[36m[m]\e[0mMENU "
printf "\e[36m[1]\e[0mBOOTPROTO \e[36m[2]\e[0mONBOOT \e[36m[3]\e[0mSETIP :"
read in_net
case $in_net in
	1) BOOTPROTO_fun ; menu_network
	;;
	2) ONBOOT_fun ; menu_network
	;;
	3) addip ; menu_network
	;;
	m) menu
	;;
	q) exit
	;;
	*) menu_network
	;;
esac
done
}
#===================防火墙二级菜单===============================
menu_iptables (){
while true
do
printf "MENU_iptables \e[36m[q]\e[0mquit \e[36m[m]\e[0mMENU "
printf "\e[36m[1]\e[0mclose iptables :"
read in_les
case $in_les in
	1) close_iptables ; menu_iptables
	;;
	m) menu
	;;
	q) exit
	;;
	*) menu_iptables
	;;
esac
done
}
#===================selinux二级菜单===============================
menu_selinux (){
while true
do
printf "MENU_SElinux \e[36m[q]\e[0mquit \e[36m[m]\e[0mMENU "
printf "\e[36m[1]\e[0mclose selinux \e[36m[2]\e[0mopen selinux :"
read in_les
case $in_les in
	1) close_selinux ; menu_selinux
	;;
	2) open_selinux ; menu_selinux
	;;
	m) menu
	;;
	q) exit
	;;
	*) menu_selinux
	;;
esac
done
}
#===================主菜单===============================
menu (){
while true
do
printf "MENU \e[36m[q]\e[0mquit \e[36m[1]\e[0mNETWORK \e[36m[2]\e[0mIPTABLES \e[36m[3]\e[0mSELinux:" ; read in_menu
case $in_menu in
	1) menu_network
	;; 
	2) menu_iptables
	;; 
	3) menu_selinux
	;; 
	q) exit
	;;
	*) menu
	;;
esac
done
}
#===================主程序===============================
menu









