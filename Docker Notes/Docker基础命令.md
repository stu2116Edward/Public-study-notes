Docker容器管理  
运行新容器：  
```
docker run [选项] <镜像名/ID>
```
停止容器：
```
docker stop <容器名/ID>
```
启动容器：
```
docker start <容器名/ID>
```
重启容器：
```
docker restart <容器名/ID>
```
删除容器：
```
docker rm <容器名/ID>
```
Docker镜像管理  
删除镜像：  
```
docker rmi <镜像名/ID>
```
拉取镜像：
```
docker pull <镜像名/ID>
```
构建镜像：
```
docker build <上下文>
```
保存镜像为文件：
```
docker save <镜像名和版本>  <文件名>.tar
```
从文件加载镜像：
```
cat <文件名>.tar | docker load
```
Docker资源查看  
列出当前运行的容器：
```
docker ps
```
列出所有容器：
```
docker ps -a
```
列出本地镜像：
```
docker images
```
查看容器日志：
```
docker logs <容器>
```
Docker资源清理  
清理未使用的资源：  
```
docker system prune
```
执行命令在运行的容器内：
```
docker exec <容器> <命令>
```
查看Docker版本：
```
docker --version
```
查看Docker系统信息：
```
docker info
```
查看容器统计信息：
```
docker stats
```
查看容器和镜像的详细信息：
```
docker inspect <容器名/ID或镜像名/ID>
```
停止并删除容器：
```
docker rm -f <容器名/ID>
```
