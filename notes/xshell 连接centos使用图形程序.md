# xshell 连接centos使用图形程序

安装测试程序

```shell
yum install xclock
```

安装x11软件组

```shell
yum -y groupinstall  "X Window System" "Fonts"
```

安装Xmanager组件。（官网下载即可）

![1605347219028](D:\linux\笔记\images\1605347219028.png)

报错问题

error: Can't open display:

原因：未开启转发x11转发。

/usr/bin/xauth:  file /root/.Xauthority does not exist

重新连接一个即可。