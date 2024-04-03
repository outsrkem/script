#!/usr/bin/env python
# -*- coding:utf-8 -*-
import os
import time

BASE_DIR = os.path.abspath(os.curdir)
picture_path = os.path.join(BASE_DIR, "..", "objective")


def picture_rename(path, file_prefix, file_format):
    """
    原始名称：Screenshot_20240308_110832.jpg
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
            # 获取时间（这个没有毫秒）：20240308110832
            f_time = name.replace(file_prefix, '').replace(file_format, '').replace('_', '')
            # 取年月日：20230729
            a = f_time[0:8]
            # 取时间
            b = f_time[8:14]
            # 取毫秒，从文件秒时间戳
            f_mtime = str(os.path.getmtime(os.path.join(path, file))).split(".")[1]
            """不足3位的补齐3位"""
            if len(f_mtime) == 1:
                f_mtime += '00'
            if len(f_mtime) == 2:
                f_mtime += '0'
            c = f_mtime
            # 最终名称：IMG_20230729_085729.091.jpeg
            new_name = "IMG_%s_%s.%s%s" % (a, b, c, file_format)
            file_name_list.append([file, new_name])
    return file_name_list


if __name__ == '__main__':
    name_list = picture_rename(picture_path, 'Screenshot_', '.jpg')
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
