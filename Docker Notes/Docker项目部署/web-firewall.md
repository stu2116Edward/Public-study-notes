# 本地部署webFirewall

### 安装

本项目提供一个已经打包编译好的项目，用户仅需自己下载本项目解压后，执行 里面的install.sh文件即可，如果自己编译项目请根据前后端代码自行进行打包即可  
下载的包名称一般为：v1.x.x.zip  
```
unzip v1.x.x.zip
cd v1.x.x.zip
bash install.sh

# 查看服务是否正常运行
systemctl status web-firewalld

# 建议停用firewalld服务
systemctl disable  firewalld
systemctl stop  firewalld
```
访问地址：
```
http://ip:8000
```
默认账号密码：`admin/admin`

### 升级
```
unzip v1.x.x.zip
cd v1.x.x.zip
bash upgrade.sh
```

### Docker安装
构建项目镜像
```
# 拉取源代码
git clone https://github.com/moreKing/web-firewall.git
cd web-firewall
# 构建镜像
docker build -f ./server/manifest/docker/Dockerfile  -t web-firewall:latest .
```

docker使用必须以特权和host模式运行才能操作主机的网络配置
```
docker run -itd --network host --privileged \
-v /etc/sysctl.conf:/etc/sysctl.conf \
-v  /proc:/host_proc \
web-firewall
```

数据持久化需要映射以下几个目录
```
-v /path/config:/web-firewall/manifest/config  # 配置文件 docker模式下 默认数据库文件也在此目录
-v /path/log:/web-firewall/log  # 日志文件目录 所有日志文件均会在此目录下
-v /path/resources/template:/web-firewall/resources/template  # 模板文件，用户可以自定义邮件样式
```
`/path/config`目录内需要提供config.yaml配置文件和db.sqlite3初始化数据库文件，可先运行一个镜像从里面对应位置拷贝出里面的默认文件，然后修改配置文件即可
