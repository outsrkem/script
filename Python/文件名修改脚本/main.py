# -*- coding:utf-8 -*-
# 文件名修改
import os
import string
import time
import random

name_list = []
BASE_DIR = os.path.abspath(os.curdir)
path = os.path.join(BASE_DIR, "..", "objective")

for file in os.listdir(path):
    if os.path.isfile(os.path.join(path, file)):
        name = str(file)
        Time = str(os.path.getmtime(os.path.join(path, file)))
        timeStamp = int(Time.split(".")[0])
        timeArray = time.localtime(timeStamp)
        otherStyleTime = time.strftime("%Y%m%d_%H%M%S", timeArray)
        r_n = ("".join(random.choices(string.digits, k=3)))
        new_name = "IMG_" + otherStyleTime + "." + r_n + "." + name.split(".")[-1]
        oldname = os.path.join(path, file)
        newname = os.path.join(path, new_name)
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
