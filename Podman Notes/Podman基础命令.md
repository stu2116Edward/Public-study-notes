# Podman基础命令

## Podman简介

Podman是一个开源的容器运行时工具，用于开发、管理和运行OCI容器。与Docker不同，Podman不需要守护进程，可以直接由用户运行，提供了更安全的容器环境。

## Podman与Docker命令对比

大多数Podman命令与Docker命令兼容，可以直接替换`docker`为`podman`使用。以下是Podman的基础命令参考：


## 容器管理

### 基本命令

#### 创建并启动一个新容器：
```bash
podman run [选项] <镜像名/ID>
```
选项与Docker基本相同：
- `-d`: 后台运行
- `-it`: 交互式运行
- `--name`: 指定容器名称
- `-p`: 端口映射
- `-v`: 挂载卷
- `--rm`: 容器停止后自动删除
- `--env`/`-e`: 设置环境变量
- `--network`: 设置网络

示例：
```bash
podman run -d --name my_container -p 8080:80 nginx
```

#### 容器生命周期管理
```bash
podman start <容器名/ID>      # 启动容器
podman stop <容器名/ID>       # 停止容器
podman restart <容器名/ID>    # 重启容器
podman kill <容器名/ID>       # 强制停止容器
podman rm <容器名/ID>         # 删除容器
podman rm -f <容器名/ID>      # 强制删除运行中的容器
```

#### 查看容器
```bash
podman ps           # 查看运行中的容器
podman ps -a        # 查看所有容器
podman inspect <容器名/ID>  # 查看容器详细信息
podman logs <容器名/ID>     # 查看容器日志
```

#### 进入容器
```bash
podman exec -it <容器名/ID> /bin/bash  # 进入运行中的容器
podman attach <容器名/ID>              # 连接到运行中的容器
```


## 镜像管理

### 镜像操作
```bash
podman pull <镜像名:tag>        # 拉取镜像
podman images                  # 列出本地镜像
podman rmi <镜像名/ID>          # 删除镜像
podman search <镜像名>          # 搜索镜像
podman inspect <镜像名/ID>      # 查看镜像详细信息
```

### 构建镜像
```bash
podman build -t <镜像名:tag> <上下文路径>  # 构建镜像
```

### 导入导出镜像
```bash
podman save -o <文件名>.tar <镜像名:tag>  # 保存镜像为文件
podman load -i <文件名>.tar              # 从文件加载镜像
```


## 网络管理

### 网络操作
```bash
podman network ls              # 列出网络
podman network create <网络名>  # 创建网络
podman network rm <网络名>      # 删除网络
podman network inspect <网络名> # 查看网络详情
```

### 网络模式
Podman支持与Docker相同的网络模式：
- bridge（默认）
- host
- none
- container:<name|id>

示例：
```bash
podman run --network host nginx  # 使用host网络模式
```


## 存储卷管理

### 卷操作
```bash
podman volume create <卷名>      # 创建卷
podman volume ls               # 列出卷
podman volume inspect <卷名>    # 查看卷详情
podman volume rm <卷名>         # 删除卷
```

### 挂载卷
```bash
podman run -v <卷名或路径>:<容器路径> <镜像名>  # 挂载卷
podman run -v <宿主机路径>:<容器路径>:ro <镜像名> # 只读挂载
```


## 系统管理

### 系统信息
```bash
podman info      # 显示系统信息
podman version   # 显示版本信息
podman stats     # 显示容器资源统计
```

### 清理资源
```bash
# 系统级清理
podman system prune         # 清理未使用的容器、镜像、网络（默认跳过卷）
podman system prune --volumes  # 包括未使用的卷（类似Docker的`-v`）

# 镜像清理
podman image prune          # 清理悬空镜像（未被引用的中间层）
podman image prune -a       # 清理所有未被容器使用的镜像（包括无标签镜像）

# 容器清理
podman container prune      # 清理所有停止的容器

# 卷清理
podman volume prune         # 清理未使用的卷

# 构建缓存清理（Podman 4.0+）
podman builder prune        # 清理未使用的构建缓存
podman builder prune -a     # 清理所有构建缓存（强制）
```


## Podman特有功能

### 无root运行
```bash
podman run --userns=keep-id <镜像名>  # 保持用户ID映射
```

### Pod管理
```bash
podman pod create --name <pod名>      # 创建pod
podman pod ls                         # 列出pod
podman pod start <pod名>              # 启动pod
podman pod stop <pod名>               # 停止pod
podman pod rm <pod名>                 # 删除pod
```

### 生成systemd服务文件
```bash
podman generate systemd --name <容器名> > /etc/systemd/system/<服务名>.service
```


## 迁移Docker到Podman

导出Docker容器/镜像并导入Podman：
```bash
docker save -o image.tar <镜像名>
podman load -i image.tar
```
使用相同的命令语法，只需将`docker`替换为`podman`


## 注意事项

1. Podman不需要守护进程，所有操作由用户直接执行
2. Podman的rootless模式更安全，但可能有权限限制
3. 某些Docker特有功能（如swarm）在Podman中不可用
4. Podman支持Kubernetes风格的pod概念
5. 存储路径与Docker不同（默认在~/.local/share/containers/）