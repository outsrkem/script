#!/usr/bin/python
#-*- coding=utf-8 -*-
# coding=utf-8

import requests
import sys
import time
import urllib2
import os
import ssl
import json
import subprocess
import threading
import random

## get ali_docker projects
res = requests.get('https://master1g4.cs-cn-hangzhou.aliyun.com:18729/projects/', verify='/var/www/.docker/aliyun/mmh-docker/ca.pem', cert=('/var/www/.docker/aliyun/mmh-docker/cert.pem', '/var/www/.docker/aliyun/mmh-docker/key.pem'))
text=res.json()

def mkdir(path):  
    folder = os.path.exists(path)  
    if not folder:
        os.makedirs(path)
    else:  
        print "---  Not  folder!  ---"  
RanDomN=random.randint(1,22)
t1=time.strftime('%Y%m%d_%H%M%S',time.localtime(time.time()))
f1="/tmp/.getdockerinfo."+str(t1)+"_"+str(RanDomN)
mkdir(f1)
          


class myThread(threading.Thread):
	def __init__(self,i):
		threading.Thread.__init__(self)
		self.i=i
	def run(self):
		print_con(self.name,text,self.i)


def print_con(threadName,text,i):
	portss=""
	if text[i]['name'] == "acslogging" or text[i]['name'] == "acsmonitoring" or text[i]['name'] == "acsrouting" or text[i]['name'] == "acsvolumedriver" or text[i]['name'] == "elk-nginx" or text[i]['name'] == "golang-default" or text[i]['name'] == "jenkins":
		#continue
		sys.exit()
	file=f1+"/threads"+str(i)
	f=open(file,'a')
	f.write('')
	f.write("\n&nbsp;<b>*&nbsp;"+text[i]['name']+"&nbsp;")
	if text[i]['current_state'] == "running":
		f.write("<font color='green'>"+text[i]['current_state']+"</font></b><br>")
	else:
		f.write("<font color='red'>"+text[i]['current_state']+"</font></b><br>")
	f.write("<table border=1 cellspacing=0><tr style='color: #ffffff' bgcolor='#444444' align='center'><td width=230px><b>Container</b></td><td width=177px><b>&nbsp;Name</b></td><td width=108px><b>Docker IP</b></td><td width=62px><b>&nbsp;Port</b></td><td width=65px><b>Status</b></td><td><b><font size=1>UrlCheck(2.2s)</font></b></td><td width=132px><b>&nbsp;Version</b></td><td width=85px><b><font size=1>Refresh_Conf</font></b></td><td width=129px><b>Log</b></td><td width=112px><b>Thread Dump</b></td><td width=92px><b>&nbsp;&nbsp;Restart</b></td></tr>")
	for con_ser in range(0,len(text[i]['services'])):
		for con_id in text[i]['services'][con_ser]['containers'].keys():
			if text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.240":
				ddid="47.98.37.224#d1"
			elif text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.242":
				ddid="47.96.124.117#d2"
			elif text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.243":
				ddid="47.96.122.253#d3"
			elif text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.245":
				ddid="47.96.125.35#d4"
			elif text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.246":
				ddid="47.96.117.252#d5"
			elif text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.244":
				ddid="47.96.126.24#d6"
			elif text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.247":
				ddid="47.96.10.245#d7"
			elif text[i]['services'][con_ser]['containers'][con_id]['node'] == "172.16.190.251":
				ddid="47.99.133.233#d8"
			ddid_getip=str(ddid).split('#')[0]

			f.write("<tr><td bgcolor='e8e8e8' class=mip>"+text[i]['services'][con_ser]['containers'][con_id]['node']+"<font size='1' color='#575757'>("+ddid+")</font></td>")
			#print  text[i]['services'][con_ser]['containers'][con_id]['status'],

			### echo name
			CName=text[i]['services'][con_ser]['containers'][con_id]['name'].split('_')[2]
			f.write("<td bgcolor='e8e8e8' class=name>&nbsp;"+text[i]['name']+CName+"</td>")

			### echo docker ip
			f.write("<td bgcolor='e8e8e8' class=ip>"+text[i]['services'][con_ser]['containers'][con_id]['ip']+"</td>")

			### echo ports ###
			f.write("<td bgcolor='e8e8e8' class=port>")
			for con_p in  text[i]['services'][con_ser]['containers'][con_id]['ports'].keys():
				if text[i]['name'] == "jar-ons" or text[i]['name'] == "jar-timer":
					#f.write("<font color='#cccccc'>None</font>")
					portss="None"
				elif text[i]['name'] == "zk-cluster":
					#f.write("2181")
					portss="2181"
				else:
					if con_p == '22/tcp':
						continue
					portss=text[i]['services'][con_ser]['containers'][con_id]['ports'][con_p][0]['host_port']
				f.write("&nbsp;"+portss+" ")
					#f.write(text[i]['services'][con_ser]['containers'][con_id]['ports'][con_p][0]['host_port']+"&nbsp;")
			f.write("</td>")

			## echo status
			if text[i]['services'][con_ser]['containers'][con_id]['status'] == "running":
				f.write("<td bgcolor='e8e8e8' class=status><font color='green'>"+text[i]['services'][con_ser]['containers'][con_id]['status']+"</font></td>")
			else:
				f.write("<td bgcolor='e8e8e8' class=status><font color='red'>"+text[i]['services'][con_ser]['containers'][con_id]['status']+"</font></td>")

			## echo url_check
			f.write("<td bgcolor='e8e8e8'>")
			if text[i]['services'][con_ser]['containers'][con_id]['status'] == "running":
				if text[i]['name'] == "jar-ons" or text[i]['name'] == "jar-timer":
					f.write("None")
				else:
					url="http://"+text[i]['services'][con_ser]['containers'][con_id]['node']+":"+portss+"/health"
					if text[i]['name'] == "tomcat-ext":
						url="http://"+text[i]['services'][con_ser]['containers'][con_id]['node']+":"+portss+"/V1/gb/queryGoodsPrice.do"
					if text[i]['name'] == "nest-api":
						url="http://"+text[i]['services'][con_ser]['containers'][con_id]['node']+":"+portss+"/app/hello"
					if text[i]['name'] == "jar-gateway" or text[i]['name'] == "jar-promotion" or text[i]['name'] == "jar-service-order" or text[i]['name'] == "jar-domain-order" or  text[i]['name'] == "jar-api" or text[i]['name'] == "jar-stock" or text[i]['name'] == "jar-pay":
						url="http://"+text[i]['services'][con_ser]['containers'][con_id]['node']+":"+portss+"/actuator/info"
					if text[i]['name'] == "jar-pos" or text[i]['name'] == "jar-domain-thirdapi" or text[i]['name'] == "jar-ebiz-achievement" or text[i]['name'] == "jar-goods" or text[i]['name'] == "jar-user":
						url="http://"+text[i]['services'][con_ser]['containers'][con_id]['node']+":"+portss+"/actuator/health"
						
					
					#url="http://172.16.190.246:4444/health"
					#httpStatusCode=200

					try:
						request = requests.get(url,timeout=2.2)
						httpStatusCode = request.status_code
					except requests.exceptions.ConnectTimeout:
						httpStatusCode = 502
					except requests.exceptions.Timeout:
						httpStatusCode = 503
					except requests.exceptions.ConnectionError:
        					httpStatusCode=504

					if httpStatusCode == 200:
						f.write("&nbsp;<font color='green'>"+str(httpStatusCode)+"</font></b><br>")
					else:
						f.write("&nbsp;<font color='red'>"+str(httpStatusCode)+"</font></b><br>")
						
					#f.write(url)
			else:
				f.write("")
			f.write("</td>")
				

			### echo version ###
			f.write("<td bgcolor='e8e8e8' class=ver>&nbsp;")
			#f.write(text[i]['services'][con_ser]['containers'][con_id]['node'])
			child = subprocess.Popen(["ssh","root@"+text[i]['services'][con_ser]['containers'][con_id]['node'], "docker exec -u 0 -i",text[i]['services'][con_ser]['containers'][con_id]['name'].strip("/"),"cat /opt/jenkins_version"], stdout=subprocess.PIPE)
			out = child.stdout.readline()
			out1=out.replace("\n","")
			f.write(out1)
			#print "version"
			f.write("</td>")

			### echo refresh url
			f.write("<td bgcolor='e8e8e8'>")
			if text[i]['services'][con_ser]['containers'][con_id]['status'] == "running":
			    if text[i]['name'] == "jar-actsys" or text[i]['name'] == "jar-stock" or text[i]['name'] == "jar-ebiz-achievement" or text[i]['name'] == "jar-cart" or text[i]['name'] == "jar-goods" or text[i]['name'] == "jar-price" or text[i]['name'] == "jar-user" or text[i]['name'] == "jar-promotion" or text[i]['name'] == "jar-voucher" or text[i]['name'] == "jar-order" or text[i]['name'] == "jar-dss" or text[i]['name'] == "jar-crm" or text[i]['name'] == "jar-pay" or text[i]['name'] == "jar-stock" or text[i]['name'] == "jar-actsys" or text[i]['name'] == "jar-search":
				#f.write("<button type='button'>Click Me!</button>")
				url="http://"+ddid_getip+":"+portss+"/refresh"
				f.write("<font size=3><a href='http://svnpass.mamahao.com/cgi-bin/refresh_conf.cgi?URL="+url+"' target='_blank'>&nbsp;URL</a></font>")	
			    elif text[i]['name'] == "jar-pos" or text[i]['name'] == "jar-api" or text[i]['name'] == "jar-domain-order" or text[i]['name'] == "jar-service-order" or text[i]['name'] == "jar-domain-thirdapi":
				url="http://"+ddid_getip+":"+portss+"/actuator/refresh"
				f.write("<font size=3><a href='http://svnpass.mamahao.com/cgi-bin/refresh_conf.cgi?URL="+url+"' target='_blank'>&nbsp;URL</a></font>")	
			    else:
				f.write("None")	
			
        		f.write("</td>")


			### log
			f.write("<td bgcolor='e8e8e8'>")
			if text[i]['services'][con_ser]['containers'][con_id]['status'] == "running":
			    #child = subprocess.Popen(["ssh","root@"+text[i]['services'][con_ser]['containers'][con_id]['node'], "docker logs --tail 100",text[i]['services'][con_ser]['containers'][con_id]['name'].strip("/")], stdout=subprocess.PIPE)
			    #out = child.stdout.readline()
			    #out1=out.replace("\n","")
			    #f.write(out1)
			    line="250"
			    conid=text[i]['services'][con_ser]['containers'][con_id]['name'].strip("/")
			    url1="http://svnpass.mamahao.com/cgi-bin/docker_getlog.cgi?node="+text[i]['services'][con_ser]['containers'][con_id]['node']+"&conid="+conid+"&line="+line+"&modes=1"
			    url2="http://svnpass.mamahao.com/cgi-bin/docker_getlog.cgi?node="+text[i]['services'][con_ser]['containers'][con_id]['node']+"&conid="+conid+"&line="+line+"&modes=2"
			    f.write("<a href='"+url1+"' target='_blank'>Normal</a>&nbsp;&nbsp;")
			    f.write("<a href='"+url2+"' target='_blank'>Simplify</a>")
			
        		f.write("</td>")

			## thread dump
			f.write("<td bgcolor='e8e8e8'>")
			if text[i]['services'][con_ser]['containers'][con_id]['status'] == "running":
			    line2="10"
			    conid=text[i]['services'][con_ser]['containers'][con_id]['name'].strip("/")
			    url1="http://svnpass.mamahao.com/cgi-bin/dockerdump.cgi?node="+text[i]['services'][con_ser]['containers'][con_id]['node']+"&conid="+conid+"&mode=0&line="+line2
			    f.write("&nbsp;&nbsp;&nbsp;<a href='"+url1+"' target='_blank'>ALL</a>&nbsp;")
			    url2="http://svnpass.mamahao.com/cgi-bin/dockerdump.cgi?node="+text[i]['services'][con_ser]['containers'][con_id]['node']+"&conid="+conid+"&mode=1&line="+line2
			    f.write("&nbsp;&nbsp;<a href='"+url2+"' target='_blank'>Top10</a>&nbsp;")
        		f.write("</td>")

			## restart
			f.write("<td bgcolor='e8e8e8'>")
			if text[i]['services'][con_ser]['containers'][con_id]['status'] == "running":
			    f.write("&nbsp;<a href='DockerStop.cgi' target='_self'>Stop</a>&nbsp;&nbsp;")
			    f.write("<a href='DockerStart.cgi' target='_self'>Start</a>")
			f.write("</td></tr>")

	f.write("<table><br><br>")
	f.close()


threads=[]
for i in range(0,len(text)-1):
#for i in range(0,6):
	t=myThread(i)
	threads.append(t)


for t in threads:
        t.start()

for t in threads:
	t.join()


### output file
filelist=os.listdir(f1)
for item in filelist:
	os.system('cat '+f1+"/"+item)




## del file
os.system('rm -rf '+f1)


