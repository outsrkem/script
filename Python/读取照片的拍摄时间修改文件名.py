import os

import exifread
import random

# 拍摄时间


DateTimeOriginal = ""
BASE_DIR = os.path.abspath(os.curdir)
path = os.path.join(BASE_DIR, "objective")
name_list = []


def fake_millisecond():
    """
    随机生产3位数毫秒
    :return: millisecond
    """
    return str(random.randint(0, 1000)).zfill(3)


for file in os.listdir(path):
    if os.path.isfile(os.path.join(path, file)):
        name = str(file)
        f = open(os.path.join(path, file), "rb")
        tags = exifread.process_file(f)
        # 如果存在拍摄时间在获取并修改
        if 'EXIF DateTimeOriginal' in tags.keys():
            DateTimeOriginal = str(tags['EXIF DateTimeOriginal'])
            # DateTimeOriginal： 2022:05:03 18:55:39
            otherStyleTime = DateTimeOriginal.replace(':', '').replace(' ', '_')
            # otherStyleTime: 20220503_185539
            new_name = "IMG_" + otherStyleTime + "." + name.split(".")[-1]
            name_list.append([file, new_name])
            f.close()

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
