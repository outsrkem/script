#!/bin/bash
 #***************************************
 #   批量解压缩
 #   Batch decompression
 #   981789763@qq.com
 #   2019-07-11 
 #***************************************
function jdt(){
    #进度条打印, $1 当前的个数, $2 总文件数
    str=""
    #(($((${1}*100/${2}))/2)) ， 长度/2是为了只打印1/2的进度条
    for ((x=0;x<=$(($((${1}*100/${2}))/2));x++))
    do
        str+="="
    done
    printf "[\e[036m%-51s\e[0m] %d%% \r" "$str" "$((${1}*100/${2}))"   #$((${1}*100/${2}))计算出百分比
}
#=========================================
function jys(){
    case $1 in
    *.tar.*) tar -xf $1 >/dev/null 2>&1
    ;;
    *.tar) tar -xf $1 >/dev/null 2>&1
    ;; 
    *.tgz) tar -xf $1 >/dev/null 2>&1
    ;;
    *.zip) unzip -o $1 >/dev/null 2>&1
    ;;
    *.gz) gunzip  $1 >/dev/null 2>&1
    ;;
    *.bz2) bzip2 -d $1 >/dev/null 2>&1
    ;;  
    *) return 1
    ;;
    esac
}
#========================================
function main (){
    m=1
    cd $1 #$1为压缩包目录
    file=(`ls |grep -E ".tar|.tgz|.gz|.bz2|.zip"`)
    printf "当前解压路径：%s ,共%d个压缩包\n" "$1" "${#file[*]}"    
    for file_name in ${file[*]}
    do
        jys $file_name
        jdt $m ${#file[*]}
        let m+=1
    done
    mkdir src
    find . -maxdepth 1 -type f -exec mv {} ./src \; &>/dev/null 
    echo -e
}
#------------------
if [ -n "$1" ];then 
    main $1
else
    echo "Enter the absolute path to decompression after the script"
fi