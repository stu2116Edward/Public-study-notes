# docker更换镜像

### 修改镜像配置文件：
```bash
vim /etc/docker/daemon.json
```
如果不存在
```bash
cd /etc/docker && touch daemon.json
```
配置文件内容：  
使用公共镜像仓库
```json
{
  "registry-mirrors":
   [
      "https://registry.hub.docker.com",
      "https://docker.itelyou.cf",
      "https://abc.itelyou.cf",
      "https://docker.ywsj.tk",
      "https://docker.xuanyuan.me",
      "http://image.cloudlayer.icu",
      "http://docker-0.unsee.tech",
      "https://dockerpull.pw",
      "https://docker.hlmirror.com"
   ]
}
```
有私人镜像仓库的
```json
{
  "registry-mirrors":
   [
      "https://registry.hub.docker.com",
      "https://docker.itelyou.cf",
      "https://abc.itelyou.cf",
      "https://docker.ywsj.tk",
      "https://docker.xuanyuan.me",
      "http://image.cloudlayer.icu",
      "http://docker-0.unsee.tech",
      "https://dockerpull.pw",
      "https://docker.hlmirror.com"
   ],
  "insecure-registries":
   [
      "修改成自己的服务器IP:端口"
   ]
}
```
`registry-mirrors`这个是公共镜像的地址，`insecure-registries`这个是私有镜像的地址，修改成自己的服务器IP:端口  
将镜像重新加载：
```
systemctl daemon-reload && systemctl restart docker
```

下面是我所整理的供大家使用：
```
https://docker.itelyou.cf
```
```
https://abc.itelyou.cf
```
```
https://docker.ywsj.tk
```
```
https://docker.xuanyuan.me
```
```
http://image.cloudlayer.icu
```
```
http://docker-0.unsee.tech
```
```
https://dockerpull.pw
```
```
https://docker.hlmirror.com
```
```
https://docker.imgdb.de
```
```
https://docker.m.daocloud.io
```
```
https://docker.melikeme.cn
```

## 登录私人Docker Hub仓库：
```
docker login <IP:端口/域名>
```
### 向私有Docker Hub拉取镜像：
```
docker pull <私有仓库地址-IP:端口/域名>/images(镜像名称):tag(版本标签)
```
### 删除本地镜像：
```
docker rmi <镜像名称/容器ID>
```
### 创建容器：
```
docker create --name <容器名> <镜像名>
```
### 运行容器:
```
docker start <容器名>
```

### 配置容器开机自启动：
```
docker update --restart=always <容器名或容器ID>
```
### 取消容器开机自启动：
```
docker update --restart=no <容器名或容器ID>
```

## 向私有Docker Hub推送镜像:  
### 重做镜像Tag:  
```
docker tag images:tag <私有仓库地址-IP:端口/域名>/images:tag
```
示例：
```
docker tag cloudreve/cloudreve:latest example.com/mycloudreve:latest
```
查看docker镜像：
```
docker images
```
可用通过`docker images`查看源镜像名称以及标签：`cloudreve/cloudreve:latest`  
后面的`example.com/mycloudreve:latest`是你的：`仓库地址/修改后的镜像名称:修改后的标签`  
如果是latest可以省略tag部分：
```
docker tag cloudreve/cloudreve example.com/mycloudreve
```
### 推送镜像：
```
docker push <私有仓库地址-IP:端口/域名>/images:tag
```
示例：
```
docker push example.com/mycloudreve
```

