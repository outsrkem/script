# lvs + keepalived  高可用集群 HAC

### LVS 安装

#### 1. 内核模块检测

```shell
# 测试是否加载，如果没有得到任何信息，则已经加载
modprobe ip_vs
# 查看版本信息，以检测是否已经开始正常工作
cat /proc/net/ip_vs
```

#### 2. 安装 lvs 管理程序 和keepalived

```shell
yum -y install ipvsadm keepalived
```

####  3. 开启路由转发

```
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
sysctl -a |grep "net.ipv4.ip_forward"
```

#### 4. lvs 主节点配置keepalived

```shell
! Configuration File for keepalived
global_defs {
   router_id lvs-01   #router_id 机器标识
}
vrrp_instance VI_1 {            #vrrp实例定义部分
    state BACKUP                #设置lvs的状态，MASTER和BACKUP两种，必须大写 
    interface ens33             #设置对外服务的接口
    virtual_router_id 100       #设置虚拟路由标示，这个标示是一个数字，同一个vrrp实例使用唯一标示 
    priority 90                 #定义优先级，主服务器优先级高
	# nopreempt         # 表示设置为不抢夺VIP# state MASTER 需修改为 state BACKUP 
    advert_int 1                #设定master与backup负载均衡器之间同步检查的时间间隔，单位是秒
    authentication {            #设置验证类型和密码
        auth_type PASS          #主要有PASS和AH两种
        auth_pass 1111          #验证密码，同一个vrrp_instance下MASTER和BACKUP密码必须相同
    }
    virtual_ipaddress {         #设置虚拟ip地址，可以设置多个，每行一个
        10.10.10.222 dev ens33
    }
}

#设置虚拟服务器，需要指定虚拟ip和服务端口(lvs 端口必须要和后端服务相同)
virtual_server 10.10.10.222 80 {  
    delay_loop 6                     #健康检查时间间隔
    lb_algo rr                      #负载均衡调度算法
    lb_kind DR                       #负载均衡转发规则
    protocol TCP                     #指定转发协议类型，有TCP和UDP两种
	
	#设置后端服务器1
    real_server 10.10.10.23 80 {
        weight 1  
        inhibit_on_failure  # 表示在节点失败后，把他权重设置成0，而不在IPVS中删除，0表示失效
        TCP_CHECK {                    #realserver的状态监测设置部分单位秒
           connect_port 80             #连接端口为服务端口，要和上面的保持一致
           connect_timeout 3           #连接超时为10秒
           nb_get_retry 3                #重连次数
           delay_before_retry 3          #重试间隔
           }
    }
	#设置后端服务器2
    real_server 10.10.10.25 80 {
        weight 1
        inhibit_on_failure
        TCP_CHECK {
           connect_port 80
           connect_timeout 3
           nb_get_retry 3
           delay_before_retry 3
           }
    }
    # 后端服务器.....

}

```

#### 5 . lvs 从节点配置keepalived

```shell
! Configuration File for keepalived
global_defs {
   router_id lvs-02
}
vrrp_instance VI_1 {
    state BACKUP
    interface ens33
    virtual_router_id 100
    priority 30		# 差值大于 50 切换会快
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        10.10.10.222 dev ens33
    }
}
virtual_server 10.10.10.222 80 {
    delay_loop 6
    lb_algo rr
    lb_kind DR
    protocol TCP

    real_server 10.10.10.23 80 {
        weight 1
        inhibit_on_failure
        TCP_CHECK {
           connect_port 80
           connect_timeout 3
           nb_get_retry 3
           delay_before_retry 3
           }
    }

    real_server 10.10.10.25 80 {
        weight 1
        inhibit_on_failure
        TCP_CHECK {
           connect_port 80
           connect_timeout 3
           nb_get_retry 3
           delay_before_retry 3
           }
    }
}
```

#### 6. 启动keepalived

```shell
systemctl start keepalived.service
systemctl status keepalived.service
systemctl enable keepalived.service
```

出现如下日志信息表示VIP配置成功

![](images/1598065700207911375.png)

### 后端服务器配置

#### 1. 安装httpd服务

```shell
yum -y install httpd
systemctl start httpd
systemctl enable httpd
```

#### 2. 添加虚拟IP和路由

- 临时配置

```shell
ip addr add 10.10.10.222/32 dev lo:0 broadcast 10.10.10.222
ip route add 10.10.10.222 dev lo:0  # 将目标ip为VIP的报文转交给lo:0处理
```

- 永久配置


```shell
cat /etc/sysconfig/network-scripts/ifcfg-lo:0
DEVICE=lo:0
IPADDR=10.10.10.222
NETMASK=255.255.255.255
NETWORK=127.0.0.0
# If you're having problems with gated making 127.0.0.0/8 a martian,
# you can change this to something else (255.255.255.255, for example)
BROADCAST=127.255.255.255
ONBOOT=yes
NAME=loopback
```

  - 查看路由

```shell
cat /etc/sysconfig/network-scripts/route-lo:0
10.10.10.222 dev lo:0
```



