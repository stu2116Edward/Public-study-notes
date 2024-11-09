# Docker基本命令

## Docker容器管理  
运行新容器：  
- 基本命令
```
docker run [选项] <镜像名/ID>
```
- <镜像名/ID>：指定要运行的Docker镜像名称或ID
- [选项]包括但不限于：
 - -d：后台运行容器
 - --name：为容器指定一个名称
 - -p：端口映射，格式为宿主机端口:容器端口
 - -e：设置环境变量
 - -v：挂载卷，用于数据持久化或共享
 - --cpus：限制容器使用的CPU资源
 - --memory：限制容器使用的内存
 - --restart：设置容器的重启策略，例如 `--restart=always` 表示容器总是重新启动，`--restart=no` 不要自动重启容器
 - --network：设置容器的网络连接

示例:
```
docker run -d --name my_container -p 8080:80 nginx --restart=always
```
这个命令会在后台运行一个名为 `my_container` 的容器，使用 `nginx 镜像`，并将`容器的80端口`映射到宿`主机的8080端口`。同时，设置容器的重启策略为总是重启 `--restart=always`

- 其他常用选项
 - -it：分配一个伪终端并保持标准输入开放，通常与bash或sh命令一起使用，以便交互式地进入容器内部。
 - --rm：容器退出时自动清理容器文件系统。
 - --env-file：从文件中读取环境变量。
 - --add-host：添加自定义的DNS条目。
 - --cap-add：添加容器的Linux能力。
 - --entrypoint：覆盖镜像中设置的入口点。
 - --detach-keys：设置容器分离的键。

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
停止并删除容器：
```
docker rm -f <容器名/ID>
```
查看容器内的进程：
```
docker top <容器名/ID>
```
进入容器内部：  
除了使用 docker run -it 来启动一个交互式容器外，您还可以使用 docker exec 命令进入已经运行的容器内部：  
```
docker exec -it <容器名/ID> /bin/bash  # 或者 /bin/sh，取决于容器内的shell
```
导出和导入容器：  
虽然通常我们更关注镜像的保存和加载，但有时也需要导出和导入容器（例如，为了迁移或备份）：  
```
# 导出容器为tar文件
docker export <容器名/ID> > <文件名>.tar

# 从tar文件导入容器为镜像（注意，这不是一个运行的容器，而是一个静态的镜像）
cat <文件名>.tar | docker import - <镜像名>:<标签>
```


### Docker 网络功能允许您将容器连接到一个或多个网络。
- --network 选项允许您指定容器应连接到的网络。以下是一些常用的网络模式和选项：
 - bridge：这是`默认`的网络设置，Docker 会创建一个桥接网络并将容器连接到这个网络。
 - host：将容器的网络堆栈与宿主机共享。容器不会获得自己的 IP 地址，并且会共享宿主机的网络。
 - none：容器有自己的网络堆栈，但是不进行任何配置。您需要手动配置网络。
 - container：容器将共享另一个容器的网络堆栈。
 - nat：容器有自己的网络堆栈，但是出站连接会通过宿主机进行NAT转换。

示例：
```
# 将容器连接到名为 my_network 的用户定义网络
docker run -d --name my_container --network my_network nginx

# 将容器连接到宿主机的网络堆栈
docker run -d --name my_container --network host nginx

# 将容器连接到另一个容器的网络堆栈
docker run -d --name my_container --network container:other_container nginx
```


### -e 或 --env：设置环境变量
环境变量是在操作系统中定义的变量，它们可以控制程序的运行方式。在 Docker 中，您可以使用 -e 或 --env 选项来设置环境变量。  
示例:  
```
# 设置单个环境变量
docker run -d --name my_container -e "ENV_VAR=value" nginx

# 设置多个环境变量
docker run -d --name my_container -e ENV_VAR1=value1 -e ENV_VAR2=value2 nginx

# 从文件中设置环境变量
docker run -d --name my_container --env-file .env nginx
```
在 .env 文件中：
```
ENV_VAR1=value1
ENV_VAR2=value2
```


### -v 或 --volume：挂载卷，用于数据持久化或共享
挂载卷（Volumes）是 Docker 中用于数据持久化和数据共享的高级功能。它们允许您将数据独立于容器的生命周期进行管理，这意味着即使容器被删除，数据也不会丢失。  
示例:  
```
# 将宿主机的目录挂载到容器中
docker run -d --name my_container -v /host/path:/container/path nginx

# 创建并挂载一个命名卷
docker run -d --name my_container -v my_volume:/container/path nginx

# 挂载一个已经存在的卷
docker run -d --name my_container --volume my_volume:/container/path nginx
```
- /host/path：宿主机上的目录路径。
- /container/path：容器内的目录路径。
- my_volume：卷的名称，Docker 将管理这个卷的生命周期。

- 使用挂载卷时，您可以指定卷的访问模式，例如：
 - ro：挂载卷为只读模式（例如 -v /host/path:/container/path:ro）
 - rw：读写模式（默认）。

示例:  
```
# 以只读模式挂载卷
docker run -d --name my_container -v /host/path:/container/path:ro nginx
```


## Docker镜像管理  
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
docker save -o <目标文件路径/文件名.tar> <镜像名>:<tag>
```
- -o 选项用于指定输出文件的路径。  
- <目标文件路径> 可以是绝对路径或相对路径。  
- <镜像名>:<tag> 指定要保存的镜像名称和标签(tag)  
示例:  
```
docker save -o ~/打包后的镜像名.tar 镜像名称:tag
```

从文件加载镜像：
```
docker load -i <文件路径>
```
或
```
cat <文件名>.tar | docker load
```
示例：
```
docker load -i ~/打包后的镜像名.tar
```
```
cat 打包后的镜像名.tar | docker load
```


## Docker资源查看  
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


## Docker资源清理  
- 清理未使用的资源（包括停止的容器、未使用的网络、未使用的镜像、未使用的构建缓存）
```
docker system prune
```
- 清理所有未使用的资源（包括卷）
```
docker system prune -a
```
- 清理所有未使用的镜像（包括悬空镜像和无标签的镜像）
```
docker image prune
```
- 清理未使用的卷
```
docker volume prune
```
- 清理未使用的网络
```
docker network prune
```
- 清理构建缓存
```
docker builder prune
```
- 清理所有未使用的 Docker 对象，包括镜像、容器、卷和网络（带强制确认）
```
docker system prune -af
```
