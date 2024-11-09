### MySQL备份指南



> 创建一个mysql用户，用来备份数据库

- 本地直连（localhost）

```
CREATE USER 'backupuser'@'localhost' IDENTIFIED BY 'backupuser';
GRANT SELECT, LOCK TABLES, SHOW VIEW, PROCESS  ON *.* TO 'backupuser'@'localhost';
```

- 远程连接（容器部署，远程部署，或者127.0.0.1访问）

```
CREATE USER 'backupuser'@'%' IDENTIFIED BY 'backupuser';
GRANT SELECT, LOCK TABLES, SHOW VIEW, PROCESS ON *.* TO 'backupuser'@'%';
```

> 刷新权限（非必要）

```
FLUSH PRIVILEGES;
```

> 添加定时任务(每天4点钟执行备份脚本，一定要关注备份是否成功)

```
00 04 * * * root /opt/mysqld/dbbackup.sh  >/dev/null 2>&1
```




