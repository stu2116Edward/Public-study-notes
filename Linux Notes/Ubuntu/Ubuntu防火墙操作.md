检查防火墙状态(显示端口开放状态)  
```
sudo ufw status
```
获取所有防火墙规则的顺序和ID号
```
sudo ufw status numbered
```
检查防火墙规则（获取更多详细信息，包括日志记录、默认策略和新配置文件）  
```
sudo ufw status verbose
```
开启防火墙  
```
sudo ufw enable
```
关闭防火墙  
```
sudo ufw disable
```
使用示例：  
开放端口80的TCP和UDP协议，允许所有IP访问端口80  
```
sudo ufw allow 80
```
关闭端口8080，阻止所有IP访问端口8080
```
sudo ufw deny 8080
```
开放端口53的UDP协议，允许所有IP访问端口53的UDP流量
```
sudo ufw allow 53/udp
```
关闭端口8080的TCP协议，阻止所有IP访问端口8080的TCP流量
```
sudo ufw deny 8080/tcp
```
允许特定服务（例如：开放 HTTP 服务）  
```
sudo ufw allow http
```
阻止特定服务（例如：关闭 FTP 服务） 
```
sudo ufw deny ftp
```
允许来自特定 IP 的访问（例如：允许 IP 192.168.1.100 访问端口 22）  
```
sudo ufw allow from 192.168.1.100 to any port 22
```
阻止来自特定 IP 的访问（例如：阻止 IP 192.168.1.101 访问）  
```
sudo ufw deny from 192.168.1.101
```
删除特定的防火墙规则（例如：删除允许端口 80 的规则）  
```
sudo ufw delete allow 80
```
删除特定的防火墙规则(带协议的)
```
sudo ufw delete allow 80/tcp
```
通过防火墙规则的顺序和ID号删除防火墙规则
```
sudo ufw delete <ID号>
```
重载防火墙规则(在添加规则和删除规则后切记要运行一下)
```
sudo ufw reload
```
