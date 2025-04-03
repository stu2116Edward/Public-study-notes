# Centos网络配置
## 一、centos网络配置说明
虚拟机网络配置有三种模式：Bridged桥接模式 、host-only仅主机模式、NAT模式。
下面分别介绍这三种模式  
![b6cf42b233c212c41750a5053f9f680f](https://github.com/user-attachments/assets/f9417abc-9203-4c34-960b-d870d8b91c74)  

### 1.Bridget桥接模式  
默认使用Vmnet0，不提供DHCP服务  
虚拟机与外部主机在同一个网段上，相当于一个主机。  
既能与局域网内的主机通讯，也能与外部网络通信。  
容易与局域网其他主机引起ip地址冲突。  
![0612eecd9d1d26d160e2c6563a64d851](https://github.com/user-attachments/assets/e50c4532-171f-47eb-befe-d833c09e7ecb)  

桥接模式直接与本机网络连接，可访问外部网络。  

### 2.仅主机模式
默认使用VMnet1,提供DHCP服务。  
一般情况下不能访问外网。  
可以与物理主机（本机）访问。  
![6ac0a8894b6d6cea63da9a15643b4201](https://github.com/user-attachments/assets/f5dd9c23-da85-488c-970a-de89cdf322b0)  
可以设置DHCP，可以修改ip地址范围，注意红圈前面的不要修改，否则本机以及虚拟机的都要修改，如下图。  
![f2b190750d03b5c21707db7e038d6583](https://github.com/user-attachments/assets/298904e9-86a8-4395-84f5-0bd8ca7540c0)  

### 3.NAT模式
默认使用VMnet8，提供DHCP服务。  
可以与物理机互相访问，也可访问外部网络。  
不能访问局域内其他机器。  
不会与局域网内其他ip地址发生冲突。  
![d879c38e4bb4ec919976ad621abc3b2b](https://github.com/user-attachments/assets/1aa1a06d-1fd7-466b-892e-42a63939ff0f)  

### 小结
虚拟网络VMnet1、VMnet8分别与主机上的VMnet1、VMnet8相连，其中IP地址都可查到  
桥接模式可设置为仅主机模式  
VMnet1、VMnet8可在NAT与仅主机模式互相切换  
为了提供不同的测试环境，有的需要虚拟机与局域网内的其它机器环境隔离，有的不需要，所以设计不同模式   

## 二、网络配置步骤
### 1.虚拟网络配置
以桥接模式为主进行网络配置  
进行虚拟网络编辑器配置：编辑 - 虚拟网络编辑器。  
![8857777c12c27a9e6cb63b5617b2ab6a](https://github.com/user-attachments/assets/7beefe8e-676a-4977-a872-2a81afc69b02)  
![e48f9125cfdc162b6387b048cf13187d](https://github.com/user-attachments/assets/63ace5ce-7e4e-448f-a2e2-78cccee06549)  
直接自动连接，无需改动。  
### 2.虚拟网络文件配置
启动虚拟机  
- 进入网络文件配置的目录，代码如下  
```
cd /etc/sysconfig/network-scripts
```
- 进入以下界面：  
![屏幕截图 2024-12-02 190154](https://github.com/user-attachments/assets/1c29f2e1-f8eb-4150-90d6-a7352e9259b2)  
在所显示的配置中有两个网络文件，其中所要配置的网络文件为第一个：`ifcfg-ens33`  

### 3.编辑网络文件配置
- 使用vim编辑神器进行编辑文件，如上图最后一行所示，另附代码如下：
```
vim ifcfg-ens33
```
1.按回车键进入以下界面：  
![109e49d1a8b40e22bb1019e9899f240f](https://github.com/user-attachments/assets/b152cbe2-4a4c-42c6-9bbb-cbf31ca8090e)  
2.在当前界面按下i键进入交互模式  
3.把 `ONBOOT=NO` 改为 `ONBOOT=YES`  
4.修改完毕后按下esc键，输入:wq即可  
5.如果无法访问互联网记得在配置文件的最后加上DNS解析记录
```
DNS1=223.6.6.6
```
如果不修改那么就无法获取到IP地址：
<pre>
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
    link/ether 00:0c:29:5e:46:43 brd ff:ff:ff:ff:ff:ff
</pre>

### 4.测试网络
进行完以上配置重启network.service服务。  
代码如下：  
```
service network restart
```
进行ping测试，是否能连接外部网络  
代码如下：  
```
ping -c 4 www.baidu.com
```
参数`-c`表示次数不加就会一直ping

如果连接成功会出现以下界面：  
![7189ba60fd0879e9accd12884c906cc6](https://github.com/user-attachments/assets/7e55f495-cc17-49b4-b0f8-c8c2dad88b14)  
网络配置到此结束~  

### 如果网卡是关闭的
1. 确认网卡状态
```bash
ip address
```
或
```bash
ip link show ens33
```
这将显示 ens33 网卡的详细状态信息。例如：
- 开启的状态包含 `UP` 和 `LOWER_UP`
<pre>
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:0c:29:5e:46:43 brd ff:ff:ff:ff:ff:ff
    inet 192.168.66.122/24 brd 192.168.66.255 scope global noprefixroute dynamic ens33
       valid_lft 1799sec preferred_lft 1799sec
    inet6 fe80::89ba:ca41:be36:f935/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
</pre>
- 关闭的状态包含 `DOWN`
<pre>
2: ens33: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast state DOWN group default qlen 1000
    link/ether 00:0c:29:5e:46:43 brd ff:ff:ff:ff:ff:ff
    inet 192.168.66.122/24 brd 192.168.66.255 scope global noprefixroute dynamic ens33
       valid_lft 1618sec preferred_lft 1618sec
</pre>
2. 启用或禁用网卡
启用网卡：
```bash
sudo ip link set ens33 up
```
禁用网卡：
```bash
sudo ip link set ens33 down
```
