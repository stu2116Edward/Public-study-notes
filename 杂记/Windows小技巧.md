# Windows使用小技巧

### 双网关同时使用内网，外网设置
打开`cmd`,输入以下命令：
```shell
route print
```
主要查看`跃点数`观察是否不一样如果有两个`不一样`的跃点数就代表当前`仅能`使有线或无线  
要想实现即能使用有线也能使用无线就需要把`跃点数改为一样`  
内网:
<pre>
IP：     192.168.0.100
netmask：255.255.255.0
gateway：192.168.0.1
</pre>
外网:
<pre>
IP：     192.168.1.100
netmask：255.255.255.0
gateway：192.168.1.1
</pre>
这里我使用家庭网络进行模拟演示我们都知道可以通过网线(有线)和WIFI(无线)进行连接到我们的互联网但是日常需求中又想同时使用`有线+无线`的形式连接到互联网，这时候就需要设置双网关了，具体操作如下：  
- ① 打开`控制面板`，点击`网络和Internet`选择`网络和共享中心`，点击`更改适配器设置`(如果桌面没有控制面板就`右键`选择`个性化`再选择`主题`再相关设置那一栏找到`桌面图标设置`点击添加控制面板)
- ② 右键点击`以太网`和`WLAN`，选择`属性`，选择`Internet协议版本4(TCP/IPv4)`，点击`属性`
- ③ 在`常规`选项卡中，点击`高级`，选择`IP设置`，取消`自动跃点数`改为手动把`以太网`和`WLAN`改为相同的跃点数，点击`确定`，`确定`，完成配置  

![yds1](https://github.com/user-attachments/assets/6e918314-d489-462d-8110-b48eb85352b9)  
![yds2](https://github.com/user-attachments/assets/a89bf038-6b64-4f27-bd04-c17d4d09dc3e)  


### 配置本地域名解析
它的作用是将域名映射到 IP 地址，以便计算机可以直接通过域名访问网络设备，而无需查询 DNS 服务器  
以管理员方式打开`cmd`  
输入以下命令：
```shell
notepad C:\Windows\System32\drivers\etc\hosts
```

### 常用配置命令
`msconfig`是一个能够修改调节系统启动方式、状态、后台服务等的程序
```
msconfig
```
`gpedit.msc`叫组策略，它的作用是用户可以通过它对计算机的安全、功能等设置用户自定义的策略
```
gpedit.msc
```
`regedit`是注册表，你机器上安装的所有软件、驱动、组件和系统本身的东西都注册在里面（通俗的讲，就是都到那儿报了个到，并挂名注册）
```
regedit
```

### 图标显示不正常？试试强制刷新 Windows 图标缓存
**方法一 删除 IconCache.db 文件**  
进入 `C:\Users\用户名\appdata\local` 目录，直接删除 `IconCache.db` 文件，重启电脑  
需要注意的是，这一步中 appdata 文件夹和 IconCache.db 文件都是隐藏的系统文件，需要手动输入地址或者显示隐藏文件  
IconCache.db 文件本质上是一个图标属性文件，在删除后系统会自动重建一个，由它导致的问题会被系统自动修复  
这个方法简单快捷，适用于大部分情况  

**方法二 Windows 自带的磁盘清理工具**  
有时候 `IconCache.db` 文件会被其他软件占用，那就试试 Windows 官方提供的清理工具  
打开开始菜单，找到 `Windows 管理工具` → `磁盘清理` → `C 盘` → `勾选「缩略图」`→ `确定`。即可将图标缓存文件顺利删除  
最后重启电脑即可看到图标刷新的效果  

**方法三 批处理清除图标缓存数据库**  
如果上面两个方法都无法解决问题，那就试试更暴力的批处理吧  
这段批处理文件会删除 IconCache.db 文件，同时还清理 thumbcache.db 文件和注册表中的 IconStreams、PastIconsStream 两个值。清理速度很快，除了会重启一下资源管理器外没有副作用  
打开记事本，将下面这段代码复制到记事本中，保存为 图标缓存清理.bat 文件，双击打开即可  
```bat
rem 关闭Windows外壳程序explorer
 
taskkill /f /im explorer.exe
 
rem 清理系统图标缓存数据库
 
attrib -h -s -r "%userprofile%\AppData\Local\IconCache.db"
 
del /f "%userprofile%\AppData\Local\IconCache.db"
 
attrib /s /d -h -s -r "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\*"
 
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_32.db"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_96.db"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_102.db"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_256.db"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_1024.db"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_idx.db"
del /f "%userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_sr.db"
 
rem 清理 系统托盘记忆的图标
 
echo y|reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v IconStreams
echo y|reg delete "HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v PastIconsStream
 
rem 重启Windows外壳程序explorer
 
start explorer
```
如果上面这三种方法还是没能解决图标问题，说明问题已经超出了「图标缓存」的范畴，需要考虑其他方面的影响（比如软件安装错误、软件图标丢失等）
