#!/usr/bin/env python
# -*- coding:utf-8 -*-
import os
import time

BASE_DIR = os.path.abspath(os.curdir)
picture_path = os.path.join(BASE_DIR, "..", "objective")


def picture_rename(path, file_prefix, file_format='.jpg'):
    """
    原始名称：XHS_1630060700785b5ac650a-5583-319d-a433-3f5fdb4f339b.jpg
    Args:
        path: 照片的路径
        file_prefix: 待去除的文件名称时间戳前面的一部分
        file_format: 照片文件的格式
    Returns: 旧名称和新名称对应的列表
    """
    file_name_list = []
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
            name = str(file)
            # 取秒时间戳
            a = name.strip(file_prefix).strip(file_format)[0:10]
            # 取毫秒
            b = name.strip(file_prefix).strip(file_format)[10:13]
            time_array = time.localtime(int(a))
            other_style_time = time.strftime("%Y%m%d_%H%M%S", time_array)
            new_name = "IMG_" + other_style_time + "." + b + "." + name.split(".")[1]
            file_name_list.append([file, new_name])
    return file_name_list


if __name__ == '__main__':
    name_list = picture_rename(picture_path, 'XHS_', '.jpg')
    for item in name_list:
        print(item)

    in_content = "N"
    try:
        """兼容Python 2和Python 3的input代码"""
        in_content = raw_input("Confirm whether to change the name [y/Y/N, default N]: ")
    except NameError:
        in_content = input("Confirm whether to change the name [y/Y/N, default N]: ")
    if in_content == "Y" or in_content == "y":
        for i in name_list:
            n0, n1 = os.path.join(picture_path, i[0]), os.path.join(picture_path, i[1])
            # 改名 os.rename(旧名称, 新名称)
            os.rename(n0, n1)
            print(n1)
