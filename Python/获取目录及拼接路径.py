#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os

# import kubernetes
# from kubernetes import client, config
# print(sys.path)
# 获取当前目录位置
BASE_DIR = os.path.abspath(os.curdir)
print(BASE_DIR)
# 对路径进行组合
# FILES_DIRS = os.path.join(BASE_DIR, 'conf', 'include', 'user.conf')
picAlt = 'data'
FILES_DIRS = os.path.join(BASE_DIR, "picAlt")

print(FILES_DIRS)
print(dir())
