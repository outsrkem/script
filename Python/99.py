#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 第一个python的九九乘法表
"""
i=[1,2,3,4,5,6,7,8,9]
s=[1]

for a in i:
    for b in s:
        c=a*b
        print ('%d*%d=%-2d'%(b,a,c),end='\t')
    print()
    m=a+1
    s.append(m)
"""

for a in range(1, 10):
    for b in range(1, a + 1):
        print('%dx%d=%-2d' % (b, a, a * b), end='\t')
    print()
