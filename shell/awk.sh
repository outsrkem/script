#/bin/bash
# Sat Oct 12 19:50:27 CST 2019
# 慢慢学习awk
# 
awk 'BEGIN{
for(i=1;i<=9;i++)
    {
        for(j=1;j<=9;j++)  
        {
            tarr[i,j]=i*j;
            print i,"*",j,"=",tarr[i,j];
        }
    }
}'
awk 'BEGIN{
for(i=1;i<=9;i++)
    {
        for(j=1;j<=9;j++)  
        {
            printf i,"*",j;
        }
    }
}'
# awk 打印 99乘法表 
awk 'BEGIN{
for(i=1;i<10;i++) 
    {
        for(j=1;j<=i;j++) 
        {
            printf "%d%s%d%s%d\t",j,"*",i,"=",i*j;
        }
        printf "\n"
    }
}'
# awk 浮点计算
aa=20645
bb=102.4
awk -v m1=$aa -v m2=$bb 'BEGIN{
    num = m1/m2;
    print m1;
    print m2;
    print num;
    printf "%.9f\n", num;
}'

# awk 计算器
firstNum=20645
secondNum=102.4
ss=`awk -v m1=$firstNum -v m2=$secondNum 'BEGIN{num = m1/m2; printf "%.9f\n", num;}'`

function calculator(){
    result=`awk -v firstNum=$1 -v secondNum=$2 'BEGIN{num = firstNum/secondNum; printf "%.9f\n", num;}'`
echo $result
}
calculator 20645 102.4
