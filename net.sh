#!/bin/sh
rm -rf evoc.txt
rm -rf bus.txt
rm -rf lan.txt
total=`lspci|grep Ethernet|wc -l`
for((i=0;i<$total;i++))
do
	ethtool -p eth$i &
	echo "please input LAN number:"
	read n
	echo "$n eth$i" >>lan.txt
	killall ethtool
done

cat lan.txt |sort -n >>evoc.txt
rm -rf tmp.txt
cat evoc.txt|awk '{print $2}' >> bus.txt
rm -rf /usr/lib/udev/rules.d/71-biosdevname.rules
for eth in `cat bus.txt`
do 
 ethtool -i $eth |grep bus-info|awk '{print $2}'>>tmp.txt
done

name1=`cat tmp.txt|wc -l`
declare -i N
for((i=0;i<$name1;i++))
do
	N=$i+1
	name=`cat tmp.txt|sed -n  ''"${N}"'p'`
echo	ACTION==\"add\", SUBSYSTEM==\"net\", DRIVERS==\"?*\", KERNELS==\"$name\", NAME=\"eth$i\" >>/usr/lib/udev/rules.d/71-biosdevname.rules
done


rm -rf evoc.txt
rm -rf bus.txt
rm -rf lan.txt
