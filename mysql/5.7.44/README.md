### MySQL 5.7.44


> 这是MySQL5.7系列的最后一个版本

```
mkdir conf
cat <<'EOF'> conf/mysqld.cnf
[mysqld]
pid-file      = /var/run/mysqld/mysqld.pid
socket        = /var/run/mysqld/mysqld.sock
datadir       = /var/lib/mysql
log-error     = /var/lib/mysql/error.log
tls_version   = 'TLSv1.2'
sql_mode      = NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER
symbolic-links        = 0
default-time-zone     = '+8:00'
log_timestamps        = system
character-set-server  = utf8mb4
collation-server      = utf8mb4_unicode_ci
log-bin               = mysql-bin
binlog_format         = ROW
max_binlog_size       = 100M
expire_logs_days      = 0
server_id             = 11
explicit_defaults_for_timestamp = true
EOF
```

```
cat <<'EOF'> run.sh
#!/bin/bash
docker run --name mysqld --restart=always \
-v /etc/localtime:/etc/localtime:ro \
-v /opt/mysqld/conf:/etc/mysql/mysql.conf.d \
-v /opt/mysqld/data:/var/lib/mysql \
-p 0.0.0.0:3306:3306/tcp \
-e MYSQL_ROOT_PASSWORD="root@pwd" \
-d mysql:5.7.44
EOF
```



```
docker pull mysql:5.7.44
```

## windows 10 安装mysql-5.7.44-winx64.zip

- 解压安装包，创建data文件夹

  ```
  D:\data\mysqld
   D:\data\mysqld 的目录

  2024-11-06  17:21    <DIR>          .
  2024-11-06  17:21    <DIR>          ..
  2023-10-11  20:23    <DIR>          bin
  2024-11-06  17:22    <DIR>          data
  2023-10-11  20:17    <DIR>          docs
  2024-11-06  17:22             4,022 error.log
  2023-10-11  20:17    <DIR>          include
  2023-10-11  20:23    <DIR>          lib
  2023-10-11  19:42           260,678 LICENSE
  2024-11-06  17:11               843 my.ini
  2023-10-11  19:42               566 README
  2023-10-11  20:17    <DIR>          share
                 4 个文件        266,109 字节
                 8 个目录 117,413,007,360 可用字节
  ```



- 创建配置文件

  ```
  [mysql]
  # 设置mysql客户端默认字符集
  default-character-set=utf8
  user=root
  password=123456

  [mysqld]
  #skip-grant-tables
  port = 3306
  basedir="D:\data\mysqld"
  datadir="D:\data\mysqld\data"

  max_connections=200
  character-set-server=utf8
  default-storage-engine=INNODB

  log-error="D:\data\mysqld\error.log"
  tls_version   = 'TLSv1.2'

  sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER
  symbolic-links        = 0
  default-time-zone     = '+8:00'
  log_timestamps        = system
  character-set-server  = utf8mb4
  collation-server      = utf8mb4_unicode_ci
  log-bin               = mysql-bin
  binlog_format         = ROW
  max_binlog_size       = 100M
  expire_logs_days      = 0
  server_id             = 11
  explicit_defaults_for_timestamp = true
  ```

- 初始化数据

  ```
  # --initialize-insecure 执行这个命令进行初始化时，会创建一个没有密码的 root 用户。然后可以自行设置密码。
  # --initialize 此命令初始化 MySQL 时，会为 root 用户生成一个随机密码，被记录在 MySQL 的错误日志文件中。
  .\bin\mysqld.exe --defaults-file=D:\data\mysqld\my.ini --initialize-insecure
  ```

- 安装服务

  ```
  .\bin\mysqld.exe --install MySQL --defaults-file="D:\data\mysqld\my.ini"
  ```

- 移除服务

  ```
  .\bin\mysqld.exe --remove
  ```

- 启动服务

  ```
  net start mysql
  ```

- 停止服务

  ```
  net stop mysql
  ```

- 修改密码

  ```
  alter user 'root'@'localhost' identified by '123456';
  ```



