# Centos防火墙管理

## firewalld管理防火墙
检查防火墙状态  
```
sudo firewall-cmd --state
```
检查防火墙规则（详细信息）  
```
sudo firewall-cmd --list-all
```
开启防火墙  
```
sudo systemctl start firewalld
```
防火墙 开机自启动  
```
sudo systemctl enable firewalld
```
关闭防火墙  
```
sudo systemctl stop firewalld
```
关闭防火墙开机自启动
```
sudo systemctl disable firewalld
```

允许特定端口（例如：开放端口 80）  
```
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload
```

阻止特定端口（例如：关闭端口 8080）  
```
sudo firewall-cmd --zone=public --remove-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

允许特定服务（例如：开放 HTTP 服务）  
```
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
```

阻止特定服务（例如：关闭 FTP 服务）  
```
sudo firewall-cmd --zone=public --remove-service=ftp --permanent
sudo firewall-cmd --reload
```

允许来自特定 IP 的访问（例如：允许 IP 192.168.1.100 访问端口 22）  
```
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.100" accept' --permanent
sudo firewall-cmd --reload
```

阻止来自特定 IP 的访问（例如：阻止 IP 192.168.1.101 访问）  
```
sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="192.168.1.101" reject' --permanent
sudo firewall-cmd --reload
```

删除特定的防火墙规则（例如：删除允许端口 80 的规则）  
```
sudo firewall-cmd --zone=public --remove-port=80/tcp --permanent
sudo firewall-cmd --reload
```

保存当前的防火墙配置
```
sudo firewall-cmd --runtime-to-permanent
```
重新加载防火墙规则  
```
sudo firewall-cmd --reload
```
先保存当前的防火墙配置，这样可以确保在系统重启后，当前的防火墙规则仍然生效。  

请注意，`--permanent` 标志表示对当前的运行规则和持久规则都进行更改，然后需要执行 `--reload` 来重新加载规则使更改生效。  
在执行这些命令之前，请确保 `firewalld` 服务已经安装在你的系统上。如果尚未安装，可以使用以下命令进行安装：  
```
sudo yum install firewalld
```
或者，如果你的系统使用的是 `dnf` 包管理器：  
```
sudo dnf install firewalld
```
在 CentOS 8 及更高版本中，`firewalld` 是默认的防火墙管理工具。


## iptables管理防火墙
对于 CentOS 的低版本，如 CentOS 7 或更早版本，`firewalld` 并不是默认的防火墙管理工具，而是使用了 `iptables`。以下是一些基本的 `iptables` 命令，用于管理防火墙：  

检查防火墙状态  
CentOS 低版本使用 `iptables` 时，没有直接的命令来检查状态，但可以通过查看规则来判断：  
```
sudo iptables -L  
```

在 CentOS 7 中，可以使用 `system-config-firewall` 图形界面工具或 `service` 命令来管理 `iptables`：  
```
sudo service iptables save  
sudo service iptables restart  
```

关闭防火墙  
禁用 `iptables` 的自动启动，并停止服务：  
```
sudo service iptables stop
sudo chkconfig iptables off
```

允许特定端口（例如：开放端口 80）  
```
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo service iptables save
sudo service iptables restart
```

阻止特定端口（例如：关闭端口 8080）  
```
sudo iptables -I INPUT -p tcp --dport 8080 -j DROP
sudo service iptables save
sudo service iptables restart
```

允许特定服务（例如：开放 HTTP 服务）  
```
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo service iptables save
sudo service iptables restart
```

阻止特定服务（例如：关闭 FTP 服务）  
```
sudo iptables -I INPUT -p tcp --dport 21 -j DROP
sudo service iptables save
sudo service iptables restart
```

允许来自特定 IP 的访问（例如：允许 IP 192.168.1.100 访问端口 22）  
```
sudo iptables -I INPUT -p tcp -s 192.168.1.100 --dport 22 -j ACCEPT  
sudo service iptables save  
sudo service iptables restart
```

阻止来自特定 IP 的访问（例如：阻止 IP 192.168.1.101 访问）  
```
sudo iptables -I INPUT -p tcp -s 192.168.1.101 -j DROP  
sudo service iptables save  
sudo service iptables restart
```

删除特定的防火墙规则  
删除规则比较复杂，因为 `iptables` 不支持直接通过规则内容删除。通常需要手动找到规则编号然后删除：  
```
sudo iptables -D INPUT [rule number]  
sudo service iptables save  
sudo service iptables restart
```

保存当前的 iptables 规则：
在 CentOS 7 中，保存 `iptables` 规则：
```
sudo service iptables save
```

重载防火墙规则  
在 CentOS 7 中，重新加载 `iptables` 规则：  
```
sudo service iptables restart
```

安装 `iptables`  
如果 `iptables` 未安装，可以使用以下命令安装：  
```
sudo yum install iptables-services  
sudo systemctl start iptables  
sudo systemctl enable iptables
```
这些命令应该可以帮助你在 CentOS 7 或更早版本上管理 `iptables` 防火墙。  
注意：不推荐同时使用 firewalld 和 iptables，因为它们是两个不同的防火墙管理工具，可能会相互冲突。每个工具都有自己的配置文件和规则集，同时使用可能会导致不可预测的行为，例如规则冲突、网络连接问题等。
