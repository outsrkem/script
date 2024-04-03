#!/usr/bin/env python
# -*- coding:utf-8 -*-
import os
import time

BASE_DIR = os.path.abspath(os.curdir)
picture_path = os.path.join(BASE_DIR, "..", "objective")


def picture_rename(path, file_prefix, file_format):
    """
    原始名称：_storage_emulated_0_Android_data_com.huawei.smarthome_files_iotplugin_ScreenShots_12884956430_2023_07_29_08_57_29_091.jpeg
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
            # 获取时间：20230729085729091
            f_time = name.replace(file_prefix, '').replace(file_format, '').replace('_', '')
            # 取年月日：20230729
            a = f_time[0:8]
            # 取时间
            b = f_time[8:14]
            # 取毫秒
            c = f_time[14:17]
            # 最终名称：IMG_20230729085729.091.jpeg
            new_name = "IMG_%s_%s.%s%s" % (a, b, c, file_format)
            file_name_list.append([file, new_name])
    return file_name_list


if __name__ == '__main__':
    name_list = picture_rename(picture_path,
                               '_storage_emulated_0_Android_data_com.huawei.smarthome_files_iotplugin_ScreenShots_12884956430_',
                               '.jpeg')
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
