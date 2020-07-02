#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 获取cpu型号
# 2018年9月5日
f=open('/proc/cpuinfo')
cpu={}
for line in f:
    if len(line.split(':')) == 2:
        cpu[line.split(':')[0].strip()] = line.split(':')[1].strip()
    else:
        cpu[line.split(':')[0].strip()] = ''
print(cpu['model name'])
