#!/bin/bash
# 2019‎年‎10‎月‎8‎日
# Delete duplicated files in one directory recursively
# 查找重复文件
# https://blog.csdn.net/qingruoshui/article/details/12947633
# 如果需要对找到的文件进行其他操作请自行替换 tar -c "$longNameFileWithPath" | tar x -C "$targetDirectory" 这一句。

 
function ergodicFolder(){
  for file in `ls "$1" | tr " " "\?"`; do
    file=`tr "\?" "\ " <<<$file`
    local currentDirectory=$1
    
    if [ -d "$currentDirectory/$file" ];then
        ergodicFolder "$currentDirectory/$file"
        else
            currentDirectory=$1
            #local path="$1""/" #get the full directory of the file
            local sourceFile="$file" #get the file names    
            echo "###Processing in directory: $currentDirectory"
        
        for file2 in `ls "$currentDirectory" | tr " " "\?"`; do
            file2=`tr "\?" "\ " <<<$file2`
            local targetFile="$file2"
            local innerPath="$currentDirectory"   
            # If the target file and source file exist
            if [ -f "$innerPath/$targetFile" ]&&[ -f "$innerPath/$sourceFile" ];then
                #skip the same file
                if [ "$targetFile" == "$sourceFile" ];then 
                    continue
                fi

                #skip the directory
                if [ -d "$innerPath/$targetFile" ]
                    then
                    #delete recursively
                    #ergodicFolder "$innerPath$targetFile"
                    continue
                fi


                #compare and delete the same file which has long name 
                if [ "`cmp "$innerPath/$sourceFile" "$innerPath/$targetFile"`" == "" ];then
                    echo "***(""$innerPath/$sourceFile"") is as same as (""$innerPath/$targetFile"")"
                    local longNameFileWithPath="$innerPath/$sourceFile" 

                    if [ `expr length "$sourceFile"` -ge `expr length "$targetFile"` ];then
                        longNameFileWithPath="$innerPath/$sourceFile" 
                    else
                        longNameFileWithPath="$innerPath/$targetFile" 
                    fi

                    tar -c "$longNameFileWithPath" | tar x -C "$targetDirectory"
                    echo "delete file:"$longNameFileWithPath" -------"
                    rm "$longNameFileWithPath"
                fi
            fi
        done
    
    fi
  done
}
 
if [ ! -d "`pwd`/DuplicatedFiles" ];then
    mkdir "`pwd`/DuplicatedFiles"
fi
targetDirectory="`pwd`/DuplicatedFiles"
ergodicFolder "$1"
