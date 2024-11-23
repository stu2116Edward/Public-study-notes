# Linux开启ssh并允许root登录

**目录**  
- 1.Ubuntu开启ssh服务及允许root登录
  - 安装ssh服务器端
  - 允许远程使用root账号ssh连接本机
- 2.CentOS开启SSH服务及允许root登录
  - 安装openssh-server
  - 修改sshd服务配置文件
  - 重启sshd服务
- 3.Kalilinux开启ssh及允许root登录
  - 安装ssh服务器端
  - 修改配置让ssh允许root登录
  - 添加ssh开机自启动

## Ubuntu开启ssh服务及允许root登录

### 安装ssh服务器端
Ubuntu默认没有安装ssh的server，需要安装  
```
apt-get install openssh-server
```
ssh客户端是默认安装的，连接其它ssh服务器用的，使用 `apt install openssh-client`安装

### 允许远程使用root账号ssh连接本机
修改`/etc/ssh/sshd_config`文件
```
vim /etc/ssh/sshd_config
```
修改如下：允许root账户登录  
<pre>
#PermitRootLogin prohibit-password
PermitRootLogin yes
</pre>
需要重启系统或者sshd服务  
```
sudo systemctl restart sshd
```
或
```
sudo service sshd restart
```
或
```
sudo /etc/init.d/ssh stop
sudo /etc/init.d/ssh start
sudo service ssh restart
```
安装ssh服务后，系统默认开启系统sshd，查看sshd状态如果不是默认启动，修改服务为enable  
```
sudo systemctl enable ssh
```


## CentOS开启SSH服务及允许root登录

### 安装openssh-server
```
yum list installed | grep openssh-server
```
如果有输出，证明已经安装了openssh-server，如果没有，需要安装
```
yum install openssh-server
```
### 修改sshd服务配置文件
编辑sshd服务配置文件  
没有vim用vi或者yum install -y vim 安装  
```
vim /etc/ssh/sshd_config
```
开启监听端口
```
Port 22
ListenAddress 0.0.0.0
ListenAddress ::
```
允许远程登录
```
PermitRootLogin yes
```
使用用户名密码作为验证连接
```
PasswordAuthentication yes
```

### 重启sshd服务
```
service sshd start
service sshd restart
```
配置开机自启动
```
systemctl enable sshd
```


## Kali开启ssh及允许root登录
安装ssh服务器端  
Kali默认是没有安装ssh的  
```
apt-get install openssh-server
```
修改配置让ssh允许root登录  
配置ssh配置文件  
```
vim /etc/ssh/sshd_config
```
修改如下：允许root账户登录  
<pre>
#PermitRootLogin prohibit-password
PermitRootLogin yes
</pre>
保存退出，重启ssh服务
```
/etc/init.d/ssh restart
```
添加ssh开机自启动  
启动ssh  
```
/etc/init.d/ssh start
```
或
```
systemctl start sshd
```
查看ssh的运行状态
```
/etc/init.d/ssh status
```
或
```
systemctl status sshd
```
开机自启动配置
```
systemctl enable ssh.service
```
或
```
update-rc.d ssh enable
```
