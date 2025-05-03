# ZeroTier内网穿透使用

### 使用命令行部署
**1.安装ZeroTier**
```bash
curl -s https://install.zerotier.com | sudo bash
```
**2.安装完成后,输入以下命令启动服务**：
```bash
zerotier-one -d
```
如果出现以下报错:
<pre>
$ zerotier-one: fatal error: cannot bind to local control interface port 9993
</pre>
表示端口被占用,使用以下命令查看
```bash
netstat -lp | grep 9993
```
解决方法：
```bash
killall -9 zerotier-one
```
然后再次尝试启动 ZeroTier 服务：
```bash
zerotier-one -d
```
**3.加入网络**
```bash
zerotier-cli join <network_id>
```
#### 一些常用命令
获取地址和服务状态：
```bash
zerotier-cli status
```
加入网络
```bash
zerotier-cli join <network_id>
```
离开网络
```bash
zerotier-cli leave <network_id>
```
列出网络
```bash
zerotier-cli listnetworks
```

### 在Docker中部署ZeroTier

***首先需要Docker环境，如果没有请先安装Docker***  

**1.安装ZeroTier**
```bash
docker pull zerotier/zerotier
```

**2.使用命令**
```bash
docker run -d \
  --name zerotier \
  --cap-add=NET_ADMIN \
  --network=host \
  -v /mnt/mmcblk0p7/docker_file/zerotier-one:/var/lib/zerotier-one \
  zerotier/zerotier \
  zerotier-one
```
这个映射目录需要自行创建或修改为自己的`/mnt/mmcblk0p7/docker_file/zerotier-one`  

**3.进入容器内部**
```bash
docker exec -it <容器名/ID> /bin/bash
```

**4.启动zerotier-one**
```bash
zerotier-one -d
```

**5.加入网络**
```bash
zerotier-cli join <network_id>
```

**6.获取地址和服务状态**
```bash
zerotier-cli status
```
如果一切正常，你会看到类似以下的输出：
<pre>
200 info 1234567890abcdef <your_node_id> ONLINE
</pre>

**7.离开网络**
```bash
zerotier-cli leave <network_id>
```

**8. 列出网络**
```bash
zerotier-cli listnetworks
```