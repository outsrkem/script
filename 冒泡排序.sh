#!/bin/bash
#***************************************
#   Bijianyong <981789763@qq.com>
#   冒泡排序
#   2018-07-31 
#***************************************
#abc=($a)
#统计数组长度
#d=${#abc[*]}
#echo "${abc[*]}"
#冒泡排序函数
paixu (){
abc=($@)
d=${#abc[*]}
max=0
echo "数组长度： $d"
echo "初始数组： ${abc[*]}"
#排序
for((i=1;i<$d;i++))
do
    for((x=0;x<=$[$d-1];x++))
    do
        if [ ${abc[$x]} -gt ${abc[$i]} ];then #0位和1位比较，大的放在1位
            max=${abc[$x]}
            abc[$x]=${abc[$i]}
            abc[$i]=$max
        fi
    done
    #let x+=1
done
echo "顺序数组： ${abc[*]}"
}
a="55 34 24 78 7 5 99 79"
paixu $a