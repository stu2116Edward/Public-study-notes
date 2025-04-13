# RustDesk远程桌面服务端和中继端部署

准备工作：  
1. 一台大带宽的VPS(最好是离自己近的)  
2. 安装好docker环境   
3. 如果使用的云服务有控制台策略，则需要在云服务控制台放行对应的端口

![RustDesk_txy](https://github.com/user-attachments/assets/7f601a8a-c440-4358-82f8-9874a8688a6d)  

## 在服务器防火墙中放行端口
Ubuntu系统：
- 放行指定端口
```bash
sudo ufw allow 21115/tcp
sudo ufw allow 21116/tcp
sudo ufw allow 21116/udp
sudo ufw allow 21117/tcp
sudo ufw allow 21118/tcp
sudo ufw allow 21119/tcp
```
- 重新加载防火墙规则
```bash
ufw reload
```
- 查看是否生效
```bash
sudo ufw status
```

Centos系统：
- 放行指定端口
```bash
sudo firewall-cmd --permanent --zone=public --add-port=21115/tcp
sudo firewall-cmd --permanent --zone=public --add-port=21116/tcp
sudo firewall-cmd --permanent --zone=public --add-port=21116/udp
sudo firewall-cmd --permanent --zone=public --add-port=21117/tcp
sudo firewall-cmd --permanent --zone=public --add-port=21118/tcp
sudo firewall-cmd --permanent --zone=public --add-port=21119/tcp
```
- 重新加载防火墙规则
```bash
sudo firewall-cmd --reload
```
- 查看是否生效
```bash
sudo firewall-cmd --list-all
```

## 服务端部署
```bash
docker run --name hbbs -v $(pwd)/data:/root -td --net=host --restart unless-stopped rustdesk/rustdesk-server hbbs
```

## 中继端部署
```bash
docker run --name hbbr -v $(pwd)/data:/root -td --net=host --restart unless-stopped rustdesk/rustdesk-server hbbr
```

### 使用Docker-compose部署
```yml
version: '3'

services:
  hbbs:
    image: rustdesk/rustdesk-server
    container_name: hbbs
    volumes:
      - ./data:/root
    networks:
      - rustdesk-network
    restart: unless-stopped
    command: hbbs

  hbbr:
    image: rustdesk/rustdesk-server
    container_name: hbbr
    volumes:
      - ./data:/root
    networks:
      - rustdesk-network
    restart: unless-stopped
    command: hbbr

networks:
  rustdesk-network:
    driver: bridge
```
在yml文件下输入以下命令启动：
```bash
docker-compose up -d
```

用下面日志命令，查看远程服务的`key`我们一会会用到:  
```bash
docker logs hbbs
```
还有IP地址（这里作为服务器地址与中继地址使用）  
![RustDesk1](https://github.com/user-attachments/assets/cbbc72af-4878-41b3-a572-a85585191ab3)

## 客户端部署
去电脑和手机端下载客户端程序:  
https://github.com/rustdesk/rustdesk  
![RustDesk2](https://github.com/user-attachments/assets/337bc549-3663-4fc1-972b-64145555aa06)  
Windows下载64位的。直接运行exe  
![RustDesk3](https://github.com/user-attachments/assets/9fdec970-8194-4b00-be94-3cbfeed4262f)  
![RustDesk4](https://github.com/user-attachments/assets/718390cf-6d65-4d01-9e19-2ef82cb9088d)  

另一台机器也这样操作。就可以输入对方设备码控制另一台机器了。还可以手机操控电脑，电脑从控安卓手机。苹果手机只能控制其他设备不能被控制  
