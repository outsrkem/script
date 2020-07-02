#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 2018年9月5日
import os, sys, time
while True: 
    time.sleep(2)
    ret = os.system('netstat -antp |grep httpd &>/dev/null')
    if int(ret)>2: 
        print ("errot")
        os.system('service httpd restart')
    else:
        print ("ok")
