#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import threading
import time


url="https://www.test.com/"


def down(x,url):
    url="https://www.test.com/"+"%s.jpg" %(x)
    print('x = %s \nurl = %s' %(x,url))
    time.sleep(3)


threads = []
for x in range(3):
    t=threading.Thread(target=down,args=(x,url,))
    threads.append(t)

# 打开线程活动
for thr in threads:
    thr.start()

# 等待所有线程完成
# join是阻塞当前线程(此处的当前线程时主线程) 
# 主线程直到Thread-1结束之后才结束
for thr in threads:
    thr.join()  