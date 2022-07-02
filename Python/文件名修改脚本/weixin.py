# -*- coding:utf-8 -*-
# Python 3.7.9
# 微信保存的图片名批量修改
# 在脚本的上级目录新建objective目录： ../objective
# 把图片放在 ../objective 目录中，运行脚本即可
# 支持的原始文件名：  mmexport1633439280253.jpg
# 修改后的文文件名：  IMG_20211005_210800.253.jpg

import os
import time

name_list = []
BASE_DIR = os.path.abspath(os.curdir)
path = os.path.join(BASE_DIR, "..", "objective")
for file in os.listdir(path):
    if os.path.isfile(os.path.join(path, file)):
        # 原始文件名  mmexport1640605722279.jpg
        name = str(file)
        # 文件秒时间戳
        Time = str(os.path.getmtime(os.path.join(path, file)))

        # 秒时间戳
        a = name.strip("mmexport").strip(".jpg")[0:10]
        # 取毫秒
        b = name.strip("mmexport").strip(".jpg")[10:13]
        timeArray = time.localtime(int(a))
        otherStyleTime = time.strftime("%Y%m%d_%H%M%S", timeArray)
        new_name = "IMG_" + otherStyleTime + "." + b + "." + name.split(".")[-1]
        name_list.append([file, new_name])

if __name__ == '__main__':
    in_content = "N"
    for i in name_list:
        print(i)
    in_content = input("Confirm whether to change the name [y/Y/N, default N]: ")
    if in_content == "Y" or in_content == "y":
        for i in name_list:
            old_name = os.path.join(path, i[0])
            new_name = os.path.join(path, i[1])
            # 改名
            os.rename(old_name, new_name)
            print(new_name)
