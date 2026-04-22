# Docker部署OpenList

官方文档 https://doc.oplist.org.cn/guide/installation/docker

安装好 Docker 后，执行以下命令：


### Docker CLI

请注意：`/etc/openlist` 仅为默认映射的目录，您可以根据需要修改为其他目录  
如果您希望使用当前用户运行和管理 OpenList 及其配置目录，请使用以下命令：
```
mkdir -p /etc/openlist
docker run --user $(id -u):$(id -g) -d --restart=unless-stopped -v /etc/openlist:/opt/openlist/data -p 5244:5244 -e UMASK=022 --name="openlist" openlistteam/openlist:latest
```

如果您希望使用 1001，即容器内置的默认 openlist 用户运行和管理 OpenList 及其配置目录，请使用以下命令：
```
sudo chown -R 1001:1001 /etc/openlist
docker run -d --restart=unless-stopped -v /etc/openlist:/opt/openlist/data -p 5244:5244 -e UMASK=022 --name="openlist" openlistteam/openlist:latest
```

v4.1.0 及以前版本
```
docker run -d --restart=unless-stopped -v /etc/openlist:/opt/openlist/data -p 5244:5244 -e PUID=0 -e PGID=0 -e UMASK=022 --name="openlist" openlistteam/openlist:latest
```



### Docker Compose
创建 docker-compose.yml 文件。
```
mkdir -p /opt/openlist
cd /opt/openlist
vim docker-compose.yml
```

写入以下内容，然后保存并退出：
```
# docker-compose.yml
services:
  openlist:
    image: 'openlistteam/openlist:latest'
    container_name: openlist
    user: '0:0' # Please replace `0:0` with the actual user ID and group ID you want to use to run OpenList.
    volumes:
      - './data:/opt/openlist/data'
    ports:
      - '5244:5244'
    environment:
      - UMASK=022
    restart: unless-stopped
```

v4.1.0 及以前版本
```
# docker-compose.yml
services:
  openlist:
    image: 'openlistteam/openlist:latest'
    container_name: openlist
    volumes:
      - './data:/opt/openlist/data'
    ports:
      - '5244:5244'
    environment:
      - PUID=0
      - PGID=0
      - UMASK=022
    restart: unless-stopped
```

在 docker-compose.yml 相同目录下执行：
```
docker compose pull
docker compose up -d
```

登录OpenList  
浏览器打开 http://127.0.0.1:5244
账号默认 admin  
密码默认 admin  
可自行修改  
