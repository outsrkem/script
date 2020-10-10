# 使用systemd管理Centos服务

### 服务权限

​        systemd有系统和用户区分；系统（/usr/lib/systemd/system/）、用户（/etc/lib/systemd/user/）。一般系统管理员手工创建的单元文件建议存放在(/etc/systemd/system/)目录下面，建议设置权限(-rw-r-----)。

### Systemd新特性

​       (1) 系统引导时实现服务并行启动：服务间无依赖关系会并行启动

​       (2) 按需激活进程：若服务非立刻使用，不会立刻激活，处于半活动状态，占用端口用时启动服务

​       (3) 系统状态快照：回滚到过去某一状态

​       (4) 基于依赖关系定义服务控制逻辑

### **创建服务文件**

- **文件路径**

```
-rw-r----- 1 root root 460 2019-04-10 20:54:02 /etc/systemd/system/nginx.service
```

- **文件内容**

````
[Unit]
Description=nginx - high performance web server
Documentation=http://nginx.org/en/docs/
After=network.target remote-fs.target nss-lookup.target 
[Service]
Type=forking
User=nginx
Group=nginx
PIDFile=/usr/local/nginx/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s stop
PrivateTmp=true
Restart=on-failure
RestartSec=5s
[Install]
WantedBy=multi-user.target
````

### 相关命令

- 新创建的脚本需要重载后才能使用，执行如下命令即可

  ```
  systemctl daemon-reload
  ```

- 启动相关服务

  ```
  systemctl start nginx.service
  ```

- 设置服务开机自启动

  ```
  systemctl enable nginx.service
  ```

- 日志查看

  ```
  journalctl -f -u nginx.service
  ```

- 查看是否设置为开启启动

  ```
  systemctl is-enabled nginx.service
  ```

  

### 参数解释

- **[Unit]**  启动顺序与依赖关系
  
  <table>
  	<tr>
          <td>参数</td>
          <td>说明</td>
      </tr>
  	<tr>
          <td>Description</td>
          <td> 服务的简单描述</td>
      </tr>
  	<tr>
          <td>Documentation</td>
          <td>服务文档。指定一个url地址</td>
      </tr>
  	<tr>
          <td>Before</td>
          <td>Before=xxx.service,代表本服务在xxx.service启动之前启动</td>
      </tr>
  	<tr>
          <td>After</td>
          <td>After=xxx.service,代表本服务在xxx.service之后启动。</td>
      </tr> 
  	<tr>
          <td>Requires</td>
          <td>这个单元启动了，它需要的单元也会被启动；它需要的单元被停止了，这个单元也停止了。</td>
      </tr>
  	<tr>
          <td>Wants</td>
          <td>这个单元启动了，它需要的单元也会被启动；它需要的单元被停止了，对本单元没有影响。</td>
      </tr>    
  </table>
  
- **[Service]** 启动行为
  
  <table>
     <tr>
        <td width="20%">参数</td>
        <td width="20%">可选值</td>
        <td>说明</td>
     </tr>
     <tr>
        <td >EnvironmentFile</td>
        <td>/etc/sysconfig/sshd</td>
        <td>许多软件都有自己的环境参数文件，该文件可以用EnvironmentFile字段读取。连词号（-），表示"抑制错误"，如：EnvironmentFile=-/etc/sysconfig/sshd，（注意等号后面的那个连词号），就表示即使/etc/sysconfig/sshd文件不存在，也不会抛出错误。</td>
     </tr>    
     <tr>
        <td rowspan="5">Type</td>
        <td>simple</td>
        <td>（默认值）：systemd认为该服务将立即启动。服务进程不会fork。如果该服务要启动其他服务，不要使用此类型启动，除非该服务是socket激活型。</td>
     </tr>
     <tr>
        <td>forking</td>
        <td>systemd认为当该服务进程fork，且父进程退出后服务启动成功。对于常规的守护进程（daemon），除非你确定此启动方式无法满足需求，使用此类型启动即可。使用此启动类型应同时指定 PIDFile=，以便systemd能够跟踪服务的主进程。</td>
     </tr>
     <tr>
         <td>oneshot</td>
         <td>这一选项适用于只执行一项任务、随后立即退出的服务。可能需要同时设置 RemainAfterExit=yes 使得 systemd 在服务进程退出之后仍然认为服务处于激活状态。</td>
     </tr>
   <tr>
     	   <td>notify</td>
         <td>与 Type=simple 相同，但约定服务会在就绪后向 systemd 发送一个信号。这一通知的实现由 libsystemd-daemon.so 提供。</td>
     </tr>
     <tr>
         <td>dbus</td>
         <td>若以此方式启动，当指定的 BusName 出现在DBus系统总线上时，systemd认为服务就绪。</td>
     </tr>
     <tr>
         <td>User</td>
         <td>nginx</td>
         <td>指定服务运行用户，需注意服务目录的权限是否合理</td>
     </tr>
     <tr>
         <td>Group</td>
         <td>nginx</td>
         <td>指定服务运行用户所属组</td>
     </tr> 
     <tr>
         <td>PIDFile</td>
         <td>pid文件绝对路径</td>
         <td>指定服务运行的pid文件</td>
     </tr>
     <tr>
         <td>ExecStartPre</td>
         <td>命令</td>
         <td>启动前执行的命令</td>
     </tr>
     <tr>
         <td>ExecStart</td>
         <td>命令</td>
         <td>服务启动命令</td>
     </tr>
     <tr>
         <td>ExecReload</td>
         <td>命令</td>
         <td>服务重启命令</td>
     </tr>   
     <tr>
         <td>ExecStop</td>
         <td>命令</td>
         <td>服务停止命令</td>
     </tr>         
     <tr>
         <td>PrivateTmp</td>
         <td>true</td>
         <td>True表示给服务分配独立的临时空间</td>
     </tr>     
     <tr>
         <td rowspan="7">Restart</td>
         <td>no</td>
         <td>（默认值）：退出后不会重启</td>
     </tr> 
     <tr>
         <td>on-success</td>
         <td>只有正常退出时（退出状态码为0），才会重启</td>
     </tr>
     <tr>
         <td>on-failure</td>
         <td>非正常退出时（退出状态码非0），包括被信号终止和超时，才会重启</td>
     </tr>
     <tr>
         <td>on-abnormal</td>
         <td>只有被信号终止和超时，才会重启</td>
     </tr>
     <tr>
         <td>on-abort</td>
         <td>只有在收到没有捕捉到的信号终止时，才会重启</td>
     </tr>
     <tr>
         <td>on-watchdog</td>
         <td>超时退出，才会重启</td>
     </tr>
     <tr>
         <td>always</td>
         <td>不管是什么退出原因，总是重启</td>
     </tr>
     <tr>
         <td>RestartSec</td>
         <td>2s</td>
         <td>表示 Systemd 重启服务之前，需要等待的秒数。此处设为等待2秒。</td>
     </tr>      
  </table>
  
- **[Install] **  定义如何安装这个配置文件，即怎样做到开机启动。
  
  <table>
      <tr>
          <td>参数</td>
          <td>说明</td>
      </tr>
      <tr>
        <td>Alias</td>
          <td>为单元提供一个空间分离的附加名字。</td>
      </tr>
      <tr>
          <td>RequiredBy</td>
          <td>单元被允许运行需要的一系列依赖单元，RequiredBy列表从Require获得依赖信息</td>
      </tr>
      <tr>
          <td>WantBy</td>
          <td>单元被允许运行需要的弱依赖性单元，Wantby从Want列表获得依赖信息。</td>
      </tr>
      <tr>
          <td>Also</td>
          <td>指出和单元一起安装或者被协助的单元。</td>
      </tr>
      <tr>
          <td>DefaultInstance</td>
          <td>实例单元的限制，这个选项指定如果单元被允许运行默认的实例。</td>
      </tr> 
      <tr>
          <td>WantedBy</td>
          <td>表示该服务所在的 Target</td>
      </tr>      
  </table>
  
  注：Target是什么？
  
  `Target`的含义是服务组，表示一组服务。`WantedBy=multi-user.target`指的是，sshd 所在的 Target 是`multi-user.target`。这个设置非常重要，因为执行`systemctl enable sshd.service`命令时，`sshd.service`的一个符号链接，就会放在`/etc/systemd/system`目录下面的`multi-user.target.wants`子目录之中。上面的结果表示，默认的启动 Target 是`multi-user.target`。在这个组里的所有服务，都将开机启动。这就是为什么`systemctl enable`命令能设置开机启动的原因。
  
  
  
  