# Redis和Redis Desktop Manager安装教程

## 安装Redis
### Redis概述
Redis是一个开源的高性能键值对数据库，以其卓越的读写速度而著称，广泛用于数据库、缓存和消息代理。它主要将数据存储在内存中，从而实现快速的数据处理，同时提供了数据持久化功能，以防止系统故障时数据丢失。Redis支持多种数据类型，包括键值对、列表、集合、有序集合、散列、HyperLogLogs和地理空间索引，满足不同场景的数据存储需求。它的原子操作确保了在多线程环境中的数据一致性和完整性，而发布/订阅功能则允许多个客户端订阅频道，实现消息的实时传递。为了保障服务的持续运行，Redis通过Sentinel和Cluster提供了高可用性解决方案。Redis的配置简单灵活，且拥有丰富的客户端库，支持几乎所有流行的编程语言，便于集成和使用。此外，Redis背后有一个活跃的社区和生态系统，提供大量工具、插件和集成选项。Redis采用单线程模型，所有操作按顺序执行，避免了多线程环境下的复杂性和竞争条件。

### 下载Windows版本Readis
下载在Windows版本中使用的Readis
```
https://github.com/tporadowski/redis/releases
```
将`Redis-x64-5.0.14.1.zip`下载至本地并解压到redis文件夹  

### 开启Redis服务端
在reids文件夹的地址栏中输入`cmd`  
输入cmd后回车打开DOS窗口  
在DOS窗口输入以下命令：
```shell
redis-server.exe redis.windows.conf
```
**请注意：开启Redis服务端后请勿关闭该DOS窗口**

### 开启Redis客户端
与开启Reids服务端类似，请在redis文件夹地址栏再次输入cmd重新开启一个新的DOS窗口并执行以下命令：
```shell
redis-cli.exe -h 127.0.0.1 -p 6379
```
至此，已经可以在Window系统使用Redis进行正常的数据存储了


## Windows系统安装Redis Desktop Manager
### Redis Desktop Manager简介  
Redis Desktop Manager 是一款广受欢迎的跨平台图形界面工具，它为连接和管理 Redis 数据库提供了一个用户友好的界面。该工具支持 Windows、macOS 和 Linux 系统，使得用户能够轻松地保存和管理多个 Redis 服务器的连接信息，实现快速切换。通过数据浏览功能，用户可以以表格形式查看和编辑 Redis 中的键值对，同时支持多种数据类型。内置的命令行界面允许用户执行各种 Redis 命令，而数据导入导出功能则方便了数据的迁移和备份。此外，Redis Desktop Manager 提供了实时的性能监控，帮助用户了解内存使用情况和客户端连接数等关键信息。为了确保数据库的安全性，它还支持密码保护功能。用户可以根据自己的喜好调整界面主题和布局，使得 Redis Desktop Manager 不仅功能强大，而且易于使用，特别适合偏好图形界面操作的用户。

### 下载Redis Desktop Manager
从官方网站下载Redis Desktop Manager至本地
```
https://github.com/uglide/RedisDesktopManager/releases/download/0.9.3/redis-desktop-manager-0.9.3.817.exe
```
### 安装Redis Desktop Manager
双击Redis Desktop Manager安装文件  
点击I Agree  
选择安装路径并点击Install  
安装结束后点击Next  
点击Finish完成安装  

### 使用Redis Desktop Manager
完成Redis Desktop Manager的安装后，使用Redis Desktop Manager链接Redis服务器  
点击绿色加号  
点击测试连接  
通过测试，点击好  
连接成功