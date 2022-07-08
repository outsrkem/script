#!/bin/bash
# 查找ll别名所在的文件.
# 20180706
# /etc/profile.d/colorls.sh
for f in `find /etc -type f`
do
    grep "ll='ls -l --color=auto'" $f &>/dev/null && echo $f
done