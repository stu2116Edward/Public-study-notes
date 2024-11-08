# 现代化Linux系统网络配置命令： 

## VMware虚拟机的三种网络模式及其特点：
### 虚拟机的网络
虚拟机上的网络连接图示：  
![f0c656bfea19ecb074bdbdc1d42abc3e](https://github.com/user-attachments/assets/3658a67c-9c21-40be-801a-553af3fdebf5)  
![84d5a2d12fb7169708ff714a87863587](https://github.com/user-attachments/assets/145de8a0-82ed-49a7-a50c-4f031ce4599d)  
![4c120f0d0c581991475d07696f8890ca](https://github.com/user-attachments/assets/e87c0f31-d38a-4f46-be1a-cdbfa1a9a8d1)  


### 桥接模式（Bridged Mode）
默认虚拟网络：VMnet0  
DHCP服务：不提供  
网络连接：虚拟机与外部主机处于同一网络段，相当于直接连接到物理网络的一个独立设备。  
通信能力：虚拟机既能与局域网内的其他主机通信，也能访问外部网络。  
IP地址：由于与局域网内的其他设备共享IP地址范围，容易发生IP地址冲突。 
注意：`虚拟机也会占用局域网中的一个 IP 地址(把虚拟机当做一台完全独立的计算机看待)`
桥接模式配置示例：  
桥接模式，虚拟机网段必须和物理机网段保持一致，另外虚拟机在网络配置的时候，一定不要忘  
![2b1e4c3c0d6b15ec6982a9c987f51a43](https://github.com/user-attachments/assets/8f5fbb4e-5d9f-4fab-a646-656c8d0f1519)  
![241667d0ec81dafadc14dabb7b76443f](https://github.com/user-attachments/assets/642b1ce1-7468-41f0-b0bf-44648756b40c)  


### NAT模式（Network Address Translation Mode）
默认虚拟网络：VMnet8  
DHCP服务：提供  
网络连接：虚拟机可以与宿主机互相访问，并且能够访问外部网络。  
通信能力：虚拟机无法访问局域网内的其他机器。  
IP地址：不会与局域网内的其他IP地址发生冲突，因为虚拟机的IP地址由宿主机的NAT服务进行转换。  
注意：虚拟机在外部网络中不必具有自己的IP地址。从外部网络来看，虚拟机和主机在共享一个IP地址，默认情况下，外部网络终端也无法访问到虚拟机，一台主机上只允许有一个 NAT 模式的虚拟网络  
NAT 网络配置示例：  
下图结构可以使虚拟机和物理机相互 ping 通，并且虚拟机通过物理机的网卡访问互联网  
![b2ed132559b2606b530db24cf98e7d3a](https://github.com/user-attachments/assets/f821d68f-c1e6-43e8-816e-93362a6e2079)  
VMnet8 设置为 NAT 模式，VMnet8 的 IP 地址为 192.168.80.1，虚拟机 A 和虚拟机 B 是 VMnet8 网段的两个虚拟机，他们的网关为 192.168.80.2 ，跟虚拟机的设置一样，如图：  
![96c0a52f891e8370ab3b8caf845582a0](https://github.com/user-attachments/assets/d0184718-592d-4398-a187-f364c30ef86e)  
虚拟路由服务启动图示：  
![2855a6bfaef07c1781da3d8dca22cb19](https://github.com/user-attachments/assets/0047e98a-9f99-4d38-a021-38c4e04f5d15)  
注意：如果发现虚拟机之间ping不通，需要检查虚拟机的防火墙设置，确保防火墙没有阻止虚拟机之间的通信。可以通过运行wf.msc来打开Windows防火墙的管理控制台，查看和修改防火墙规则。  
![9bc30f24ee97bf3104ea60e3aebfb4f0](https://github.com/user-attachments/assets/b16402a9-c27b-4bbc-92a0-851e510d7a2b)  
Ubuntu/Debian（使用UFW）  
检查防火墙状态：  
```
sudo ufw status
```
允许特定端口（例如，允许ping，即ICMP）：  
```
sudo ufw allow icmp
```
禁用防火墙（不推荐，但有时需要临时操作）：  
```
sudo ufw disable
```
CentOS/RHEL（使用firewalld）  
检查防火墙状态：  
```
sudo firewall-cmd --state
```
允许特定服务（例如，允许ping）：
```
sudo firewall-cmd --permanent --add-service=icmp
sudo firewall-cmd --reload
```
停止并禁用防火墙：
```
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```
Fedora（使用firewalld）  
Fedora也使用firewalld作为其防火墙管理工具，操作与CentOS/RHEL类似。  
Arch Linux（使用nftables或iptables）  
检查防火墙规则（使用iptables）：  
```
sudo iptables -L
```
允许ICMP（使用iptables）：  
```
sudo iptables -A INPUT -p icmp -j ACCEPT
```
停止并禁用防火墙（如果使用nftables或iptables）：  
```
sudo systemctl stop nftables
sudo systemctl disable nftables
```
NAT设置实现端口转发  
前面我们已经提到，默认情况下，外部网络无法访问到虚拟机，不过我们也可以通过手动修改 NAT 设置实现端口转发功能，将外部网络发送到主机指定端口的数据转发到指定的虚拟机上。比如，我们在虚拟机的 80 端口上 "建立" 了一个站点，只要我们设置端口转发，将主机 88 端口上的数据转发给虚拟机的 80 端口，就可以让外部网络通过主机的 88 端口访问到虚拟机 80 端口上的站点。  
远程控制 NAT 网段虚拟机图示：  
![87a99edc4c2f70ea6bcca701b0236c8b](https://github.com/user-attachments/assets/c94dc8ae-7b2f-4874-8987-b258441b739c)  
虚拟机配置图示如下：  
![dad8c3985d8ec15328bf8ec514ed6f8c](https://github.com/user-attachments/assets/31d1f32d-e168-429e-a175-877a5dc8faf8)  


### 仅主机模式（Host-Only Mode）
默认虚拟网络：VMnet1  
DHCP服务：提供  
网络连接：通常情况下，虚拟机无法访问外部网络，只能与宿主机（物理主机）进行通信。  
通信能力：虚拟机可以访问宿主机，但无法访问局域网内的其他设备。  
注意：仅主机模式的虚拟网络适配器仅对主机可见，并在虚拟机和主机系统之间提供网络连接  


### 使用 DHCP 自动分配地址
勾选 DHCP 服务，可以配置 DHCP 分配地址的范围，自动分配 IP 地址  
![dd089cbda77da0e8b8bfec0443a8f6ff](https://github.com/user-attachments/assets/ffd934f0-4f26-465c-8f91-78702269f6b1)  


### 1. 重启网络服务  
需要注意的是，systemd-networkd 和 NetworkManager 通常不会同时使用，因为它们是两种不同的网络管理服务。systemd-networkd 是一个低级别的网络配置守护程序，而 NetworkManager 提供了一个更高级别的网络管理界面。  
在基于systemd的系统中，你可以使用以下命令来重启网络服务：  
```
sudo systemctl restart systemd-networkd
```
或者，如果你想要重启网络管理器（例如NetworkManager），可以使用：  
```
sudo systemctl restart NetworkManager
```
### 2. 对单一网卡进行操作  
使用ip命令来管理网络接口：  
- 查看所有网络接口信息：  
```
ip addr show
```

- 禁用指定的网络接口：  
```
sudo ip link set [网卡名称] down
```
- 启用指定的网络接口：  
```
sudo ip link set [网卡名称] up
```
### 3. DHCP重新获取IP  
使用dhclient命令来管理DHCP：  
- 释放当前的DHCP租约：  
```
sudo dhclient -r [网卡名称]
```
- 重新获取IP地址：  
```
sudo dhclient [网卡名称]
```
### 4. 配置静态或动态IP  
在/etc/network/interfaces文件中配置网络接口    
例如，要为一个名为eth0的网络接口配置静态IP，可以编辑该文件并添加以下内容：  
```
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 8.8.8.8 8.8.4.4
```
对于动态IP（DHCP），配置如下：  
```
auto eth0
iface eth0 inet dhcp
```
### 5. 应用配置  
在修改了/etc/network/interfaces文件后，你可以使用以下命令来重新加载网络配置：  
```
sudo systemctl restart networking
```
或者，如果你使用的是NetworkManager，可以使用：  
```
sudo systemctl restart NetworkManager
```

## 旧版本Linux系统网络配置命令：  
### 1.重启网络服务  
在基于System V init的旧版系统中，你可以使用以下命令来重启网络服务：  
```
sudo /etc/init.d/networking restart
```
或者，如果你想要重启网络管理器（例如NetworkManager），可以使用：  
```
sudo service network-manager restart
```
### 2.对单一网卡进行操作  
使用 ifconfig 命令来管理网络接口：  
- 查看所有网络接口信息：  
```
ifconfig -a
```
- 禁用指定的网络接口：  
```
sudo ifconfig [网卡名称] down
```
- 启用指定的网络接口：  
```
sudo ifconfig [网卡名称] up
```
### 3. DHCP重新获取IP  
使用dhclient命令来管理DHCP：  
- 释放当前的DHCP租约：  
```
sudo dhclient -r [网卡名称]
```
- 重新获取IP地址：  
```
sudo dhclient [网卡名称]
```
### 4.配置静态或动态IP  
在 /etc/sysconfig/network-scripts/ifcfg-[网卡名称] 文件中配置网络接口。  
- 例如，要为一个名为 eth0 的网络接口配置静态IP，可以编辑该文件并添加以下内容：  
```
DEVICE=eth0
BOOTPROTO=static
ONBOOT=yes
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
```
- 对于动态IP（DHCP），配置如下：  
```
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
```
### 5.应用配置  
在修改了 /etc/sysconfig/network-scripts/ifcfg-[网卡名称] 文件后，你可以使用以下命令来重新加载网络配置：  
```
sudo /etc/init.d/networking restart
```
或者，如果你使用的是NetworkManager，可以使用：  
```
sudo service network-manager restart
```

## 常用的网管命令  
### ip 命令：

1. **查看所有网络接口信息**：
   ```
   ip addr show
   ```

2. **禁用指定的网络接口**：
   ```
   sudo ip link set [网卡名称] down
   ```

3. **启用指定的网络接口**：
   ```
   sudo ip link set [网卡名称] up
   ```

4. **添加IP地址**：
   ```
   sudo ip addr add [IP地址]/[子网掩码] dev [网卡名称]
   ```

5. **删除IP地址**：
   ```
   sudo ip addr del [IP地址]/[子网掩码] dev [网卡名称]
   ```

6. **添加路由**：
   ```
   sudo ip route add [目的地网络] via [下一跳IP]
   ```

7. **删除路由**：
   ```
   sudo ip route del [目的地网络] via [下一跳IP]
   ```

8. **查看路由表**：
   ```
   ip route show
   ```

9. **查看网络统计信息**：
   ```
   ip -s link
   ```

10. **修改网络设备属性（如MTU）**：
    ```
    sudo ip link set [网卡名称] mtu [值]
    ```

### ifconfig 命令：

1. **查看所有网络接口信息**：
   ```
   ifconfig -a
   ```

2. **禁用指定的网络接口**：
   ```
   sudo ifconfig [网卡名称] down
   ```

3. **启用指定的网络接口**：
   ```
   sudo ifconfig [网卡名称] up
   ```

4. **添加IP地址**：
   ```
   sudo ifconfig [网卡名称] [IP地址] netmask [子网掩码]
   ```

5. **删除IP地址**（将接口关闭再开启）：
   ```
   sudo ifconfig [网卡名称] 0.0.0.0
   ```

6. **查看网络接口状态**：
   ```
   ifconfig [网卡名称]
   ```

7. **设置广播地址**：
   ```
   sudo ifconfig [网卡名称] broadcast [广播地址]
   ```

8. **添加ARP条目**（需要root权限）：
   ```
   sudo arp -s [IP地址] [MAC地址]
   ```

9. **删除ARP条目**（需要root权限）：
   ```
   sudo arp -d [IP地址]
   ```

   
## 不同Linux发行版网络配置文件路径和重启网络服务命令的详细列表：  
<table border="1">
    <tr>
        <th>Linux发行版</th>
        <th>网络配置文件路径</th>
        <th>重启网络服务命令</th>
    </tr>
    <tr>
        <td>Ubuntu</td>
        <td>/etc/network/interfaces</td>
        <td>sudo systemctl restart networking 或 sudo /etc/init.d/networking restart</td>
    </tr>
    <tr>
        <td>Debian</td>
        <td>/etc/network/interfaces</td>
        <td>sudo systemctl restart networking 或 sudo /etc/init.d/networking restart</td>
    </tr>
    <tr>
        <td>Fedora</td>
        <td>/etc/sysconfig/network-scripts/ifcfg-<网卡名称></td>
        <td>sudo systemctl restart network</td>
    </tr>
    <tr>
        <td>CentOS</td>
        <td>/etc/sysconfig/network-scripts/ifcfg-<网卡名称></td>
        <td>对于CentOS 6及以下版本，使用 service network restart；对于CentOS 7及以上版本，使用 sudo systemctl restart NetworkManager</td>
    </tr>
    <tr>
        <td>RHEL (Red Hat Enterprise Linux)</td>
        <td>/etc/sysconfig/network-scripts/ifcfg-<网卡名称></td>
        <td>对于RHEL 6及以下版本，使用 service network restart；对于RHEL 7及以上版本，使用 sudo systemctl restart NetworkManager</td>
    </tr>
    <tr>
        <td>Kali Linux</td>
        <td>/etc/network/interfaces 或 /etc/sysconfig/network-scripts/ifcfg-<网卡名称></td>
        <td>sudo systemctl restart networking 或 sudo service network-manager restart</td>
    </tr>
    <tr>
        <td>Kubuntu</td>
        <td>/etc/network/interfaces</td>
        <td>sudo systemctl restart networking 或 sudo /etc/init.d/networking restart</td>
    </tr>
    <tr>
        <td>Arch Linux</td>
        <td>/etc/netctl/<接口名></td>
        <td>sudo systemctl restart netctl</td>
    </tr>
    <tr>
        <td>OpenSUSE</td>
        <td>/etc/sysconfig/network/ifcfg-<网卡名称></td>
        <td>sudo systemctl restart wickedd 或 sudo /etc/init.d/network restart</td>
    </tr>
</table>
