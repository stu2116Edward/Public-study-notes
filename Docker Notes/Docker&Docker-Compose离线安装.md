# 离线安装Docker&Docker-Compose

前言：基于Ubuntu Jammy 22.04 (LTS)版本安装和测试  
[Docker在线安装官方文档](https://docs.docker.com/engine/install/)

## 使用一键脚本安装Docker&docker-compose
运行以下命令：
```bash
curl -sS -O https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/Docker%20Notes/Docker_Shell/docker_tools.sh && chmod +x docker_tools.sh && ./docker_tools.sh
```
使用Gitee镜像加速
```bash
curl -sS -O https://gitee.com/stu2116Edward/docker-tools/raw/master/docker_tools.sh && chmod +x docker_tools.sh && ./docker_tools.sh
```
注意使用脚本安装成功后输入`docker-compose -v`查看版本信息没有立即生效则需要清理一下父Shell中的缓存：
```bash
hash -r
```
一般情况下使用包管理器安装的docker-compose的版本基本较低如果想要安装更高版本的建议用户手动进行安装，即下载[docker-compose安装包](https://github.com/docker/compose/releases)

## 手动安装Docker
### 步骤一：[离线安装包官网](https://download.docker.com/linux/static/stable/x86_64/)下载 docker 安装包
```
wget https://download.docker.com/linux/static/stable/x86_64/docker-24.0.6.tgz
```
### 步骤二：解压安装包
```
tar -zxvf <对应版本的包名>.tgz
```
示例：
<pre>
tar -zxvf docker-24.0.6.tgz
</pre>
### 步骤三：将解压之后的docker文件移到 /usr/bin目录下
```
sudo cp docker/* /usr/bin/
```
### 步骤四：将docker注册成系统服务
```
sudo vim /etc/systemd/system/docker.service
```
然后在文件中添加以下内容，退出并保存
```
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
```
### 步骤五：给文件增加可执行权限
```
sudo chmod +x /etc/systemd/system/docker.service
```
```
sudo systemctl daemon-reload
```
### 步骤六 ：启动docker
```
systemctl start docker
```
### 步骤七：设置开机自启动
```
systemctl enable docker.service
```
### 步骤八：测试docker是否启动
查看docker运行状态
```
systemctl status docker
```
或尝试运行docker容器
```
docker run hello-world
```


## 卸载Docker
### 步骤一：停止docker
```
sudo systemctl stop docker
```
### 步骤二：删除Docker服务  
移除开机自启动
```
systemctl disable docker.service
```
删除service服务
```
rm -f /etc/systemd/system/docker.service
```
### 步骤三：删除Docker相关命令
```
rm -f /usr/bin/docker*
rm -f /usr/bin/containerd*
rm -f /usr/bin/ctr
rm -f /usr/bin/runc
```
删除docker目录和容器相关文件
```
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```
### 步骤四：验证是否已成功卸载
```
docker --version
```


## 手动安装docker-compose
### 1.下载docker-compose二进制文件：
[docker-compose安装包下载地址](https://github.com/docker/compose/releases)  
将二进制文件复制到目标机器并将二进制文件移动到适当的位置，并确保具有执行权限  
可以将其放在/usr/local/bin/目录下，这样可以全局访问Docker Compose  

验证文件完整性：
```
sha256sum -c docker-compose-linux-x86_64.sha256
```
正常输出：`docker-compose-linux-x86_64: OK`

### 2.将二进制文件移动到/usr/local/bin/目录下：
```
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
```
### 3.赋予执行权限
```
sudo chmod +x /usr/local/bin/docker-compose
```
### 4.配置环境变量:
```bash
echo "export PATH=$PATH:/usr/local/bin" >> ~/.bashrc
```
使环境变量生效：
```bash
source ~/.bashrc
```
或者使用软链接：
```
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
由于系统可能在`/usr/bin`目录下寻找命令，您可以尝试在`/usr/bin`目录下创建一个指向`/usr/local/bin/docker-compose`的软链接  
这样系统就可以找到docker-compose命令了  

### 5.验证安装：
```
docker-compose -v
```

***或者***

### 自定义安装包位置
#### 赋予执行权限：
```
chmod +x docker-compose-linux-x86_64
```
#### 移动到合适的位置：
```
sudo mv docker-compose-linux-x86_64 /usr/local/bin/docker-compose
```

#### 创建软链接:
```
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
由于系统可能在`/usr/bin`目录下寻找命令，您可以尝试在`/usr/bin`目录下创建一个指向`/usr/local/bin/docker-compose`的软链接  
这样系统就可以找到docker-compose命令了  
#### 验证安装：
```
docker-compose --version
```

### 卸载docker-compose：

使用apt install docker-compose方式安装的：
```
apt remove docker-compose
```
使用二进制文件安装的：
直接删除/usr/local/bin/docker-compose文件
```
sudo rm /usr/local/bin/docker-compose
```

