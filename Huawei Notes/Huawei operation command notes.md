# Huawei命令笔记
 
- [基础命令](#基础命令)
- [接口速率](#接口速率)
- [MAC地址自动学习于接口绑定](#MAC地址自动学习于接口绑定)
- [生成树协议](#生成树协议)
- [链路聚合](#链路聚合)
- [vlan的创建与应用](#vlan的创建与应用)
- [vlan中绑定MAC地址](#vlan中绑定MAC地址)
- [MUX-VLAN配置](#MUX-VLAN配置)
- [交换机端口隔离功能](#交换机端口隔离功能)
- [不同vlan之间的通信](#不同vlan之间的通信)
- [VRRP默认网关冗余技术](#VRRP默认网关冗余技术)
- [MSTP与VRRP](#MSTP与VRRP)
- [路由协议](#路由协议)


## [基础命令](#基础命令)
用户视图 `<Huawei>`

1.进入系统视图  
```
system-view
```

2.删除或禁用某个功能或者删除某项配置  
```
undo
```

3.在系统视图中设置网络设备的名称  
```
sysname 设备的名称
```   
缩写  
```
sys 设备的名称
```

4.用户视图中查看当前生效的配置信息  
```
display current-configuration
```
缩写为
```
disp cur
```

5.查看系统当前视图运行的配置  
```
display this
```

6.验证网络连通性
```
ping -c <测试的次数(数字)> <your ip address>
```

7.查看系统vlan信息  
```
display vlan
```

8.查看vlan中接口信息  
```
display port vlan
```

9.显示端口组的详细信息
```
display port-group
```

10.显示以太网聚合接口（Eth-Trunk）的信息
```
display eth-trunk
```

11.查看隔离组中的接口配置信息(系统视图)  
```
display port-isolate group all
```

12.查看设备路由表  
```
display ip routing-table
```

13.查看交换机MAC地址表(为空就是没有ping)  
```
display mac-address
```

14.查看交换机链路状态
```
display stp brief
```

15.查看交换机接口模式接口速率  
```
display interface Ethernet brief
```

16.进入指定接口视图  
```
interface 接口名称
```  

17.退回较低级别的视图  
```
quit
```

18.在用户视图中保持当前的配置  
```
save
```

19.在用户视图中重启系统  
```
reboot
```

20.在用户视图中清空设备下次启动使用的配置文件内容  
```
reset saved-configuration
```

21.进入接口视图配置接口描述  
```
description 描述信息
```

## [接口速率](#接口速率)
1.接口视图中将当前接口配置为非自动协商模式和全双工模式  
```
undo negotiation auto
```
```
duplex full
```

2.接口视图中将接口速率设置为100Mb/s  
```
speed 100
```

3.接口视图中打开当前接口流量控制开关  
```
flow-control
```

## [MAC地址自动学习于接口绑定](#MAC地址自动学习于接口绑定)
1.系统视图中关闭交换机指定接口的MAC地址学习功能(避免陌生mac设备接入),也称为信息中心功能  
```
undo info-center enable
```

2.关闭指定接口的MAC地址自动学习功能(接口视图中)  
```
mac-address learning disable action discard
```

3.将host1的MAC地址与Ethernet 0/0/1接口绑定  
```
Mac-address static <host1的mac地址> Ethernet0/0/1 vlan 1
```


## [生成树协议](#生成树协议)
交换机间采用双链路通信时，如果关闭生成树协议，交换机间会出现广播包环路，严重消耗网络资源，最终导致整个网络资源被耗尽，网络瘫痪不可用  

![认识生成树协议](https://github.com/user-attachments/assets/3034571e-0d31-4afb-bab9-8e5f0b0142e5)

1:认识生成树  
生成树协议：不改变网络的实际拓扑，在逻辑上切断某些链路，使得一台主机到所有其他主机的路径是无环路的树状结构，从而消除了环路  
STP的作用是防止环路和提供冗余功能  
STP的版本：  
STP(多生成树) --> RSTP(快速生成树协议) --> MSTP(多生成树协议)  
MSTP实现了对VLAN的兼容(一般使用这个版本的STP)  

开启交换机生成树协议(系统视图)  
```
stp enable
```
我们一般使用高级版本的STP协议MSTP  
2.MSTP的应用  
多个vlan凑成一个实例(instance)多个实例凑成一个区域（一个实例对应一个树）  
LSW1:  
进入系统视图  
```
sys
```
创建VLAN  
```
vlan batch 10 20 30 40
```
进入接口组模式
```
port-group 1
```
加入组成员接口
```
group-member e0/0/1 to e0/0/3
```
将组成员接口配置为trunk模式
```
port link-type trunk
```
配置允许所有VLAN通过
```
port trunk allow-pass vlan all
```
退出接口组视图
```
quit
```
选择MSTP版本
```
stp mode mstp
```
进入区域视图
```
stp region-configuration
```
设置区域名称
```
region-name RG1
```
关联实例
```
instance 1 vlan 10 30
```
```
instance 2 vlan 20 40
```
激活区域
```
active region-configuration
```
配置实例优先级(数字越小优先级越高越不会被断开，数字越大优先级越低容易断开)
```
stp instance 1 priority 4096
```
```
stp instance 2 priority 8192
```

LSW2:  
进入系统视图  
```
sys
```
创建VLAN
```
vlan batch 10 20 30 40
```
进入接口组模式
```
port-group 1
```
加入组成员接口
```
group-member e0/0/1 to e0/0/3
```
将组成员接口配置为trunk模式
```
port link-type trunk
```
配置允许所有VLAN通过
```
port trunk allow-pass vlan all
```
退出接口组视图
```
quit
```
选择MSTP版本
```
stp mode mstp
```
进入区域视图
```
stp region-configuration
```
设置区域名称
```
region-name RG1
```
关联实例
```
instance 1 vlan 10 30
```
```
instance 2 vlan 20 40
```
激活区域
```
active region-configuration
```
配置实例优先级(数字越小优先级越高越不会被断开，数字越大优先级越低容易断开)
```
stp instance 1 priority 8192
```
```
stp instance 2 priority 4096
```


## [链路聚合](#链路聚合)
关闭生成树协议使用链路聚合实现正常通信，并提供链路可靠性增加网络带宽  
创建链路聚合组1(系统视图)  
```
interface Eth-Trunk 1
```  
退出当前视图  
```
quit
```  
进入接口视图  
```
interface g0/0/1
```  
将当前接口加入到之前创建的链路聚合组1中  
```
eth-trunk 1
```  
退出当前视图  
```
quit
```  
进入接口视图  
```
int g0/0/2
```  
将当前接口加入到之前创建的链路聚合组1中  
```
eth-trunk 1
```  
退出当前视图  
```
quit
```  
同理另外一台交换机也配置相同的配置  

链路聚合拓扑及配置Demo  

![链路聚合](https://github.com/user-attachments/assets/40eb1087-712e-4bce-96d3-6dac0930d7e2)

链路聚合用于增加带宽  
链路聚合的配置  
进入聚合接口  
```
int Eth-Trunk 1
```
加入成员  
```
trunkport g0/0/2
```
```
trunkport g0/0/3
```
```
trunkport g0/0/4
```
或者  
```
trunkport g 0/0/2 to 0/0/4
```
配置为Trunk  
```
port link-type trunk
```
允许所有vlan通过  
```
port trunk allow-pass vlan all
```

## Access、Trunk、Hybrid含义
**Access**类型：端口只能属于1个VLAN，`一般用于连接计算机`  
**Trunk**类型：端口可以属于多个VLAN，可以接收和发送多个VLAN的报文，`一般用于交换机之间连接`  
**Hybrid**类型：端口可以属于多个VLAN，可以接收和发送多个VLAN的报文，可以用于`交换机`之间连接，也可以用于连接用户的`计算机`  

## [vlan的创建与应用](#vlan的创建与应用)
创建多个vlan  
```
vlan batch 10 20 30 100
```

将接口划入vlan  
```
interface Ethernet0/0/1
```

将接口类型配置为access  
```
port link-type access
```

划分到vlan 100  
```
port default vlan 100
```

创建进入某个vlan的视图(10是vlan的编号)  
```
vlan 100
```

设置为主vlan(主vlan可以和所有vlan通信)  
```
mux-vlan
```

在某个vlan视图内绑定互通型vlan 10 vlan 20(互通型vlan可以和主vlan通信也可以和同一vlan内的设备通信)  
```
subordinate group 10 20
```  
缩写  
```
sub group 10 20
```

在某个vlan视图内定义一个隔离形vlan 30(隔离型vlan只能与主vlan通信不能与其他vlan通信)  
```
subordinate separate 30
```  
缩写  
```
sub sep 30
``` 

显示当前视图下的配置  
```
display this
```  
缩写  
```
disp this
``` 

退出当前视图  
```
quit
```  
缩写  
```
q
```


设置接口的链路类型为access  
进入接口  
```
int g0/0/2
```  

配置接口的链路类型为access  
```
port link-type access
```  

配置当前接口的vlan为vlan 100  
```
port default vlan 100
```

启用当前接口的主vlan(只有开启了才能应用主vlan的对于关系)  
```
port mux-vlan enable
```


设置接口的链路类型为trunk  
进入接口  
```
int g0/0/1
```

配置接口的链路类型为trunk  
```
port link-type trunk
```

配置运行通过的vlan  
```
port trunk allow-pass vlan 10 20 30 100
```

或允许全部vlan通过  
```
port trunk allow-pass vlan all
```

## [vlan中绑定MAC地址](#vlan中绑定MAC地址)
vlan中绑定MAC地址  
进入vlan视图  
```
vlan 10
```  
绑定MAC地址到VLAN：  
```
mac-vlan mac-address <MAC地址>
```

在接口中基于MAC地址实现划分VLAN  
进入接口视图  
```
int g0/0/1
```  
启用基于MAC地址的VLAN功能：  
```
mac-vlan enable
```

将接口设置为hybrid类型  
```
port link-type hybrid
```

允许vlan 10和vlan 20的帧通过，并且将帧发送出接口时去掉VLAN标记  
```
port hybrid untagged vlan 10 20
```


## [MUX-VLAN配置](#MUX-VLAN配置)
绑定vlan关系：  
主 VLAN(Principal VLAN)可以访问所有从 VLAN  
组 VLAN(Group VLAN)内部的接口可以互相访问，也可以访问主 VLAN，但不能访问隔离 VLAN  
隔离 VLAN(Isolate VLAN)内部的接口不能互相访问，只能访问主 VLAN  
主vlan: mux-vlan  
互通型(组)vlan: sub group  
隔离型vlan: sub sep  
MUX VLAN 是一种用于对连接批量设备的访问控制功能，  
它允许在一个物理接口上虚拟出多个逻辑接口，  
每个逻辑接口可以属于不同的 VLAN，从而实现不同 VLAN 间的隔离和互通  

### 接口绑定vlan    
trunk模式:    
```
int <接口名称>
```
设置接口为trunk模式
```
port link-type trunk
```
配置允许通过的VLAN
```
port trunk allow-pass vlan <允许通过的vlan列表>
```

access模式:  
```
int 接口名称
```
设置接口为access模式
```
port link-type access
```
绑定VLAN
```
port default vlan <vlan编号>
```
启用策略
```
port mux-vlan enable
```  
退出当前视图
```
quit
```

### vlan关系配置示例:  
进入系统视图  
```
sys
```  
配置设备名称  
```
sysname LSW2
```  
批量创建vlan  
```
vlan batch 10 20 30 100
```  
进入vlan 100的视图  
```
vlan 100
```  
将vlan 100配置为MUX VLAN的主VLAN  
```
mux-vlan
```  
配置为互通型vlan:  
```
subordinate group 10 20
```  
配置为隔离型vlan:  
```
subordinate separate 30
```  
显示当前的配置信息  
```
display this
```  
退出当前视图  
```
quit
```

### 在接口中应用：  
进入接口视图  
```
interface g0/0/1
```  
接口设置为trunk模式  
```
port link-type trunk
```  
指定允许通过的vlan  
```
port trunk allow-pass vlan 10 20 30 100
```  
退出当前视图  
```
quit
```  
进入接口视图  
```
int g0/0/2
```  
接口设置为access模式  
```
port link-type access
```  
将主vlan 100划分到当前接口  
```
port default vlan 100
```  
启用 MUX VLAN  
```
port mux-vlan enable
```  
退出当前视图  
```
quit
```

**创建了一个名为vlan10的端口组**  
端口组是`将多个物理端口逻辑上组合在一起`，以便可以对它们进行统一的配置和管理  
```
port-group vlan10
```  
将多个端口加入到名为vlan10的端口组中  
```
group-member g0/0/3 to g0/0/14
```  
设置为access模式,access模式下端口只允许一个VLAN的流量通过  
```
port link-type access
```  
将端口的默认VLAN设置为vlan 10  
```
port default vlan 10
```  
启用了MUX VLAN功能(不启用无法生效主vlan策略)  
```
port mux-vlan enable
```  
退出当前视图  
```
quit
```

**创建了一个名为vlan30的端口组**  
```
port-group vlan30
```  
将多个端口加入到名为vlan10的端口组中  
```
group-member g0/0/15 to g0/0/24
```  
设置为access模式  
```
port link-type access
```  
将端口的默认VLAN设置为vlan 30  
```
port default vlan 30
```  
启用了MUX VLAN功能(不启用无法生效主vlan策略)  
```
port mux-vlan enable
```  
退出端口组视图  
```
quit
```  
退出系统视图  
```
quit
```  
在用户视图中保存当前配置  
```
save
```  
选择是  
```
y
```


## [交换机端口隔离功能](#交换机端口隔离功能)
交换机实现端口隔离功能  
接口视图下开启此接口的端口隔离功能  
交换机默认是将隔离的端口加入到了一个隔离组中，默认是group 1，处于同一个组中的端口之间是不能互相访问的。不同组之间的端口是可以互相访问的。  
将1口加入到组1中  
```
interface GigabitEthernet0/0/1
```  
```
port-isolate enable group 1
```  
 或  
```
port-isolate enable
```  

将2口加入到组1中  
```
interface GigabitEthernet0/0/2
```  
```
port-isolate enable group 1
```  
 或  
```
port-isolate enable
```  

将3口加入到组2中  
```
interface GigabitEthernet0/0/3
```  
```
port-isolate enable group 2
```  
1、2口之间的主机即使处于同一个网段中也是不能互相访问的，但是他们和3口之间是可以互相访问的。这属于端口隔离中的双向隔离。需要注意的是，同组中的端口是不能互相访问的，即使没有配置端口隔离的端口，是可以和配置了的端口进行访问的


还有一种是单向隔离，如果在一个端口下开启和另一个端口之间的单向隔离，那么另一个端口的发包是可以到达此接口的，只是此接口回不了包而已  
```
interface g0/0/3
```  
```
am isolate g0/0/1
```  
那么，1口的包是可以到达3口的，只是3口不能给1口进行回包而已


如果开启了代理arp，那么双方还是会相互访问，那是因为隔离模式默认是2层隔离，开启了代理arp,数据包会发送给具有代理arp功能的设备，如果这个设备有能力到达目标IP，那么所请求的mac地址，就由代理arp帮你请求  
进入到需要开启代理arp的接口  
```
interface g0/0/0
```  
```
arp-proxy enable
```  
这样的话，即使开启的单向隔离，那么两个端口之间也会进行访问，但是需要注意它们之间访问的逻辑是什么

项目示例：  
实验要求：  
内部员工外部员工和外来人员所有pc能访问服务器  
外部员工能和内部员工通信，但外部员工之间不能通信来访人员不能和员工通信  

实验配置：  
内部外部员工使用vlan 10  
访客使用vlan 20  
服务器使用vlan 100  
使用vlanif在端口中应用使其都能通信  
然后使用端口隔离功能  
把内部员工pc1加入group1  
把内部员工pc2加入group2  
把外部员工pc3加入group3  
把外部员工pc4加入group3  
把访客pc5中加入group1，group2，group3  
把访客pc6中加入group1，group2，group3  
也就是说一个端口中可以加入多个组(相同组无法通信，不同组才能进行通信)  

命令解释：  
属于同一个VLAN不能进行二层通信但是可以进行三层通信  
```
port-isolate mode l2
```  
属于同一个VLAN既不能进行二层通信，也不能进行三层通信  
```
port-isolate mode all
```  

## [不同vlan之间的通信](#不同vlan之间的通信)
### 三层交换机创建VLAN SVI实现不同vlan之间的通信  
创建vlan 10的SVI,并给其配置ip地址  
```
vlan batch 10
```  
```
quit
```  
```
interface vlanif 10
```  
```
ip address 192.168.64.254 255.255.255.0
```  
VLAN 10的SVI的IP地址，就是VLAN 10中各主机配置的默认网关地址  
#### 在接口中应用：  
##### 接口为Access类型：  
```
int g0/0/1
```  
```
port link-type access
```  
```
port default vlan 10
```  
```
quit
```  
##### 接口为Trunk类型：  
```
int g0/0/1
```  
```
port link-type trunk
```  
```
port trunk allow-pass vlan 10
```  
```
quit
```  

### 在路由器接口中配置地址  
```
int g0/0/1
```  
```
ip address <ip地址> <子网掩码>
```  


## [VRRP默认网关冗余技术](#VRRP默认网关冗余技术)
VRRP默认网关冗余技术(避免默认网关失效)  
即使用了双网关  
如果AR1路由器坏掉了，那么久可以使用AR2路由器作为网关  
![VRRP](https://github.com/user-attachments/assets/73aca3af-da7a-4a8b-a123-60f8fb12abc3)

AR1:  
进入内部接口网关的视图  
```
int g0/0/1
```
配置内部网关接口的IP地址
```
ip address 192.168.11.1 24
```
在接口中配置虚拟IP,即网关(这里的虚拟IP地址要和实际的IP地址在同一个网段内)
```
vrrp vrid 1 virtual-ip 192.168.11.254
```
配置AR1的优先级(这里的数字越大优先级越高)
```
vrrp vrid 1 priority 120
```
配置回环接口用于测试优先级
```
int LoopBack 1
```
配置接口ip地址用于测试(PC只要能到这个路由器那么就能访问这个ip)
```
ip address 10.10.10.1 32
```


AR2:  
进入内部接口网关的视图  
```
int g0/0/0
```
配置内部网关接口的IP地址
```
ip address 192.168.11.2 24
```
在接口中配置虚拟IP,即网关
```
vrrp vrid 1 virtual-ip 192.168.11.254
```
配置回环接口用于测试优先级
```
int LoopBack 1
```
配置接口ip地址用于测试(PC只要能到这个路由器那么就能访问这个ip)
```
ip address 20.20.20.1 32
```
查看交换机链路状态
```
display stp brief
```

## [MSTP与VRRP](#MSTP与VRRP)
拓扑图如下  
![屏幕截图 2024-11-03 095150](https://github.com/user-attachments/assets/660f7757-e9c5-4253-9f42-28808d3575ae)

可以见到LSW1与LSW2，LSW3，LSW4之间的链路都使用Trunk模式  
LSW3和LSW4与各自四台PC之间的链路都使用Access模式  
我们把PC1和PC5的默认VLAN设置为VLAN 10  
我们把PC2和PC6的默认VLAN设置为VLAN 20  
我们把PC3和PC7的默认VLAN设置为VLAN 30  
我们把PC4和PC8的默认VLAN设置为VLAN 40  

接下来是配置命令部分  
SW1:  
进入系统视图  
```
system-view
```
创建VLAN
```
vlan batch 10 20 30 40
```

进入接口组模式编号1
```
port-group 1
```
添加接口组成员
```
group-member g0/0/1 to g0/0/2
```
或不用事先指定接口组编号使用默认编号直接添加接口组成员
```
port-group group-member g0/0/1 to g0/0/2
```
将接口组1链路设置为Trunk模式
```
port link-type trunk
```
编辑允许所有VLAN通过
```
port trunk allow-pass vlan all
```
退出当前接口组1视图
```
quit
```
配置LSW1与LSW2的链路聚合
进入聚合接口组1
```
int Eth-Trunk 1
```
添加聚合端口
```
trunkport g 0/0/3 to 0/0/4
```
设置端口的链路类型为混合模式
```
port link-type hybrid
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 10
```
配置逻辑接口的ip地址
```
ip address 192.168.10.1 24
```
配置虚拟网关的ip地址
```
vrrp vrid 10 virtual-ip 192.168.10.254
```
提高vrid 10的优先级
`在VRRP中，优先级较高的路由器将成为主路由器(master)，负责转发虚拟IP地址的流量。通过提高优先级，您可以控制哪个路由器将成为主路由器(即主网关地址)。`
```
vrrp vrid 10 priority 120
```
配置虚拟网关的ip地址
```
vrrp vrid 11 virtual-ip 192.168.10.253
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 20
```
配置逻辑接口的ip地址
```
ip address 192.168.20.1 24
```
配置虚拟网关的ip地址
```
vrrp vrid 20 virtual-ip 192.168.20.254
```
提高vrid 20的优先级
```
vrrp vrid 20 priority 120
```
配置虚拟网关的ip地址
```
vrrp vrid 21 virtual-ip 192.168.20.253
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 30
```
配置逻辑接口的ip地址
```
ip address 192.168.30.1 24
```
配置虚拟网关的ip地址
```
vrrp vrid 30 virtual-ip 192.168.30.254
```
提高vrid 30的优先级
```
vrrp vrid 30 priority 120
```
配置虚拟网关的ip地址
```
vrrp vrid 31 virtual-ip 192.168.30.253
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 40
```
配置逻辑接口的ip地址
```
ip address 192.168.40.1 24
```
配置虚拟网关的ip地址
```
vrrp vrid 40 virtual-ip 192.168.40.254
```
提高vrid 40的优先级
```
vrrp vrid 40 priority 120
```
配置虚拟网关的ip地址
```
vrrp vrid 41 virtual-ip 192.168.40.253
```
退出当前视图
```
quit
```
选择MSTP版本
```
stp mode mstp
```
进入MSTP协议视图
```
stp region-configuration
```
设置区域名称
```
region-name RG1
```
关联实例
将VLAN 10和VLAN 30关联到编号为1的实例
```
instance 1 vlan 10 30
```
将VLAN 20和VLAN 40关联到编号为2的实例
```
instance 2 vlan 20 40
```
激活区域
```
active region-configuration
```
退出当前视图
```
quit
```
配置实例优先级(数字越小优先级越高，数字越大优先级越低)  
这里优先使用实例1  
```
stp instance 1 priority 4096
```
```
stp instance 2 priority 8192
```
退出当前视图
```
quit
```
退出当前视图
```
quit
```
保存当前配置
```
save
```
输入 y 确认

SW2:  
进入系统视图
```
system-view
```
创建VLAN
```
vlan batch 10 20 30 40
```
进入接口组模式编号1
```
port-group 1
```
添加接口组成员
```
group-member g0/0/1 to g0/0/2
```
或不用事先指定接口组编号使用默认编号直接添加接口组成员
```
port-group group-member g0/0/1 to g0/0/2
```
将接口组1链路设置为Trunk模式
```
port link-type trunk
```
编辑允许所有VLAN通过
```
port trunk allow-pass vlan all
```
退出当前接口组1视图
```
quit
```
配置LSW1与LSW2的链路聚合
进入聚合接口组1
```
int Eth-Trunk 1
```
添加聚合端口
```
trunkport g 0/0/3 to 0/0/4
```
设置端口的链路类型为混合模式
```
port link-type hybrid
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 10
```
配置逻辑接口的ip地址
```
ip address 192.168.10.2 24
```
配置虚拟网关的ip地址
```
vrrp vrid 10 virtual-ip 192.168.10.254
```
配置虚拟网关的ip地址
```
vrrp vrid 11 virtual-ip 192.168.10.253
```
提高vrid 11的优先级
```
vrrp vrid 11 priority 120
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 20
```
配置逻辑接口的ip地址
```
ip address 192.168.20.1 24
```
配置虚拟网关的ip地址
```
vrrp vrid 20 virtual-ip 192.168.20.254
```
配置虚拟网关的ip地址
```
vrrp vrid 21 virtual-ip 192.168.20.253
```
提高vrid 21的优先级
```
vrrp vrid 21 priority 120
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 30
```
配置逻辑接口的ip地址
```
ip address 192.168.30.1 24
```
配置虚拟网关的ip地址
```
vrrp vrid 30 virtual-ip 192.168.30.254
```
配置虚拟网关的ip地址
```
vrrp vrid 31 virtual-ip 192.168.30.253
```
提高vrid 31的优先级
```
vrrp vrid 31 priority 120
```
退出当前视图
```
quit
```
进入逻辑接口视图
```
int vlanif 40
```
配置逻辑接口的ip地址
```
ip address 192.168.40.1 24
```
配置虚拟网关的ip地址
```
vrrp vrid 40 virtual-ip 192.168.40.254
```
配置虚拟网关的ip地址
```
vrrp vrid 41 virtual-ip 192.168.40.253
```
提高vrid 41的优先级
```
vrrp vrid 41 priority 120
```
退出当前视图
```
quit
```
选择MSTP版本
```
stp mode mstp
```
进入MSTP协议视图
```
stp region-configuration
```
设置区域名称
```
region-name RG1
```
关联实例
将VLAN 10和VLAN 30关联到编号为1的实例
```
instance 1 vlan 10 30
```
将VLAN 20和VLAN 40关联到编号为2的实例
```
instance 2 vlan 20 40
```
激活区域
```
active region-configuration
```
退出当前视图
```
quit
```
配置实例优先级(数字越小优先级越高，数字越大优先级越低)
这里优先使用实例2
```
stp instance 1 priority 8192
```
```
stp instance 2 priority 4096
```
退出当前视图
```
quit
```
退出当前视图
```
quit
```
保存当前配置
```
save
```
输入 y 确认


SW3:
进入系统视图
```
system-view
```
创建VLAN
```
vlan batch 10 20 30 40
```
进入接口组模式编号1
```
port-group 1
```
添加接口组成员
```
group-member e0/0/1 to e0/0/2
```
将接口组1链路设置为Trunk模式
```
port link-type trunk
```
编辑允许所有VLAN通过
```
port trunk allow-pass vlan all
```
退出当前接口组1视图
```
quit
```
进入接口组模式编号2
```
port-group 2
```
添加接口组成员
```
group-member e0/0/3 to e0/0/6
```
将接口组2链路设置为Access模式
```
port link-type access
```
退出当前视图
```
quit
```
进入接口e0/0/3视图
```
int e0/0/3
```
配置默认VLAN为vlan 10
```
port default vlan 10
```
退出当前视图
```
quit
```
进入接口e0/0/4视图
```
int e0/0/4
```
配置默认VLAN为vlan 20
```
port default vlan 20
```
退出当前视图
```
quit
```
进入接口e0/0/5视图
```
int e0/0/5
```
配置默认VLAN为vlan 30
```
port default vlan 30
```
退出当前视图
```
quit
```
进入接口e0/0/6视图
```
int e0/0/6
```
配置默认VLAN为vlan 40
```
port default vlan 40
```
退出当前视图
```
quit
```
选择MSTP版本
```
stp mode mstp
```
进入MSTP协议视图
```
stp region-configuration
```
设置区域名称
```
region-name RG1
```
关联实例  
将VLAN 10和VLAN 30关联到编号为1的实例  
```
instance 1 vlan 10 30
```
将VLAN 20和VLAN 40关联到编号为2的实例  
```
instance 2 vlan 20 40
```
激活区域
```
active region-configuration
```
退出当前视图
```
quit
```
退出当前视图
```
quit
```
保存当前配置
```
save
```
输入 y 确认


LSW4:  
进入系统视图
```
system-view
```
创建VLAN
```
vlan batch 10 20 30 40
```
进入接口组模式编号1
```
port-group 1
```
添加接口组成员
```
group-member e0/0/1 to e0/0/2
```
将接口组1链路设置为Trunk模式
```
port link-type trunk
```
编辑允许所有VLAN通过
```
port trunk allow-pass vlan all
```
退出当前接口组1视图
```
quit
```
进入接口组模式编号2
```
port-group 2
```
添加接口组成员
```
group-member e0/0/3 to e0/0/6
```
将接口组2链路设置为Access模式
```
port link-type access
```
退出当前视图
```
quit
```
进入接口e0/0/3视图
```
int e0/0/3
```
配置默认VLAN为vlan 10
```
port default vlan 10
```
退出当前视图
```
quit
```
进入接口e0/0/4视图
```
int e0/0/4
```
配置默认VLAN为vlan 20
```
port default vlan 20
```
退出当前视图
```
quit
```
进入接口e0/0/5视图
```
int e0/0/5
```
配置默认VLAN为vlan 30
```
port default vlan 30
```
退出当前视图
```
quit
```
进入接口e0/0/6视图
```
int e0/0/6
```
配置默认VLAN为vlan 40
```
port default vlan 40
```
退出当前视图
```
quit
```
选择MSTP版本
```
stp mode mstp
```
进入MSTP协议视图
```
stp region-configuration
```
设置区域名称
```
region-name RG1
```
关联实例  
将VLAN 10和VLAN 30关联到编号为1的实例  
```
instance 1 vlan 10 30
```
将VLAN 20和VLAN 40关联到编号为2的实例
```
instance 2 vlan 20 40
```
激活区域
```
active region-configuration
```
退出当前视图
```
quit
```
退出当前视图
```
quit
```
保存当前配置
```
save
```
输入 y 确认  
测试阶段  
在LSW1和LSW2中分别配置回环接口的ip地址  
LSW1:  
进入回环接口  
```
int LoopBack 1
```
配置回环接口ip地址
```
ip address 10.10.10.1 24
```
这里最好保存一下配置  
LSW2:  
进入回环接口  
```
int LoopBack 1
```
配置回环接口ip地址
```
ip address 20.20.20.1 24
```
这里最好保存一下配置  
4台PC的网关配置为254，另外四台网关配置为253  
测试当一台交换机坏了(关闭LSW1或LSW2)测试是否还能实现通信  
测试结果能够实现通信  
![result](https://github.com/user-attachments/assets/ba1c3d93-e9bc-4681-aba0-b8188fff78de)


## [路由协议](#路由协议)
### 配置默认路由:  
```
ip route-static 0.0.0.0 0.0.0.0 <下一跳地址>
```  

### 配置静态路由:  
```
ip route-static <目的网络地址.0结尾的> <子网掩码/网络号24> <下一跳地址>
```  

### 配置RIP路由：  
RIP是一种基于距离矢量的算法协议，它使用跳数作为度量值来衡量到达目的地址的距离，于它直连的网络跳数为0，通过一个设备可达的网络的跳数为1  
RIP不能在大型网络中得到应用  
特点：仅和相邻路由器交换信息  
1. 进入RIP进程配置模式
```shell
rip
```
2. 网络声明
```shell
network [ip address]
```
在RIP中声明直连的网络段，使能这些网段上的接口参与RIP路由协议    
3. 配置RIP版本
- 配置RIP2
启用 RIP 默认 v1
```shell
rip
version 2
network [ip address]
```
- 或者直接配置
```shell
rip 1
version 2
network [ip address]
```
这些命令用于配置路由器使用RIP版本2，RIPv2支持CIDR和VLSM，允许更灵活的路由汇总  
4. 查看 rip
```shell
disp rip
```
5. 查看 rip 数据库
```shell
disp rip <进程号> database
```
6. 查看路由表
```shell
disp ip routing-table
```
7. 配置RIPv2自动汇总路由
- 方法1：
```shell
rip 1
version 2
summary always
```
- 方法2：
```shell
int [接口]
undo rip split-horizon
```
关闭水平分割功能，允许自动汇总路由  
8. 配置RIPv2手动汇总
```shell
int [接口]
rip summary-address 3.3.0.0 255.255.252.0
```
9. RIP与不连续子网（解决不连续子网问题）  
- 方法1：给接口配置第二个IP地址  
```shell
int [接口]
ip address 10.0.23.2 sub
```
- 方法2：使用RIPv2，关闭自动汇总
```shell
rip
version 2
undo summary
```
关闭自动汇总，关闭水平分割功能，开启毒性逆转功能，增加度量值  
10. Rip路由引入  
- 引入直连路由
```shell
rip
import-route direct
```
- 引入静态路由
```shell
rip
import-route static
```
- 引入OSPF路由
```shell
import-route ospf
```
- 引入BGP路由
```shell
import-route bgp
```
11. 查看RIP定期更新情况
```shell
debugging rip 1
```
开启RIP调试，查看RIP协议的定期更新情况  
12. 调试信息显示设置
```shell
terminal debugging
terminal monitor
```
这些命令用于在屏幕上显示调试信息  
13. 关闭debug调试功能
```shell
undo debugging rip 1
undo debug all
```
14. RIP简单认证
```shell
rip authentication-mode simple huawei
```
配置RIP简单认证，需要在所有路由器上配置相同的密码  
15. 配置RIPv2 MD5密文验证
```shell
rip authentication-mode md5 usual huawei
```
配置RIP使用MD5密文验证，增强安全性  
16. 查看RIP配置信息
```shell
disp default-parameter rip
```
17. 配置RIP版本兼容
```shell
rip version 2 broadcast
rip version 2 multicast
```
配置路由器以广播或组播的形式发送RIPv2报文  
18. 配置RIP定时器和优先级  
- 停止发送RIP路由更新
```shell
int [接口]
undo rip output
```
- 检查RIP发布数据库中的所有路由激活
```shell
display rip 1 database
```
- 设置RIP定时器
```shell
rip
timers rip 20 120 60
```
- 修改RIP协议优先级
```shell
preference 90
```
19. 配置抑制接口
```shell
rip 1
silent-interface GigabitEthernet 0/0/0
```
设置要抑制的接口，不通过该接口发送或接收RIP更新  
20. 配置RIP单播更新
```shell
rip 1
peer 172.16.1.100
```
配置RIP单播更新，指定邻居路由器的IP地址
