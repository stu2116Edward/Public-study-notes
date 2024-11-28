# Docker基本命令

## Docker容器管理  

### 基本命令
创建并立即启动一个新容器：  
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


仅创建一个新的容器，但不启动它：
```
docker create --name <容器名> <镜像名>
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
停止并删除容器：
```
docker rm -f <容器名/ID>
```
查看容器内的进程：
```
docker top <容器名/ID>
```
重新加载镜像：
```
systemctl daemon-reload && systemctl restart docker
```

**进入容器内部**：  
除了使用 docker run -it 来启动一个交互式容器外，您还可以使用 docker exec 命令进入已经运行的容器内部：  
```
docker exec -it <容器名/ID> /bin/bash  # 或者 /bin/sh，取决于容器内的shell
```
连接容器：
```
docker attach <容器名/ID>
```

**导出和导入容器**：  
虽然通常我们更关注镜像的保存和加载，但有时也需要导出和导入容器（例如，为了迁移或备份）：  
导出容器为tar文件:  
```
docker export <容器名或ID> > <输出文件名>.tar
```
从tar文件导入容器为镜像（注意，这不是一个运行的容器，而是一个静态的镜像）:  
```
cat <文件名>.tar | docker import - <镜像名>:<标签>
```
查看容器的详细信息：
```
docker inspect <容器名/ID>
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
查找镜像:
```
docker search <镜像名称>
```
登录私有dockerhub仓库:
```
docker login <IP/域名>
```
输入账号密码  

拉取镜像：  
```
docker pull <镜像名:tag/ID>
```
给镜像打标签:  
```
docker tag <原始镜像名>:<tag> <私有仓库地址>/<新镜像名>:<tag>
```
如果是latest可以省略tag部分  

推送镜像：
```
docker push <IP/域名>/images:<tag>
```
列出本地镜像：
```
docker images
```
构建镜像：
```
docker build -t <镜像名>:<tag> <上下文路径>
```
删除镜像：  
```
docker rmi <镜像名/ID>
```
保存镜像为文件：
```
docker save -o <目标文件路径/文件名.tar> <镜像名>:<tag>
```
- -o 选项用于指定输出文件的路径。  
- <目标文件路径> 可以是绝对路径或相对路径。  
- <镜像名>:<tag> 指定要保存的镜像名称和标签(tag)  
示例:  
将镜像保存到home目录下
```
docker save -o ~/打包后的镜像名.tar 镜像名称:tag
```

从文件加载镜像：
```
docker load -i <镜像路径/镜像名.tar>
```
或
```
cat <文件名>.tar | docker load
```
示例：  
从当前目录下加载镜像文件
```
docker load -i ./打包后的镜像名.tar
```
```
cat 打包后的镜像名.tar | docker load
```
查看镜像信息：
```
docker inspect <registry:latest>
```


## Docker镜像&容器的导入导出
**导出和导入容器**：  
虽然通常我们更关注镜像的保存和加载，但有时也需要导出和导入容器（例如，为了迁移或备份）：  
导出容器为tar文件:  
```
docker export <容器名或ID> > <输出文件名>.tar
```
从tar文件导入容器为镜像（注意，这不是一个运行的容器，而是一个静态的镜像）:  
```
docker import <文件名>.tar <镜像名>:<标签>
```

**导出和导入镜像**：  
保存镜像为文件：
```
docker save -o <目标文件路径/文件名.tar> <镜像名>:<tag>
```
从文件加载镜像：
```
docker load -i <镜像路径/镜像名.tar>
```
总的来说，如果你想要`保存整个镜像，包括它的所有历史和标签`，那么你应该使用 `docker save` 和 `docker load` 命令。而如果你只是想要`保存一个容器的当前状态`，那么你应该使用 `docker export` 和 `docker import` 命令  
注意：在 docker save 和 docker load 的操作中，你在操作镜像，镜像名称后可以带标签（如果不指定标签，默认为 latest）。而在 docker export 和 docker import 的操作中，你在操作容器（对应的是一个容器的 ID 或名称）和镜像（可以指定新的镜像名称和标签）  


## Docker资源查看  
列出当前运行的容器：
```
docker ps
```
列出所有容器（包括停止的）：
```
docker ps -a
```
列出本地镜像：
```
docker images
```
查看指定容器的日志：
```
docker logs <容器名/ID>
```
查看Docker版本：
```
docker --version
```
查看 Docker 系统信息（包括资源使用情况、配置等）：
```
docker info
```
实时查看容器统计信息（CPU、内存、网络 I/O 等）：
```
docker stats
```
查看容器或镜像的详细信息：
```
docker inspect <容器名/ID或镜像名/ID>
```
查看 Docker 网络信息：
```
docker network ls
```
查看 Docker 卷信息:
```
docker volume ls
```
列出所有 Docker 构建的缓存（适用于 Docker 18.09 及更高版本）
```
docker builder prune -a --filter "until=<timestamp>"
```
可选参数 <timestamp> 用于指定时间之前的构建缓存  
注意：通常不使用 --filter 参数，直接运行 `docker builder prune -a` 来清理所有构建缓存  

查看 Docker 磁盘使用情况:
```
docker system df
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


## Docker网络
<table>
  <tr>
    <th>网络模式</th>
    <th>指定方式</th>
    <th>解释</th>
  </tr>
  <tr>
    <td>bridge</td>
    <td>--network bridge指定，默认使用docker0</td>
    <td>桥接模式链接宿主机，通过虚拟出来的docker0作为网桥链接物理网卡，也可以使用docker network create --subnet=172.18.0.0/16 docker1创建新的网桥使用。</td>
  </tr>
  <tr>
    <td>host</td>
    <td>--network host指定</td>
    <td>主机模式链接宿主机，通过和宿主机共享同一物理网卡链接，自身不在配置IP，这种模式无法做到网络端口映射。</td>
  </tr>
  <tr>
    <td>none</td>
    <td>--network none指定</td>
    <td>none模式，禁用网络功能，这个Docker容器不存在网卡，IP等信息。不能和其它容器或宿主机进行通信。</td>
  </tr>
  <tr>
    <td>container</td>
    <td>--network container:NAME或者容器ID</td>
    <td>container模式，同其它容器共享网络，MAC地址和ip一样。</td>
  </tr>
</table>

## 进阶操作：
CPU隔离:  
```
docker run -d --cpuset-cpus=1-20 coml_transcode:v2.0
```
指定该容器使用CPU 1-20

日志文件同步:  
日志同步可以做到容器指定目录下的文件可以和宿主机指定目录下的文件进行实时同步功能。这样可以解决如下几个问题：  
1.如果启动的容器异常退出之后，重启不起来，导致容器里存在的程序日志信息无法查看；  
2.如果需要更新程序，只需要将最新版本的程序，上传至宿主机的共享目录下，然后重启容器即可完成程序的迭代更新；  
3.对于集群部署的容器，可以将宿主机共享文件统一设置再一个目录下，如：data/data1, data/data2, data/data3这样的格式，这样便于查看每个容器所打印的日志信息，不必去连接到每一个容器去查看  
启动容器时使用如下命令：  
```
# 获取宿主机可执行程序运行目录
root@ubuntu:/home/DockerTranscode/coml_transcode# pwd
/home/DockerTranscode/coml_transcode

# 启动容器
 docker run -d --privileged=true -v /home/DockerTranscode/coml_transcode:/home/coml_transcode/ coml_transcode:v5.0
```
