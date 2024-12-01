# ubuntu镜像源更换

### 先查询自己系统的版本号：
```
lsb_release -a
```
<pre>
edwardhu@edwardhu-virtual-machine:~$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 20.04.6 LTS
Release:	20.04
Codename:	focal
</pre>

可以看出我系统版本是 Ubuntu 20.04.6 LTS，注意这个开发代号`Codename`，Ubuntu每一个版本都有一个代号，这个一定要跟国内源对应，否则会出问题

### 阿里云镜像  
通过以下地址可以看到阿里云Ubuntu各个版本的镜像地址，从中选择自己的系统版本就好，一定要选择`Codename`对应的版本  
镜像地址: 阿里云Ubuntu镜像：https://developer.aliyun.com/mirror/ubuntu  

ubuntu 20.04 LTS (focal) 配置如下  
我系统版本是20.04，所以可以从下面镜像信息中看到都是`focal`代号的  
```
deb https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse
```

### 更换方法
1.备份镜像源  
```
sudo cp /etc/apt/sources.list /etc/apt/sources.list.back
```
2.编辑  
打开vim编辑器，把sources.list文件中所有的deb文件全部注释掉或者删除掉，然后把上面给的国内镜像复制去就可以  
```
vim /etc/apt/sources.list
```
3.更新  
```
sudo apt update
sudo apt upgrade
```
#### 其他镜像  
清华源  
地址：https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/  
```
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
# deb-src http://security.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse
```
