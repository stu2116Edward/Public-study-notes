# fnos设置网络唤醒(WOL)

网络唤醒（WOL）是一项实用技术，它允许你通过网络远程启动计算机。在飞牛OS上设置WOL，你可以方便地从其他设备或远程位置启动你的飞牛NAS，而无需手动按下电源按钮  

### 准备工作
在开始设置之前，请确保你具备以下条件：
1. 硬件支持： 你的飞牛NAS的网卡和主板必须支持WOL功能
2. BIOS 设置： 在BIOS中启用WOL功能。具体操作请参考你的主板说明书，通常在“Power Management”、“Advanced”或类似的菜单中查找“Wake on LAN”、“Wake on PCI”等选项并设置为“Enabled”
3. 操作系统： 已安装fnos
4. 网络连接： 你的飞牛NAS已连接到局域网
5. 工具： 你需要安装 `ethtool` 和 `wakeonlan` 工具
6. SSH 连接： 你需要启用SSH服务并使用SSH客户端连接到你的飞牛NAS

### 操作步骤

1. 启用SSH服务：
- 打开飞牛NAS的控制面板或管理界面
- 找到SSH服务设置选项，并将其启用
- 设置SSH端口（默认为22）和允许连接的用户

2. 连接到飞牛NAS：
- 在你的电脑上安装SSH客户端软件（例如PuTTY、MobaXterm、FinalShell、Termius等）
- 使用SSH客户端连接到你的飞牛NAS，输入IP地址、端口号和用户名

3. 使用sudo提权：
成功连接到飞牛NAS后，输入以下命令切换到root用户或具有sudo权限的用户：
```
sudo -i
​```
或
```
sudo su -
​```
输入你的密码以确认提权

4. 安装工具：
在终端中，输入以下命令安装所需的工具：
```
sudo apt update
sudo apt install ethtool wakeonlan
```

5. 查看网卡信息：

使用以下命令查看你的网卡信息，找到你的网卡接口名称（例如 eth0 或 enp2s0）：
```
ip add
```
这里记录下你NAS插网线的网卡接口的MAC地址


6. 启用WOL：
使用以下命令启用WOL，将 <网卡接口名称> 替换为你的网卡接口名称：
```
sudo ethtool -s <网卡接口名称> wol g
```
- `g` 表示启用 magic packet 唤醒，这是最常用的 WOL 方式

7. 设置开机自启：
为了使 WOL 设置在每次启动时都生效，你需要将以下命令添加到开机启动脚本中。你可以编辑 `/etc/rc.local` 文件（如果存在），或者创建一个 systemd 服务。以下是使用 systemd 服务的示例：  
创建一个服务文件：
```
touch /etc/systemd/system/wol.service
vim /etc/systemd/system/wol.service
```
在文件中添加以下内容，将 <网卡接口名称> 替换为你的网卡接口名称：
```
[Unit]
Description=Wake-on-LAN for <网卡接口名称>
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s <网卡接口名称> wol g

[Install]
WantedBy=multi-user.target
```
保存文件并启用服务：
```
systemctl start wol.service
```
```
systemctl enable wol.service
```
检查WOL是否启动成功（Wake-on: g  ✅ (已开启)）
```
sudo ethtool enp2s0 | grep -i wake-on
```
关闭WOL（❌ Wake-on: d(已关闭)）
```
sudo ethtool -s enp2s0 wol d
```
注：`enp2s0` 为 <网卡接口名称>

8. 唤醒电脑
使用以下命令唤醒你的电脑，将 <MAC 地址> 替换为你的网卡 MAC 地址：
```
wakeonlan <MAC 地址>
```

### 测试WOL
- 关机或进入睡眠模式： 将你的电脑关机或进入睡眠模式
- 发送唤醒信号： 你可以使用其他设备（如手机 App、路由器管理界面等）向你的电脑发送唤醒信号
- 确认唤醒： 如果你的电脑成功启动，则说明 WOL 功能已成功启用


### 注意事项
- 电源设置： 确保你的电脑在关机或睡眠模式下仍然有电源供应给网卡
- 防火墙设置： 确保你的防火墙没有阻止 WOL 所需的网络流量
- 路由器支持： 某些路由器可能需要进行额外的设置才能支持 WOL
