import os

from pyexiv2 import Image

DateTimeOriginal = ""
BASE_DIR = os.path.abspath(os.curdir)
path = os.path.join(BASE_DIR, "objective")

exif_dict = {}

exif_image_datetime = ''

for file in os.listdir(path):
    if os.path.isfile(os.path.join(path, file)):
        name = str(file)
        y = name.split("_")[1]
        t = name.split("_")[2].split(".")[0]
        exif_image_datetime = y[0:4] + ":" + y[4:6] + ":" + y[6:8] + ' ' + t[0:2] + ":" + t[2:4] + ":" + t[4:7]
        print(exif_image_datetime)
        img = Image(os.path.join(path, file))
        print(img.read_exif())
        exif_dict['Exif.Image.DateTime'] = exif_image_datetime
        exif_dict['Exif.Photo.DateTimeOriginal'] = exif_image_datetime
        exif_dict['Exif.Photo.DateTimeDigitized'] = exif_image_datetime
        img.modify_exif(exif_dict)
        print(img.read_exif())

