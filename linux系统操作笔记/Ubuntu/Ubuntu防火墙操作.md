检查防火墙状态  
sudo ufw status  
检查防火墙规则（详细信息）  
sudo ufw status verbose  

开启防火墙  
sudo ufw enable  
关闭防火墙  
sudo ufw disable  

允许特定端口（例如：开放端口 80,允许所有 IP 访问端口 80）  
sudo ufw allow 80  

阻止特定端口（例如：关闭端口 8080）  
sudo ufw deny 8080  

允许特定服务（例如：开放 HTTP 服务）  
sudo ufw allow http  

阻止特定服务（例如：关闭 FTP 服务）  
sudo ufw deny ftp  

允许来自特定 IP 的访问（例如：允许 IP 192.168.1.100 访问端口 22）  
sudo ufw allow from 192.168.1.100 to any port 22  

阻止来自特定 IP 的访问（例如：阻止 IP 192.168.1.101 访问）  
sudo ufw deny from 192.168.1.101  

删除特定的防火墙规则（例如：删除允许端口 80 的规则）  
sudo ufw delete allow 80  

重载防火墙规则  
sudo ufw reload  
