# ZeroTier内网穿透使用

### 使用命令行部署ZeroTier
**1.安装ZeroTier**
```bash
curl -s https://install.zerotier.com | sudo bash
```
安装后一般直接加入网络就可以了除非报错  

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
查看服务状态：
```bash
zerotier-cli status
```
如果一切正常，你会看到类似以下的输出：
<pre>
200 info 1234567890abcdef <your_node_id> ONLINE
</pre>

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
查看Zerotier节点：
```bash
zerotier-cli peers
```
或
```bash
zerotier-cli listpeers
```
`<role>`表明机器身份：  
- PLANET 表示 zerotier 官方的中转节点
- MOON 表示自建 zerotier 中转节点
- LEAF 表示组网范围内的其他同级别节点


#### 在Windows中使用
如果要在`Windows`中使用命令行的方式使用Zerotier那么需要使用`管理员模式开启Windows Powershell`然后把命令行前缀改为`zerotier-cli.bat`就可以了如下：  
查看服务状态：
```
zerotier-cli.bat status
```
加入网络
```
zerotier-cli.bat join <network_id>
```
离开网络
```
zerotier-cli.bat leave <network_id>
```
列出网络
```
zerotier-cli.bat listnetworks
```
查看Zerotier节点：
```
zerotier-cli.bat peers
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

**6.获取服务状态**
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



## Zerotier Moon节点搭建
ZeroTier 是商业级的 P2P 组网方案。因其服务器位于境外，中国大陆用户经常遇到延迟较高的问题。为解决这个问题，[从 ZeroTier 1.2.0 版本开始，引入了自建 Moon 节点功能](https://docs.zerotier.com/roots/)，允许用户部署私有中转节点来优化网络性能  

1. 双重路由机制
- 节点同时使用 Planet 和 Moon 服务器
- 自动选择延迟最低的路由
- 当两者都不可用时回退到官方服务器

2. 适用场景
- 优化特定地理位置的网络性能
- 创建离线/内网组网环境（毕竟整个互联网也算是个大局域网）

前置条件：
- 节点需要具有静态 IP（可以是公网 IP 或内网 IP。如果没有公网IP，无法通过路由公网访问）
- 开放 `UDP 9993` 端口（防火墙和安全组都需要放行，可在服务器防火墙和云服务商安全组中放行）

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

验证安装情况：
```bash
zerotier-cli info
```
如果一切正常，你会看到类似以下的输出：
<pre>
200 info 1234567890abcdef <your_node_id> ONLINE
</pre>

**将云服务器加入虚拟网络**(可选非必要)  
执行命令，将云服务器加入到自己创建好的虚拟网络，将命令中的 `xxxxxxxx` 替换成实际的虚拟网络 ID
```bash
sudo zerotier-cli join xxxxxxxx
```
可以进入[Web后台](https://www.zerotier.com/)进行统一管理勾选后`Authorize`授权`Deauthorize`取消授权  

**正式开始**  
### 配置 Moon
进入 zerotier-one 程序所在的目录，默认为 `/var/lib/zerotier-one`
```bash
cd /var/lib/zerotier-one
```
生成 `moon.json` 配置文件
```bash
sudo zerotier-idtool initmoon identity.public >> moon.json
```
编辑 `moon.json` 配置文件
```bash
sudo vim moon.json
```
将配置文件中的 `"stableEndpoints": []` 修改成 `"stableEndpoints": ["ServerIP/9993"]`，将 `ServerIP` 替换成云服务器的公网IP(这里是/不是冒号),这里可能需要`放行防火墙的9993端口`    
```bash
sudo ufw allow 9993/udp
sudo ufw reload
```
或通用配置
```bash
sudo iptables -A INPUT -p udp --dport 9993 -j ACCEPT
```

生成 `.moon` 文件
```
sudo zerotier-idtool genmoon moon.json
```
- 是二进制文件，不可读
- 带有加密签名
- 通常放在 `/var/lib/zerotier-one/moons.d/` 目录下
- moon-id 为(10位或16位标识符)： `000000a62f602019` 或 `a62f602019`

将生成的 `000000xxxxxxxxxx.moon` 移动到 `moons.d` 目录
```bash
sudo mkdir moons.d
```
```bash
sudo mv 000000xxxxxxxxxx.moon moons.d
```
.moon 配置文件的名一般为6个前导零+本机的节点ID  

重启 zerotier-one 服务
```bash
sudo systemctl restart zerotier-one
```

### 使用 Moon
同样地，首先需要`在客户端安装 Zerotier`，然后在在客户端中加入 moon 节点  
普通的 Zerotier 成员使用 Moon 有两种方法，第一种方法是使用 `zerotier-cli orbit` 命令直接添加 Moon 节点ID；第二种方法是在 zerotier-one 程序的根目录创建`moons.d`文件夹，将 `xxx.moon` 复制到该文件夹中，我们采用第一种方法：  

#### Linux 系统下使用 Moon
不同客户端版本 moon-id 不一致，需要检查本机 zerotier 版本（`zerotier-cli -v` 命令可查看版本），如：
- 在 zerotier 1.10.6 版本中， moon-id 是 16 位，前面有多余 0
- 在 zerotier 1.12.2 版本后，moon-id 是 10 位字符串即后面的 xxxxxxxxxx

我这里是1.12.2 版本后的将命令中的`两组 xxxxxxxxxx` 都替换成 `000000xxxxxxxxxx.moon` 的节点ID(或者复制Web后台中的Address中的节点ID)
```bash
sudo zerotier-cli orbit xxxxxxxxxx xxxxxxxxxx
```
orbit 命令会返回 200 状态码表示添加成功。如果 orbit 一直返回 404 状态需要检查上文的版本，多重试几次 orbit  
检查是否添加成功
```bash
sudo zerotier-cli listpeers
```
检查 moons 列表
```bash
zerotier-cli listmoons
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
检查 moons 列表
```bash
zerotier-cli.bat listmoons
```
退出 Moon 节点
```powershell
zerotier-cli.bat deorbit xxxxxxxxxx
```
提示：Windows 系统的默认程序目录位于 `C:\Program Files (x86)\ZeroTier\One`  

常见问题一：电脑添加了虚拟网络，但Zerotier管理列表中始终没有显示这台设备  

可以尝试在Zerotier管理界面中 `Advanced -> Manually Add Member` 中手动添加电脑的节点

`zerotier-cli -h` 帮助，可查看所有指令  

##### 最佳实践
- 建议客户端至少加入两个 Moon 节点
- Moon 节点专注于网络中转功能
  - 避免将多个节点部署在同一物理服务器上
  - 避免将 Moon 服务器同时作为 Moon 和 Leaf 节点
  - 适合将 Moon 部署在就近的数据中心（如国内云服务商）

##### Ref
[Private Root Servers](https://docs.zerotier.com/roots/)  
[MoonID 变更情况，新机器无法加入 moon-id 的方案](https://github.com/zerotier/ZeroTierOne/issues/2197)
