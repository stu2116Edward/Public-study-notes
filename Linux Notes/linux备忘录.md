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
重启服务(生产环境中不推荐频繁使用)：
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
重新加载服务配置(生产环境中推荐使用)：
```
sudo systemctl reload <service_name>
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


### top 命令实时显示系统中各个进程的资源占用情况
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


### htop 交互式进程查看器
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
sudo ip addr del <ip>/<mask> dev <interface>
```


### - ping 命令  
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


### - netstat 或 ss 命令  
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

### - ip命令

#### 语法结构
用法
```
ip [OPTIONS] OBJECT { COMMAND | help } [ARGUMENTS]
```
OPTIONS选项  
- -V：显示指令版本信息；
- -s：输出更详细的信息；可以使用多个 -s 来显示更多的信息
- -f 或 -family：强制使用指定的协议族（如inet, inet6, link）
- -4：指定使用的网络层协议是IPv4协议
- -6：指定使用的网络层协议是IPv6协议
- -0：shortcut for -family link
- -o：每条记录输出一行，即使内容较多也不换行显示
- -r：显示主机时，不使用IP地址，而使用主机的域名

OBJECT对象
- link：网卡信息
- address：IP地址信息
- neighbour：邻居表
- route：路由表
- rule：IP策略
- tunnel：IP隧道

#### 显示网络接口信息
用法

```bash
ip [选项] link show [接口名]
```
常用选项

无特定选项，但可以通过接口名来显示特定接口的信息。
示例

显示所有网络接口的状态：
```bash
ip link show
```
显示特定网络接口（如eth0）的状态：
```bash
ip link show eth0
```

#### 配置网络接口
用法

```bash
ip link set [接口名] [选项]
```
常用选项

- up：启用网络接口。
- down：禁用网络接口。
- mtu [值]：设置网络接口的MTU（最大传输单元）。
- address [MAC地址]：设置网络接口的MAC地址。
示例

启用网络接口eth0：
```bash
ip link set eth0 up
```
禁用网络接口eth0：
```bash
ip link set eth0 down
```
修改网络接口eth0的MTU为1500：
```bash
ip link set eth0 mtu 1500
```
设置网络接口eth0的MAC地址为00:11:22:33:44:55：
```bash
ip link set dev eth0 address 00:11:22:33:44:55
```

#### 配置IP地址
用法

```bash
ip addr [选项] [IP地址/子网掩码] dev [接口名]
```
常用选项

- add：添加IP地址。
- del：删除IP地址。
- show：显示IP地址。
示例

给网络接口eth0添加IP地址192.168.1.100/24：
```bash
ip addr add 192.168.1.100/24 dev eth0
```
删除网络接口eth0的IP地址192.168.1.100/24：
```bash
ip addr del 192.168.1.100/24 dev eth0
```
显示网络接口eth0的IP地址：
```bash
ip addr show dev eth0
```

#### 显示路由信息
用法

```bash
ip route [选项]
```
常用选项

- show：显示路由表。
- add：添加路由。
- del：删除路由。
- change：修改路由。
示例

显示当前的路由表：
```bash
ip route show
```
添加路由，使192.168.2.0/24网络通过192.168.1.1网关访问：
```bash
ip route add 192.168.2.0/24 via 192.168.1.1
```
删除路由，删除到192.168.2.0/24网络的路由：
```bash
ip route del 192.168.2.0/24 via 192.168.1.1
```
修改默认网关为192.168.1.1：
```bash
ip route change default via 192.168.1.1
```
显示特定路由表（如main、local、default）：
```bash
ip route show table main
ip route show table local
ip route show table default
```

#### 显示和配置策略路由
用法

```bash
ip rule [选项]
```
常用选项

- show：显示策略路由规则。
- add：添加策略路由规则。
- del：删除策略路由规则。
- change：修改策略路由规则。
示例

显示策略路由规则：
```bash
ip rule show
```
添加策略路由规则，使来自192.168.1.100/32的流量使用表100：
```bash
ip rule add from 192.168.1.100/32 table 100
```
删除策略路由规则，删除来自192.168.1.100/32的流量使用表100的规则：
```bash
ip rule del from 192.168.1.100/32 table 100
```
修改策略路由规则，修改来自192.168.1.100/32的流量使用表100的规则，并设置优先级为100：
```bash
ip rule change from 192.168.1.100/32 table 100 priority 100
```

#### 显示和管理邻居（ARP表）
用法

```bash
ip neigh { show | add | del | change | replace } [IP地址]
```
常用选项

- show：显示邻居信息。
- add：添加静态邻居条目。
- del：删除邻居条目。
- change：修改邻居条目。
- replace：替换一个已有的邻居条目。
- dev：指定邻居条目所属的网络接口。
- lladdr：指定邻居的链路层地址（MAC地址）。
- nud { permanent | noarp | stale | reachable }：设置邻居条目的状态。

示例

显示所有邻居信息：
```bash
ip neigh show
```

显示特定接口（如eth0）的邻居信息：
```bash
ip neigh show dev eth0
```

添加静态邻居条目，使IP地址192.168.1.100与MAC地址00:11:22:33:44:55关联，并设置为永久有效：
```bash
ip neigh add 192.168.1.100 lladdr 00:11:22:33:44:55 dev eth0 nud permanent
```

删除邻居条目，删除IP地址192.168.1.100的邻居信息：
```bash
ip neigh del 192.168.1.100 dev eth0
```

修改邻居条目，修改IP地址192.168.1.100与MAC地址00:11:22:33:44:55的关联，并设置为永久有效：
```bash
ip neigh change 192.168.1.100 lladdr 00:11:22:33:44:55 dev eth0 nud permanent
```

替换一个已有的邻居条目，如果条目不存在则添加：
```bash
ip neigh replace 192.168.1.100 lladdr 00:11:22:33:44:55 dev eth0 nud permanent
```

#### 显示和管理隧道
用法

```bash
ip tunnel [选项] [隧道接口名]
```
常用选项

- add：创建一个新的隧道接口。
- del：删除一个已存在的隧道接口。
- show：列出所有隧道接口的详细信息。

示例

创建一个IPIP模式的隧道接口 `tun0`，远程地址为 `192.168.1.1`，本地地址为 `192.168.1.100`：
```bash
ip tunnel add tun0 mode ipip remote 192.168.1.1 local 192.168.1.100
```

启用并激活隧道接口 `tun0`：
```bash
ip link set tun0 up
```

删除隧道接口 `tun0`：
```bash
ip tunnel del tun0
```

显示所有隧道接口的信息：
```bash
ip tunnel show
```

#### IPv6 over IPv4隧道
用法

```bash
ip tunnel [选项] [隧道接口名]
```
常用选项

- add：创建一个新的隧道接口。
- del：删除一个已存在的隧道接口。
- mode sit：设置隧道模式为SIT（Simple IP Tunneling），适用于IPv6 over IPv4。
- remote any：指定隧道的远程端地址，`any` 表示自动选择。
- local any：指定隧道的本地端地址，`any` 表示自动选择。

示例

创建一个IPv6 over IPv4隧道接口 `tun6to4`：
```bash
ip tunnel add tun6to4 mode sit remote any local any
```

启用并激活隧道接口 `tun6to4`：
```bash
ip link set tun6to4 up
```

为隧道接口 `tun6to4` 分配一个IPv6地址：
```bash
ip -6 addr add 2001:470:1f11:101::1/64 dev tun6to4
```

通过隧道接口 `tun6to4` 添加默认IPv6路由：
```bash
ip -6 route add default via 2001:470:1f11:101::2 dev tun6to4
```

删除隧道接口 `tun6to4`：
```bash
ip tunnel del tun6to4
```

#### 显示和管理网络设备
用法

```bash
ip link [选项]
```
常用选项

- add：创建虚拟网络设备。
- del：删除虚拟网络设备。
- show：显示虚拟网络设备。
示例

创建虚拟网络设备：
```bash
ip link add dummy0 type dummy
```
删除虚拟网络设备：
```bash
ip link del dummy0
```
显示虚拟网络设备：
```bash
ip link show type dummy
```

#### 显示和管理网络策略
用法

```bash
ip netns [选项]
```
常用选项

- list：显示所有网络命名空间。
- add：创建网络命名空间。
- del：删除网络命名空间。
- exec：在网络命名空间中执行命令。
示例

显示所有网络命名空间：
```bash
ip netns list
```
创建网络命名空间myns：
```bash
ip netns add myns
```
删除网络命名空间myns：
```bash
ip netns del myns
```
进入网络命名空间myns并执行bash：
```bash
ip netns exec myns bash
```
在命名空间myns中配置网络接口eth0为启用状态：
```bash
ip netns exec myns ip link set eth0 up
```
在命名空间myns中配置IP地址192.168.1.100/24给接口eth0：
```bash
ip netns exec myns ip addr add 192.168.1.100/24 dev eth0
```
在命名空间myns中配置路由：
```bash
ip netns exec myns ip route add default via 192.168.1.1
```

#### 防止ARP欺骗攻击
用法

```bash
ip neigh [选项]
```
常用选项

- add：添加静态邻居条目。
- show：显示邻居信息。
- del：删除邻居条目。
- change：修改邻居条目。
示例

设置静态ARP条目，防止ARP欺骗：
```bash
ip neigh add 192.168.1.1 lladdr 00:11:22:33:44:55 dev eth0 nud permanent
```
显示静态ARP条目：
```bash
ip neigh show dev eth0 nud permanent
```
删除静态ARP条目：
```bash
ip neigh del 192.168.1.1 dev eth0
```

### - traceroute 或 tracepath 命令  
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


### - nslookup 或 dig 命令  
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

### - iptables 和 ufw 命令  
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


### - curl 或 wget 命令  
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


### - nmap 命令  
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


### - arp 命令  
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


### - host 命令  
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


## Linux系统中常用的查看系统日志的命令

在Linux系统中，查看系统日志的命令有很多，不同的命令适用于不同的场景。以下是一些在多个Linux操作系统中常用的查看系统日志的命令：
1. `journalctl`
- `systemd`系统中用于查看系统日志的命令，非常强大且灵活。
- 示例命令：`journalctl`
- 查看特定服务的日志：`journalctl -u <服务名>.service`
- 查看最新的日志：`journalctl -f`
- 查看特定时间段的日志：`journalctl --since="2024-11-18" --until="2024-11-19"`

2. `tail`
- 用于显示文件的末尾部分，常用于实时查看日志文件。
- 示例命令：`tail -f /var/log/syslog`
- 查看最后10行：`tail /var/log/syslog`

3. `dmesg`
- 用于显示内核环形缓冲区的内容，通常用于查看内核消息。
- 示例命令：`dmesg`
- 为了更易读，可以使用管道和`less`命令：`dmesg | less`

### 其他命令

4. `less`
- 用于分页查看文件内容，可以配合其他命令使用。
- 示例命令：`less /var/log/syslog`

5. `cat`
- 用于查看文件内容，但不推荐用于大文件，因为它会一次性加载整个文件到内存。
- 示例命令：`cat /var/log/syslog`

6. `grep`
- 用于搜索文件中的特定文本模式，常与日志文件一起使用。
- 示例命令：`grep "error" /var/log/syslog`

7. `awk`
- 用于文本处理，可以用来格式化和过滤日志文件内容。
- 示例命令：`awk '/error/ {print $0}' /var/log/syslog`

8. `logrotate`
- 用于管理和压缩旧的日志文件。
- 查看配置：`logrotate --debug /etc/logrotate.conf`

9. `last`
- 用于查看系统登录日志。
- 示例命令：`last`

10. `lastb`
- 用于查看系统失败的登录尝试。
- 示例命令：`lastb`

11. `lastlog`
- 用于查看系统中所有用户的最后登录时间。
- 示例命令：`lastlog`

12. `who`
- 用于显示当前登录的用户。
- 示例命令：`who`

13. `whoami`
- 用于显示当前用户。
- 示例命令：`whoami`

14. `uptime`
- 用于显示系统的负载平均值和运行时间。
- 示例命令：`uptime`

15. `sar`
- 用于显示系统活动报告，需要安装`sysstat`包。
- 示例命令：`sar`
请根据你的具体需求选择合适的命令。如果你需要查看特定的日志文件，通常这些文件位于`/var/log/`目录下


## 备份和恢复

### 备份命令

1. **`cp`**
   - 用于复制文件或目录。
   - 示例命令：
     - 复制文件：`cp 源文件 备份文件`
     - 递归复制目录：`cp -r 源目录 备份目录`

2. **`rsync`**
   - 用于同步文件和目录，支持本地和远程备份。
   - 示例命令：
     - 同步目录：`rsync -av 源目录/ 备份目录/`
     - 同步并删除备份目录中多余的文件：`rsync -av --delete 源目录/ 备份目录/`

3. **`tar`**
   - 用于打包和压缩文件。
   - 示例命令：
     - 创建tar包：`tar -cvf 备份文件名.tar 源目录/`
     - 创建gzip压缩的tar包：`tar -czvf 备份文件名.tar.gz 源目录/`

4. **`dd`**
   - 用于复制和转换文件，常用于备份整个磁盘或分区。
   - 示例命令：`dd if=/dev/sdX of=备份镜像.img`

5. **`dump`**
   - 用于备份文件系统，支持增量备份。
   - 示例命令：`dump -0u -f /路径/到/备份文件 源目录`

6. **`bzip2`, `gzip`, `xz`**
   - 用于压缩文件，常与`tar`命令结合使用。
   - 示例命令：
     - 使用bzip2压缩：`tar -cjvf 备份文件名.tar.bz2 源目录/`

7. **`zip`**
   - 用于压缩文件和目录。
   - 示例命令：`zip -r 备份文件名.zip 源目录/`

### 恢复命令

1. **`cp`**
   - 用于复制文件或目录，也可以用于恢复。
   - 示例命令：
     - 恢复文件：`cp 备份文件 源文件`
     - 递归恢复目录：`cp -r 备份目录/ 源目录/`

2. **`rsync`**
   - 用于同步文件和目录，也可以用于恢复。
   - 示例命令：
     - 从备份恢复：`rsync -av 备份目录/ 源目录/`

3. **`tar`**
   - 用于解压和解包文件。
   - 示例命令：
     - 解压tar包：`tar -xvf 备份文件名.tar`
     - 解压gzip压缩的tar包：`tar -xzvf 备份文件名.tar.gz`

4. **`dd`**
   - 用于恢复整个磁盘或分区。
   - 示例命令：`dd if=备份镜像.img of=/dev/sdX`

5. **`restore`**
   - 用于从`dump`命令创建的备份中恢复文件系统。
   - 示例命令：`restore -rf /路径/到/备份文件`

6. **`bzip2`, `gzip`, `xz`**
   - 用于解压缩文件。
   - 示例命令：
     - 使用bzip2解压缩：`tar -xjvf 备份文件名.tar.bz2`

7. **`unzip`**
   - 用于解压缩zip文件。
   - 示例命令：`unzip 备份文件名.zip`
