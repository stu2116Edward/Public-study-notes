# Docker基本命令

## Docker容器管理  

### 基本命令
#### 创建并立即启动一个新容器：  
```
docker run [选项] <镜像名/ID>
```
- <镜像名/ID>：指定要运行的Docker镜像名称或ID
- [选项]包括但不限于：
 - -d: 后台运行容器并返回容器 ID
 - - -it：交互式运行容器，分配一个伪终端
 - --name：为容器指定一个名称
 - -p：端口映射，格式为宿(主机端口:容器端口)
 - -v：挂载卷，用于数据持久化或共享，格式为：(宿主机目录:容器目录)
 - --rm: 容器停止后自动删除容器
 - --env 或 -e: 设置环境变量
 - --network：设置容器的网络连接
 - --restart：容器的重启策略（如 no、on-failure、always、unless-stopped）
 - -u: 指定用户

示例:
```
docker run -d --name my_container -p 8080:80 nginx --restart=always
```
这个命令会在后台运行一个名为 `my_container` 的容器，使用 `nginx 镜像`，并将`容器的80端口`映射到宿`主机的8080端口`。同时，设置容器的重启策略为总是重启 `--restart=always`

- 其他常用选项
 - --env-file：从文件中读取环境变量
 - --add-host：添加自定义的DNS条目
 - --cap-add：添加容器的Linux能力
 - --entrypoint：覆盖镜像中设置的入口点
 - --detach-keys：设置容器分离的键
 - --cpus：限制容器使用的CPU资源
 - --memory：限制容器使用的内存

#### 仅创建一个新的容器，但不启动它：
```
docker create --name <容器名> <镜像名>
```
常用参数：
- --name: 给容器指定一个名称。
- -p, --publish: 端口映射，格式为 host_port:container_port
- -v, --volume: 挂载卷，格式为 host_dir:container_dir
- -e, --env: 设置环境变量
- --network: 指定容器的网络模式
- --restart: 容器的重启策略（如 no、on-failure、always、unless-stopped）
- -u, --user: 指定用户
- --entrypoint: 覆盖容器的默认入口点
- --detach: 在后台创建容器

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

### 管理 Docker 网络
查看所有的docker网络:
```bash
docker network ls
```
这个命令会列出 Docker 守护进程当前知道的所有的网络

创建新网络:
```bash
docker network create [选项] <网络名称>
```
- [选项] 可以包括网络驱动程序（如 --driver bridge）、子网（--subnet）、网关（--gateway）等
- <网络名称> 是您要创建的网络的名称

这将创建一个名为 my-network 的新网络。您可以使用不同的驱动程序创建网络，例如使用 overlay 驱动程序创建一个跨主机的网络：  
```bash
docker network create --driver overlay <我的覆盖网络>
```
删除指定网络:
```bash
docker network rm <网络名称>
```
请注意，在删除网络之前，需要先断开所有连接到该网络的容器  
连接容器到网络:  
```bash
docker network connect [选项] <网络名称> <容器名称或ID>
```
这个命令会将一个已运行的容器连接到指定的网络  
从网络断开容器:
```bash
docker network disconnect [选项] <网络名称> <容器名称或ID>
```
查看网络详情:
```bash
docker network inspect <网络名称或ID>
```
创建并启动容器时连接到网络:
```bash
docker run [选项] --network <网络名称或ID> --name <容器名称> <镜像名称> [命令] [参数]
```
指定其他网络选项：
```bash
docker network create \  
  --driver bridge \  
  --subnet=172.25.0.0/16 \  
  --gateway=172.25.0.1 \  
  --ip-range=172.25.50.0/24 \  
  --aux-address="my-router=172.25.50.10" \  
  my-custom-network
```
这将创建一个名为 my-custom-network 的自定义 bridge 网络，具有指定的子网、网关、IP 地址范围和辅助地址  
- --driver 或 -d：指定网络驱动程序，如 bridge 或 overlay
- --subnet：指定网络的子网地址
- --gateway：指定网络的网关地址
- --ip-range：指定网络的 IP 地址范围
- --aux-address：指定网络的辅助地址

![host2](https://github.com/user-attachments/assets/cf5d6f52-b5c9-42c9-a78c-70c0131285d5)  

Docker网络服务发现与负载均衡：  
**Docker Swarm**  
`Docker的网络服务发现与负载均衡功能在Docker Swarm模式下特别有用。Swarm是Docker的一个集群管理工具，它允许将多个Docker主机组合成一个单一的、可伸缩的、高可用的集群。在这个集群中，可以部署和管理服务，而Docker Swarm会负责在集群节点之间分配和调度容器`  
- 服务发现:  
服务发现是Swarm的一个核心功能，它允许服务自动找到彼此，而不需要硬编码主机名或IP地址。Swarm使用DNS和VIP（虚拟IP地址）来实现服务发现。每个服务在Swarm中都会被分配一个唯一的名称和VIP，其他服务可以通过这个名称或VIP来访问该服务，而不需要知道底层容器的实际IP地址  
- 负载均衡:  
当服务有多个副本（即多个容器实例）在Swarm集群中运行时，Docker Swarm会自动处理负载均衡。它使用内置的负载均衡器来将流量分发到不同的容器实例上，从而实现高可用性和扩展性。这个负载均衡器是基于Docker的网络驱动和iptables（Linux内核的包过滤技术）实现的  


### Docker网络模式

![dnetwork](https://github.com/user-attachments/assets/6a2dbfef-1270-447b-93bc-2df47325f657)  

bridge模式：--net=bridge 桥接模式（默认设置，自己创建也使用bridge 模式）  
host模式：--net=host 和宿主机共享网络  
container模式：--net=container:NAME_or_ID 容器网络连通!(很少用，局限性很大！)  
none模式：--net=none 不配置网络  

#### 桥接模式（Bridge Network）
Docker的bridge网络模式是`Docker的默认网络模式`。当Docker进程启动时，它会在主机上创建一个名为docker0的虚拟网桥。此主机上启动的Docker容器会连接到这个虚拟网桥上。这个虚拟网桥的工作方式类似于物理交换机，使得主机上的所有容器都通过交换机连接在一个二层网络中  

![BN](https://github.com/user-attachments/assets/985dcbe9-f145-447d-9b03-263272452d24)  

在这种模式下，Docker会为每个新创建的容器分配`独立的Network Namespace和IP段`等，同时文件系统、进程等也是`隔离`的。容器内部会有一个虚拟网卡，名为eth0，容器之间可以通过这个虚拟网卡和内部的IP地址进行通信。另外，从docker0子网中分配一个IP给容器使用，并设置docker0的IP地址为容器的默认网关  

然而，处于桥接模式的容器和宿主机网络不在同一个网段，容器一般使用172.16.0.xx/24这种网段。因此，容器不能直接和宿主机以外的网络进行通信，而必须要经过NAT转换。同时，容器需要在宿主机上竞争端口，完成端口映射的配置后，从外部到容器内的网络访问tcp流量将会通过DNAT从宿主机端口转发到容器内对应的端口上。此外，容器对于宿主机以外是不可见的，从容器发出的网络请求会通过SNAT从已对接的虚拟网桥（如宿主机的docker0）上统一发出  

#### Host 网络
Docker的host网络模式是另一种网络模式，与bridge模式不同，它`将容器直接融入到主机的网络栈中，使得容器直接使用主机的网络接口和IP地址`。在这种模式下，容器不会获得一个独立的Network Namespace，而是`和宿主机共用一个Network Namespace`。因此，容器内部的服务可以使用宿主机的网络地址和端口，无需进行NAT转换，网络性能较好  

使用host网络模式的一个典型场景是需要容器与宿主机共享网络资源或者容器需要快速访问宿主机网络服务的场景。例如，如果需要在容器内部运行一些网络相关的应用，如网络监控、日志收集等，这些应用需要直接访问宿主机的网络接口和IP地址，此时就可以使用host网络模式  

![Host](https://github.com/user-attachments/assets/d80efa59-27ff-4357-a76b-b1b68659f27b)  

需要注意的是，由于容器与宿主机共用一个网络栈，因此容器的网络隔离性较差，可能存在安全隐患。如果需要在不同主机上运行容器并实现跨主机通信，则不能使用host网络模式  

`总的来说，Docker的host网络模式提供了一种将容器与宿主机网络栈直接融合的方式，使得容器可以直接使用宿主机的网络接口和IP地址，适用于一些需要快速访问宿主机网络服务的场景。但是需要注意的是，该模式下容器的网络隔离性较差，需要谨慎使用`  

#### None 网络
Docker的none网络模式是Docker提供的一种特殊网络模式，它`将容器与宿主机隔离开来`，不提供任何网络能力。在这种模式下，容器内部没有网卡、IP地址、路由等信息，只有一个回环网络（loopback）接口。这意味着容器不能访问外部网络，也不能被外部网络访问  

none网络模式通常用于一些特殊场景，比如需要在容器内部运行一些独立的、与网络无关的应用程序，或者需要进行一些网络调试。由于容器与外部网络完全隔离，这种模式可以增加容器的安全性  

#### container 模式
Docker的container网络模式是指新`创建的容器和已经存在的一个容器共享一个Network Namespace，而不是和宿主机共享`。这意味着新创建的容器不会创建自己的网卡、配置自己的IP地址，而是和一个已存在的容器共享IP地址、端口范围等网络资源。同时，这两个容器的进程可以通过lo网卡设备通信。然而，这两个容器在其他方面，如文件系统、进程列表等，仍然是隔离的  

![container](https://github.com/user-attachments/assets/e9e46b05-a3af-4e40-8dc5-eb58687ccf1a)  

使用container网络模式的一个典型场景是，当需要多个容器之间共享网络配置时，可以使用该模式。例如，可以使用该模式创建一个nginx容器，并指定其网络模型为container模式，和另一个已经存在的容器共享网络命名空间。这样，nginx容器就可以直接使用另一个容器的IP地址和端口，无需进行额外的网络配置  

**Docker 网络桥接模式和 Host 模式的区别**  
在桥接网络模式下，Docker 将为每个容器创建一个独立的网络命名空间，并为容器分配一个|P 地址。而在 Host 网络模式下，容器将直接使用主机的网络栈，与主机共享网络接口和 IP 地址，这意味着容器可以直接访问主机上的所有网络服务，同时也会导致容器与主机网络之间的隔离性降低  

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
