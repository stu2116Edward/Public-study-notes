# Linux基本操作命令

## 服务管理：  
启动服务：
```
sudo systemctl start <service_name>
```
停止服务：
```
sudo systemctl stop <service_name>
```
重启服务：
```
sudo systemctl restart <service_name>
```
查看服务状态：
```
sudo systemctl status <service_name>
```
设置服务开机自启：
```
sudo systemctl enable <service_name>
```
取消服务开机自启：
```
sudo systemctl disable <service_name>
```


## 查看进程：  
ps 命令查看进程：
```
ps
```
查看所有进程：
```
ps aux
```
查看特定用户进程：
```
ps -u <username>
```
查看特定组进程：
```
ps -G <groupname>
```
按CPU使用率排序：
```
ps -eo pid,ppid,%cpu,cmd --sort=-%cpu
```
按内存使用率排序：
```
ps -eo pid,ppid,%mem,cmd --sort=-%mem
```
查看进程树：
```
ps -ef | grep <process-name>
```


## top 命令实时显示系统中各个进程的资源占用情况
实时显示进程信息：
```
top
```
显示特定用户的进程：
```
top -u <username>
```
显示特定组的进程：
```
top -G <groupname>
```
显示所有CPU的核心：
```
top -1
```
显示特定核心的进程信息：
```
top -1 -p <core_number>
```
以树状图显示进程：
```
top -t -c
```


## htop 交互式进程查看器
实时显示进程信息：
```
htop
```
启动时不显示颜色：
```
htop -n 1
```
设置更新间隔：
```
htop -d 5
```
以树状图显示进程：
```
htop -t
```
只显示用户进程：
```
htop -u <username>
```
过滤进程：
```
htop -F <process-name>
```


## 管理进程  
- kill 命令  
终止进程：
```
kill PID
```
强制终止进程：
```
kill -9 PID
```
发送SIGTERM信号：
```
kill -15 PID
```
向特定用户进程发送信号：
```
kill -USER PID
```


- pkill 命令  
按名称终止进程：
```
pkill <processname>
```
按组名终止进程：
```
pkill -G <groupname>
```
按用户名终止进程：
```
pkill -u <username>
```
递归终止进程：
```
pkill -r pattern
```


- killall 命令  
按名称终止所有匹配的进程：
```
killall <processname>
```
按用户名终止所有匹配的进程：
```
killall -u <username>
```
按组名终止所有匹配的进程：
```
killall -G <groupname>
```


- nice 和 renice 命令  
以低优先级运行命令：
```
nice -n 10 <some_command>
```
调整正在运行的进程的优先级：
```
renice 10 -p PID
```


- nohup 命令  
在断开终端后继续运行命令：
```
nohup <some_command> &
```


- pstree 命令  
以树状图显示进程：
```
pstree
```
显示进程的完整命令行：
```
pstree -p
```
显示进程的PID：
```
pstree -s
```


- top 命令的交互模式  
刷新屏幕：`Ctrl + L`  
排序：`O` (大写字母o),然后选择列进行排序  
查看线程：`H` (大写字母h)  
退出：`q`  


- htop 命令的交互模式  
排序：`F3` 或 `O`，然后选择列进行排序  
切换树状图显示：`F5`  
切换彩色/单色显示：`F9`  
切换滚动模式：`Space`（空格键）  
退出：`F10`  



## 网络管理  
- ifconfig 或 ip addr 命令  
查看所有网络接口：
```
ip addr show
```
或
```
ifconfig -a
```
查看特定网络接口：
```
ip addr show <interface>
```
或
```
ifconfig <interface>
```
启用网络接口：
```
sudo ip link set <interface> up
```
禁用网络接口：
```
sudo ip link set <interface> down
```
为网络接口分配IP地址：
```
sudo ip addr add <ip>/<mask> dev <interface>
```
移除网络接口的IP地址：
```
sudo ip addr del <ip>/<mask} dev <interface>
```


- ping 命令  
测试网络连接：
```
ping <host>
```
连续发送ping：
```
ping -t <host>
```
使用特定次数的ping：
```
ping -c <count> <host>
```
使用特定大小的包：
```
ping -s <size> <host>
```


- netstat 或 ss 命令  
查看所有网络端口：
```
sudo netstat -tuln
```
或
```
sudo ss -tuln
```
查看所有服务的 PID
```
sudo netstat -tulnp
```
或
```
sudo ss -tulnp
```
查看特定服务的端口：
```
sudo netstat -tulnp | grep <service>
```
或
```
sudo ss -tulnp | grep <service>
```
查看所有UDP端口：
```
sudo netstat -tulnu 或 sudo ss -tulnu
```
查看所有TCP端口：
```
sudo netstat -tulnt 或 sudo ss -tulnt
```


- traceroute 或 tracepath 命令  
追踪网络路径：
```
traceroute <host>
```
或
```
tracepath <host>
```
使用ICMP协议：
```
traceroute -I <host>
```
使用UDP协议：
```
traceroute -U <host>
```


- nslookup 或 dig 命令  
查询DNS信息：
```
nslookup <hostname>
```
或
```
dig <hostname>
```
查询特定类型的DNS记录：
```
dig <记录类型> <hostname>
```
示例：
```
dig A <hostname>（A记录）
dig MX <hostname>（MX记录）  
```
示例：  
例如，要查询 google.com 的IP地址，你可以使用：
```
nslookup google.com
```
指定一个特定的DNS服务器来查询  
```
nslookup google.com 8.8.8.8
```
例如，要查询 google.com 的DNS信息，你可以使用：
```
dig google.com
```
查询A记录（IPv4地址）：
```
dig A google.com
```
查询NS记录（域名服务器）：
```
dig NS google.com
```
查询MX记录（邮件交换服务器）：
```
dig MX google.com
```
查询TXT记录（通常用于存储元数据）：
```
dig TXT google.com
```

- iptables 或 ufw 命令  
列出iptables规则：
```
sudo iptables -L
```
添加规则允许端口：
```
sudo iptables -A INPUT -p tcp --dport <port> -j ACCEPT
```
添加规则阻止端口：
```
sudo iptables -A INPUT -p tcp --dport <port> -j DROP
```
启用防火墙：
```
sudo ufw enable
```
禁用防火墙：
```
sudo ufw disable
```
允许特定端口：
```
sudo ufw allow <port>/<protocol>
```
阻止特定端口：
```
sudo ufw deny <port>/<protocol>
```


- curl 或 wget 命令  
获取网页内容：
```
curl <url> 或 wget <url>
```
获取网页内容并输出到文件：
```
curl -o <file> <url> 或 wget -O <file> <url>
```
发送POST请求：
```
curl -d "param=value" <url>
```


- nmap 命令  
扫描主机端口：
```
nmap <host>
```
扫描特定端口范围：
```
nmap -p <port1>-<port2> <host>
```
扫描所有TCP端口：
```
nmap -p 1-65535 <host>
```
扫描主机开放的端口：
```
nmap -sT <host>
```


- arp 命令  
查看ARP表：
```
arp -a
```
添加静态ARP映射：
```
sudo arp -s <ip> <mac>
```
删除静态ARP映射：
```
sudo arp -d <ip>
```


- host 命令  
查看主机名和IP地址映射：
```
host <hostname>
```
查看特定类型的记录：  
```
host -t <记录类型> <hostname>
```
查询A记录（IPv4地址）：
```
host -t A <hostname>（A记录）
```
查询MX记录（邮件交换服务器）：
```
host -t MX <hostname>（MX记录）
```


## 磁盘管理
查看磁盘空间使用情况：
```
df -h
```
查看特定文件系统的使用情况：
```
df -h <filesystem>
```
查看所有文件系统的使用情况：
```
df -h --local
```
查看当前目录的磁盘使用情况：
```
du -sh
```
查看特定目录的磁盘使用情况：
```
du -h <directory>
```
查看文件的磁盘使用情况：
```
du -h <file>
```
查看特定深度的目录树使用情况：
```
du -h --max-depth=<depth> <directory>
```
列出所有可用的块设备：
```
lsblk
```
以易于阅读的格式显示：
```
lsblk -f
```
查看磁盘分区表：
```
sudo fdisk -l
```
交互式地管理磁盘分区：
```
sudo fdisk <device>
```
创建新的文件系统：
```
sudo mkfs -t <type> <device>
```
挂载文件系统：
```
sudo mount <device> <mountpoint>
```
挂载特定类型的文件系统：
```
sudo mount -t <type> <device> <mountpoint>
```
卸载文件系统：
```
sudo umount <mountpoint>
```
交互式地查看磁盘使用情况：
```
ncdu <directory>
```
查找大文件：
```
find <directory> -type f -size +100M
```
监控磁盘I/O：
```
iostat <device>
```
查看和调整磁盘参数：
```
sudo hdparm -I /dev/sda
```
检查磁盘的SMART状态：
```
sudo smartctl -a /dev/sda
```


## 文件权限管理  
设置文件权限：  
```
chmod <权限数字> <文件或目录>
```

- 数字参考示例：  
0	无权限（---）  
1	执行（--x）  
2	写（-w-）  
3	写和执行（-wx）  
4	读（r--）  
5	读和执行（r-x）  
6	读和写（rw-）  
7	读、写和执行（rwx）  

- 以下是一些常见的权限设置示例：  
644：所有者有读写权限，所属组和其他用户只有读权限。  
755：所有者有全部权限，所属组和其他用户有读和执行权限。  
700：只有所有者有读、写和执行权限，所属组和其他用户没有任何权限。  
777：所有用户都有读、写和执行权限（注意：这通常不推荐，因为它不够安全）。




## 用户管理  
查看当前用户信息：  
- 显示当前执行命令的用户的名字
```
whoami
```
显示当前用户的用户ID（UID）、组ID（GID）以及用户和组的名称
```
id
```
显示当前登录系统的用户列表，包括用户名称、终端、登录时间等信息
```
who
```
显示系统中所有用户的活动，包括哪些用户已登录以及他们在做什么
```
w
```
显示当前登录系统的用户列表
```
users
```
显示用户的登录历史记录，包括登录和注销时间
```
last
```
显示用户的失败登录尝试记录
```
lastb
```
显示系统中所有用户的最后登录时间
```
lastlog
```
ps命令结合特定的选项，可以查看当前运行的进程，包括它们的所有者
```
ps aux
```
添加新用户：
```
sudo useradd <username>
```
设置用户主目录：
```
sudo useradd -m <username>
```
设置用户Shell：
```
sudo useradd -s <shell-path> <username>
```
修改用户信息：
```
sudo usermod <options> <username>
```
更改用户主目录：
```
sudo usermod -d <new-home-dir> <username>
```
更改用户组：
```
sudo usermod -g <groupname> <username>
```
更改用户密码：
```
sudo passwd <username>
```
立刻强制用户下次登录时更改密码：
```
sudo passwd -e <username>
```
更改文件权限：
```
sudo chmod <permissions> <file>
```
递归更改目录权限：
```
sudo chmod -R <permissions> <directory>
```
使文件可执行：
```
sudo chmod +x <file>
```
更改文件所有者：
```
sudo chown <new-owner> <file>
```
递归更改目录及其内容的所有者：
```
sudo chown -R <new-owner> <directory>
```
更改文件组：
```
sudo chgrp <groupname> <file>
```
递归更改目录及其内容的组：
```
sudo chgrp -R <groupname> <directory>
```

## Nginx管理：  
nginx -s reload：重新加载配置文件  
nginx -s reopen：重新打开日志文件  
nginx -s stop：快速关闭服务  
nginx -t：测试配置文件  


## 防火墙管理（如果使用iptables）：  
iptables -L：列出规则  
iptables -A INPUT -p tcp --dport 80 -j ACCEPT：添加规则允许80端口  
iptables -D INPUT -p tcp --dport 80 -j ACCEPT：删除规则  


## 日志管理：  
tail -f /var/log/nginx/access.log：查看Nginx访问日志  
tail -f /var/log/syslog：查看系统日志  


## 备份和恢复：  
tar：打包和压缩文件  
rsync：同步文件和目录  
