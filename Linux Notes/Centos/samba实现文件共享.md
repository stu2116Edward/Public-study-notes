# samba实现文件共享

### 1. 确保物理机和虚拟机能够互相通信
这里使用虚拟机当服务端，物理机当客户端。确认一下自己的Linux是否安装了Samba：
```bash
rpm -qa | grep samba
```
如果不完整就安装Samba的服务器组件：
```bash
sudo yum install samba samba-client
```

### 2. 开启samba
```bash
systemctl start smb
```
查看samba运行状态：
```bash
systemctl status smb
```

### 3. 关闭服务器防火墙和安全加强
如果防火墙不关闭，Windows和Samba之间的连通可能会被阻挡  
关闭服务器防火墙：
```bash
systemctl stop firewalld
```
关闭安全加强：
```bash
setenforce 0
```

### 4. 打开samba配置文件
```bash
vim /etc/samba/smb.conf
```

### 5. samba配置文件参数介绍
配置文件`/etc/samba/smb.conf`是samba服务器配置的核心，主要分为全局参数和共享资源参数两部分。

#### 全局参数设置：
```ini
[global]
    workgroup = WORKGROUP  # 工作组名称
    netbios name = server  # 主机名称
    server string = Samba Server Version %v  # 服务器说明
    security = user  # 安全级别
    map to guest = bad user  # 将无效用户映射为guest用户
    log file = /var/log/samba/log.%m  # 日志文件
    max log size = 50  # 日志文件最大大小
    dns proxy = no  # 是否启用DNS代理
```

#### 共享资源设置：
```ini
[temp]
    comment = Temporary file space
    path = /tmp
    writable = yes
    browseable = yes
    guest ok = yes
```

### 6. 添加用户并设置密码
设置账号用于登录samba服务器，同时并设置密码。具体命令：
添加一个用户：
```
useradd <用户名>
```
配置指定用户的密码：
```
smbpasswd -a <用户名>
```

### 7. 重启samba服务
```bash
systemctl restart smb
```
如果这段命令无法运行，就是Samba没有正确安装的原因。

### 8. 登录samba
在Windows和Linux网络都畅通的情况下，在Windows下登录Samba服务器。使用命令查看Samba的IP地址：
```bash
ifconfig
```
在Windows的运行，输入`\\<IP地址>`（Samba对应的IP地址）  
然后输入用户和密码就可以登陆了

### 9. 常见问题及解决方法
- **网络选择**：确保Linux下的IP和Windows下的IP处于同一网段中，并且保证相互可以ping通。
- **防火墙问题**：如果防火墙不关闭，Windows和Samba之间的连通可能会被阻挡。在Linux上关闭防火墙：
  ```bash
  systemctl stop firewalld
  ```
  在Windows上关闭防火墙：
  - 控制面板->系统和安全->Windows防火墙->打开或关闭Windows防火墙；
- **权限问题**：可能会出现权限不够的问题，修改你想要的那个文件的权限。
  ```bash
  chmod 777 /home
  ```
- **无法访问**：如果用windows访问samba，跳出以下对话框的错误：
  “无法访问。您可能没有权限使用网络资源。请与这台服务器的管理员联系以查明您是否有访问权限。”
  允许一个用户使用一个以上用户名与一个服务器或共享资源的多重连接。中断与此服务器或共享资源的所有连接，然后再试一次……或者直接重启Windows。
  在Windows的命令行中输入：
  ```cmd
  net use * /delete /y
  ```
- **自动连接**：使每次打开Linux自动运行samba服务器：
  - 在终端中输入`setup->system service->找到smb，按下空格，便可选中->退出完成`（注意切换用tab键）。


