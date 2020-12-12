## pod进程的运行用户

配置位置：Deployment.spec.template.spec.containers.securityContext

在k8s v1.16.2 中没有fsGroup

```yaml
spec:
  containers:
  - name: redis
    image: registry.cn-shanghai.aliyuncs.com/outsrkem/redis:5.0.2-tools
    ports:
    - name: http
      containerPort: 6379
      protocol: TCP
    volumeMounts:
    - name: vol-logstash-volume
      mountPath: /usr/local/redis/conf/conf.d/
    securityContext:
      runAsNonRoot: true
      runAsUser: 1200
```

效果如下，相当于Dockerfile中的USER 参数指定的用户一样。

```shell
[redis@redis-pod-cm-1-7fb75f45bd-ts8mf redis]$ id
uid=1200(redis) gid=1200(redis) groups=1200(redis)
[redis@redis-pod-cm-1-7fb75f45bd-ts8mf redis]$ ps axu 
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
redis         1  0.1  0.1  50248  2676 ?        Ssl  10:57   0:00 redis-server 0.0.0.0:6379
redis       102  0.0  0.1  12364  2496 pts/0    Ss   11:05   0:00 bash
```

## volumes配置权限

为volumes配置权限Deployment.spec.template.spec.volumes.configMap.defaultMode，

此权限只针对挂载的文件生效，

```yaml
spec:
  containers:
  - name: redis
    image: registry.cn-shanghai.aliyuncs.com/outsrkem/redis:5.0.2-tools
    ports:
    - name: http
      containerPort: 6379
      protocol: TCP
    volumeMounts:
    - name: vol-logstash-volume
      mountPath: /usr/local/redis/conf/conf.d/
    securityContext:
      runAsUser: 1200
  volumes:
  - name: vol-logstash-volume
    configMap:
      name: logstash-config
      defaultMode: 0600
```


效果如下

```shell
[redis@redis-pod-cm-1-7fb75f45bd-ts8mf conf]$ find . -exec ls -l {} \;
total 64
drwxrwxrwx 3 root root   151 Nov  1 10:57 conf.d  # 挂载在这个目录下
total 0
lrwxrwxrwx 1 root root 26 Nov  1 10:57 02-beats-input.conf -> ..data/02-beats-input.conf
lrwxrwxrwx 1 root root 21 Nov  1 10:57 10-syslog.conf -> ..data/10-syslog.conf
lrwxrwxrwx 1 root root 20 Nov  1 10:57 11-nginx.conf -> ..data/11-nginx.conf
lrwxrwxrwx 1 root root 21 Nov  1 10:57 30-output.conf -> ..data/30-output.conf
total 16
-rw------- 1 root root  41 Nov  1 10:57 02-beats-input.conf  # 这里是生效的权限
-rw------- 1 root root 456 Nov  1 10:57 10-syslog.conf
-rw------- 1 root root 113 Nov  1 10:57 11-nginx.conf
-rw------- 1 root root 151 Nov  1 10:57 30-output.conf
-rw------- 1 root root 41 Nov  1 10:57 ./conf.d/..2020_11_01_02_57_10.956627988/02-beats-input.conf
-rw------- 1 root root 456 Nov  1 10:57 ./conf.d/..2020_11_01_02_57_10.956627988/10-syslog.conf
-rw------- 1 root root 113 Nov  1 10:57 ./conf.d/..2020_11_01_02_57_10.956627988/11-nginx.conf
-rw------- 1 root root 151 Nov  1 10:57 ./conf.d/..2020_11_01_02_57_10.956627988/30-output.conf
lrwxrwxrwx 1 root root 21 Nov  1 10:57 ./conf.d/10-syslog.conf -> ..data/10-syslog.conf
lrwxrwxrwx 1 root root 20 Nov  1 10:57 ./conf.d/11-nginx.conf -> ..data/11-nginx.conf
lrwxrwxrwx 1 root root 21 Nov  1 10:57 ./conf.d/30-output.conf -> ..data/30-output.conf
lrwxrwxrwx 1 root root 26 Nov  1 10:57 ./conf.d/02-beats-input.conf -> ..data/02-beats-input.conf
lrwxrwxrwx 1 root root 31 Nov  1 10:57 ./conf.d/..data -> ..2020_11_01_02_57_10.956627988


```

