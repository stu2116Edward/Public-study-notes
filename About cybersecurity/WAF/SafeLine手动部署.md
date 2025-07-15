# SafeLine部署

### 创建雷池目录
确保该目录至少有 5GB 的存储空间
```bash
mkdir -p /data/safeline
```

### 下载 compose 编排脚本
使用下方的命令进入雷池安装目录，并下载 docker compose 编排脚本
```bash
cd /data/safeline
wget https://waf-ce.chaitin.cn/release/latest/compose.yaml
```

### 配置 compose 环境变量
使用下方的命令进入雷池安装目录，并创建 `.env` 配置文件
```bash
cd /data/safeline
touch .env
```

使用文本编辑器打开 `.env` 文件，写入下方的内容，`POSTGRES_PASSWORD`的密码需自定义
```bash
vim .env
```
```
SAFELINE_DIR=/data/safeline
IMAGE_TAG=latest
MGT_PORT=9443
POSTGRES_PASSWORD={postgres-password}
SUBNET_PREFIX=172.22.222
IMAGE_PREFIX=chaitin
ARCH_SUFFIX=
RELEASE=
REGION=-g
```
如果是 ARM 服务器需要把 `ARCH_SUFFIX`改成 `-arm`
```
ARCH_SUFFIX=-arm
```
如果是安装 LTS 版本需要把 `RELEASE` 改成 `-lts`
```
RELEASE=-lts
```

配置文件的格式说明如下：

- `SAFELINE_DIR`: 雷池安装目录，如 `/data/safeline`
- `IMAGE_TAG`: 要安装的雷池版本，保持默认的 `latest` 即可
- `MGT_PORT`: 雷池控制台的端口，保持默认的 `9443` 即可
- `POSTGRES_PASSWORD`: 雷池所需数据库的初始化**密码**，请随机生成一个
- `SUBNET_PREFIX`: 雷池内部网络的**网段**，保持默认的 `172.22.222` 即可
- `IMAGE_PREFIX`: 雷池镜像源的前缀，建议根据服务器地理位置选择合适的源
- `ARCH_SUFFIX`: 雷池架构的后缀，ARM 服务器需要配置为 -arm
- `RELEASE`: 更新通道，LTS 版本需要配置为 -lts

### 启动雷池
```bash
cd /data/safeline
docker-compose up -d
```

雷池安装成功以后，你可以打开浏览器访问 `https://<safeline-ip>:9443/` 来使用雷池控制台  

**注意对9443的端口打开访问**  

### 登录雷池

第一次登录雷池需要初始化你的管理员账户（默认会执行），如果没有找到账户密码，手动执行以下命令即可  
```bash
docker exec safeline-mgt resetadmin
```
命令执行完成后会随机重置 admin 账户的密码，输出结果如下
<pre>
[SafeLine] Initial username：admin
[SafeLine] Initial password：**********
[SafeLine] Done
</pre>

### 卸载雷池
进入安装目录
```bash
cd /data/safeline
```
停止运行
```bash
docker-compose down
```
删除安装目录
```bash
rm -rf /data/safeline
```

### 雷池离线安装包
离线安装包下载地址：  
https://demo.waf-ce.chaitin.cn/image.tar.gz

导入Docker image
```bash
cat image.tar.gz | gzip -d | docker load
```