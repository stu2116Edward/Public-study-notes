# Windows CMD 命令速查表

## 一、网络相关

| 用途 | 命令 |
|------|------|
| 测试网络连通性 | `ping 域名或IP` |
| 持续ping | `ping -t 域名或IP` |
| 查看端口是否被占用 | `netstat -ano \| findstr :端口号` |
| 查看本机IP配置 | `ipconfig` |
| 查看所有网卡详细信息 | `ipconfig /all` |
| 清除DNS缓存 | `ipconfig /flushdns` |
| 刷新IP地址 | `ipconfig /renew` |
| 释放IP地址 | `ipconfig /release` |
| 追踪路由 | `tracert 域名或IP` |
| 查看所有监听端口 | `netstat -an` |
| 查看指定进程的端口 | `netstat -ano \| findstr 进程PID` |
| 查看路由表 | `route print` |
| 查看ARP缓存 | `arp -a` |
| 清除ARP缓存 | `arp -d` |
| 添加静态ARP | `arp -s IP MAC地址` |
| 解析域名 | `nslookup 域名` |
| 反向解析 | `nslookup IP地址` |
| 查看域名记录 | `nslookup -type=记录类型 域名` |
| 查看网络连接统计 | `netstat -e` |
| 查看所有连接和监听 | `netstat -a` |
| 显示进程ID | `netstat -o` |
| 显示路由跟踪 | `pathping 域名或IP` |
| 远程登录测试 | `telnet 域名或IP 端口` |
| 重置Winsock | `netsh winsock reset` |
| 重置TCP/IP栈 | `netsh int ip reset` |
| 查看无线配置文件 | `netsh wlan show profiles` |
| 查看无线密码 | `netsh wlan show profile name=配置名 key=clear` |
| 查看网络共享 | `net share` |
| 创建网络共享 | `net share 共享名=路径` |
| 删除网络共享 | `net share 共享名 /delete` |
| 映射网络驱动器 | `net use Z: \\服务器\共享` |
| 删除网络映射 | `net use Z: /delete` |
| 查看相邻计算机 | `net view` |
| 查看DNS缓存 | `ipconfig /displaydns` |
| 注册DNS | `ipconfig /registerdns` |
| 指定次数ping | `ping -n 次数 域名或IP` |
| 指定大小ping | `ping -l 字节数 域名或IP` |
| 跳过DNS解析追踪 | `tracert -d 域名或IP` |
| 查看网络配置详情 | `netsh interface ip show config` |

## 二、进程管理

| 用途 | 命令 |
|------|------|
| 查看所有进程 | `tasklist` |
| 根据PID结束进程 | `taskkill /PID 进程PID /F` |
| 根据名称结束进程 | `taskkill /IM 进程名.exe /F` |
| 查看特定进程 | `tasklist \| findstr 进程名` |
| 启动进程 | `start 程序名.exe` |
| 查看服务列表 | `sc query` |
| 启动服务 | `net start 服务名` |
| 停止服务 | `net stop 服务名` |
| 查看进程详细信息 | `tasklist /v` |
| 查看进程对应的服务 | `tasklist /svc` |
| 以低优先级启动 | `start /low 程序名.exe` |
| 以高优先级启动 | `start /high 程序名.exe` |
| 等待程序退出 | `start /wait 程序名.exe` |
| 查看服务详细信息 | `sc query 服务名` |
| 配置服务自动启动 | `sc config 服务名 start= auto` |
| 配置服务手动启动 | `sc config 服务名 start= demand` |
| 禁用服务 | `sc config 服务名 start= disabled` |
| 创建服务 | `sc create 服务名 binPath= 程序路径` |
| 删除服务 | `sc delete 服务名` |
| 查看进程树 | `wmic process get processid,parentprocessid` |
| 查看进程命令行 | `wmic process get processid,commandline` |

## 三、文件与目录

| 用途 | 命令 |
|------|------|
| 列出当前目录文件 | `dir` |
| 切换目录 | `cd 目录路径` |
| 返回上级目录 | `cd ..` |
| 删除文件 | `del 文件名` |
| 删除空目录 | `rmdir 目录名` |
| 强制删除目录及文件 | `rmdir /s /q 目录名` |
| 创建目录 | `mkdir 目录名` |
| 复制文件 | `copy 源文件 目标路径` |
| 移动文件 | `move 源文件 目标路径` |
| 重命名 | `ren 原文件名 新文件名` |
| 查看文件内容 | `type 文件名` |
| 查找文件中的文本 | `find "文本" 文件名` |
| 查找字符串 | `findstr "文本" 文件名` |
| 递归查找 | `findstr /s "文本" *.txt` |
| 列出包括隐藏文件 | `dir /a` |
| 分页显示目录 | `dir /p` |
| 递归列出子目录 | `dir /s` |
| 只显示文件名 | `dir /b` |
| 按名称排序 | `dir /on` |
| 按时间排序 | `dir /od` |
| 按大小排序 | `dir /os` |
| 返回根目录 | `cd \` |
| 显示当前目录 | `cd` |
| 创建多级目录 | `mkdir 目录1\目录2\目录3` |
| 强制删除文件 | `del /f 文件名` |
| 静默删除（不提示） | `del /q 文件名` |
| 复制并重命名 | `copy 源文件 目标路径\新文件名` |
| 合并文件 | `copy 文件1+文件2 目标文件` |
| 复制目录 | `xcopy 源目录 目标目录 /e` |
| 复制目录及属性 | `xcopy 源目录 目标目录 /e /k` |
| 只复制新文件 | `xcopy 源目录 目标目录 /d` |
| 批量重命名 | `ren *.txt *.bak` |
| 分页查看文件 | `more 文件名` |
| 创建空文件 | `type nul > 文件名` |
| 创建带内容文件 | `echo 内容 > 文件名` |
| 比较文件 | `fc 文件1 文件2` |
| 比较二进制文件 | `fc /b 文件1 文件2` |
| 不区分大小写查找 | `find /i "文本" 文件名` |
| 统计行数 | `find /c "文本" 文件名` |
| 使用正则查找 | `findstr /r "正则" 文件名` |
| 显示文件属性 | `attrib 文件名` |
| 设置只读属性 | `attrib +r 文件名` |
| 去除只读属性 | `attrib -r 文件名` |
| 设置隐藏属性 | `attrib +h 文件名` |
| 显示文件扩展名 | `assoc` |
| 修改文件关联 | `assoc .txt=txtfile` |
| 显示命令路径 | `where 命令名` |
| 递归查找文件 | `where /r C:\ 文件名` |

## 四、高级文件操作

| 用途 | 命令 |
|------|------|
| 创建符号链接（文件） | `mklink 链接名 目标文件` |
| 创建目录符号链接 | `mklink /D 链接名 目标目录` |
| 创建硬链接 | `mklink /H 链接名 目标文件` |
| 创建目录链接（类似快捷方式） | `mklink /J 链接名 目标目录` |
| 显示目录树结构 | `tree` |
| 显示目录树及文件 | `tree /F` |
| 显示所有层级 | `tree /A` |
| 高级复制（镜像/多线程） | `robocopy 源目录 目标目录` |
| 镜像复制（删除目标多余文件） | `robocopy 源目录 目标目录 /MIR` |
| 只复制新文件/修改过的 | `robocopy 源目录 目标目录 /XO` |
| 复制子目录（包括空目录） | `robocopy 源目录 目标目录 /E` |
| 多线程复制（速度更快） | `robocopy 源目录 目标目录 /MT:8` |
| 复制文件并保留权限 | `robocopy 源目录 目标目录 /COPY:DAT` |
| 移动文件（复制后删除源） | `robocopy 源目录 目标目录 /MOVE` |
| 只复制指定扩展名 | `robocopy 源目录 目标目录 *.txt /S` |
| 复制超过N天未修改的文件 | `robocopy 源目录 目标目录 /MINAGE:N` |
| 复制最近N天内修改的文件 | `robocopy 源目录 目标目录 /MAXAGE:N` |
| 显示复制进度 | `robocopy 源目录 目标目录 /NP` |
| 生成备份日志 | `robocopy 源目录 目标目录 /LOG:备份日志.txt` |
| 显示robocopy详细参数 | `robocopy /?` |
| 搜索大文件（大于100MB） | `forfiles /s /c "cmd /c if @fsize GEQ 104857600 echo @path @fsize"` |
| 批量修改文件扩展名 | `ren *.old *.new` |
| 批量修改文件名前缀 | `for %i in (*.txt) do ren "%i" "新前缀_%i"` |

## 五、批量处理高级命令

| 用途 | 命令 |
|------|------|
| 批量处理文件 | `for %i in (目录\*.扩展名) do 命令 %i` |
| 数字循环 | `for /l %i in (1,1,10) do echo %i` |
| 批量删除指定文件 | `for %i in (*.tmp) do del "%i"` |
| 批量重命名 | `for %i in (*.txt) do ren "%i" "%~ni.bak"` |
| 遍历目录 | `for /r 目录 %i in (*.log) do echo %i` |
| 解析文件内容 | `for /f "tokens=*" %i in (文件.txt) do echo %i` |
| 按分隔符解析 | `for /f "tokens=1,2 delims=," %i in (文件.csv) do echo %i %j` |
| 递归处理所有子目录 | `for /r . %i in (*.log) do del "%i"` |
| 处理日期范围 | `for /l %i in (20240101,1,20241231) do echo %i` |
| **forfiles 批量处理旧文件** | `forfiles /p 路径 /s /m *.log /d -7 /c "cmd /c del @file"` |
| forfiles 删除7天前文件 | `forfiles /p C:\Logs /s /m *.* /d -7 /c "cmd /c del @path"` |
| forfiles 移动30天前文件 | `forfiles /p C:\Data /s /m *.* /d -30 /c "cmd /c move @path D:\Archive\"` |
| forfiles 列出所有文件 | `forfiles /p C:\Test /s /c "cmd /c echo @file @fdate @fsize"` |
| forfiles 递归执行命令 | `forfiles /p C:\Scripts /s /m *.bat /c "cmd /c @path"` |
| forfiles 按扩展名筛选 | `forfiles /p C:\Temp /m *.tmp /c "cmd /c del @file"` |
| forfiles 执行自定义命令 | `forfiles /p C:\Backup /c "cmd /c if @isdir==TRUE echo @file is a directory"` |

## 六、系统修复

| 用途 | 命令 |
|------|------|
| 检查系统文件完整性 | `sfc /verifyonly` |
| 扫描并修复系统文件 | `sfc /scannow` |
| 离线修复系统文件 | `sfc /scannow /offbootdir=C:\ /offwindir=C:\Windows` |
| 查看修复日志 | `findstr /c:"[SR]" %windir%\Logs\CBS\CBS.log` |
| 检查映像是否可修复 | `DISM /Online /Cleanup-Image /CheckHealth` |
| 扫描映像是否有损坏 | `DISM /Online /Cleanup-Image /ScanHealth` |
| 修复映像（使用Windows更新） | `DISM /Online /Cleanup-Image /RestoreHealth` |
| 修复映像（指定源） | `DISM /Online /Cleanup-Image /RestoreHealth /Source:D:\sources\install.wim /LimitAccess` |
| 修复映像（使用挂载的ISO） | `DISM /Online /Cleanup-Image /RestoreHealth /Source:WIM:E:\sources\install.wim:1 /LimitAccess` |
| 离线修复映像 | `DISM /Image:C:\ /Cleanup-Image /RestoreHealth /Source:D:\sources\install.wim` |
| 查看DISM修复进度详情 | `DISM /Online /Cleanup-Image /RestoreHealth /Verbose` |
| 重置Windows更新组件 | `DISM /Online /Cleanup-Image /StartComponentCleanup` |
| 删除旧版本组件（释放空间） | `DISM /Online /Cleanup-Image /StartComponentCleanup /ResetBase` |
| 分析磁盘空间占用 | `DISM /Online /Cleanup-Image /AnalyzeComponentStore` |
| 查看映像版本信息 | `DISM /Online /Get-ImageInfo` |
| 挂载WIM映像 | `DISM /Mount-Image /ImageFile:D:\install.wim /Index:1 /MountDir:C:\Mount` |
| 卸载WIM映像 | `DISM /Unmount-Image /MountDir:C:\Mount /Commit` |
| 将修复结果输出到文件 | `sfc /scannow > C:\sfc_log.txt` |
| 修复后检查特定组件 | `DISM /Online /Cleanup-Image /CheckHealth \| findstr "损坏"` |
| 修复引导记录 | `bootrec /fixmbr` |
| 修复引导扇区 | `bootrec /fixboot` |
| 重建BCD引导配置 | `bootrec /rebuildbcd` |
| 扫描操作系统并修复引导 | `bootrec /scanos` |
| 重建BCD（详细） | `bcdedit /export C:\BCD_Backup & bootrec /rebuildbcd` |

## 七、批处理编程语法

| 用途 | 命令 |
|------|------|
| 条件判断（if） | `if 条件 (命令)` |
| 判断字符串相等 | `if "%var%"=="value" (echo equal)` |
| 判断数字大小 | `if %num% EQU 10 (echo equal)` |
| 判断文件存在 | `if exist "文件名" (echo found)` |
| 判断目录存在 | `if exist "目录名\" (echo found)` |
| 判断变量是否定义 | `if defined 变量名 (echo defined)` |
| 判断错误码 | `if errorlevel 1 (echo error)` |
| 简写判断错误码 | `if %errorlevel% neq 0 (echo error)` |
| 逻辑与（多个条件） | `if 条件1 if 条件2 (命令)` |
| 逻辑或（使用else） | `if 条件1 (命令1) else (命令2)` |
| 判断是否以管理员运行 | `net session >nul 2>&1 & if %errorlevel% neq 0 (echo 非管理员)` |
| 跳转到标签 | `goto 标签名` |
| 定义标签 | `:标签名` |
| 暂停N秒 | `timeout /t N /nobreak` |
| 暂停N秒（可跳过） | `timeout /t N` |
| 等待用户按键 | `pause` |
| 单字符选择 | `choice /C YN /M "是否继续"` |
| 带默认选项的选择 | `choice /C YN /D Y /T 5 /M "是否继续（5秒后默认Y）"` |
| 根据choice返回值执行 | `if %errorlevel% equ 1 (echo 选择了Y)` |
| 多选项菜单 | `choice /C 123 /M "请选择 1.启动 2.停止 3.退出"` |
| 循环执行（指定次数） | `for /l %%i in (1,1,10) do (命令)` |
| 遍历文件 | `for %%i in (*.txt) do (echo %%i)` |
| 遍历目录 | `for /d %%i in (*) do (echo %%i)` |
| 递归遍历 | `for /r 目录 %%i in (*.log) do (echo %%i)` |
| 解析文件内容 | `for /f "tokens=*" %%i in (文件.txt) do (echo %%i)` |
| 按分隔符解析 | `for /f "tokens=1,2 delims=," %%i in (文件.csv) do (echo %%i %%j)` |
| 跳过空行 | `for /f "eol=; tokens=*" %%i in (文件.txt) do (echo %%i)` |
| 无限循环 | `:loop & timeout /t 5 & goto loop` |
| 调用子程序 | `call :子程序名 参数1 参数2` |
| 子程序定义 | `:子程序名` |
| 子程序结束返回 | `goto :eof` |
| 带返回值的子程序 | `:子程序名 & set result=%1 & goto :eof` |
| 延迟变量扩展（解决循环内变量问题） | `setlocal enabledelayedexpansion` |
| 使用延迟变量 | `!变量名!` |
| 设置局部环境 | `setlocal` |
| 结束局部环境 | `endlocal` |
| 注释（方式1） | `rem 注释内容` |
| 注释（方式2） | `:: 注释内容` |
| 注释（方式3） | `if 1==0 (注释内容)` |
| 获取当前日期 | `%date%` |
| 获取当前时间 | `%time%` |
| 获取随机数 | `%random%` |
| 取模运算 | `set /a mod=%random% %% 100` |
| 算术运算 | `set /a 结果=10+20*3` |
| 字符串截取 | `%变量名:~起始位置,长度%` |
| 字符串替换 | `%变量名:旧=新%` |
| 获取文件路径 | `%%~dpi`（在for循环中） |
| 获取文件名（无扩展名） | `%%~ni`（在for循环中） |
| 获取文件扩展名 | `%%~xi`（在for循环中） |
| 获取完整路径 | `%%~fi`（在for循环中） |
| 获取文件大小 | `%%~zi`（在for循环中） |
| 获取修改时间 | `%%~ti`（在for循环中） |
| 显示错误级别 | `echo %errorlevel%` |
| 手动设置错误级别 | `exit /b 错误码` |
| 传递参数到批处理 | `%1`, `%2`, `%3...` |
| 获取所有参数 | `%*` |
| 转义特殊字符 | `^`（如 `^|`, `^&`, `^>`） |
| 执行多条命令 | `命令1 & 命令2 & 命令3` |
| 前成功才执行 | `命令1 && 命令2` |
| 前失败才执行 | `命令1 \|\| 命令2` |
| 后台执行（不等待） | `start 程序.exe` |
| 隐藏窗口执行 | `start /b 程序.exe` |
| 重定向输出到NUL | `命令 >nul` |
| 重定向错误到NUL | `命令 2>nul` |
| 重定向所有输出 | `命令 >nul 2>&1` |
| 从文件中读取输入 | `命令 < 文件名` |
| 管道传递 | `命令1 \| 命令2` |

## 八、磁盘高级操作

| 用途 | 命令 |
|------|------|
| 进入磁盘分区工具 | `diskpart` |
| 列出所有磁盘 | `list disk` |
| 选择磁盘 | `select disk 0` |
| 列出分区 | `list partition` |
| 创建主分区 | `create partition primary size=10240` |
| 创建扩展分区 | `create partition extended` |
| 创建逻辑分区 | `create partition logical size=10240` |
| 删除分区 | `delete partition` |
| 格式化分区 | `format fs=ntfs quick` |
| 分配盘符 | `assign letter=D` |
| 移除盘符 | `remove letter=D` |
| 激活分区 | `active` |
| 查看卷信息 | `list volume` |
| 选择卷 | `select volume 1` |
| 扩展卷 | `extend` |
| 收缩卷 | `shrink desired=10240` |
| 转换为GPT | `convert gpt` |
| 转换为MBR | `convert mbr` |
| 清理磁盘 | `clean` |
| 彻底清理（擦除所有扇区） | `clean all` |
| 查看磁盘详细信息 | `detail disk` |
| 查看分区详细信息 | `detail partition` |
| 创建VHD | `create vdisk file=D:\test.vhd maximum=10240 type=fixed` |
| 创建动态VHDX | `create vdisk file=D:\test.vhdx maximum=10240 type=expandable` |
| 挂载VHD | `select vdisk file=D:\test.vhd & attach vdisk` |
| 卸载VHD | `select vdisk file=D:\test.vhd & detach vdisk` |
| 压缩VHD | `select vdisk file=D:\test.vhd & compact vdisk` |
| 磁盘碎片整理 | `defrag C: /O`（优化） |
| 分析磁盘碎片 | `defrag C: /A` |
| 快速整理 | `defrag C: /Q` |
| 同时整理多个盘 | `defrag C: D: /U` |
| 查看磁盘I/O统计 | `wmic diskdrive get status` |
| 查看磁盘健康（SMART） | `wmic diskdrive get model,status` |
| 检查磁盘错误（不修复） | `chkdsk C:` |
| 修复磁盘错误 | `chkdsk C: /F` |
| 查找坏扇区并恢复 | `chkdsk C: /R` |
| 强制卸载卷再检查 | `chkdsk C: /X` |
| 检查NTFS权限 | `chkdsk C: /P` |
| 查看磁盘配额 | `fsutil quota query C:` |
| 启用磁盘配额 | `fsutil quota enforce C:` |
| 查看卷的可用空间 | `fsutil volume diskfree C:` |
| 查看NTFS信息 | `fsutil fsinfo ntfsinfo C:` |
| 查看所有驱动器 | `fsutil fsinfo drives` |
| 修改卷序列号 | `fsutil volume setnewvolumename C: new-sn` |

## 九、系统信息

| 用途 | 命令 |
|------|------|
| 查看系统信息 | `systeminfo` |
| 查看主机名 | `hostname` |
| 查看当前用户 | `whoami` |
| 查看系统版本 | `ver` |
| 查看环境变量 | `set` |
| 查看特定环境变量 | `echo %变量名%` |
| 查看系统启动时间 | `systeminfo \| findstr "系统启动时间"` |
| 查看CPU信息 | `wmic cpu get name, maxclockspeed` |
| 查看内存信息 | `wmic memorychip get capacity, speed` |
| 查看磁盘信息 | `wmic diskdrive get model, size` |
| 查看已安装补丁 | `wmic qfe list brief` |
| 查看当前用户详细信息 | `whoami /all` |
| 设置临时环境变量 | `set 变量名=值` |
| 设置永久环境变量 | `setx 变量名 值` |
| 查看系统信息精简 | `systeminfo \| findstr /i "os"` |
| 查看特定补丁 | `wmic qfe where "hotfixid='KB1234567'"` |
| 查看系统位数 | `wmic os get osarchitecture` |
| 查看BIOS信息 | `wmic bios get manufacturer, version` |
| 查看主板信息 | `wmic baseboard get product, manufacturer` |
| 查看显卡信息 | `wmic path win32_videocontroller get name` |
| 查看操作系统序列号 | `wmic os get serialnumber` |
| 查看系统运行时间 | `wmic os get lastbootuptime` |

## 十、系统配置

| 用途 | 命令 |
|------|------|
| 打开系统配置工具 | `msconfig` |
| 查看操作系统版本 | `ver` |
| 查看产品密钥 | `wmic path softwarelicensingservice get OA3xOriginalProductKey` |
| 查看激活状态 | `slmgr /dli` |
| 查看激活详细信息 | `slmgr /dlv` |
| 安装产品密钥 | `slmgr /ipk 密钥` |
| 激活Windows | `slmgr /ato` |
| 查看许可证过期时间 | `slmgr /xpr` |
| 设置系统时区 | `tzutil /s "China Standard Time"` |
| 查看当前时区 | `tzutil /g` |
| 列出所有时区 | `tzutil /l` |
| 设置电源方案（高性能） | `powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c` |
| 查看所有电源方案 | `powercfg /list` |
| 查看睡眠状态 | `powercfg /a` |
| 禁用休眠 | `powercfg /h off` |
| 启用休眠 | `powercfg /h on` |
| 查看电池报告 | `powercfg /batteryreport` |
| 查看电源效率报告 | `powercfg /energy` |
| 设置自动登录 | `control userpasswords2` |
| 打开本地安全策略 | `secpol.msc` |
| 打开组策略编辑器 | `gpedit.msc` |
| 刷新组策略 | `gpupdate /force` |
| 查看组策略应用结果 | `gpresult /r` |
| 导出组策略报告 | `gpresult /h report.html` |
| 查看Windows版本号 | `reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v ReleaseId` |
| 查看Windows内部版本 | `reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild` |

## 十一、用户与权限

| 用途 | 命令 |
|------|------|
| 查看系统用户 | `net user` |
| 查看特定用户信息 | `net user 用户名` |
| 添加用户 | `net user 用户名 密码 /add` |
| 删除用户 | `net user 用户名 /del` |
| 修改用户密码 | `net user 用户名 新密码` |
| 查看本地组 | `net localgroup` |
| 查看组成员 | `net localgroup 组名` |
| 将用户加入组 | `net localgroup 组名 用户名 /add` |
| 将用户移出组 | `net localgroup 组名 用户名 /delete` |
| 以管理员身份运行 | 右键CMD选择"以管理员身份运行" |
| 获取文件所有权 | `takeown /f 文件名` |
| 查看文件权限 | `icacls 文件名` |
| 授予管理员权限 | `icacls 文件名 /grant 用户名:F` |
| 重置文件权限 | `icacls 文件名 /reset` |
| 激活/禁用用户 | `net user 用户名 /active:yes/no` |
| 设置密码永不过期 | `wmic useraccount where "name='用户名'" set passwordexpires=false` |
| 创建本地组 | `net localgroup 组名 /add` |
| 删除本地组 | `net localgroup 组名 /delete` |
| 提权执行 | `runas /user:administrator "命令"` |
| 继承权限 | `icacls 文件名 /inheritance:e` |
| 移除继承 | `icacls 文件名 /inheritance:r` |

## 十二、防火墙

| 用途 | 命令 |
|------|------|
| 查看防火墙状态 | `netsh advfirewall show allprofiles` |
| 关闭防火墙 | `netsh advfirewall set allprofiles state off` |
| 开启防火墙 | `netsh advfirewall set allprofiles state on` |
| 添加入站规则 | `netsh advfirewall firewall add rule name="规则名" dir=in action=allow protocol=tcp localport=端口号` |
| 删除规则 | `netsh advfirewall firewall delete rule name="规则名"` |
| 查看所有规则 | `netsh advfirewall firewall show rule name=all` |
| 添加出站规则 | `netsh advfirewall firewall add rule name="规则名" dir=out action=allow protocol=tcp remoteport=端口号` |
| 添加程序规则 | `netsh advfirewall firewall add rule name="规则名" dir=in action=allow program="程序路径"` |
| 恢复默认策略 | `netsh advfirewall reset` |
| 查看启用规则 | `netsh advfirewall firewall show rule name=all dir=in` |
| 开启ICMP回显 | `netsh advfirewall firewall add rule name="ICMP Allow" protocol=icmpv4:8,any dir=in action=allow` |

## 十三、计划任务

| 用途 | 命令 |
|------|------|
| 查看所有计划任务 | `schtasks /query` |
| 创建每日任务 | `schtasks /create /tn 任务名 /tr 程序路径 /sc daily /st 09:00` |
| 删除计划任务 | `schtasks /delete /tn 任务名 /f` |
| 运行计划任务 | `schtasks /run /tn 任务名` |
| 创建开机启动任务 | `schtasks /create /tn 任务名 /tr 程序路径 /sc onstart` |
| 创建用户登录任务 | `schtasks /create /tn 任务名 /tr 程序路径 /sc onlogon` |
| 禁用计划任务 | `schtasks /change /tn 任务名 /disable` |
| 启用计划任务 | `schtasks /change /tn 任务名 /enable` |
| 查看详细任务 | `schtasks /query /fo LIST /v` |
| 查看特定任务 | `schtasks /query /tn 任务名` |
| 创建每周任务 | `schtasks /create /tn 任务名 /tr 程序路径 /sc weekly /d MON /st 10:00` |
| 创建每月任务 | `schtasks /create /tn 任务名 /tr 程序路径 /sc monthly /d 1 /st 00:00` |
| 创建单次任务 | `schtasks /create /tn 任务名 /tr 程序路径 /sc once /sd 2024/01/01 /st 12:00` |
| 创建空闲时任务 | `schtasks /create /tn 任务名 /tr 程序路径 /sc onidle /i 10` |
| 结束计划任务 | `schtasks /end /tn 任务名` |
| 修改任务触发时间 | `schtasks /change /tn 任务名 /st 14:00` |
| 导出计划任务 | `schtasks /query /tn 任务名 /xml > 任务.xml` |
| 导入计划任务 | `schtasks /create /tn 任务名 /xml 任务.xml` |

## 十四、注册表

| 用途 | 命令 |
|------|------|
| 查看注册表 | `reg query 注册表路径` |
| 添加注册表项 | `reg add 注册表路径 /v 名称 /t 类型 /d 数据 /f` |
| 删除注册表项 | `reg delete 注册表路径 /v 名称 /f` |
| 导出注册表 | `reg export 注册表路径 文件.reg` |
| 导入注册表 | `reg import 文件.reg` |
| 递归查看 | `reg query 注册表路径 /s` |
| 查看特定值 | `reg query 注册表路径 /v 名称` |
| 删除整个键 | `reg delete 注册表路径 /f` |
| 复制注册表项 | `reg copy 源路径 目标路径 /s /f` |
| 比较注册表 | `reg compare 路径1 路径2` |
| 保存注册表项 | `reg save 注册表路径 文件.hiv` |
| 加载注册表配置单元 | `reg load 目标路径 文件.hiv` |
| 卸载注册表配置单元 | `reg unload 目标路径` |

## 十五、事件日志

| 用途 | 命令 |
|------|------|
| 查看系统日志 | `wevtutil qe System /c:10 /rd:true /f:text` |
| 查看应用程序日志 | `wevtutil qe Application /c:10 /rd:true /f:text` |
| 清除事件日志 | `wevtutil cl System` |
| 按事件ID筛选 | `wevtutil qe System /q:"*[System[(EventID=1001)]]" /f:text` |
| 查看安全日志 | `wevtutil qe Security /c:10 /rd:true /f:text` |
| 按时间筛选 | `wevtutil qe System /q:"*[System[TimeCreated[@SystemTime>='2024-01-01T00:00:00']]]" /f:text` |
| 导出事件日志 | `wevtutil epl System 日志.evtx` |
| 查看日志文件 | `wevtutil gli System` |
| 查看所有日志名称 | `wevtutil el` |

## 十六、常用快捷命令

| 用途 | 命令 |
|------|------|
| 打开计算器 | `calc` |
| 打开记事本 | `notepad` |
| 打开画图 | `mspaint` |
| 打开命令行 | `cmd` |
| 打开PowerShell | `powershell` |
| 打开任务管理器 | `taskmgr` |
| 打开注册表编辑器 | `regedit` |
| 打开服务管理器 | `services.msc` |
| 打开设备管理器 | `devmgmt.msc` |
| 打开磁盘管理 | `diskmgmt.msc` |
| 打开系统配置 | `msconfig` |
| 打开系统属性 | `sysdm.cpl` |
| 打开网络连接 | `ncpa.cpl` |
| 打开电源选项 | `powercfg.cpl` |
| 打开程序和功能 | `appwiz.cpl` |
| 打开组策略编辑器 | `gpedit.msc` |
| 打开本地用户和组 | `lusrmgr.msc` |
| 打开性能监视器 | `perfmon` |
| 打开资源监视器 | `resmon` |
| 打开计算机管理 | `compmgmt.msc` |
| 打开事件查看器 | `eventvwr.msc` |
| 打开证书管理器 | `certmgr.msc` |
| 打开日期和时间 | `timedate.cpl` |
| 打开鼠标属性 | `main.cpl` |
| 打开声音设置 | `mmsys.cpl` |
| 打开用户账户 | `netplwiz` |

## 十七、CMD基础操作

| 用途 | 命令 |
|------|------|
| 清屏 | `cls` |
| 退出CMD | `exit` |
| 查看命令帮助 | `help` 或 `命令 /?` |
| 查看所有命令帮助 | `help` |
| 管道符（传递输出） | `命令1 \| 命令2` |
| 重定向输出到文件 | `命令 > 文件名` |
| 追加输出到文件 | `命令 >> 文件名` |
| 执行多个命令 | `命令1 & 命令2` |
| 前一个成功才执行 | `命令1 && 命令2` |
| 前一个失败才执行 | `命令1 \|\| 命令2` |
| 查看命令历史 | `doskey /history` |
| 设置命令别名 | `doskey 别名=原命令` |
| 暂停执行 | `pause` |
| 注释 | `:: 注释内容` 或 `rem 注释内容` |
| 重定向错误输出 | `命令 2> 文件名` |
| 重定向所有输出 | `命令 > 文件名 2>&1` |
| 从文件输入 | `命令 < 文件名` |
| 获取错误级别 | `echo %errorlevel%` |
| 设置错误级别 | `exit /b 错误码` |

## 十八、关机与重启

| 用途 | 命令 |
|------|------|
| 关机 | `shutdown /s /t 秒数` |
| 重启 | `shutdown /r /t 秒数` |
| 取消关机 | `shutdown /a` |
| 强制关机 | `shutdown /s /f /t 0` |
| 强制重启 | `shutdown /r /f /t 0` |
| 注销 | `shutdown /l` |
| 休眠 | `shutdown /h` |
| 锁定计算机 | `rundll32.exe user32.dll,LockWorkStation` |
| 查看关机计划 | `shutdown /l` |

## 十九、常用变量

| 变量 | 说明 |
|------|------|
| `%CD%` | 当前目录 |
| `%DATE%` | 当前日期 |
| `%TIME%` | 当前时间 |
| `%RANDOM%` | 随机数0-32767 |
| `%ERRORLEVEL%` | 上条命令错误码 |
| `%USERNAME%` | 当前用户名 |
| `%COMPUTERNAME%` | 计算机名 |
| `%USERPROFILE%` | 用户目录 |
| `%APPDATA%` | 应用数据目录 |
| `%TEMP%` | 临时目录 |
| `%WINDIR%` | Windows目录 |
| `%SYSTEMROOT%` | 系统根目录 |
| `%PROCESSOR_ARCHITECTURE%` | 处理器架构 |
| `%NUMBER_OF_PROCESSORS%` | CPU核心数 |
| `%PATH%` | 可执行文件搜索路径 |