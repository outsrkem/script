#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 第一个求和程序
# 2018年9月5日
def sum(A, B):
    ss = (A + B) * (B / 2)
    print("%s" % ss)


a = input("a=")
b = input("b=")
sum(int(a), int(b))
