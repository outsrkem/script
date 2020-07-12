

# logrotate日志轮替

#### 配置文件

```
-rw-r--r--. 1 root root 662 2013-07-31 19:46:23 /etc/logrotate.conf
```

改配文件记录着日志的轮替规则，对全局 rsyslog 所管理的服务生效

#### 定时脚本

```
-rwx------. 1 root root 219 2017-08-02 09:12:36 /etc/cron.daily/logrotate
```

该脚本每天都会运行，检查是否有符合轮替的日志，然后进行轮替，也是系统能够进行轮替的原因。

#### 管理的对象

- 主要是 rsyslog 服务所管理产生的日志
- 也包含一部分通过 rpm 安装的服务（httpd、vsftpd....）/etc/logrotate.d/*

#### 操作命令

- 强制轮替日志

```
logrotate -vf /etc/logrotate.conf
    -v 	    显示过程
    -f      强制
    -d      调试模式，不会真的轮替日志文件，只是打印信息
```

#### 参数解释

| 参数                 | 解释                                                         |
| -------------------- | ------------------------------------------------------------ |
| daily                | 每天轮替                                                     |
| weekly               | 每周轮替                                                     |
| monthly              | 每月轮替                                                     |
| size                 | 大于该指定大小时轮替，而不按时间轮替，如 size 100k，日志大小达到这个值触发，和时间、周期没有关系。 |
| minsize              | 日志轮替最小值。时间周期到了，日志大小达到这个值；两个条件都要满足才触发。 |
| maxsize              | 如果按小时触发，则满足maxsize大小时会轮替，此时忽略(daily, weekly, monthly, or yearly) 等参数。（M K）。时间周期到了，日志大小大于这个值；两个条件任何一个满足则触发。 |
| missingok            | 如果日志不存在，不报错继续滚动下一个日志                     |
| maxage               | 保存日志个数，以天数为单位，如果我们是以按天来轮转日志，那么rotate和maxage的差别就不大了 |
| rotate               | 指定日志文件删除之前转储的个数，0 指没有备份，5 指保留5个备份，以个数为单位 |
| compress             | 通过gzip 压缩转储以后的日志                                  |
| delaycompress        | 和 compress 一起使用时，转储的日志文件到下一次转储时才压缩   |
| dateext              | 使用当期日期作为命名格式                                     |
| dateformat           | 配合dateext使用，紧跟在下一行出现，定义文件切割后的文件名，必须配合dateext使用，只支持 %Y %m %d %s 这四个参数（dateformat -%Y%m%d-%s） |
| notifempty           | 当日志文件为空时，不进行轮转                                 |
| create               | 指定创建新文件的属性，如 create 0777 nobody nobody           |
| sharedscripts        | 运行postrotate脚本，作用是在所有日志都轮转后统一执行一次脚本。如果没有配置这个，那么每个日志轮转后都会执行一次脚本 |
| prstrotade/endscript | postrotate/endscript  在logrotate转储之后需要执行的指令，例如重新启动 (kill -HUP) 某个服务！必须独立成行 |
| prerote/endscript    | 在日志轮替之前的脚本命令，标识脚本结束                       |

#### 特殊说明

参考文档：https://access.redhat.com/solutions/39006

查看系统规则库，可以看到Nginx的日志目录应具有 system_u:object_r:httpd_log_t:s0  上下文，如下：

```
# semanage fcontext -l |grep nginx
/var/log/nginx(/.*)?          all files          system_u:object_r:httpd_log_t:s0
```

我们可以直接将标签加到selinux的安全策略库中：

```
# semanage fcontext -a -t httpd_log_t '/usr/local/nginx/logs(/.*)?'
```

根据新定义，运行以下命令递归设置logs上下文，该命令要求启用selinux才能使用

```
# restorecon -Frvv /usr/local/nginx/logs
```

If SELinux is not in the Enforcing mode, this solution does not apply. Please, refer to [this article](https://access.redhat.com/site/solutions/32831) in order to get more information on logrotate troubleshooting.

或者手动设置/usr/local/nginx/logs目录的上下文：

```
# chcon -R -t httpd_log_t  /usr/local/nginx/logs
```

#### Diagnostic Steps

- Check if `/etc/logrotate.conf` or the `/etc/logrotate.d` directory has custom scripts that require logrotate to rotate files from directories outside of `/var/log`.

- Check the SELinux context on those custom directories. They should have the "var_log_t" type on those files.

- The message `logrotate: ALERT exited abnormally with [1]` comes from the `/etc/cron.daily/logrotate` script:

  ```shell
  #!/bin/sh
  
  /usr/sbin/logrotate /etc/logrotate.conf >/dev/null 2>&1
  EXITVALUE=$?
  if [ $EXITVALUE != 0 ]; then
      /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
  fi
  exit 0
  ```

### selinux相关命令

- 设置文件selinux上下文

  ```
  chcon [-R] [-t type] [-u user] [-r role] 文件
      选项与参数：
      -R ：连同该目录下的次目录也同时修改;
      -t ：后面接安全性本文的类型字段，例如 var_log_t;
      -u ：后面接身份识别，例如 system_u;
      -r ：后面接角色，例如 system_r;
  如： chcon -R -t httpd_sys_content_t /www/  修改 Apache 的网页目录的安全类型
  ```

  

# 日志切割

- 当日志文件产生后，发现日志文件过大(事后)，通过脚本来进行对日志文件的切割

- split -[bl] 文件名

- 按行数切割

  ```
  split -l 100 install.log -d -a 3 ins_log
      -d       声明切割后的文件的前缀
      -a 3     以数字作为后缀，以 3 位长度的数作为后缀（000）
      -l 100   设置 100 行切割一个
      ins_log  人为指定切割后文件的前缀
  ```

- 按大小切割

  ```
  split -b 1M install.log -d -a 3 ins_log
  ```

  

## 系统日志

| 日志文件         | 说明                                                         |
| ---------------- | ------------------------------------------------------------ |
| /var/log/cron    | 定时任务相关日志                                             |
| /var/log/cups/   | 打印信息                                                     |
| /var/log/dmesg   | 开机内核自检信息，可用 dmesg 直接查看                        |
| /var/log/btmp    | 错误登录日志（lastb）                                        |
| /var/log/lastlog | 所有用户最后一次登录时间（lastlog）                          |
| /var/log/message | 记录系统重要信息日志                                         |
| /var/log/secure  | 验证和授权方面信息，如 ssh 登录，su，sudo,创建用户等操作     |
| /var/log/wtmp    | 永久记录所有用户的登录，注销信息，系统的启动，重启，关机等事件 |
| /var/log/utmp    | 记录当前已经登录的用户信息                                   |

