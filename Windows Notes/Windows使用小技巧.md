# Windows使用小技巧

### 装机必下工具
[图吧工具箱](https://www.tbtool.cn/)  
[DISM++](https://github.com/Chuyu-Team/Dism-Multi-language)  
[HiBitUninstaller](https://github.com/stu2116Edward/Public-study-notes/blob/main/tools/HiBitUninstaller_3.2.40_Single.zip)  
[dnGrep](https://github.com/dnGrep/dnGrep)  


### 常用的Windows命令
[点击跳转](https://github.com/stu2116Edward/Public-study-notes/blob/main/Windows%20Notes/Windows%E5%B8%B8%E7%94%A8%E9%85%8D%E7%BD%AE%E5%91%BD%E4%BB%A4.md)  


### 禁用Windows自动更新
使用Dism++的系统优化功能中的`Windows Update`实现：  
![gbzdgx1](https://github.com/user-attachments/assets/5ad8407f-0887-4ec6-aa56-291f898bc93f)  
接下来是可选配置（非必要）：  
![gbzdgx2](https://github.com/user-attachments/assets/0a8d4501-54d3-41d2-a1c5-f6a633cdd576)  
![gbzdgx3](https://github.com/user-attachments/assets/89c1c3e6-9467-4026-9019-9515798596b8)  

编辑注册表的方式实现：  
1. 按**Win+R**快捷键后输入`regedit`启动注册表编辑器  
2. 从左侧依序打开相关路径  
```
计算机\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings
```
在右侧空白位置按下鼠标右键新建数值  
3. 点选右键后选择「新建」、「DWORD(32-位)值」,输入数值名称：  
```
FlightSettingsMaxPauseDays
```
4. 接着再双击打开刚才加入的数值，将数值数据修改为`36500`,再选择「十进制」后确定  
5. 开启设置中「Windows Update」后会显示目前系统更新状态，从下方找到高级选项  
6. 在暂停更新的日期中往下卷动，最下方找到最长期限「2632年9月16日」  
7. 选好后就能将Windows更新暂停、延长100年  


### 如何重启资源管理器？
Win11:  
![Win11zyglq](https://github.com/user-attachments/assets/aae73fa3-777d-4457-ad7d-e57242189099)  
Win10:  
![Win10zyglq](https://github.com/user-attachments/assets/c0a9f63d-1d3a-4e03-8991-ec38349d2791)  
选中“Windows资源管理器”进程，点击右下角的“重新启动”即可重启Windows资源管理器  
或者 Win+R 输入 `explorer.exe`  


### 修改win11右键菜单、右键选项、还原win10右键菜单
- 不改设置，非永久  
每次按下`shift+右键`，既可直接打开折叠菜单啦~  
- 命令一键修改
确保以`管理员身份运行cmd`，防止权限问题  
1. `Win+R`打开运行  
2. 输入`cmd`，按下`Ctrl+Shift+Enter`以管理员身份运行  
3. 在命令行里输入  
```
reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
```
4. 重启（重启电脑或文件资源管理器（File Explorer））  
重启后即可使用win10风格右键菜单  
![w10yj](https://github.com/user-attachments/assets/61aaa6bc-e192-4ace-8952-3ac3fb567764)  

6. 恢复方法  
如果想回到win11风格，在命令行输入：
```
reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /va /f
```
重启后恢复win11右键  
![w11yj](https://github.com/user-attachments/assets/fb452926-5211-43be-90f5-9135059af2db)  

你可以创建一个批处理文件，方便快速切换右键菜单风格：
```bat
@echo off
setlocal

echo 1. 切换到Windows 10风格右键菜单
echo 2. 恢复到Windows 11风格右键菜单
echo 3. 退出
echo.
set /p choice="请选择一个选项: "

if "%choice%"=="1" (
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
    echo 已切换到Windows 10风格右键菜单，请重启资源管理器或电脑。
)

if "%choice%"=="2" (
    reg.exe delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /va /f
    echo 已恢复到Windows 11风格右键菜单，请重启资源管理器或电脑。
)

if "%choice%"=="3" (
    exit
)

endlocal
```
将上述内容保存为`.bat`文件，然后以`管理员身份`运行它，即可快速切换右键菜单风格  


### 关闭UAC弹窗警告
如UAC未彻底关闭，对系统进行更改或者下载软件时，电脑总是询问，是否允许，如下面的界面：  
![uac1](https://github.com/user-attachments/assets/95f3d33b-5923-4b71-872c-94e293c38057)  
Win+R输入`msconfig`打开系统配置-工具-选中更改UAC设置-点击启动-并修改为从不通知-点击确定  
![uac2](https://github.com/user-attachments/assets/d82e50fe-459a-4485-8385-568be8842a70)  
![uac3](https://github.com/user-attachments/assets/a92fc4b0-a130-4b45-8dc8-f5987a1e1f1b)  
之后就不会有这样的弹窗了  


### 关闭打开此文件前总是询问的弹窗警告
弹窗界面如下：  
![fjqyxx1](https://github.com/user-attachments/assets/19c46a03-8cde-4153-acc5-ae5318542533)  
附件区域信息  
![fjqyxx2](https://github.com/user-attachments/assets/838b9447-6acb-4539-9850-2532d89adf8b)  
这里需要打开Dism++进行系统优化配置配置内容如下：  
![fjqyxx3](https://github.com/user-attachments/assets/4272095e-00c2-429c-af60-5e79790ff5b5)
此方式只适用于之后这样类似的文件比如从网上下载的内容等  
如果之前的文件每次打开都这样一个一个取消太麻烦可以选择先将这些有弹窗警告的文件复制到虚拟机里面然后再粘贴回去这样即可全部恢复取消弹窗  
不过微软好像也有类似的工具：  
https://learn.microsoft.com/en-us/sysinternals/downloads/streams  


### Windows笔记本电池正确配置
**控制面板-硬件和声音-电源选项-选择电源按钮的功能**  
![battery](https://github.com/user-attachments/assets/51297506-a8bf-4d3c-82ff-4e001939f1c1)  


### 配置本地域名解析
它的作用是将域名映射到 IP 地址，以便计算机可以直接通过域名访问网络设备，而无需查询 DNS 服务器  
以管理员方式打开`cmd`  
输入以下命令：
```shell
notepad C:\Windows\System32\drivers\etc\hosts
```


### Win10/11 更改电脑用户名
**方法一**  
1. 在电脑桌面选中**此电脑**并右击选择**管理**  
![gl1](https://github.com/user-attachments/assets/2d687780-1c64-44c6-bb97-f6a09b9e3000)  
2. 进入**到计算机管理**页面后选择**本地用户和组**，双击**用户**打开  
![gl2](https://github.com/user-attachments/assets/b9dbbee1-9704-4850-bfbc-d4e2db39cfec)  
3. 选中和桌面用户名一致的选项，右击选择**重命名**  
![gl3](https://github.com/user-attachments/assets/065f419d-a453-4e6e-856c-19f2438517ce)  

**方法二**  
1. 打开**控制面板**，点击**用户帐户**进入  
![kzmb1](https://github.com/user-attachments/assets/841e1250-c31d-4000-b9df-df0ed117199d)  
2. 接着点击**用户帐户**  
![kzmb2](https://github.com/user-attachments/assets/84645ec6-1bff-41c2-83c7-e3ba841b905c)  
3. 在下图所示的界面中点击**更改帐户名称**  
![kzmb3](https://github.com/user-attachments/assets/b9c36b0a-7c9b-46a8-a354-4aa2efc35916)  
4. 在跳转的页面中输入**新帐户名**，点击**更改名称**即可  
![kzmb4](https://github.com/user-attachments/assets/7b8eb375-243c-4474-bca0-441b52f2a249)  


### 图标显示不正常？试试强制刷新 Windows 图标缓存
最方便的是使用下面这个项目解决：  
https://github.com/iKineticate/AHK-ChangeIcon    

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

### 此电脑流氓网盘图标管理
使用此工具：  
https://github.com/1357310795/MyComputerManager  
删除或者禁用对应的图标


### 关于右键菜单管理
推荐一个右键菜单管理工具  
Github仓库：ContextMenuManager  
下载地址：https://github.com/BluePointLilac/ContextMenuManager/releases  
打开注册表 `Win + R` 输入 `regedit`  
管理右键文件打开方式(图标缓存清理的问题)  
```
计算机\HKEY_USERS\S-1-5-21-538346675-2617965756-301681954-1001\Software\Classes\Applications
```
针对桌面右键菜单：
```
计算机\HKEY_CLASSES_ROOT\Directory\Background\shell
```
```
计算机\HKEY_CLASSES_ROOT\Directory\Background\Background
```
```
计算机\HKEY_CLASSES_ROOT\Directory\Background\shellex
```
文件：
```
计算机\HKEY_CLASSES_ROOT\*\shell
```
文件夹：
```
计算机\HKEY_CLASSES_ROOT\Directory\shell
```
文件和文件夹：
```
计算机\HKEY_CLASSES_ROOT\AllFilesystemObjects\shell
```
文件夹空白处：
```
计算机\HKEY_CLASSES_ROOT\Directory\Background\shell
```


### Windows家庭版无法使用mstsc解决方法
打开`控制面板`，选择【`程序和功能`】选择【`启动或关闭Windows功能`】在弹出框里勾选【`Telent客户端`】功能  
![mstsc1](https://github.com/user-attachments/assets/19edd353-32d7-41db-a575-ea519241fad0)  
![mstsc2](https://github.com/user-attachments/assets/1d5b0661-5892-4c18-969e-77966e7a9069)  
![mstsc3](https://github.com/user-attachments/assets/7c46fe76-1ac3-4ddc-bd62-ee160c3d2155)  
点击确定，如有必要则选择重启  
重启后 `win + R` 键，输入 `mstsc`，输入对应链接地址即可远程连接服务器  


### 本地组策略编辑器(gpedit.msc)打不开解决方案
这是解决了问题后的截图  
![gpeditmsc1](https://github.com/user-attachments/assets/356719a7-8464-4e5e-a40b-6794ac3ce336)  

新建一个txt文件粘贴如下内容：
```
@echo off

pushd "%~dp0"

dir /b C:\Windows\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >List.txt

dir /b C:\Windows\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>List.txt

for /f %%i in ('findstr /i . List.txt 2^>nul') do dism /online /norestart /add-package:"C:\Windows\servicing\Packages\%%i"

pause
```
接下来选择文件另存为，文件类型选择所有文件，名称随意，`扩展名修改为“.cmd”`把它保存下来  
右键以管理员身份运行这个文件，命令行里面有如下内容：  
<pre>

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientExtensions-Package~31bf3856ad364e35~amd64~en-US~10.0.22000.1
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientExtensions-Package~31bf3856ad364e35~amd64~zh-CN~10.0.22000.1
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientExtensions-Package~31bf3856ad364e35~amd64~~10.0.22000.1
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientExtensions-Package~31bf3856ad364e35~amd64~~10.0.22000.653
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientTools-Package~31bf3856ad364e35~amd64~en-US~10.0.22000.593
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientTools-Package~31bf3856ad364e35~amd64~en-US~10.0.22000.653
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientTools-Package~31bf3856ad364e35~amd64~zh-CN~10.0.22000.593
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientTools-Package~31bf3856ad364e35~amd64~zh-CN~10.0.22000.653
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientTools-Package~31bf3856ad364e35~amd64~~10.0.22000.593
[==========================100.0%==========================]
操作成功完成。

部署映像服务和管理工具
版本: 10.0.22000.653

映像版本: 10.0.22000.675

正在处理 1 (共 1) - 正在添加程序包 Microsoft-Windows-GroupPolicy-ClientTools-Package~31bf3856ad364e35~amd64~~10.0.22000.653
[==========================100.0%==========================]
操作成功完成。
请按任意键继续. . .
</pre>
`win+r`，输入`gpedit.msc`，回车  
![gpeditmsc2](https://github.com/user-attachments/assets/942ac72f-b934-4b2d-aff8-e9cad186c1b1)  
就有熟悉的本地组策略编辑器了  
![gpeditmsc3](https://github.com/user-attachments/assets/c4b5787a-b9bb-424a-8f2a-a8ddc760095b)  


### 家庭版本开启Hyper-v虚拟机
测试是否支持虚拟化在任务管理器中的性能处查看  
一般只要安装了VMware并且能够正常使用就是支持虚拟化的  
![xnh](https://github.com/user-attachments/assets/53b0fc26-e0f6-480d-8e3a-b40821657bd2)  

安装脚本及步骤  
1、IBOS开启虚拟化  

2、安装脚本cmd或bat后缀    
```
pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
del hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V-All /LimitAccess /ALL
```
安装大约需要五至六分钟，如果中间卡主，可以回车试试。最后下载完毕，输入y确认安装  
![hv1](https://github.com/user-attachments/assets/f31db33a-6cde-4be2-a4c0-de144889654e)  

与VM冲突  
`VMware Workstation 与 Hyper-V 不兼容。请先从系统中移除 Hyper-V 角色,然后再运行VMware Wokstation`  

解决问题，重新使用VMware  
关闭windwos Hyper-v功能  
1、键盘windows，打开开始菜单  
2、开始菜单，打开控制面板  
3、控制面板，类别显示，卸载程序  
4、左侧：启用或关闭windows功能  
5、关闭Hyper-v功能  
![hv2](https://github.com/user-attachments/assets/64fb99ef-6220-4d4e-970d-cb6ebffe9aa2)  

使用命令  
关闭Hyper-v服务
```
bcdedit /set hypervisorlaunchtype off
```
创建脚本，管理员模式启动，关闭hyper-v服务。当然也可以通过页面系统，手动关闭服务，重启，成功打开VM  
开启Hyper-v服务  
```
bcdedit /set hypervisorlaunchtype auto
```


### Windows垃圾清理
**这里只推荐使用前两个**  
1. 系统自带清理
**Win11: 使用Win+I 系统-存储-临时文件删除里面的内容即可**  
**操作步骤「右键C盘」→「属性」→「磁盘清理」**  
勾选：  
- 已下载的程序文件
- Internet临时文件
- 回收站
然后点击清理系统文件  
勾选Windows更新清理  
点击确定  
2. 系统进程创建的临时文件
**操作步骤 Win+R 输入 %temp% 回车 shift+Delete删除里面的所有文件**
3. 清理系统升级过后的垃圾（注意在系统提示更新时不要删除）
**进入这个目录 C:\Windows\SoftwareDistribution\Download 删除里面的所有文件**
4. 清理系统的预读取文件
**进入这个目录 C:\Windows\Prefetch 删除里面的所有文件**
5. 刷新dns缓存
使用命令：
```
ipconfig /flushdns
```
6. 使用第三方的工具清理（使用其默认的清理）
- DISM++工具下载地址：  
https://github.com/Chuyu-Team/Dism-Multi-language  
- HiBitUninstaller工具下载地址：  
https://www.ghxi.com/hibituninstaller.html  

**最后清理完成之后不要忘记重启电脑**
>[!Note]
注册表最好不要乱修改
系统的虚拟内存默认就行了


### Windows系统修复
使用cmd的管理员输入下面的命令帮助解决系统启动失败、功能异常等问题：
```
sfc /scannow
```
扫描当前系统映像的健康状况，检查是否存在可能的损坏或问题
```
DISM /Online /Cleanup-Image /ScanHealth
```
检查当前系统映像的损坏程度，确定映像是否可以修复
```
DISM /Online /Cleanup-Image /CheckHealth
```
修复系统映像中的损坏
```
DISM /Online /Cleanup-Image /RestoreHealth
```


### 修改Windows的网络名称
`打开注册表`：  
**Win+R**  
输入gpedit.msc  
找到以下路径  
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WidowsNT\CurrentVersion\NetworkList\Profiles
```
修改文件夹内的`ProfileName`  
或者使用第三方工具实现修改：[Network Profile Name Changer](https://github.com/stu2116Edward/Public-study-notes/blob/main/tools/%E7%BD%91%E7%BB%9C%E9%87%8D%E5%91%BD%E5%90%8D%E5%B7%A5%E5%85%B7/Network%20Profile%20Name%20Changer.zip)


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


### Windows中wget的安装与使用
去[wget官网](https://eternallybored.org/misc/wget/)下载二进制文件：  
***注意：要根据你的电脑选择32位还是64位***  
然后你会得到一个.zip格式的文件夹  
解压，解压到哪里都行(最好不要有中文的目录)  
然后配置`Path`环境变量`E:\software\wget-1.21.3-win64`  
wget的使用：  
```
wget 下载地址
```
指定目录：
```
wget -P 目录地址 下载地址
```
***注意：目录地址中不能有中文、空格，不然无法解析***  
更详细的使用教程请参考[Linux命令之wget](https://blog.csdn.net/liaowenxiong/article/details/117337527)

### 组策略配置
打开组策略编辑器：
```
gpedit.msc
```
更新组策略的命令:
```
gpupdate /force
```

### Windows安装配置curl
curl是一种命令行工具，作用是发出网络请求，然后得到和提取数据，显示在"标准输出"（stdout）上面  
curl 安装及配置  
官网下载地址：[curl官网](https://curl.se/download.html#Win64)  
windows系统版本下拉到最下方，我选择的是标红色方框的版本，如下图：  
![win_curl1](https://github.com/user-attachments/assets/29e83713-5c85-4c05-bbdb-2e407601f02d)  
直接点击链接，进入下一个页面，如下图：  
![win_curl2](https://github.com/user-attachments/assets/5cf52c8a-e4f7-4b9d-a806-c8463516528d)  
我这里下载的第一个文件并解压  
![win_curl3](https://github.com/user-attachments/assets/b2e2d644-e855-4d12-97e6-bb7f8fc6b227)  
配置环境变量添加个变量名为`CURL_HOME`，指定到刚解压的文件，`E:\curl`，确定  
![win_curl4](https://github.com/user-attachments/assets/50c8619c-95e7-465d-ac08-2d87d03933f8)  
这里还需在`Path`中添加如下内容：
```
%CURL_HOME%\bin\
```
测试是否安装成功  
```bash
curl  -V
```
我们就可以看到，curl 的版本，说明安装成功  
![win_curl5](https://github.com/user-attachments/assets/3f299a23-e1cb-4b8a-8083-9020427ab97a)  


### Windows优化使用体验
#### Win11任务栏设置居左
在Win10以下的版本都是使用的左面任务栏，但是Win11 将开始菜单和图标搬到了任务栏中间，使用的时候多少有些不习惯，如果你也不喜欢开始菜单的位置，可以右键任务栏打开任务栏设置：  
![Win11rwl1](https://github.com/user-attachments/assets/76346963-f1e8-4193-aa98-bcef1f9e5eb5)  
找到`任务栏行为`，将任务栏对其方式修改为`靠左`  
![Win11rwl2](https://github.com/user-attachments/assets/fec7c4af-d0e4-42f0-8a4a-898b25cb2446)  
在同样的位置还可以设置「自动隐藏任务栏」，下方的「选择任务栏的远角以显示桌面」开启该功能后鼠标点击任务栏右侧可以隐藏全部窗口  

#### 隐藏任务栏多余图标
Win11可能会有四个图标，搜索、任务视图、小组件、聊天。如果你不需要这些功能，直接右键任务栏打开任务栏设置，隐藏那些不需要的功能即可  
![Win11rwl3](https://github.com/user-attachments/assets/aa8a7108-c90a-4123-bc1c-743ff8b1680f)  

#### 开启剪贴板历史记录
开启该功能后系统会将你复制过的文字、图片保存在剪贴板历史记录中，这样不会被新的复制内容覆盖掉  
你可以直接按 `Win+V` 打开剪贴板历史记录面板，然后点击启用该功能：  
![Winjqb1](https://github.com/user-attachments/assets/5301aca1-2971-4b30-9e06-4a658c8e067c)  
点击记录右侧的图钉，可以将该记录固定，被固定的记录不会被清除，即便电脑重启也还在  
![Winjqb2](https://github.com/user-attachments/assets/a58bc740-4f98-4fcd-ba1c-bf082a965fe1)  

#### 总弹出在Microsoft Store查找应用的窗口
解决方法：  
1. 在键盘上按下`Win+R`打开运行，输入`regedit`，打开`注册表`  
2. 在注册表中找到以下路径：
```
HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Explorer
```
如果没有`Explorer`项需要自行创建一个  
3. 在右侧右键选择`新建DWORD(32位)值`，取名为`NoUseStoreOpenWith`，并输入数值为`1`（十六进制H）  
![MStcclose](https://github.com/user-attachments/assets/3fbcdea8-6c7b-41ef-aad9-ddc9d8c4a1d2)  
4. 重启系统或者重启资源管理器  


#### Windows Search卡顿解决办法
可以通过修改注册表，来禁用 Windows 搜索的 Bing 网络搜索功能  

1. 开启系统注册表,`Win+R`呼出运行键入`regedit`  
2. 通过地址栏进入到以下路径：
```
计算机\HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\
```
3. 接着，对准 Windows 的文件夹点击右键呼出快捷菜单，选择 `新建项`，然后，将新建的项命名为 `Explorer`(如果有直接跳过)  
4. 右键点击 Explorer，选择 `新建DWORD(32位)值`,并将它命名为 `DisableSearchBoxSuggestions`  
5. 然后，修改这个键值的内容，**设置为 `1`** （十六进制H）即是禁用 Windows 的网络搜索，设置为 `0` 则是开启 Windows 网络搜索特性  
![winsssz3](https://github.com/user-attachments/assets/903d60a8-9771-4502-85f3-3fe83efd17b6)  
6. 重启系统或者重启资源管理器，从此以后用只会搜出本地结果，不会让 Bing 来降低效率，占用资源了  

此外，在搜索设置中还可进行如下设置，进一步提高搜索响应速度，提高效率  
![winsssz1](https://github.com/user-attachments/assets/90c35549-b4f1-458c-8e0e-781167f932e7)  
![winsssz2](https://github.com/user-attachments/assets/df780233-7734-494b-88df-21de10086a02)  
