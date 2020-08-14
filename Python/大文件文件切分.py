#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os
class DocumentSegmentation:
    def __init__(self,srcpath, despath, mergepath, chunksize, filename):
        '''
        参数如下：
        :param srcpath:  待切分文件
        :param despath: 切分目标目录
        :param mergepath: 合并后保存的目录
        :param chunksize: 切分后文件的大小，（字节）
        :param filename: 文件名
        '''
        self.chunksize = chunksize
        self.srcpath = srcpath
        self.despath = despath
        self.mergepath = mergepath
        self.filename = filename
        self.mergeFilePath = os.path.join(self.mergepath, fileName)

    def splitFile(self):
        'split the files into chunks, and save them into despath'
        if not os.path.exists(self.srcpath):
            print("无源文件")
            os._exit(0)
        elif not os.path.exists(self.despath):
            os.mkdir(self.despath)
        chunknum = 0
        inputfile = open(self.srcpath, 'rb')  # rb 读二进制文件
        try:
            while 1:
                chunk = inputfile.read(self.chunksize)
                if not chunk:  # 文件块是空的
                    break
                chunknum += 1
                filename = os.path.join(self.despath, ("part--%04d" % chunknum))
                fileobj = open(filename, 'wb')
                fileobj.write(chunk)
        except IOError:
            print("read file error\n")
        finally:
            inputfile.close()
        return chunknum

    def mergeFile(self):
        '将src路径下的所有文件块合并，并存储到des路径下。'
        if not os.path.exists(self.despath):
            print("srcpath doesn't exists, you need a srcpath")
            os._exit(0)
        elif not os.path.exists(self.mergepath):
            os.mkdir(self.mergepath)
        files = os.listdir(self.despath)
        mergeFilePath = os.path.join(self.mergepath, fileName)
        with open(mergeFilePath, 'wb') as output:  # wb  二进制方式打开文件，只用于写入
            for eachfile in files:
                filepath = os.path.join(self.despath, eachfile)
                with open(filepath, 'rb') as infile:
                    data = infile.read()
                    output.write(data)


if __name__ == '__main__':
    fileName = "curl-7.20.0.tar.gz"
    chunkSize = 1024 * 1024 #默认单位字节
    BASE_DIR = os.path.join(os.path.abspath(os.curdir), 'file')
    filesPath = os.path.join(BASE_DIR, fileName)
    desPath = os.path.join(BASE_DIR, "binary")
    mergePath = os.path.join(BASE_DIR, "mergefile")

    test = DocumentSegmentation(filesPath ,desPath, mergePath, chunkSize, fileName)
    test.splitFile()
    test.mergeFile()
