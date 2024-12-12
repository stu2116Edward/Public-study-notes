# Docker-搭建一个网页版的WebSSH工具

## 使用Docker运行：
```bash
docker run -d --log-driver json-file --log-opt max-file=1 --log-opt max-size=100m --restart always --name webssh -e TZ=Asia/Shanghai -e SAVEPASS=false -p 5032:5032 jrohy/webssh -a admin:password
```

## 使用docker-compose配置文件运行：
创建一个目录
```bash
mkdir ~/webssh
cd ~/webssh
```

创建docker-compose配置文件
```bash
touch docker-compose.yml
```
文件内容为：
```yml
version: '3.3'
services:
    webssh:   #服务名，可以自定义
        container_name: webssh    #容器名，可以自定义
        command: ["-a", "admin:password"]  # 设置账号密码
        ports:
            - '5032:5032'   # 添加容器端口映射
        environment:
            - PUID=0    # 稍后在终端输入id可以查看当前用户的id
            - PGID=0    # 同上
            - TZ=Asia/Shanghai  #时区，可以自定义
            - SAVEPASS=false    # 是否保存密码，这里设置为false
        restart: always    #开启开机自启动
        image: jrohy/webssh    #镜像名不要改
```

部署运行
```bash
docker-compose up -d
```

登录webSSH页面
```
http://ip:5032
```