#!/usr/bin/env python
# -*- coding:utf-8 -*-
# 20190705



'''
# 列表推导式
data = [x*y for x in range(1,5) if x > 2 for y in range(1,4) if y < 3]
print(data)

# 他的执行顺序是:
list = []
for x in range(1,5):
    if x > 2:
        for y in range(1,4):
            if y < 3:
                list.append(x*y)

print(list)

'''






'''
list = ['xiaoZhang','xiaoLi','xiaoWang']
print(list[0])
print(list[1])
print(list[2])
#获取长度
len(list)
#遍历
for x in list:
    print(x)
'''




'''
print("*******if...else语句*********")
# if 条件为真的时候返回if前面内容，否则返回0
exp1 = lambda x: x + 1 if 2 == 1 else 0
print(exp1(2))
exp2 = lambda x: x + 1 if 1 == 1 else 0
print(exp2(2))

print("*******if not...else语句*********")
# if not 为假返回if not前面内容，否则返回0
exp3 = lambda x: x + 1 if not 2 == 1 else 0
print(exp3(2))

exp4 = lambda x: x + 1 if not 1 == 1 else 0
print(exp4(2))

'''




'''
for i in range(1,5):
    for j in range(1,5):
        for k in range(1,5):
            if( i != k ) and (i != j) and (j != k):
                print (i,j,k)

'''

'''
#实现矩阵相加
X = [
	[12,7,3],
    [4 ,5,6],
    [7 ,8,9]
	]
 
Y = [
	[5,8,1],
    [6,7,3],
    [4,5,9]
	]
 
result = [[0,0,0],[0,0,0],[0,0,0]]
 
# 迭代输出行
for i in range(len(X)):
   # 迭代输出列
   for j in range(len(X[0])):
       result[i][j] = X[i][j] + Y[i][j]
 
for r in result:
   print(r)
'''

'''
class Employee:
   '所有员工的基类'
   empCount = 0
 
   def __init__(self, name, salary):
      self.name = name
      self.salary = salary
      Employee.empCount += 1
   
   def displayCount(self):
     print ("Total Employee %d" % Employee.empCount)
 
   def displayEmployee(self):
      print ("Name : ", self.name,  ", Salary: ", self.salary)

"创建 Employee 类的第一个对象"
emp1 = Employee("Zara", 2000)
"创建 Employee 类的第二个对象"
emp2 = Employee("Manni", 5000)
emp1.displayEmployee()
emp2.displayEmployee()
print ("Total Employee %d" % Employee.empCount)
'''

'''


import time
ticks = time.time()
print ("当前时间戳为:", ticks)

import time
localtime = time.localtime(time.time()) #获取当前时间
print ("本地时间为 :", localtime)

import time
 
localtime = time.asctime( time.localtime(time.time()) )
print ("本地时间为 :", localtime)

#----------------------
import time
# 格式化成2016-03-20 11:45:39形式
print (time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))
# 格式化成Sat Mar 28 22:24:24 2016形式
print (time.strftime("%a %b %d %H:%M:%S %Y", time.localtime()))   
# 将格式字符串转换为时间戳
a = "Sat Mar 28 22:24:24 2016"
print (time.mktime(time.strptime(a,"%a %b %d %H:%M:%S %Y")))


#--------------------
import calendar
 
cal = calendar.month(2019, 6)
print ("以下输出2019年6月份的日历:")
print (cal)
#----------------------
import datetime
i = datetime.datetime.now()
print ("当前的日期和时间是 %s" % i)
print ("ISO格式的日期和时间是 %s" % i.isoformat() )
print ("当前的年份是 %s" %i.year)
print ("当前的月份是 %s" %i.month)
print ("当前的日期是  %s" %i.day)
print ("dd/mm/yyyy 格式是  %s/%s/%s" % (i.day, i.month, i.year) )
print ("当前小时是 %s" %i.hour)
print ("当前分钟是 %s" %i.minute)
print ("当前秒是  %s" %i.second)
'''

'''
dict = {}
dict['one'] = "This is one"
dict[2] = "This is two"
 
tinydict = {'name': 'john','code':6734, 'dept': 'sales'}
 
  
print (dict)          
print (dict['one'])          # 输出键为'one' 的值
print (dict[2])              # 输出键为 2 的值
print (tinydict)             # 输出完整的字典
print (tinydict.keys())      # 输出所有键
print (tinydict.values())    # 输出所有值
'''

'''
#元组是另一个数据类型，类似于 List（列表）。元组用 () 标识。内部元素用逗号隔开。但是元组不能二次赋值，相当于只读列表。
tuple = ( 'runoob', 786 , 2.23, 'john', 70.2 )
tinytuple = (123, 'john')
 
print (tuple)               # 输出完整元组
print (tuple[0])            # 输出元组的第一个元素
print (tuple[1:3])          # 输出第二个至第四个（不包含）的元素 
print (tuple[2:])           # 输出从第三个开始至列表末尾的所有元素
print (tinytuple * 2)       # 输出元组两次
print (tuple + tinytuple)   # 打印组合的元组


tuple = ( 'runoob', 786 , 2.23, 'john', 70.2 )
list = [ 'runoob', 786 , 2.23, 'john', 70.2 ]
print ("更改前")
print (tuple)
print (list)
print ("更改后")
list[2] = 1000     # 列表中是合法应用
#tuple[2] = 1000    # 元组中是非法应用，会报错
print (tuple)
print (list)
'''

'''
#Python 列表截取可以接收第三个参数，参数作用是截取的步长，以下实例在索引 1 到索引 4 的位置并设置为步长为 2（间隔一个位置）来截取字符串：
letters = ['a','b','c','d','e','f','g']
tinylist = [123, 'john']
print (letters[1:4:2])
print (letters)
print (letters[0])
print (letters[1:3])
print (letters[2:])
print (tinylist * 2)
print (letters + tinylist)


'''

'''
1.Numbers（数字）2.String（字符串）3.List（列表）4.Tuple（元组）5.Sets（集合）
Dictionary（字典）
'''

'''
#第一个python的九九乘法表
for a in range(1,10):
	for b in range(1,a+1):
		print ('%d*%d=%-2d'%(b,a,a*b),end='\t')
	print()

'''

"""
#计算10！
def getNums(num):
	if num>1:
		return num * getNums(num-1)
	else:
		return num
result = getNums(10)
print("10!=%d" %result)
"""

'''
print ("Hello, Python!")

'''

'''
namesList = ['小张','夏丽丽','张三']
length = len(namesList)
i = 0
while i<length:
	print(namesList[i])
	i+=1
	
'''

'''	
movieName = ['战狼 1','战狼 2','速 8','孙悟空','星球大战','异星觉醒']
print('------删除之前------')
for tempName in movieName:
	print(tempName)
del movieName[2]
print('------删除之后------')
for tempName in movieName:
	print(tempName)
'''

'''
def calculateNum(num):
	result = 0
	i = 1
	while i<=num:
		result = result + i
		i+=1
	return result
result = calculateNum(100)
print('1~100 的累积和为:%d'%result)
'''
