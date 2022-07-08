#!/bin/bash
#======================================
#	打印内存当前的使用率
#	Bijianyong <981789763@qq.com>
#
#	2018-07-31 
#======================================

a=$(ps aux | awk 'NR>1{print $4}')
abc=($a)
sum=0
#sum_1=1
for i in ${abc[*]}
do
	#sum=`awk 'BEGIN{printf "%.5f\n",'$i'+'$sum'}'`
	sum=`echo "$sum+$i" | bc`
	
done

printf "%.2f%%\n" "$sum"
#echo $sum
