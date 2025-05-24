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
这个可能有问题
```bash
killall -9 zerotier-one
```
一般先尝试关闭：
```
sudo systemctl stop zerotier-one
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
或
```bash
zerotier-cli info
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

**查看节点服务器**
```
zerotier-cli peers
```

如果要在Windows中使用命令行的方式使用Zerotier那么需要使用`管理员模式开启Windows Powershell`然后把命令行前缀改为`zerotier-cli.bat`就可以了  
例如：
```
zerotier-cli.bat join <network_id>
zerotier-cli.bat status
zerotier-cli.bat listnetworks
zerotier-cli.bat peers
```


## Zerotier Moon节点搭建

### 安装 zerotier-one  
方法一 更简单
```bash
curl -s https://install.zerotier.com | sudo bash
```
方法二 更安全
```bash
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
```

### 将云服务器加入虚拟网络
执行命令，将云服务器加入到自己创建好的虚拟网络，将命令中的 `xxxxxxxx` 替换成实际的虚拟网络 ID
```bash
sudo zerotier-cli join xxxxxxxx
```
可以进入[Web后台](https://www.zerotier.com/)进行统一管理勾选后`Authorize`授权`Deauthorize`取消授权  

### 配置 Moon
进入 zerotier-one 程序所在的目录，默认为 `/var/lib/zerotier-one`
```bash
cd /var/lib/zerotier-one
```
生成 moon.json 配置文件
```bash
sudo zerotier-idtool initmoon identity.public >> moon.json
```
编辑 moon.json 配置文件
```bash
sudo vim moon.json
```
将配置文件中的 `"stableEndpoints": []` 修改成 `"stableEndpoints": ["ServerIP/9993"]`，将 `ServerIP` 替换成云服务器的公网IP(这里是/不是冒号),这里可能需要`放行防火墙的9993端口`    
```bash
sudo ufw allow 9993/udp
sudo ufw allow 9993/tcp
sudo ufw reload
```
或通用配置
```bash
sudo iptables -A INPUT -p udp --dport 9993 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9993 -j ACCEPT
```

生成 .moon 文件
```
sudo zerotier-idtool genmoon moon.json
```
将生成的 `000000xxxxxxxxxx.moon` 移动到 `moons.d` 目录
```bash
sudo mkdir moons.d
sudo mv 000000xxxxxxxxxx.moon moons.d
```
.moon 配置文件的名一般为6个前导零+本机的节点ID  

重启 zerotier-one 服务
```bash
sudo systemctl restart zerotier-one
```

### 使用 Moon
普通的 Zerotier 成员使用 Moon 有两种方法，第一种方法是使用 `zerotier-cli orbit` 命令直接添加 Moon 节点ID；第二种方法是在 zerotier-one 程序的根目录创建`moons.d`文件夹，将 `xxx.moon` 复制到该文件夹中，我们采用第一种方法：  

#### Linux 系统下使用 Moon
将命令中的`两组 xxxxxxxxxx` 都替换成 `000000xxxxxxxxxx.moon` 的节点ID(或者复制Web后台中的Address中的节点ID)
```bash
sudo zerotier-cli orbit xxxxxxxxxx xxxxxxxxxx
```
检查是否添加成功
```bash
sudo zerotier-cli listpeers
```
退出 Moon 节点
```bash
sudo zerotier-cli deorbit xxxxxxxxxx
```

#### Windows 系统下使用 Moon
以`管理员身份`打开 PowerShell，将命令中的两组 `xxxxxxxxxx` 都替换成 moon 的节点ID  
```powershell
zerotier-cli.bat orbit xxxxxxxxxx xxxxxxxxxx
```
检查是否添加成功
```powershell
zerotier-cli.bat listpeers
```
退出 Moon 节点
```powershell
zerotier-cli.bat deorbit xxxxxxxxxx
```
提示：Windows 系统的默认程序目录位于 `C:\Program Files (x86)\ZeroTier\One`  

常见问题一：电脑添加了虚拟网络，但Zerotier管理列表中始终没有显示这台设备  

可以尝试在Zerotier管理界面中 `Advanced -> Manually Add Member` 中手动添加电脑的节点
