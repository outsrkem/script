```
GetKey()
{
aKey=(0 0 0)
cESC=`echo -ne "\033"`
while : 
do
    read -s -n 1 key
    echo $key
    aKey[0]=${aKey[1]}
    aKey[1]=${aKey[2]}
    aKey[2]=$key
    if [[ "$key" == "" ]];then
        echo "enter"
    else
        if [[ ${aKey[0]} == $cESC && ${aKey[1]} == "[" ]]
        then
            #方向键判断
            if [[ $key == "A" ]];then echo KEYUP
                elif [[ $key == "B" ]];then echo KEYDOWN
                elif [[ $key == "D" ]];then echo KEYLEFT
                elif [[ $key == "C" ]];then echo KEYRIGHT
            fi
        fi
    fi
done
}


```