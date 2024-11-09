#!/bin/bash
docker run --name mysqld --restart=always \
-v /etc/localtime:/etc/localtime:ro \
-v /usr/share/zoneinfo/iso3166.tab:/usr/share/zoneinfo/iso3166.tab:ro \
-v /opt/mysqld/conf:/etc/mysql/mysql.conf.d \
-v /opt/mysqld/data:/var/lib/mysql \
-p 0.0.0.0:3306:3306/tcp \
-e MYSQL_ROOT_PASSWORD="123456@root##" \
-e TZ=Asia/Shanghai \
-d mysql:5.7.44
