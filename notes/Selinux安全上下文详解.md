# Selinux安全上下文详解

## SELinux介绍

selinux 有一下特点：
		1、防篡改
		2、无旁路
		3、可验证

### DAC  和 MAC

- DAC：自由访问控制。环境下进程是无束缚的

- MAC:  强制访问控制。环境下策略的规则决定控制的严格程度，环境下进程可以被限制

策略被用来定义被限制的进程能够使用哪些资源（文件和端口）默认情况下，没有被明确允许的行为将被拒绝。

![1542888628953754.png](.\images\1542888628953754.png)

### Selinux策略

对象：所有可以读取的对象，包括文件、目录和进程、端口等称之为对象（object）

主体：进程称为主体（subject）

Selinux中所有的文件都赋予一个type的文件类型标签，对于所有的进程也赋予格子衣domain的标签。domain标签能够执行的操作由安全策略里定。

当一个subject试图访问一个object，Kernel中的策略执行服务器将检查AVC(访问矢量缓存Access Vector Cache)，在AVC中，subject和object的权限被缓存，查找“应用+文件”的安全环境。然后根据查询结果允许或拒绝访问

安全策略：定义主体读取对象的规则类数据库，规则中记录了哪个类型的主体使用哪个方法读取哪一个对象是允许还是拒绝，并且定义了哪种行为是允许或拒绝。

### Selinux安全上下文

传统Linux,一切接文件，由用户，组，权限控制访问

 在Selinux中，一切皆对象（object），由存放在inode的扩展属性域的安全元素所控制其访问

所有文件和端口资源和进程都具备安全标签：安全上下文（security context）

安全上下文有五个安全元素组成：user:role:type:sensitivity:category。如 user_u:object_r:tmp_t:s0:c0

实际上下文：存放在文件系统中，ls -Z;ps -Z可以查看详细信息

期望（默认）上下文：存放在二进制的SElinux策略库（映射目录和期望安全上下文），可使用如下命令查看：

```\
semanage fcontext -l
```

#### 五个安全元素

（1）User：指示登录系统的用户类型，如root,user_u,system_u,多数本地进程都属于自由（unconfined）进程

（2）Role：定义文件，进程和用户的用途：文件：object_r,进程和用户：system_r

（3）Type：指定数据类型，规则中定义何种进程类型访问何种文件Target策略基于type实现，多服务公用：public_conten_t

（4）Sensitivity：限制访问的需要，由组织定义的分层安全级别，如unclassified，secret,top,secret，一个对象有且只要一个sensitivity,分0-15级，s0最低，Target策略默认使用s0

（5）Category：对于特定组织划分不分层的分类，如FBI Secret，NSA secret,一个对象可以有多个catagroy,c0-c1-23共1024个分类，Target策略不适用category

### Selinux配置文件

```
/etc/sysconfig/selinux(是一个符号链接,指向/etc/selinux/config)
-rw-r--r--. 1 root root 545 2017-10-15 23:21:40 /etc/selinux/config
```

## Selinux 相关操作

### Selinux常用工具

#### 查看相关命令

```
# 查询当前 selinux 状态（详细）
sestatus –v
# 获取当前 selinux 状态
getenforce
# 临时开启（0 关闭）
setenforce 1
# 查看文件的 selinux 类型
ls –Z
```

#### 修改文件安全上下文

```
chcon [OPTION]... CONTEXT FILE...
chcon [OPTION]... [-u USER] [-r ROLE] [-l RANGE] [-t TYPE] FILE...
chcon [OPTION]... --reference=RFILE FILE...
```

说明：

```
CONTEXT		为要设置的安全上下文
FILE		对象（文件、端口等）
options	 选项：
    -f 		强制修改
    -h 		修改软连接，不修改软连接对应的实际文件
    -R 		递归修改对象的安全上下文
    -r  	后面接角色，例如 system_r
    -t  	后面接安全性本文的类型字段,例如 var_log_t
    -u  	后面接身份识别，例如 system_u
如设置log目录的上下文：
chcon -R -t httpd_log_t  /usr/local/nginx/logs
```

如果selinux策略的数据库中有对应的标签类型，使用restorecon后面跟/var/log/message直接恢复即可

```
# semanage fcontext -l |grep /var/log/message
/var/log/messages[^/]*     all files   system_u:object_r:var_log_t:s0
# restorecon -Frvv /var/log/message
```

我们可以直接将标签加到selinux的安全策略库中，这样以后所有在该目录下创建的文件都会自动打上标签，这个定义将存储在/etc/selinux/targeted/contexts/files/file_contexts中。这样更改将是持久的。这可以通过查看文件来验证。

```
semanage fcontext -a -t httpd_log_t '/usr/local/nginx/logs(/.*)?'
```

根据新定义，运行以下命令递归设置logs上下文，该命令要求启用selinux才能使用

```
restorecon -Frvv /usr/local/nginx/logs
```



### Selinux端口标签

查看端口标签

```
semanage port -l
```

添加端口（需启用selinux）

```
semanage port -a -t [port_label] -p [tcp|upd] [PORT]
semanage port -a -t http_port_t -p tcp  8998
```

删除端口

```
semanage port -d -t [port_lable] -p [tcp|udp] [PORT]
semanage port -d -t http_port_t -p tcp 8998
```

修改现有端口为新标签

```
semanage port -m -t [port_lable] -p [tcp|udp] [PORT]
semanage port -m -t http_port_t -p tcp 8998  
```

### Selinux的布尔值

SEliux 布尔值就相当于一个开关，精确控制 SElinux 对某个服务的某个选项的保护，比如 samba 服务命令列出系统中可用的 SELinux 布尔值。

查看命令

```
getsebool -a
semanage boolean -l
semanage boolean -l -C 查看修改过的布尔值
```

修改命令

```
命令用来改变 SELinux 布尔值
# setsebool -P 参数
如开启家目录是否能访问的控制 ：
samba_create_home_dirs --> off 默认值
# setsebool -P samba_enable_home_dirs=1  开启家目录共享所有权限
samba_export_all_ro --> off 默认值
# setsebool -P samba_export_all_ro=1  修改用户家目录samba的布尔值为只读（须关闭家目录共享所有权限）
# setsebool -P samba_export_all_ro on 同上一条，也是开启
```

做安全上下文。所有客体（文件、进程间通讯通道、套接字、网络主机等）和主体（进程）都有与其关联的安全上下文，一个

### 进程的selinx上下文

设置执行命令的上下文，使用systemctl命令启动服务，进程会获得selinx上下文。



