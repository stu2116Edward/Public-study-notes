# 修改SSH默认端口
服务器默认为22端口，这样会造成有被暴力破解密码的风险，下面是更换ssh端口过程  

1. 添加ssh端口
```
vim /etc/ssh/sshd_config
```
打开配置文件，添加我们需要更改的端口号，**此时不要删除默认22端口**，让两个端口同时存在，如果我们直接修改了端口，然后启动防火墙之后，就会出现我们没有使用防火墙开放端口，导致我们连接不上服务器，我们暂且保留默认22，如果更改过后，使用新端口号没问题，再删除默认22端口不迟  
例如：修改ssh端口号为3389  
```
Port 3389
```
其他安全设置：  
禁止root远程登录，最大失败次数3
```
Port 22
PermitRootLogin no
MaxAuthTries 3
```
启用root登录，禁用密码登录
```
PermitRootLogin yes
PasswordAuthentication no
```

2. 重启ssh服务
```
systemctl restart sshd
```
或
```
service sshd restart
```

3. 查看端口是否开启
```
netstat -ntlp | grep 3389
```
或
```
ss -tuln | grep 3389
```

4. 配置防火墙规则，添加端口
Ubuntu:
```
sudo ufw allow 3389/tcp
sudo ufw enable
sudo ufw status
```

CentOS:
```
firewall-cmd --zone=public --add-port=3389/tcp --permanent
firewall-cmd --reload
firewall-cmd --list-ports
```

适用于 Ubuntu 和 CentOS:
```
iptables -A INPUT -p tcp --dport 3389 -j ACCEPT
```
