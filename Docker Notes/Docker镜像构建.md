# Docker镜像构建

- [Python项目Docker镜像构建流程](#Python项目Docker镜像构建流程)
- [C项目Docker镜像构建流程](#C项目Docker镜像构建流程)
- [Java项目Docker镜像构建流程](#Java项目Docker镜像构建流程)
- [C++项目Docker镜像构建流程](#cpp项目Docker镜像构建流程)
- [Go项目Docker镜像构建流程](#Go项目Docker镜像构建流程)

## [Python项目Docker镜像构建流程](#Python项目Docker镜像构建流程)

1.创建项目结构：  
/my-python-app/  
|-- app.py  
|-- requirements.txt  
|-- Dockerfile  

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
/my-c-app/  
|-- main.c  
|-- Dockerfile  

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
/my-java-app/  
|-- src/  
|   |-- main/  
|       |-- java/  
|           |-- com/  
|               |-- myapp/  
|                   |-- MyApp.java  
|-- pom.xml  
|-- Dockerfile  

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

## [C++项目Docker镜像构建流程](#cpp项目Docker镜像构建流程)
1.创建项目结构：  
/my-cpp-app/  
|-- main.cpp  
|-- Dockerfile  

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
/my-go-app/  
|-- main.go  
|-- go.mod  
|-- Dockerfile  

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
