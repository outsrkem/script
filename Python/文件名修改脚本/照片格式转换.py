import os
from PIL import Image

name_list = []
BASE_DIR = os.path.abspath(os.curdir)
path = os.path.join(BASE_DIR, "..", "objective")
dirname_write = os.path.join(BASE_DIR, "..", "JPEGImages")
dirname_read = path

names = os.listdir(dirname_read)
print(names)
count = 0
for name in names:
    img = Image.open(os.path.isfile(os.path.join(path, name)))
    # name = name.split(".")
    # if name[-1] != "png":
    #     name[-1] = "jpg"
    #     name = str.join(".", name)
    #     print(name)
        # to_save_path = dirname_write + name
        # img.save(to_save_path)
        # count += 1
        # print(to_save_path, "------conut：", count)
    # else:
    #     continue
