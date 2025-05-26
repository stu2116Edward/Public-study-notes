# docker镜像站搭建

## 使用docker-compose配置文件部署

- 1.创建docker-registry-ui专用目录  
```bash
mkdir -p /root/docker-registry-ui/{data,auth}
```
```bash
cd docker-registry-ui
```

- 2.安装htpasswd工具  
htpasswd是一个命令行工具，用于生成http基本认证的密码文件  
Ubuntu:
```bash
apt-get install apache2-utils
```
Centos:
```bash
yum -y install httpd-tools
```

- 3.创建用户和对应的登录凭据文件  
passwd是登录凭据文件 -B 强制密码加密 -b 命令行密码 -n 不更新加密文件  
```bash
htpasswd -Bbn 用户名 密码 > /root/docker-registry-ui/auth/passwd
```
验证密码
```bash
cat /root/docker-registry-ui/auth/passwd
```
htpasswd使用教程：  
- 创建一个新的用户：
```bash
htpasswd -Bb /root/docker-registry-ui/auth/passwd 新用户名 新密码
```

- 更新现有的用户密码：
```bash
htpasswd -b /root/docker-registry-ui/auth/passwd 已存在用户名 新密码
```

- 创建一个新的用户（追加模式）：
```bash
htpasswd -Bi /root/docker-registry-ui/auth/passwd 新用户名 新密码
```

- 覆盖整个密码文件：
```bash
htpasswd -Bbn 新用户名 新密码 > /root/docker-registry-ui/auth/passwd
```

- 删除密码
```bash
htpasswd -D /root/docker-registry/auth/passwd 用户名
```

- 4.安装registry-ui
将`docker-compose.yaml`文件放入 `/root/docker-registry-ui/` 目录下  
```yaml
version: '3.8'

services:
  registry-ui:
    image: joxit/docker-registry-ui:main
    restart: always
    ports:
      - 8280:80
    environment:
      - SINGLE_REGISTRY=true
      - REGISTRY_TITLE=Docker Registry UI
      - DELETE_IMAGES=true
      - SHOW_CONTENT_DIGEST=true
      - NGINX_PROXY_PASS_URL=http://registry-server:5000
      - SHOW_CATALOG_NB_TAGS=true
      - CATALOG_MIN_BRANCHES=1
      - CATALOG_MAX_BRANCHES=1
      - TAGLIST_PAGE_SIZE=100
      - REGISTRY_SECURED=false
      - CATALOG_ELEMENTS_LIMIT=1000
    container_name: registry-ui

  registry-server:
    image: registry:2.8.2
    restart: always
    environment:
      # 这里是跨域如果不用可以注释
      # REGISTRY_HTTP_HEADERS_Access-Control-Allow-Origin: '[http://registry.example.com]'
      REGISTRY_HTTP_HEADERS_Access-Control-Allow-Methods: '[HEAD,GET,OPTIONS,DELETE]'
      REGISTRY_HTTP_HEADERS_Access-Control-Allow-Credentials: '[true]'
      REGISTRY_HTTP_HEADERS_Access-Control-Allow-Headers: '[Authorization,Accept,Cache-Control]'
      REGISTRY_HTTP_HEADERS_Access-Control-Expose-Headers: '[Docker-Content-Digest]'
      REGISTRY_STORAGE_DELETE_ENABLED: 'true'
      REGISTRY_AUTH: htpasswd  
      REGISTRY_AUTH_HTPASSWD_REALM: Registry Realm  
      REGISTRY_AUTH_HTPASSWD_PATH: /etc/registry/auth/htpasswd
    volumes:
      # 注意你的挂载路径是否正确即/root/docker-registry-ui/内的文件夹名称
      - ./data:/var/lib/registry
      - ./auth/passwd:/etc/registry/auth/htpasswd:ro
    container_name: registry-server
```
然后运行以下命令完成部署(一定要在配置文件的文件夹下运行这个命令)  
```bash
docker-compose up -d
```
安装完成后使用`http://127.0.0.1:8280`访问  
停止容器运行(一定要在配置文件的文件夹下运行这个命令)  
```bash
docker-compose down
```


## 使用Docker命令部署
注意这里使用docker`仅下载registry(没有可视化界面)`  
- 创建目录  
```bash
mkdir -p /root/docker-registry/{data,auth}
```
- 设置密码：
```bash
htpasswd -Bbn 用户名 密码 > /root/docker-registry/auth/passwd
```
注意这里的registry和docker-compose搭建的文件夹名称不同！
```bash
docker run -d \
--restart=always \
--name registry \
-p 5002:5000 \
-v /root/docker-registry/data:/var/lib/registry \
-v /root/docker-registry/auth:/etc/registry/auth \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e "REGISTRY_AUTH_HTPASSWD_PATH=/etc/registry/auth/passwd" \
registry:latest
```
注意`"REGISTRY_AUTH_HTPASSWD_PATH=/etc/registry/auth/passwd"`这里是你密码存放的路径  
使用Docker安装完成后使用`http://ip:5002/v2/_catalog`访问  


## 客户端使用教程
编辑`daemon.json`配置文件:
```
vim /etc/docker/daemon.json
```
添加以下内容：
```json
{
  "registry-mirrors":
  [
    "https://docker.registry.cyou",
    "https://docker-cf.registry.cyou",
    "https://dockercf.jsdelivr.fyi",
    "https://docker.jsdelivr.fyi",
    "https://dockertest.jsdelivr.fyi",
    "https://mirror.aliyuncs.com",
    "https://dockerproxy.com",
    "https://mirror.baidubce.com",
    "https://docker.m.daocloud.io",
    "https://docker.nju.edu.cn",
    "https://docker.mirrors.sjtug.sjtu.edu.cn",
    "https://docker.mirrors.ustc.edu.cn",
    "https://mirror.iscas.ac.cn",
    "https://docker.rainbond.cc"
  ],
  "insecure-registries" :
  [
    "你自己的镜像站"
  ]
}
```
"你自己的镜像站"注意如果是IP地址记得加上端口"IP:8280"  

将重新加载镜像：
```bash
systemctl daemon-reload && systemctl restart docker
```
如果出现以下错误那就证明你配置的格式不正确(提示：注意逗号`,`🤭)：
<pre>
root@VM-16-7-ubuntu:~# systemctl daemon-reload && systemctl restart docker
Job for docker.service failed because the control process exited with error code.
See "systemctl status docker.service" and "journalctl -xe" for details.
</pre>

登录dockerhub仓库:
```bash
docker login <IP:端口/域名>
```
注意要先在`/etc/docker/daemon.json`加上你的私人镜像仓库地址才能实现登陆否则可能出现以下错误  
没有修改`/etc/docker/daemon.json`配置文件，注意加上你的私有地址才行  
<pre>
Error response from daemon: Get "https://127.0.0.1/v2/  ": dial tcp 101.34.30.246:443: connect: connection refused
</pre>
使用域名访问或者加了端口但是没有修改`/etc/docker/daemon.json`配置文件  
<pre>
Error response from daemon: Get "https://127.0.0.1:8280/v2/": http: server gave HTTP response to HTTPS client
</pre>

输入账号密码
<pre>
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
</pre>
这里提示警告是因为 Docker 默认将你的登录凭据（用户名和密码）以 明文形式 存储在 `~/.docker/config.json` 文件中，存在安全隐患  
1. 所以需要使用 Docker 凭证存储（Credential Helper）  
**Linux 系统（推荐 pass 或 secretservice）**  
安装 `pass`（基于 GPG 加密）  
- Debian/Ubuntu
```bash
sudo apt-get install pass gnupg2 -y
```
- CentOS/RHEL
```bash
sudo yum install pass gnupg2 -y
```

或安装 `docker-credential-secretservice`  
- Debian/Ubuntu
```bash
sudo apt-get install docker-credential-secretservice -y
```
- CentOS/RHEL
```bash
sudo yum install docker-credential-secretservice -y
```

2. 配置 Docker 使用凭证助手
编辑或创建 Docker 配置文件 `~/.docker/config.json`，添加 `"credsStore"` 选项：
```bash
vim ~/.docker/config.json
```
修改为以下内容：
```json
{
  "credsStore": "pass"  # 或 "secretservice"
}
```
然后重新登录 Docker  
退出登陆
```
docker logout <IP:端口/域名>
```
登陆  
```
docker login <IP:端口/域名>
```
验证是否生效  
检查 `~/.docker/config.json`，应该不再有明文密码，而是类似：
<pre>
{
  "auths": {
    "https://index.docker.io/v1/": {}
  },
  "credsStore": "pass"
}
</pre>

拉取镜像：
```bash
docker pull <镜像名:tag/ID>
```
给镜像打标签(在需要推送镜像的时候):
```bash
docker tag <原始镜像名>:<tag> <私有仓库地址>/<新镜像名>:<tag>
```
这里如果使用IP:Port的话别漏了端口  
推送镜像：
```bash
docker push <私有仓库地址>/<新镜像名>:<tag>
```
这里就直接复制已经打上标签的那段内容就可以了如果是latest的话可以默认不填latest
