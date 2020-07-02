#!/usr/bin/env python3
# -*- coding: UTF-8 -*-
# filename:test.py


#from requests.auth import HTTPBasicAuth
import requests
import threading
import time
import urllib


ser = ["mamahao-actsys-app","mamahao-app-api","mamahao-domain-order","mamahao-domain-order"]
ject = ["pro","pre","dev","test"]
ject1 = ["pro","pre","dev","test"]


print ("<table border=1 cellspacing=0><tr style='color: #ffffff' bgcolor='#444444' align='center'><td>服务</td><td>status</td><td>status</td><td>status</td><td>status</td></tr>")


def haha(i):
    print ("<tr>")
    print ("<td> %s </td>" % (ser[i]))
    for j in range(0,len(ject1)):
        url = "https://www.baidu.com"
        geturl = requests.get(url=url)
        status = geturl.status_code
        #status=urllib.urlopen("https://www.baidu.com").code
        print ("<td> %s %s </td>" % (ject1[j],status))
        #print ("<td> %s %s </td>" % (ject1[j]))
    print ("</tr>")
threads = []
for x in range(0,len(ser)):
    t=threading.Thread(target=haha,args=(x,))
    threads.append(t)
for thr in threads:
    thr.start()
for thr in threads:
    thr.join()


print ("</table>")

