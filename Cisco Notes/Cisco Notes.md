# Cisco命令笔记

- [基础理论](#基础理论)
- [初识Cisco-CLI面板信息](#初识Cisco-CLI面板信息)
- [快捷键以及基础命令](#快捷键以及基础命令)
- [Telnet远程管理交换机](#Telnet远程管理交换机)
- [追踪路由途径](#追踪路由途径)
- [配置交换机VLAN](#配置交换机VLAN)
- [子网汇聚](#子网汇聚)
- [链路聚合](#链路聚合)
- [静态路由配置](#静态路由配置)
- [RIP动态路由配置](#RIP动态路由配置)
- [OSPF路由配置](#OSPF路由配置)
- [ACL（访问控制列表）](#ACL访问控制列表)
- [NAT地址转换](#NAT地址转换)
- [端口映射](#端口映射)
- [端口转发](#端口转发)
- [生成树协议（STP）](#生成树协议STP)
- [交换机端口安全](#交换机端口安全)
- [配置SSH访问](#配置SSH访问)
- [内网静态路由重发布](#内网静态路由重发布)
- [链路聚合和Trunk](#链路聚合和Trunk)
- [三层交换机操作](#三层交换机操作)
- [配置DHCP](#配置DHCP)
- [配置GRE-tunnel隧道](#配置GRE-tunnel隧道)
- [日志信息](#日志信息)
- [关于设备信息](#关于设备信息)

## [基础理论](#基础理论)

### 广域网协议
- Serial（串口）

### 以太网协议
- RJ45的均为以太网

### 专业术语：  
- 1.在路由协议中，“跳数”（Hop Count）是一个重要的概念，它用来衡量数据包从一个网络设备到达另一个网络设备所经过的路由器数量,每经过一个路由器，跳数就增加1。

## [初识Cisco-CLI面板信息](#初识Cisco-CLI面板信息)
### 超级终端：Terminal
- 用于访问和配置Cisco设备的控制台。

### 用户模式与特权模式
- 用户模式：`>`
- 特权模式：`#`

### 配置模式与接口模式
- 配置模式：`config#`
- 接口模式：`config-if#`

## [快捷键以及基础命令](#快捷键以及基础命令)

### 快捷键
- 直接退到特权模式(`#`)：`Ctrl+Z` 或者在命令行中输入`end`命令。
- 在终端内加速时间：`Ctrl+Shift+6`
- 用于查看当前视图中的命令及解释：`?`
- 补全当前的命令：`Tab`

### 基础命令
- 进入特权模式：  
```
enable
```
- 显示当前目录：  
```
dir
```
- 进入配置模式：  
```
configure terminal
```
或简写为  
```
conf t
```
- 进入某个接口：  
```
interface <接口名称>
```
这里示例：  
```
int f0/1
```
- 进入接口组模式(用于一次性配置多个接口)：  
```
int range f0/1-f0/10
```
或者  
```
int range f0/1-10
```
- 对当前的设备重新命名：`hostname <设备名>`  
示例：  
```
hostname SW1
```

- 关闭或撤销配置命令：一般在命令行前加上`no`  
示例：  
- 从接口上删除IP地址:  
```
no ip address
```
- 激活（启用）之前被关闭的接口:  
```  
no shutdown 
```
- 关闭日志记录功能:  
```
no logging
```
- 用于显示某个命令执行的信息 `show <属性>` (注意要在特权模式下)：  
- 显示单个接口状态：  
```
show int f0/1
```
- 显示所有接口状态：  
```
show interfaces
```
- 显示接口的简要状态(接口速率)：  
```
show interfaces status
```
- 显示接口的协议状态(包括vlan)：  
```
show ip interface brief
```
- 显示所有路由信息(路由器，三层交换机中)：  
```
show ip route
```
- 显示特定目的网络的路由：`show ip route <网段或ip地址>`  
```
show ip route 192.168.0.0
```
或者  
```
show ip route 192.168.0.1
```
- 显示直连路由(于当前设备相连接的路由接口)：  
```
show ip route connected
```
或者  
```
show ip route | section connected
```
- 显示静态路由信息(包括默认路由)：  
```
show running-config | section ip route
```
- 显示路由的汇总信息：  
```
show ip protocols
```
- 显示OSPF路由信息：  
```
show ip ospf database
```
- 显示RIP路由信息：  
```
show ip rip database
```
- 显示EIGRP路由信息：  
```
show ip eigrp neighbors 或者 show ip eigrp topology
```  
保存配置：  
- 保存配置到设备的启动配置寄存器中：
```
write memory
```
- 保存配置到闪存：
```
write flash
```
拓展  
保存配置到SD卡：`write sdcard:`  
保存配置到USB存储设备：`write usbflash:`  
保存到TFTP服务器：  
假设TFTP服务器的IP地址是 192.168.1.100  
`configure terminal`  
`copy running-config tftp://192.168.1.100/config_backup.txt`

清除配置(特权模式)：  
```
erase startup-config
```
清除配置后需要重启设备以使更改生效(特权模式):  
```
reload
```


## [Telnet远程管理交换机](#Telnet_Remote_Management)

![屏幕截图 2024-10-26 135534](https://github.com/user-attachments/assets/3d38b66c-0075-48d8-8551-d451df591ce7)

### 配置VLAN接口
- 默认的VLAN为VLAN 1。
- 进入VLAN接口配置模式：
```
interface vlan 1
```
- 配置远程管理的IP地址以及子网掩码：
```
ip address 192.168.100.5 255.255.255.0
```
- 开启接口(注意这里要开启vlan 1的接口否则无法ping通和telnet)：
```
no shutdown
```    
- 退出当前模式：
```
exit
```
- 给交换机定义网关：
```
ip default-gateway 192.168.100.100
```
- 查看当前配置信息：
```
show running-config
```

### 设置密码
- 在配置模式中设置进入特权模式的密码：
```
enable secret <密码>
```
- 进入虚拟终端模式并设置密码（这里设置的是Telnet的密码）：
```
line vty 0 4
```
或
```
line vty 5 15
```
然后输入 
```
login
```
和 
```
password <密码>
```
- 进入特权模式'#'：
```
end
```
- 保存配置：
```
write memory
```

### 远程登录
- 进行远程登录：
```
telnet <IP地址>
```

## [追踪路由途径](#Trace_Route)
- 使用 `tracert <IP/域名>` 命令追踪路由途径。
- tracert命令的最大跳数默认为30跳。如果要增加最大跳数，可以使用`-h`参数，后跟所需的最大跳数。

### 显示配置信息
- 显示交换机当前在内存配置里的情况（特权模式中进行）：
```
show running-config
```
- 显示交换机保存在闪存(flash)中的配置（特权模式中进行）：
```
show startup-config
```

## [配置交换机VLAN](#Configuring_Switch_VLANs)

### 创建VLAN并分配端口
- 进入配置模式中：
```
conf t
```
- 创建VLAN 10 和 VLAN 20(思科中的vlan不能批量创建和华为不同只能一个一个创建)：
```
vlan 10
```
```
exit
```
```
vlan 20
```
```
exit
```
- 将端口加入VLAN：
```
int f0/1
```
```
switchport mode access
```
```
switchport access vlan 10
```
对于`f0/2`，操作类似。

### 交换机间Trunk配置
- 配置为trunk模式：
```
int f0/24
```
```
switchport mode trunk
```
- 允许所有VLAN通过：
```
switchport trunk allowed vlan all
```
- 当然你也可以自定义允许通过的vlan：
```
switchport trunk allowed vlan 10,20
```


## [子网汇聚](#Subnet_Aggregation)
子网汇聚的配置示例  
假设你有一个大型的网络，它由多个子网组成，这些子网的地址如下：  
192.168.1.0/24  
192.168.2.0/24  
192.168.3.0/24  
... 一直到 192.168.255.0/24  
你可以使用子网汇聚将这些子网合并成一个更大的网络，例如：  
- 子网汇聚静态路由配置参考：`ip route <汇聚后的子网网段> <汇聚后子网掩码> <下一跳地址>`  
配置示例：  
```
ip route 192.168.0.0 255.255.0.0 192.168.5.1
```  
- 子网汇聚rip路由配置参考：`network <汇聚后的子网段>`  
配置示例：   
```
route rip  
```
```
network 192.168.0.0
```
- 子网汇聚rip路由配置参考：`network <汇聚后的子网网段> <汇聚后的反掩码> area <区域号>`
配置示例：  
```
network 192.168.0.0 0.0.255.255 area 0
```  

## [链路聚合](#Link_Aggregation)

### 二层交换机链路聚合配置

![屏幕截图 2024-10-26 180503](https://github.com/user-attachments/assets/ffad97a9-84cc-43f3-930d-b05bb4b5afdb)

- 将多个接口绑定为一个聚合组：
```
int range f0/1-f0/2
```
- 设置聚合模式为on：
```
channel-group 1 mode on
```
如果需要网管在VLAN中配置

### 三层交换机链路聚合配置：
进入全局配置模式
- 将物理接口添加到Port-channel接口：
```
interface range f0/1-2
```
- 设置聚合模式为on：
```
channel-group 1 mode on
```
退出当前视图  
```
exit
```
配置链路聚合可网管(如果需要网管)：  
把三层交换机当成路由器来使用接口都是路由模式的(接口变为三层无需配置trunk)  

![屏幕截图 2024-10-26 160123](https://github.com/user-attachments/assets/79bf5b6d-cd5a-47aa-b228-ac873482c514)

- 进入Port-channel接口：
```
int port-channel 1
```
将二层端口改为三层：
```
no switchport
```
- 设置IP地址：`ip address [IP地址] [子网掩码]`
```
ip address 192.168.1.1 255.255.255.0
```
退出当前视图  
```
exit
```
开启三层交换机的路由功能  
```
ip routing
```
记得在三层交换机中配置路由实现跨网段通信：  
静态,默认,rip,ospf,eigrp看心情配置  

### 配置链路聚合和Trunk(接口处于二层)
- 二层交换机：

![屏幕截图 2024-10-26 180208](https://github.com/user-attachments/assets/aa334d27-2bb2-4bcc-80d2-b2f340ab4f4b)

  - 进入接口组模式：
  ```
  int range f0/1-f0/2
  ```
  - 建立聚合链路：
  ```
  channel-group 1 mode on
  ```
  - 退出当前视图：
  ```
  exit
  ```
  - 进入聚合链路1：
  ```
  int port-channel 1
  ```
  - 设置为trunk模式：
  ```
  switchport mode trunk
  ```
  - 允许所有VLAN通过：
  ```
  switchport trunk allowed vlan all
  ```

- 三层交换机：

![屏幕截图 2024-10-26 162122](https://github.com/user-attachments/assets/5bdb2ea4-aa29-43ed-ae31-abbb658312d8)

  - 进入接口组模式：
  ```
  int range f0/1-f0/2
  ```
  - 建立聚合链路：
  ```
  channel-group 1 mode on
  ```
  - 退出当前视图：
  ```
  exit
  ```
  - 进入聚合链路1：
  ```
  int port-channel 1
  ```
  - 设置为trunk模式并封装：
  ```
  switchport trunk encapsulation dot1q
  ```
  - 设置为trunk模式：
  ```
  switchport mode trunk
  ```
  - 允许所有VLAN通过：
  ```
  switchport trunk allowed vlan all
  ```

### 显示配置信息：
显示接口编号为1的端口通道（Port-Channel）的配置和状态信息：  
```
show interfaces port-channel 1
```
显示所有以太网通道（EtherChannel）的摘要信息：  
```
show etherchannel summary
```


## [静态路由配置](#Static_Routing_Configuration)

### 直连路由配置
- 进入端口配置模式：`int <接口名称>`
```
int f0/0
```
- 配置IP地址：`ip address <IP地址> <子网掩码>`
```
ip address 192.168.0.1 255.255.255.0
```
- 开启端口：
```
no shutdown
```

### 单臂路由配置


- 配置子接口：`int <接口名称>.<子接口编号>`
- 封装协议：`encapsulation dot1q <VLAN编号>`
- 分配IP地址：`ip address <IP地址> <子网掩码>`
配置示例：
  先开启端口  
  ```
  int f0/0
  ```
  ```
  no shutdown
  ```
  - 配置子接口：
  ```
  int f0/0.1
  ```
  ```
  encapsulation dot1q 10
  ```
  ```
  ip address 192.168.1.254 255.255.255.0
  ```
  - 配置另一个VLAN的子接口：
  ```
  int f0/0.2
  ```
  ```
  encapsulation dot1q 20
  ```
  ```
  ip address 192.168.2.254 255.255.255.0
  ```

### 静态路由和默认路由
- 配置静态路由：`ip route <目标网络地址> <目标子网掩码> <下一跳IP地址或接口>`
- 配置默认路由：`ip route 0.0.0.0 0.0.0.0 <下一跳IP地址或接口>`

### 显示配置信息：
- 显示当前路由器的IP路由表：`show ip route`
- 显示路由表中所有静态路由条目：`show ip route static`

## [RIP动态路由配置](#RIP_Dynamic_Routing_Configuration)

### 启用RIP路由
- 启用RIP路由：`router rip`
- 配置网络：`network <与自身相连的网段，例如：192.168.1.0>`
- 关闭自动汇总：`no auto-summary`
- 设置RIP版本：`version 2`
- 显示RIP信息：`show ip rip`
- 显示RIP数据库：`show ip rip database`

### 重发布静态路由到RIP
- 启用RIP路由：`router rip`
- 在RIP中重发布静态路由：`redistribute static`  
redistribute static subnets 使用subnets关键字，可以确保所有静态路由的子网信息都被考虑在内，这样RIP就可以正确地处理这些路由,有助于减少路由聚合，提高路由的精确性和网络的效率(在RIP版本2中使用)

### 重发布默认路由到RIP
- 启用RIP路由：`router rip`
- 在RIP中重发布默认路由：`default-information originate`

### 在RIP重发布OSPF路由
- 指定一个度量值（metric），这是RIP中跳数的值：`redistribute ospf <进程号> metric <度量值>`  
这里的 <度量值> 是指 RIP 使用的度量值，用于表示 OSPF 路由在 RIP 中的"成本"  
### 在RIP重发布EIGRP路由  
- `redistribute eigrp <自治系统号> metric <度量值>`  
这里的 <度量值> 则是指 EIGRP 使用的度量值，用于表示 EIGRP 路由在 RIP 中的"成本

### 显示配置信息：
- 用于开启IP RIP的调试模式和诊断和解决RIP路由问题：`debug ip rip`
- 清除路由器上的所有IP路由条目：`clear ip route *`

## [OSPF路由配置](#OSPF_Routing_Configuration)

### 启用OSPF路由
- 启用OSPF路由：`router ospf <进程号>`
- 配置网络：`network <本地网络IP地址> <本地网络子网掩码> area <区域号>`
- 重发布静态路由到OSPF：`redistribute static subnets`  
redistribute static subnets 使用subnets关键字，可以确保所有静态路由的子网信息都被考虑在内，这样OSPF就可以正确地处理这些路由,有助于减少路由聚合，提高路由的精确性和网络的效率
- 在OSPF中重发布默认路由：`default-information originate`  
使用 always 关键字可以确保即使没有静态默认路由，也会通告一个默认路由如果您只想在存在默认路由时重发布它，可以省略 always 关键字：default-information originate always

### 在OSPF重发布RIP路由
- redistribute rip metric <度量值> subnets
这里的<度量值>是OSPF中的度量值，它不是RIP的跳数

### 在OSPF中重发布EIGRP路由
- redistribute eigrp <自治系统号> metric <度量值> subnets  
<自治系统号>是EIGRP的进程号或自治系统号
<度量值>是OSPF中的度量值，它考虑了带宽、延迟、负载、可靠性和MTU等因素，需要根据你的网络环境和需求来调整  

### OSPF中的不同区域边界路由配置：  
这是一个边界路由  
1.定义区域  
R1(config)# `router ospf 1`  
R1(config-router)# `network 10.0.0.0 0.255.255.255 area 0`  
R1(config-router)# `network 192.168.1.0 0.0.0.255 area 1`  
2.配置ABR  
R1(config)# `interface GigabitEthernet0/0`  
R1(config-if)# `ip ospf 1 area 0` 
R1(config-if)# `interface GigabitEthernet0/1`  
R1(config-if)# `ip ospf 1 area 1`  
3.配置Stub区域或NSSA区域  
R1(config-router)# `area 1 stub`  
或者  
R1(config-router)# `area 1 nssa`  

### 不同的OSPF进程之间重发布路由  
在进程1中重发布进程2的路由  
R1(config)# `router ospf 1`  
R1(config-router)# `redistribute ospf 2 metric 20`  
在进程2中重发布进程1的路由  
R1(config-router)# `router ospf 2`  
R1(config-router)# `redistribute ospf 1 metric 20`

### 显示配置信息：
- `show ip ospf neighbor`
- `show ip ospf database`

## [ACL（访问控制列表）](#ACL_Access_Control_List)

### 标准ACL
- 配置标准ACL：`access-list <编号> permit <源IP地址网段> <反掩码>`  
<编号>：ACL 的编号，标准 ACL 使用 1-99 或 1300-1999  
<源IP地址网段>：要允许的数据包的源 IP 地址网段  
<反掩码>：与源 IP 地址网段结合使用，定义网络范围  
配置标准 ACL 示例：`access-list 10 permit 192.168.1.0 0.0.0.255`  
- 在接口中应用标准 ACL
interface <接口>  
ip access-group <编号> in  
应用标准 ACL 示例：`int f0/1`，`ip access-group 10 in`  

### 扩展ACL
- 配置扩展ACL：`access-list <编号> deny|permit <协议> <源IP地址网段> <反掩码> <目的IP地址网段> <反掩码> [operator <端口号或服务>]`  
<编号>：ACL 的编号，扩展 ACL 使用 100-199 或 2000-2699  
<协议>：指定协议类型，如 tcp、udp、icmp、igmp 等  
<源IP地址网段>：指定源 IP 地址范围  
<反掩码>：与 <源IP地址网段> 配合使用，表示网络掩码  
<目的IP地址网段>：指定目的 IP 地址范围  
<反掩码>：与 <目的IP地址网段> 配合使用，表示网络掩码  
[operator <端口号或服务>]：可选，指定协议的端口号或服务名称，如 eq 23（等于23端口）

配置示例：  
拒绝从 192.168.1.0/24 网络到any(任何目的地的) TCP 端口 23（Telnet）的流量  
`access-list 100 deny tcp 192.168.1.0 0.0.0.255 any eq 23`

拒绝从 192.168.1.0/24 网络到 10.10.10.0/24 网络的 TCP 端口 23（Telnet）的流量  
`access-list 100 deny tcp 192.168.1.0 0.0.0.255 10.10.10.0 0.0.0.255 eq 23`  

- 在接口中应用扩展 ACL：`interface <接口>`，`ip access-group <编号> in`
- 应用扩展ACL示例：`int f0/1`，`ip access-group 100 in`

### 显示配置信息：
- `show access-lists`
- `clear access-list counters`

## [NAT地址转换](#NAT_Address_Translation)

### 静态NAT配置
- 配置静态NAT：`ip nat inside source static <内网IP> <公网IP>`
- 应用NAT：`int f0/0`，`ip nat inside`；`int f0/1`，`ip nat outside`

### 动态NAT配置
- 配置说明：`access-list 1 permit 192.168.0.0 <反掩码>`
- 配置示例：`access-list 1 permit 192.168.0.0 0.0.0.255`
- 配置NAT池：`ip nat pool zzz 20.0.0.1 20.0.0.1 netmask 255.255.255.0`
- 应用动态NAT：`ip nat inside source list 1 pool zzz overload`
- 应用NAT：`int f0/0`，`ip nat inside`；`int f0/1`，`ip nat outside`

### 动态NAPT配置
- 配置访问控制列表：`access-list 1 permit 192.168.1.0 <反掩码>`
- 配置示例：`access-list 1 permit 192.168.1.0 0.0.0.255`
- 应用动态NAPT：`ip nat inside source list 1 interface f0/1 overload`
- 应用NAT：`int f0/0`，`ip nat inside`；`int f0/1`，`ip nat outside`

## [端口映射](#端口映射)
端口映射，通常也称为网络地址转换（NAT），允许多个内部设备共享单个公网IP地址，并通过不同的端口号来区分。
假设您的公司有多个内部设备需要访问互联网，但只有一个公网IP地址`203.0.113.5`。您希望通过端口映射（PAT）允许这些设备共享这个公网IP地址。

### 配置端口映射
### 进入全局配置模式
- `configure terminal`

### 定义NAT池，使用公网IP地址
- `ip nat pool MYPOOL 203.0.113.5 203.0.113.5 netmask 255.255.255.255`

### 定义访问控制列表，允许内部网络的所有IP地址使用NAT
- `access-list 1 permit 192.168.1.0 0.0.0.255`

### 将访问控制列表与NAT池关联，启用PAT
- `ip nat inside source list 1 pool MYPOOL`

### 配置内外网接口（假设内网接口是GigabitEthernet0/0，外网接口是GigabitEthernet0/1）
- `interface GigabitEthernet0/0`
- `ip nat inside`

- `interface GigabitEthernet0/1`
- `ip nat outside`

### 保存配置
- `end`
- `write memory`

## [端口转发](#端口转发)
端口转发是一种安全功能，它允许外部请求通过特定的端口被转发到内部网络上的特定设备和端口上。端口转发通常用于让外部用户访问内部网络上提供的服务，如Web服务器或FTP服务器。
- 配置说明： `ip nat inside source static tcp <公网IP> <外部端口> <内网IP> <内部端口> extendable`
### 配置端口转发

### 进入全局配置模式
- `configure terminal`

### 定义端口转发规则，将到达公网IP地址的80端口的流量转发到内网Web服务器的80端口
- `ip nat inside source static tcp 61.159.62.131 80 192.168.100.2 80 extendable`

### 配置内外网接口（假设内网接口是GigabitEthernet0/0，外网接口是GigabitEthernet0/1）
- `interface GigabitEthernet0/0`
- `ip nat inside`

- `interface GigabitEthernet0/1`
- `ip nat outside`

### 保存配置
- `end`

- `write memory`

### 显示配置信息：
- `show ip nat translations`
- `clear ip nat translations`

## [生成树协议（STP）](#Spanning_Tree_Protocol)

### 配置生成树
- 查看当前STP模式：`show spanning-tree mode`
- 关闭生成树：`no spanning-tree mode pvst`
- 设置VLAN优先级：`spanning-tree vlan 10-40 priority 0`

### 显示配置信息：
- `show spanning-tree`
- `show spanning-tree vlan 10`

## [交换机端口安全](#Switch_Port_Security)

### 配置端口安全
- 进入接口配置模式：`int f0/1`
- 开启端口安全：`switchport port-security`
- 设置最大MAC连接数：`switchport port-security maximum 2`
- 设置端口老化时间：`switchport port-security aging time 60`

### 显示配置信息：
- `show port-security`
- `show port-security address`

## [配置SSH访问](#Configuring_SSH_Access)
- 进入特权模式：`enable`
- 进入全局配置模式：`configure terminal`
- 生成RSA密钥 `crypto key generate rsa general-keys modulus 1024`
- 设置用户名和密码：`username <用户名> privilege 15 secret <密码>`
- 开启VTY线路并指定允许的SSH版本：
- 配置虚拟终端（VTY）线路，通常用于远程访问。这里的0 4指定了要配置的VTY线路编号：`line vty 0 4`
- 只允许SSH协议通过这些VTY线路进行连接：`transport input ssh`
- 指示设备在用户登录时使用本地用户数据库进行身份验证：`login local`
- 删除VTY线路的密码要求，因为现在我们使用SSH密钥或用户名/密码进行身份验证：`no password`
- 保存配置重启后配置仍然有效：`write memory`

### 显示配置信息：
- `show crypto key mypubkey rsa`
- `show ssh`

## [内网静态路由重发布](#Internal_Static_Route_Redistribution)

### 重发布静态路由
- 在RIP中重发布静态路由：`router rip`，`redistribute static`
- 在OSPF中重发布静态路由：`router ospf 1`，`redistribute static subnets`

### 显示配置信息：
- `show ip route static`
- `show ip rip database`


### 显示配置信息：
- `show interfaces port-channel 1`
- `show etherchannel summary`

## [三层交换机操作](#Layer_3_Switch_Operations)
三层交换机(具备路由功能的交换机)需要注意的地方：
### 使用端口路由
- 进入接口配置模式：`int f0/1`
- 关闭交换模式：`no switchport`
- 配置IP地址：`ip address 192.168.1.254 255.255.255.0`
- 开启接口：`no shutdown`
- 开启路由功能：`ip routing`

### 使用VLAN路由
- 创建VLAN：`vlan 10`，`vlan 20`
- 将端口加入VLAN：`int f0/2`，`switchport mode access`，`switchport access vlan 20`
- 配置VLAN接口：`int vlan 10`，`ip address 192.168.1.254 255.255.255.0`
- 注意：不需要开启IP路由

### 开启Trunk封装
三层交换机开启trunk需要封装
- 进入接口配置模式：`int f0/3`
- 设置封装类型：`switchport trunk encapsulation dot1q`
- 开启Trunk模式：`switchport mode trunk`

## [配置DHCP](#配置DHCP)
- 开启DHCP服务(全局配置模式)：`service dhcp`
- 创建DHCP池：`ip dhcp pool bbb`  bbb是地址池的名称
- 配置网络和默认路由器：`network 192.168.1.0 255.255.255.0`，`default-router 192.168.1.1`
- 配置DNS服务器：`dns-server 60.191.244.5`
- 保存配置(特权模式)：`write memory` 或者 `copy running-config startup-config`


## [配置GRE-tunnel隧道](#配置GRE-tunnel隧道)
![屏幕截图 2024-10-25 212304](https://github.com/user-attachments/assets/61ca170d-b4bc-4d9e-9151-95b2ac29ca4b)  
配置示例:  
Route0是公网的路由  
在Router1和Router2中使用默认路由指向Route0用来模拟公网透明传输  
Router1:  
`ip route 0.0.0.0 0.0.0.0 <R0的接口/直连ip地址>`  
Router2:  
`ip route 0.0.0.0 0.0.0.0 <R0的接口/直连ip地址>`  

配置Router1和Router2之间的GRE隧道  
隧道的源接口是 FastEthernet0/1，目标是Router2 的 FastEthernet0/1  

Router1:  
`interface Tunnel0`  
给GRE隧道配置ip地址  
`ip address <R1隧道的ip地址> <子网掩码>`  
指定隧道的接口  
`tunnel source FastEthernet0/1`  
指定目的接口的ip地址  
`tunnel destination <R2的目的接口的ip地址>`  
`no shutdown`  

Router2:  
`interface Tunnel0`  
给GRE隧道配置ip地址  
`ip address <R2隧道的ip地址> <子网掩码>`  
指定隧道的接口  
`tunnel source FastEthernet0/1`  
指定目的接口的ip地址  
`tunnel destination <R1的目的接口的ip地址>`  
`no shutdown`  

在R1和R2中使用 ospf 路由（端到端路由传递）  
Router1:  
配置进程号(仅本地有效)  
`router ospf 1`  
指定路由器id号用于区分路由器  
`router-id 1.1.1.1`  
`network <与R1相连接的内网网段> <子网掩码/反掩码> area 0`  
`network <隧道ip的网段> <子网掩码/反掩码> area 0`  
Router2:  
配置进程号(仅本地有效)  
`router ospf 1`  
指定路由器id号用于区分路由器  
`router-id 2.2.2.2`  
`network <与R2相连接的内网网段> <子网掩码/反掩码> area 0`  
`network <隧道ip的网段> <子网掩码/反掩码> area 0`  

验证隧道接口的状态 `show ip interface brief` 应显示 `up/up` 状态  
`show ip route` 输出应显示静态路由条目，验证静态路由已成功配置  
输入 `show ip ospf interface` 查看邻居建立结果  


## [日志信息](#日志信息)
- 启用日志记录功能(全局配置模式)：`logging on`
- 设置日志服务器地址：`logging host <IP地址>` 或 `logging host <域名>`
- 设置日志记录的严重级别：`logging trap <级别>` 级别范围从0（紧急）到7（调试），例如 logging trap 3 表示记录错误及以上级别的日志。
- 设置日志消息的时间戳：`service timestamps log datetime localtime`
- 查看日志信息：`show logging`
- 清除缓存器中的日志消息：`clear logging`


## [关于设备信息](#关于设备信息)
- 查看设备版本信息：`show version`
- 查看设备时钟信息：`show clock`
- 查看设备技术支持信息：`show tech-support`
