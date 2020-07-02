#!/usr/bin/env python3
# 这个脚本是可以用的
# -*- coding: UTF-8 -*-
# filename:test.py


from requests.auth import HTTPBasicAuth
import requests
import threading
import time


ser = ["mamahao-actsys-app","mamahao-app-api","sgffhffdgfdg","dafgdfhg"]
ject1 = ["pro","pre","dev","test"]
status = []


print ("Content-Type:text/html")
print ("")
print ("<html><head>")
print ("<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />")
print ("</head>")


print ("<table border=1 cellspacing=0><tr style='color: #ffffff' bgcolor='#444444' align='center'><td>Service</td><td>status</td><td>status</td><td>status</td><td>status</td></tr>")


def haha(i):
    for j in range(0,len(ject1)):
        url = "https://www.baidu.com/"
        requests.packages.urllib3.disable_warnings()
        geturl = requests.get(url=url,verify=False)
        status.append(geturl.status_code)
    print ("<tr>")
    print ("<td> %s </td>" % (ser[i]))
    for j in range(0,len(ject1)):
        print ("<td> %s %s </td>" % (ject1[j],status[j]))
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
print ("</html>")