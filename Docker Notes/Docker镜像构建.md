# Docker镜像构建

- [Python项目Docker镜像构建流程](#Python项目Docker镜像构建流程)
- [C项目Docker镜像构建流程](#C项目Docker镜像构建流程)
- [Java项目Docker镜像构建流程](#Java项目Docker镜像构建流程)
- [cpp项目Docker镜像构建流程](#cpp项目Docker镜像构建流程)
- [Go项目Docker镜像构建流程](#Go项目Docker镜像构建流程)

## Docker Buildx 手动安装

### 下载 Buildx 二进制文件
首先，从 Docker Buildx 的 GitHub 发布页面下载适合你操作系统的最新版本：
```bash
wget https://github.com/docker/buildx/releases/download/v0.11.2/buildx-v0.11.2.linux-amd64
```

### 安装 Buildx 插件
将下载的二进制文件移动到 Docker 的插件目录并重命名：
```bash
mkdir -p ~/.docker/cli-plugins
mv buildx-v0.11.2.linux-amd64 ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
```

### 验证安装
检查 Buildx 是否安装成功：
```
docker buildx version
```

如果安装成功，你应该能看到类似这样的输出：
<pre>
github.com/docker/buildx v0.11.2 5fac64c2c49dae1320f2b51f1a899ca451935554
</pre>


## 什么是Dockerfile
Dockerfile 是用于构建 Docker 镜像的文本文件。它包含了一系列的指令，用于描述如何构建镜像的步骤和配置  
通过编写 Dockerfile，您可以定义镜像的基础环境、安装软件包、复制文件、设置环境变量等操作。Dockerfile 提供了一种可重复、可自动化的方式来构建镜像，使得您可以轻松地创建和部署应用程序的容器化版本  
Dockerfile 的编写非常灵活，您可以根据自己的需求和项目的特点来定义构建镜像的步骤和配置。通过使用 Dockerfile，您可以将整个构建过程以代码的形式进行版本控制，并且可以轻松地在不同的环境中重复构建相同的镜像  
Dockerfile的基本结构包括四个部分：基础镜像信息、维护者信息、镜像操作指令和容器启动时执行指令  
Docker以从上到下的顺序运行Dockerfile的指令。为了指定基本映像，第一条指令必须是FROM。一个声明以“#”字符开头则被视为注释  
在Dockerfile中可以使用多种指令，例如RUN、CMD、FROM、EXPOSE、ENV等。这些指令可以用来定义镜像的操作系统、软件安装、环境变量等  
一旦编写好 Dockerfile，您可以使用 Docker 命令来构建镜像。通过运行 docker build 命令并指定 Dockerfile 的路径，Docker 引擎将根据 Dockerfile 中的指令逐步执行构建过程，生成一个新的镜像  
总结来说，Dockerfile 是一个用于定义构建 Docker 镜像的文本文件，它提供了一种可重复、可自动化的方式来构建和配置镜像，使得容器化应用程序的构建和部署更加简单和可靠  

## Dockerfile 中常用的指令
| 指令         | 说明                                                         |
|--------------|--------------------------------------------------------------|
| FROM        | 指定基础镜像，作为后续指令的基础。                             |
| MAINTAINER   | 设置维护者信息，虽然已弃用，但可用于记录维护者联系方式。         |
| LABEL       | 添加镜像的元数据，使用键值对的形式，可以添加多个 LABEL 指令。   |
| RUN         | 在构建过程中执行命令，用于安装软件或执行其他设置。             |
| CMD         | 指定容器启动时要执行的默认命令，可以被 docker run 命令行参数覆盖。 |
| ENTRYPOINT  | 设置容器启动时执行的入口点命令，不会被 docker run 命令行参数覆盖。 |
| EXPOSE      | 声明容器运行时监听的特定网络端口，仅用于文档说明和映像构建者提示。|
| ENV         | 在容器内部设置环境变量，可用于配置容器环境。                     |
| ADD         | 将文件、目录或远程URL复制到镜像中，支持解压缩。               |
| COPY        | 将文件或目录复制到镜像中。                                     |
| VOLUME      | 为容器创建挂载点或声明卷，用于数据持久化。                       |
| WORKDIR     | 设置后续指令的工作目录，可以多次使用，最终路径是累积结果。         |
| USER        | 指定运行容器时的用户名或 UID，用于改变运行进程的用户安全上下文。 |
| HEALTHCHECK | 定义容器的健康检查命令，用于持续监控容器的健康状态。             |
| ARG         | 定义构建时的变量，可以通过 --build-arg 参数传递值。               |
| ONBUILD     | 指定当该镜像被用作另一个构建过程的基础时，自动执行的指令。       |
| STOPSIGNAL  | 设置发送给容器以退出的系统调用信号，默认为 SIGTERM。             |
| SHELL       | 覆盖 Docker 中默认的 shell，用于 RUN、CMD、ENTRYPOINT 指令。       |

这些指令可以根据需要灵活组合，构建出符合需求的 Docker 镜像。请注意，Dockerfile 中的指令顺序很重要，因为每个指令都会创建一个新的镜像层，而后续的指令将基于前面的镜像层进行操作  
更详细的指令说明和用法，请参考 Docker 官方文档：https://docs.docker.com/engine/reference/builder/  


## docker build命令详解
docker build 命令用于从 Dockerfile 创建镜像  
<pre>
docker build [OPTIONS] PATH | URL | -
</pre>
其中， PATH 是 Dockerfile 所在的路径， URL 是 Dockerfile 的 URL， - 表示从标准输入读取 Dockerfile  
docker build 命令可以使用以下选项：  
- -t ：指定镜像的名称和标签。
- -f ：指定 Dockerfile 的路径或 URL。
- -q ：只显示镜像 ID。
- -no-cache ：不使用缓存构建镜像。
- -build-arg ：指定构建镜像时使用的参数。
- -force-rm ：在构建镜像时删除中间容器。
- -target ：指定构建镜像的目标阶段。

以下是 docker build 命令的一些示例：  
<pre>
# 从当前目录构建镜像
docker build -t my-image .

# 从指定路径构建镜像
docker build -t my-image /path/to/Dockerfile

# 从指定 URL 构建镜像
docker build -t my-image https://github.com/docker/dockerfile-examples/blob/master/nginx.dockerfile

# 只显示镜像 ID
docker build -t my-image -q .

# 不使用缓存构建镜像
docker build -t my-image -no-cache .

# 指定构建镜像时使用的参数
docker build -t my-image -build-arg VERSION=1.0 .

# 在构建镜像时删除中间容器
docker build -t my-image -force-rm .

# 指定构建镜像的目标阶段
docker build -t my-image -target build .
</pre>
docker build 命令是构建 Docker 镜像的常用命令。它可以用于从 Dockerfile 创建镜像，也可以从指定的路径或 URL 创建镜像  

### 补充说明--target参数
-target 参数用于指定构建镜像的目标阶段。当 Dockerfile 中定义了多个阶段时，可以使用 -target 参数来选择性地构建特定阶段的镜像  
在 Dockerfile 中定义多个阶段时，可以使用 AS 关键字为每个阶段命名。例如：  
<pre>
FROM base AS build
RUN apt-get update && apt-get install -y build-essential

FROM base AS test
RUN apt-get update && apt-get install -y curl

FROM base AS deploy
COPY --from=build /app /app
COPY --from=test /test /test
</pre>
在上面的示例中，Dockerfile 定义了三个阶段： build 、 test 和 deploy 。每个阶段都有一个特定的操作。 deploy 阶段依赖于 build 和 test 阶段的结果  
使用 -target 参数，可以选择性地构建特定的阶段。例如，要只构建 build 阶段的镜像，可以执行以下命令：  
```
docker build -t my-image --target build .
```
这将只构建 build 阶段的镜像，并忽略其他阶段。通过 -target 参数，可以控制构建过程中所涉及的阶段，从而提高构建效率  
需要注意的是， -target 参数只能选择构建过程中的某个阶段，而不能选择构建过程中的某个指令。因此，指定的目标阶段必须在 Dockerfile 中明确定义  
-target 参数是一个有用的选项，特别适用于大型项目或复杂的构建流程，可以帮助减少构建时间并提高构建效率  


## [Python项目Docker镜像构建流程](#Python项目Docker镜像构建流程)

1.创建项目结构：  
<pre>
/my-python-app/  
|-- app.py  
|-- requirements.txt  
|-- Dockerfile  
</pre>

2.Dockerfile (/my-python-app/Dockerfile)：  
```dockerfile
# 使用官方Python运行时作为父镜像
FROM python:3.8-slim

# 设置工作目录
WORKDIR /usr/src/app

# 将本地代码复制到容器中
COPY . .

# 安装任何所需的包
RUN pip install --no-cache-dir -r requirements.txt

# 告诉Docker容器在运行时监听哪个端口
EXPOSE 80

# 定义环境变量
ENV NAME World

# 运行时执行的命令
CMD ["python", "app.py"]
```
3.构建镜像：  
```bash
cd /my-python-app
docker build -t my-python-app .
```

## [C项目Docker镜像构建流程](#C项目Docker镜像构建流程)
1.创建项目结构：  
<pre>
/my-c-app/  
|-- main.c  
|-- Dockerfile  
</pre>

2.Dockerfile (/my-c-app/Dockerfile)：  
```dockerfile
# 使用官方C运行时作为父镜像
FROM gcc:latest

# 设置工作目录
WORKDIR /usr/src/app

# 将本地代码复制到容器中
COPY . .

# 编译C程序
RUN gcc -o myapp main.c

# 告诉Docker容器在运行时监听哪个端口（如果需要）
EXPOSE 80

# 运行时执行的命令
CMD ["./myapp"]
```

3.构建镜像：
```bash
cd /my-c-app
docker build -t my-c-app .
```

## [Java项目Docker镜像构建流程](#Java项目Docker镜像构建流程)
1.创建项目结构：  
<pre>
/my-java-app/
|-- src/
|   |-- main/
|       |-- java/
|           |-- com/
|               |-- myapp/
|                   |-- MyApp.java
|-- pom.xml
|-- Dockerfile
</pre>

2.Dockerfile (/my-java-app/Dockerfile)：
```dockerfile
# 使用官方Maven运行时作为父镜像
FROM maven:3.6.3-jdk-11

# 设置工作目录
WORKDIR /usr/src/app

# 将本地代码复制到容器中
COPY . .

# 构建Java项目
RUN mvn -f pom.xml clean package

# 使用JRE运行时作为父镜像
FROM openjdk:11-jre-slim

# 设置工作目录
WORKDIR /usr/src/app

# 将构建的jar文件复制到容器中
COPY --from=0 /usr/src/app/target/myapp-1.0-SNAPSHOT.jar ./myapp.jar

# 告诉Docker容器在运行时监听哪个端口
EXPOSE 8080

# 运行时执行的命令
CMD ["java", "-jar", "myapp.jar"]
```

3.构建镜像：
```bash
cd /my-java-app
docker build -t my-java-app .
```

## [cpp项目Docker镜像构建流程](#cpp项目Docker镜像构建流程)
1.创建项目结构：  
<pre>
/my-cpp-app/  
|-- main.cpp  
|-- Dockerfile  
</pre>
  
2.Dockerfile (/my-cpp-app/Dockerfile)：  
```dockerfile
# 使用基础镜像
FROM 192.168.3.40:5000/centos:7.3.1611

# 将项目文件夹复制到镜像中
COPY . /app

# 设置工作目录
WORKDIR /app

# 安装依赖库
RUN yum install -y gcc make

# 编译项目
RUN g++ -o my_program main.cpp

# 运行时执行的命令
CMD ["./my_program"]
```

3.构建镜像：
```bash
cd /my-cpp-app
docker build -t my-cpp-app:v1.00 .
```

## [Go项目Docker镜像构建流程](#Go项目Docker镜像构建流程)
1.创建项目结构：
<pre>
/my-go-app/  
|-- main.go  
|-- go.mod  
|-- Dockerfile  
</pre>
  
2.Dockerfile (/my-go-app/Dockerfile)：
```dockerfile
# 使用Go语言的官方镜像作为构建环境
FROM golang:1.16-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制go.mod和go.sum
COPY go.mod .
COPY go.sum .

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 编译Go程序
RUN go build -o /my-go-app

# 使用alpine作为运行时环境
FROM alpine:latest
RUN apk --no-cache add ca-certificates

# 设置工作目录
WORKDIR /root/

# 从构建阶段复制二进制文件
COPY --from=builder /my-go-app .

# 暴露端口
EXPOSE 8080

# 运行时执行的命令
CMD ["./my-go-app"]
```

3.构建镜像：
```
cd /my-go-app
docker build -t my-go-app:latest .
```
