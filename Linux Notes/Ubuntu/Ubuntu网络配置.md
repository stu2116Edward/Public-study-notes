# Ubuntu网络配置

**一般都使用dhcp所以以下内容是针对静态IP配置的**

编辑配置文件
```bash
sudo vim /etc/netplan/01-network-manager-all.yaml
```
源网络配置文件：
```yaml
# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: NetworkManager
```
修改成:
```yaml
network:
    version: 2
    renderer: NetworkManager
    ethernets:
      ens33:        # 你的网卡名称
        dhcp4: no       # 是否启用dhcp
        addresses:
          - 192.168.66.113/24      # 你的ip地址/子网掩码
        optional: true
        gateway4: 192.168.66.1     # 网关
        nameservers:
          addresses:                # 配置DNS服务器
            - 223.6.6.6
            - 8.8.8.8
```
相关说明：  
- ens33：网卡名称，一般网卡名称是ens33，若不同可能为ens32，具体通过ifconfig命令查看
- dhcp4:no，该字段设置为no，表示设置为静态IP
- address：静态IP地址
- gateway4：网关
- nameservers：DNS设置

如果出现缩进问题，可对vim进行配置(错误时请尝试)
```bash
vim ~/.vimrc
```

打开vimrc配置文件，添加以下内容
```
set shiftwidth=2
set expandtab
set autoindent
set smartindent
filetype plugin indent on
```
然后重新修改网络配置文件即可  

为了解决权限问题，运行以下命令(错误时请尝试)
```bash
sudo chmod 600 /etc/netplan/01-network-manager-all.yaml
```

键入以下命令使得配置文件生效
```bash
sudo netplan apply
```
验证配置：
- 使用`ip a`命令来检查IP地址是否已正确设置
- 使用`systemd-resolve --status`命令来检查DNS服务器设置

请确保在进行网络配置更改时，考虑到网络环境的其他因素，比如确保静态IP地址不与网络中的其他设备冲突