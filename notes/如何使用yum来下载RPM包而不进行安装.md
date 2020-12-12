# 如何使用yum来下载RPM包而不进行安装

yum是基于Red Hat的系统(如CentOS、Fedora、RHEl)上的默认包管理器。使用yum，你可以安装或者更新一个RPM包，并且他会自动解决包依赖关系。但是如果你只想将一个RPM包下载到你的系统上该怎么办呢? 例如，你可能想要获取一些RPM包在以后使用，或者将他们安装在另外的机器上。

## 下载

### 方法一:yum

yum命令本身就可以用来下载一个RPM包，标准的yum命令提供了--downloadonly(只下载)的选项来达到这个目的。

```shell
yum install --downloadonly <package-name> 
```

默认情况下，一个下载的RPM包会保存在下面的目录中:

/var/cache/yum/x86_64/[centos/fedora-version]/[repository]/packages 

以上的[repository]表示下载包的来源仓库的名称(例如：base、fedora、updates)

如果你想要将一个包下载到一个指定的目录(如/tmp)：

```shell
yum install --downloadonly --downloaddir=/tmp/yumpackage <package-name> 
```

注意，如果下载的包包含了任何没有满足的依赖关系，yum将会把所有的依赖关系包下载，但是都不会被安装。

另外一个重要的事情是，在CentOS/RHEL 6或更早期的版本中，你需要安装一个单独yum插件(名称为 yum-plugin-downloadonly)才能使用--downloadonly命令选项：

```shell
yum install yum-plugin-downloadonly
```

如果没有该插件，你会在使用yum时得到以下错误：

Command line error: no such option: --downloadonl



### 方法二: Yumdownloader

另外一个下载RPM包的方法就是通过一个专门的包下载工具--yumdownloader。 这个工具是yum工具包(包含了用来进行yum包管理的帮助工具套件)的子集。

```shell
yum install yum-utils 
```

下载一个RPM包：

```shell
yumdownloader <package-name>
```

下载的包会被保存在当前目录中。你需要使用root权限，因为yumdownloader会在下载过程中更新包索引文件。与yum命令不同的是，任何依赖包不会被下载。

下载lsof示例：

```
yumdownloader lsof --resolve --destdir=/data/mydepot/　　#resolve下载依赖
```

## 安装

上面我们下载了rpm软件包，安装的时候可以使用如下命令，这种方式可以解决依赖问题并自动安装。

```shell
yum localinstall /tmp/yumpackage/<package-name>.rpm 
```

