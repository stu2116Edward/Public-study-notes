# moreKing自研web-firewall

基于`golang+vue3` 开发的Web Linux防火墙，前端使用`SoybeanAdmin`框架，后端使用`goframe2`，数据库支持 `sqlite3(默认)`/`postgresql` ，它可以在Linux系统中基于`nfatables`用于替代`firewalld`工具  

### 使用Docker编译部署
拉取源代码
```bash
git clone https://github.com/moreKing/web-firewall.git
cd web-firewall
```
构建镜像
```bash
docker build -f ./server/manifest/docker/Dockerfile  -t web-firewall:latest .
```
运行容器
```bash
docker run -itd --network host --privileged \
-v /etc/sysctl.conf:/etc/sysctl.conf \
-v  /proc:/host_proc \
web-firewall
```
docker使用必须以特权和host模式运行才能操作主机的网络配置

访问地址：`http://ip:8000`  

默认账号密码：`admin/admin`  

创建持久化目录结构
```bash
mkdir -p /data/web-firewall/{config,log,resources/template}
chmod -R 755 /data/web-firewall
```
数据持久化需要映射以下几个目录
```
-v /path/config:/web-firewall/manifest/config  # 配置文件 docker模式下 默认数据库文件也在此目录
-v /path/log:/web-firewall/log  # 日志文件目录 所有日志文件均会在此目录下
-v /path/resources/template:/web-firewall/resources/template  # 模板文件，用户可以自定义邮件样式
```
`/path/config`目录内需要提供`config.yaml`配置文件和`db.sqlite3`初始化数据库文件，可先运行一个镜像从里面对应位置拷贝出里面的默认文件，然后修改配置文件即可  

从镜像中提取默认文件
```bash
docker run -d --name temp_firewall web-firewall:latest
```
复制配置文件和数据库
```bash
docker cp temp_firewall:/web-firewall/manifest/config/config.yaml /data/web-firewall/config/
docker cp temp_firewall:/web-firewall/manifest/config/db.sqlite3 /data/web-firewall/config/
```
复制模板文件（可选）
```bash
docker cp temp_firewall:/web-firewall/resources/template/. /data/web-firewall/resources/template/
```
清理临时容器
```bash
docker rm -f temp_firewall
```
修改配置文件：
```yml
server:
  address:     ":8000"
  https: false  # https 端口 自动开启80跳转到 https端口
  # httpsCertPath:   "./manifest/config/server.crt"
  # httpsKeyPath:    "./manifest/config/server.key"
  openapiPath: "/api/api.json" # 在线文档访问地址
  swaggerPath: "/api/docs" # 在线文档访问地址
  swaggerCss: ./resource/public/docs/swagger.css
  swaggerJs: ./resource/public/docs/swagger.js
  serverRoot: "./resource/public/html"
  indexFiles: [ "index.html", "main.html" ]
  accessLogEnabled: true
  #  shell操作日志存放路径
  shellMode: sh
  shellLog: /web-firewall/log/shell

  logger:
    path:                  "./log/access"   # 日志文件路径。默认为空，表示关闭，仅输出到终端
    # file:                  "" # 日志文件格式。默认为"{Y-m-d}.log"
    # prefix:                ""            # 日志内容输出前缀。默认为空
    level:                 "info"         # 日志输出级别
    # stdout:                false          # 日志是否同时输出到终端。默认true
    # rotateSize:            0             # 按照日志文件大小对文件进行滚动切分。默认为0，表示关闭滚动切分特性
    # rotateExpire:          0             # 按照日志文件时间间隔对文件滚动切分。默认为0，表示关闭滚动切分特性
    # rotateBackupLimit:     0             # 按照切分的文件数量清理切分文件，当滚动切分特性开启时有效。默认为0，表示不备份，切分则删除
    # rotateBackupExpire:    0             # 按照切分的文件有效期清理切分文件，当滚动切分特性开启时有效。默认为0，表示不备份，切分则删除
    # rotateBackupCompress:  0             # 滚动切分文件的压缩比（0-9）。默认为0，表示不压缩
    # rotateCheckInterval:   "1d"          # 滚动切分的时间检测间隔，一般不需要设置。默认为1小时


logger:
  path: "/web-firewall/log/server"           # 日志文件路径。默认为空，表示关闭，仅输出到终端
  file: "{Y-m-d}.log"         # 日志文件格式。默认为"{Y-m-d}.log"
  prefix: ""                    # 日志内容输出前缀。默认为空
  level: "all"                 # 日志输出级别，不区分大小写 all 所有日志 DEBU < INFO < NOTI < WARN < ERRO < CRIT
  timeFormat: "2006-01-02T15:04:05" # 自定义日志输出的时间格式，使用Golang标准的时间格式配置
  #  ctxKeys: [ ]                    # 自定义Context上下文变量名称，自动打印Context的变量到日志中。默认为空
  header: true                  # 是否打印日志的头信息。默认true
  stdout: true                  # 日志是否同时输出到终端。默认true
  rotateSize: 0                     # 按照日志文件大小对文件进行滚动切分。默认为0，表示关闭滚动切分特性
  rotateExpire: "1d"                     # 按照日志文件时间间隔对文件滚动切分。默认为0，表示关闭滚动切分特性
  rotateBackupLimit: 30                     # 按照切分的文件数量清理切分文件，当滚动切分特性开启时有效。默认为0，表示不备份，切分则删除
  rotateBackupExpire: 0                     # 按照切分的文件有效期清理切分文件，当滚动切分特性开启时有效。默认为0，表示不备份，切分则删除
  rotateBackupCompress: 0                     # 滚动切分文件的压缩比（0-9）。默认为0，表示不压缩
  rotateCheckInterval: "1d"                  # 滚动切分的时间检测间隔，一般不需要设置。默认为1小时
  stdoutColorDisabled: false                 # 关闭终端的颜色打印。默认开启
  writerColorEnable: false                 # 日志文件是否带上颜色。默认false，表示不带颜色

firewall:
  type: auto # 配置防火墙类型，可选参数 nftables/iptables/auto 默认auto
  typePriority: nftables # nftables/iptables type 为auto 设置优先检测防火墙类型，在某些系统下两种会共存 默认nftables
  chainPriority: #配置链的优先级，仅type为 nftables时生效
    input: 0
    output: 100
    forward: 100
    prerouting: 100
    postrouting: 100

database:
  logger:
    path: "/web-firewall/log/sql"
    level: "all"
    stdout: true
  default:
    link:  "sqlite::@file(/web-firewall/manifest/config/db.sqlite3)"
  debug: true
```

生产环境下运行容器
```bash
docker run -itd --network host --privileged \
--restart=always \
-v /etc/sysctl.conf:/etc/sysctl.conf \
-v /proc:/host_proc \
-v /data/web-firewall/config:/web-firewall/manifest/config \
-v /data/web-firewall/log:/web-firewall/log \
-v /data/web-firewall/resources/template:/web-firewall/resources/template \
web-firewall
```
