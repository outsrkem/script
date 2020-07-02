#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# 文件名更改脚本
import os
# 获取当前目录位置
BASE_DIR = os.path.abspath(os.curdir)
path = os.path.join(BASE_DIR)
# 原始文件名   9.009-xxxxx-xxxxxxx-结构说明
# 处理后文件名  9.009-结构说明
for file in os.listdir(path):
    #判断是否是文件
    if os.path.isfile(os.path.join(path,file))==True:
        name = str(file)
        # 指定分隔符截取字符串
        Time = str(os.path.getmtime(file))
        print(Time)
        a_name = '-'.join(name.split('-')[0:1])
        b_name = '-'.join(name.split('-')[3:])
        name = a_name + '-' + b_name
        new_name = name
        oldname = os.path.join(path, file)
        newname = os.path.join(path, new_name)
        # os.rename(oldname, newname)