## Linux 采用 SSH CA 登陆验证

当配置大量的服务器有很多用户，保持SSH访问在线的基础设施可以变得复杂，SSH实际上具有使用证书颁发机构来验证服务器和客户端的功能。

## 步骤

- 生成 CA 证书
- 为目标服务器配置 SSH CA 公钥信任
- 生产客户端 SSH 密钥对
- 采用 CA 私钥客户端 SSH 公钥进行签名
- 客户端采用客户端 SSH 私钥和公钥签名登陆目标客户机

## 生成 CA 证书

目的：配置客户端认证服务器的证书，该证书允许我们的客户端连接到我们的服务器，而不需要质疑服务器的真实性。

```shell
ssh-keygen -C "ssh_server_ca" -b 4096 -f ca/server_ca
```

## 为目标服务器配置 SSH CA 公钥信任

修改目标机的/etc/ssh/sshd_config文件，添加刚生产的server_ca.pub信任

将server_ca.pub复制到目标服务器的/etc/ssh/目录下

```shell
echo "TrustedUserCAKeys /etc/ssh/server_ca.pub" >>/etc/ssh/sshd_config
systemctl restart sshd
```

## 生产客户端 SSH 密钥对

```shell
mkdir rsa
ssh-keygen -t rsa -b 4096 -f rsa/id_rsa -C host_cert
```

## 采用 CA 客户端 SSH 公钥进行签名

生成id_rsa-cert.pub公钥签名文件。这里只需要客户机的公钥文件，所以也可以直接签署客户机提供的公钥。

```shell
cd rsa
ssh-keygen -s ../ca/server_ca -I xiexianbin  -O source-address=10.10.10.11,10.10.10.12 -n root,develop -V +52w id_rsa.pub
```

>  说明：
>
> - -s：CA 证书私钥
> - -I：识别证书的名称，相当于注释。 当证书用于认证时，它用于日志记录
> - -n：识别与此证书关联的名称（用户或主机），表示证书仅对该域名有效。如果有多个，则使用逗号分隔。上例中只有root用户能够登录到目标服务器。
> - -V：指定证书的有效期为。 在这种情况下，我们指定证书将在一年（52周）过期，默认情况下，证书是永远有效的。建议使用该参数指定有效期，并且有效期最好短一点，最长不超过 52 周。
> - -O option：source-address=address_list ：允许用户证书使用的客户端的地址，多个地址用逗号分隔，可以时候CIDR， 我们将设置这个来限制用户证书的使用范围。如： -O source-address=10.10.10.11,10.10.10.12

生成证书以后，可以使用下面的命令，查看证书的细节。

```shell
ssh-keygen -L -f id_rsa-cert.pub
# 大概如下
id_rsa-cert.pub:
        Type: ssh-rsa-cert-v01@openssh.com user certificate
        Public key: RSA-CERT SHA256:HP71SBszAWUOgg1uOjkZCEkoeEaNgWU3eF9oCV0bctc
        Signing CA: RSA SHA256:PpwLGScb0WQLDar94WyOD5DKkdTjzJohQS76wNRJQQg
        Key ID: "xiexianbin" # 此处则是 -I 指定的值
        Serial: 0
        Valid: from 2020-12-09T22:11:00 to 2021-12-08T22:12:27
        Principals: # 此处则是 -n 指定的值
                root
                develop
        Critical Options:  # 此处则是 -O 指定的值
                source-address 10.10.10.11,10.10.10.12
        Extensions: 
                permit-X11-forwarding
                permit-agent-forwarding
                permit-port-forwarding
                permit-pty
                permit-user-rc
               
```



## 登陆

将id_rsa、id_rsa-cert.pub、id_rsa.pub 全部上传到客户机

```shell
ssh -i id_dsa root@ip  #即可登陆，默认会加载：id_dsa + id_dsa-cert.pub登陆测试机器
```

> 说明：
>
> - -i 指定自己的私钥文件，默认会加载：id_dsa + id_dsa-cert.pub两个文件，默认读取 /root/.ssh/id_rsa



## Python 实现

依赖 paramiko>=2.3.0 版本

```py
cat test_paramiko_cert_key.py
# -*- coding: utf-8 -*-
'''
依赖：
    paramiko==2.3.3
'''

import paramiko

from StringIO import StringIO


def test_ssh_ca_key():
    key_file = """<PRIVATE KEY>"""
    cert_pub_file = """<*-cert.pub>"""
    ip = "<ip>"
    port = 22
    pkey = paramiko.DSSKey.from_private_key(StringIO(key_file))
    pkey.load_certificate(cert_pub_file)

    # Client setup
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(hostname=ip, port=port, username='root', pkey=pkey)

    stdin, stdout, stderr = ssh.exec_command("pwd")
    print stdin, stdout, stderr


if __name__ == '__main__':
    test_ssh_ca_key()
```

> https://www.xiexianbin.cn/linux/ssh/2018-04-30-linux-ssh-ca-key-validate-hosts-and-clients/index.html