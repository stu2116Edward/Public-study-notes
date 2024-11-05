## 现代化Linux系统网络配置命令： 
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
