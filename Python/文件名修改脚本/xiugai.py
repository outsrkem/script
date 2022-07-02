import os
import re
import string
import random

name_list = []
BASE_DIR = os.path.abspath(os.curdir)
path = os.path.join(BASE_DIR, "..", "objective")
for file in os.listdir(path):
    if os.path.isfile(os.path.join(path, file)):
        # 原始文件名  IMG_20190108_203408_4579.JPG
        name = str(file)
        # 文件秒时间戳
        Time = str(os.path.getmtime(os.path.join(path, file)))

        # 秒时间戳
        a = name[0:19]
        # 取毫秒
        b = name[20:23]
        if not re.findall('[0-9]', b):
            b = ("".join(random.choices(string.digits, k=3)))
        new_name = a + "." + b + "." + name.split(".")[-1]
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
