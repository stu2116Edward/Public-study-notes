# PowerShell 命令速查表（完整版 · 按常用度排序）

## 一、基础入门

| 用途 | 命令 |
|------|------|
| 查看命令帮助 | `Get-Help 命令名` 或 `命令名 -?` |
| 查看命令示例 | `Get-Help 命令名 -Examples` |
| 查看详细帮助 | `Get-Help 命令名 -Detailed` |
| 列出所有可用命令 | `Get-Command` |
| 搜索包含某关键词的命令 | `Get-Command *关键词*` |
| 查看命令的用法 | `Get-Command 命令名 -Syntax` |
| 查看命令别名 | `Get-Alias` |
| 查看特定别名 | `Get-Alias 别名` |
| 创建别名 | `Set-Alias 别名 原命令` |
| 查看历史记录 | `Get-History` |
| 清屏 | `Clear-Host` 或 `cls` |
| 退出PowerShell | `exit` |

## 二、文件和目录操作

| 用途 | 命令 |
|------|------|
| 列出当前目录文件 | `Get-ChildItem` 或 `ls` 或 `dir` |
| 列出包括隐藏文件 | `Get-ChildItem -Force` |
| 只列出目录 | `Get-ChildItem -Directory` |
| 只列出文件 | `Get-ChildItem -File` |
| 递归列出所有子目录 | `Get-ChildItem -Recurse` |
| 按名称筛选 | `Get-ChildItem -Filter "*.txt"` |
| 切换目录 | `Set-Location 路径` 或 `cd 路径` |
| 返回上级目录 | `cd ..` |
| 返回根目录 | `cd \` |
| 显示当前目录 | `Get-Location` 或 `pwd` |
| 创建目录 | `New-Item -ItemType Directory -Path 目录名` 或 `mkdir 目录名` |
| 创建多级目录 | `New-Item -ItemType Directory -Force -Path 目录1\目录2\目录3` |
| 删除空目录 | `Remove-Item -Path 目录名` 或 `rmdir 目录名` |
| 强制删除目录及文件 | `Remove-Item -Recurse -Force -Path 目录名` |
| 删除文件 | `Remove-Item 文件名` 或 `del 文件名` |
| 复制文件 | `Copy-Item 源文件 目标路径` 或 `cp 源文件 目标路径` |
| 复制目录 | `Copy-Item -Recurse 源目录 目标目录` |
| 移动文件 | `Move-Item 源文件 目标路径` 或 `mv 源文件 目标路径` |
| 重命名 | `Rename-Item 原文件名 新文件名` 或 `ren 原文件名 新文件名` |
| 批量重命名 | `Get-ChildItem *.txt \| Rename-Item -NewName { $_.Name -replace "\.txt$",".bak" }` |
| 查看文件内容 | `Get-Content 文件名` 或 `type 文件名` |
| 查看文件前N行 | `Get-Content 文件名 -TotalCount N` |
| 查看文件后N行 | `Get-Content 文件名 -Tail N` |
| 实时监控文件 | `Get-Content 文件名 -Wait` |
| 创建空文件 | `New-Item 文件名 -ItemType File` |
| 写入文件 | `"内容" \| Out-File 文件名` |
| 追加到文件 | `"内容" \| Out-File -Append 文件名` |
| 查找文件中的文本 | `Select-String -Path "*.txt" -Pattern "关键词"` |
| 递归查找文本 | `Select-String -Path "*.txt" -Pattern "关键词" -Recurse` |
| 比较两个文件 | `Compare-Object (Get-Content 文件1) (Get-Content 文件2)` |
| 查看文件属性 | `Get-Item 文件名 \| Format-List *` |
| 显示文件大小 | `Get-ChildItem \| Format-Table Name, Length` |

## 三、进程管理

| 用途 | 命令 |
|------|------|
| 查看所有进程 | `Get-Process` 或 `ps` |
| 查看特定进程 | `Get-Process -Name 进程名` |
| 根据ID查看进程 | `Get-Process -Id 进程PID` |
| 结束进程 | `Stop-Process -Name 进程名` 或 `kill 进程名` |
| 根据ID结束进程 | `Stop-Process -Id 进程PID -Force` |
| 启动进程 | `Start-Process 程序名.exe` |
| 以管理员身份启动 | `Start-Process 程序名.exe -Verb RunAs` |
| 等待进程结束 | `Start-Process -Wait 程序名.exe` |
| 查看进程详细信息 | `Get-Process \| Select-Object Name, CPU, WorkingSet` |
| 按CPU排序 | `Get-Process \| Sort-Object CPU -Descending` |
| 按内存排序 | `Get-Process \| Sort-Object WorkingSet -Descending` |

## 四、服务管理

| 用途 | 命令 |
|------|------|
| 查看所有服务 | `Get-Service` |
| 查看特定服务 | `Get-Service -Name 服务名` |
| 查看正在运行的服务 | `Get-Service \| Where-Object {$_.Status -eq "Running"}` |
| 启动服务 | `Start-Service -Name 服务名` |
| 停止服务 | `Stop-Service -Name 服务名` |
| 重启服务 | `Restart-Service -Name 服务名` |
| 禁用服务 | `Set-Service -Name 服务名 -StartupType Disabled` |
| 设置服务自动启动 | `Set-Service -Name 服务名 -StartupType Automatic` |
| 设置服务手动启动 | `Set-Service -Name 服务名 -StartupType Manual` |

## 五、网络相关

| 用途 | 命令 |
|------|------|
| 测试网络连通性 | `Test-Connection 域名或IP` 或 `ping 域名或IP` |
| 测试TCP端口 | `Test-NetConnection 域名或IP -Port 端口号` |
| 查看网络配置 | `Get-NetIPAddress` |
| 查看所有网卡信息 | `Get-NetAdapter \| Format-List` |
| 查看路由表 | `Get-NetRoute` |
| 查看DNS配置 | `Get-DnsClientServerAddress` |
| 清除DNS缓存 | `Clear-DnsClientCache` |
| 解析域名 | `Resolve-DnsName 域名` |
| 反向解析 | `Resolve-DnsName IP地址 -Type PTR` |
| 查看网络连接 | `Get-NetTCPConnection` |
| 查看监听端口 | `Get-NetTCPConnection -State Listen` |
| 查看端口被哪个进程占用 | `Get-NetTCPConnection -LocalPort 端口号 \| Select-Object OwningProcess` |
| 根据PID查进程名 | `Get-Process -Id (Get-NetTCPConnection -LocalPort 端口号).OwningProcess` |
| 追踪路由 | `Test-NetConnection 域名或IP -TraceRoute` |
| 下载文件 | `Invoke-WebRequest -Uri "URL" -OutFile "保存路径"` |
| 访问网页内容 | `Invoke-WebRequest -Uri "URL"` |
| 发送HTTP请求 | `Invoke-RestMethod -Uri "URL"` |

## 六、系统信息

| 用途 | 命令 |
|------|------|
| 查看系统信息 | `Get-ComputerInfo` |
| 查看操作系统版本 | `Get-ComputerInfo \| Select-Object WindowsProductName, WindowsVersion` |
| 查看主机名 | `hostname` 或 `$env:COMPUTERNAME` |
| 查看当前用户 | `whoami` 或 `$env:USERNAME` |
| 查看系统启动时间 | `Get-CimInstance -ClassName Win32_OperatingSystem \| Select-Object LastBootUpTime` |
| 查看系统运行时间 | `(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime` |
| 查看CPU信息 | `Get-CimInstance -ClassName Win32_Processor` |
| 查看内存信息 | `Get-CimInstance -ClassName Win32_PhysicalMemory` |
| 查看磁盘信息 | `Get-CimInstance -ClassName Win32_LogicalDisk` |
| 查看磁盘剩余空间 | `Get-PSDrive -Name C` |
| 查看所有盘符 | `Get-PSDrive -PSProvider FileSystem` |
| 查看环境变量 | `Get-ChildItem Env:` |
| 查看特定环境变量 | `$env:变量名` |
| 设置临时环境变量 | `$env:变量名 = "值"` |
| 设置永久环境变量 | `[Environment]::SetEnvironmentVariable("变量名", "值", "User")` |
| 查看已安装补丁 | `Get-HotFix` |
| 查看特定补丁 | `Get-HotFix -Id "KB1234567"` |
| 查看BIOS信息 | `Get-CimInstance -ClassName Win32_BIOS` |
| 查看显卡信息 | `Get-CimInstance -ClassName Win32_VideoController` |

## 七、管道和对象操作

| 用途 | 命令 |
|------|------|
| 筛选对象 | `命令 \| Where-Object {条件}` 或 `命令 \| where {条件}` |
| 选择属性 | `命令 \| Select-Object 属性1, 属性2` 或 `命令 \| select 属性1, 属性2` |
| 选择前N个 | `命令 \| Select-Object -First N` |
| 选择后N个 | `命令 \| Select-Object -Last N` |
| 排序 | `命令 \| Sort-Object 属性` 或 `命令 \| sort 属性` |
| 降序排序 | `命令 \| Sort-Object 属性 -Descending` |
| 分组统计 | `命令 \| Group-Object 属性` |
| 统计数量 | `命令 \| Measure-Object` |
| 求和 | `命令 \| Measure-Object -Sum 属性` |
| 平均值 | `命令 \| Measure-Object -Average 属性` |
| 最大值 | `命令 \| Measure-Object -Maximum 属性` |
| 最小值 | `命令 \| Measure-Object -Minimum 属性` |
| 格式化表格 | `命令 \| Format-Table` 或 `ft` |
| 格式化列表 | `命令 \| Format-List` 或 `fl` |
| 导出为CSV | `命令 \| Export-Csv 文件.csv` |
| 导出为JSON | `命令 \| ConvertTo-Json \| Out-File 文件.json` |
| 导出为XML | `命令 \| Export-Clixml 文件.xml` |
| 导入CSV | `Import-Csv 文件.csv` |
| 导入JSON | `Get-Content 文件.json \| ConvertFrom-Json` |

## 八、批量处理与脚本编程

| 用途 | 命令 |
|------|------|
| 遍历数组 | `foreach ($item in $数组) { 命令 }` |
| 管道遍历 | `$数组 \| ForEach-Object { $_ }` 或 `$数组 \| % { $_ }` |
| 循环数字 | `1..10 \| ForEach-Object { $_ }` |
| while循环 | `while (条件) { 命令 }` |
| do-while循环 | `do { 命令 } while (条件)` |
| 条件判断 | `if (条件) { 命令 } else { 命令 }` |
| 多条件判断 | `switch (变量) { 值1 {命令} 值2 {命令} }` |
| 函数定义 | `function 函数名 { 参数; 命令 }` |
| 调用函数 | `函数名 参数` |
| 延迟加载脚本 | `. ./脚本.ps1` |
| 设置执行策略 | `Set-ExecutionPolicy RemoteSigned` |
| 查看执行策略 | `Get-ExecutionPolicy` |
| 暂停脚本（按任意键继续） | `Read-Host "按回车键继续"` |
| 暂停N秒 | `Start-Sleep -Seconds N` |
| 获取用户输入 | `$input = Read-Host "请输入内容"` |
| 输出彩色文字 | `Write-Host "文字" -ForegroundColor Red` |
| 抛出错误 | `Throw "错误信息"` |
| 捕获异常 | `try { 命令 } catch { 处理 }` |
| 脚本中获取当前目录 | `$PSScriptRoot` |
| 脚本中获取脚本名称 | `$MyInvocation.MyCommand.Name` |

## 九、注册表操作

| 用途 | 命令 |
|------|------|
| 查看注册表项 | `Get-ChildItem -Path HKLM:\Software\路径` |
| 查看注册表值 | `Get-ItemProperty -Path HKLM:\Software\路径` |
| 查看特定值 | `Get-ItemProperty -Path HKLM:\Software\路径 -Name 值名称` |
| 创建注册表项 | `New-Item -Path HKLM:\Software\路径` |
| 设置注册表值 | `Set-ItemProperty -Path HKLM:\Software\路径 -Name 值名称 -Value 数据` |
| 删除注册表项 | `Remove-Item -Path HKLM:\Software\路径` |
| 删除注册表值 | `Remove-ItemProperty -Path HKLM:\Software\路径 -Name 值名称` |
| 常用注册表根键 | `HKLM:` 本地机器<br>`HKCU:` 当前用户<br>`HKCR:` 类根<br>`HKU:` 用户 |

## 十、系统修复（DISM与SFC）

| 用途 | 命令 |
|------|------|
| 检查系统文件完整性 | `sfc /verifyonly` |
| 扫描并修复系统文件 | `sfc /scannow` |
| 检查映像是否可修复 | `Repair-WindowsImage -Online -CheckHealth` |
| 扫描映像是否有损坏 | `Repair-WindowsImage -Online -ScanHealth` |
| 修复映像（使用Windows更新） | `Repair-WindowsImage -Online -RestoreHealth` |
| 修复映像（指定源） | `Repair-WindowsImage -Online -RestoreHealth -Source D:\sources\install.wim -LimitAccess` |
| 离线修复映像 | `Repair-WindowsImage -Path C:\ -RestoreHealth -Source D:\sources\install.wim` |
| 重置Windows更新组件 | `Repair-WindowsImage -Online -StartComponentCleanup` |
| 删除旧版本组件（释放空间） | `Repair-WindowsImage -Online -StartComponentCleanup -ResetBase` |
| 分析磁盘空间占用 | `Repair-WindowsImage -Online -AnalyzeComponentStore` |

## 十一、用户和权限

| 用途 | 命令 |
|------|------|
| 查看本地用户 | `Get-LocalUser` |
| 查看特定用户 | `Get-LocalUser -Name 用户名` |
| 创建用户 | `New-LocalUser -Name 用户名 -Password (ConvertTo-SecureString "密码" -AsPlainText -Force)` |
| 删除用户 | `Remove-LocalUser -Name 用户名` |
| 修改用户密码 | `Set-LocalUser -Name 用户名 -Password (ConvertTo-SecureString "新密码" -AsPlainText -Force)` |
| 启用用户 | `Enable-LocalUser -Name 用户名` |
| 禁用用户 | `Disable-LocalUser -Name 用户名` |
| 查看本地组 | `Get-LocalGroup` |
| 查看组成员 | `Get-LocalGroupMember -Group 组名` |
| 添加用户到组 | `Add-LocalGroupMember -Group 组名 -Member 用户名` |
| 从组移除用户 | `Remove-LocalGroupMember -Group 组名 -Member 用户名` |
| 获取文件权限 | `Get-Acl 文件路径` |
| 设置文件权限 | `Set-Acl 文件路径 -AclObject 新ACL` |
| 获取文件所有者 | `Get-Acl 文件路径 \| Select-Object Owner` |
| 以管理员身份运行脚本 | 右键PowerShell选择"以管理员身份运行" |

## 十二、计划任务

| 用途 | 命令 |
|------|------|
| 查看计划任务 | `Get-ScheduledTask` |
| 查看特定任务 | `Get-ScheduledTask -TaskName 任务名` |
| 创建计划任务 | `Register-ScheduledTask -TaskName 任务名 -Action (New-ScheduledTaskAction -Execute "程序路径") -Trigger (New-ScheduledTaskTrigger -Daily -At "09:00")` |
| 删除计划任务 | `Unregister-ScheduledTask -TaskName 任务名 -Confirm:$false` |
| 启动计划任务 | `Start-ScheduledTask -TaskName 任务名` |
| 停止计划任务 | `Stop-ScheduledTask -TaskName 任务名` |
| 禁用计划任务 | `Disable-ScheduledTask -TaskName 任务名` |
| 启用计划任务 | `Enable-ScheduledTask -TaskName 任务名` |

## 十三、事件日志

| 用途 | 命令 |
|------|------|
| 查看系统日志 | `Get-EventLog -LogName System -Newest 10` |
| 查看应用程序日志 | `Get-EventLog -LogName Application -Newest 10` |
| 查看安全日志 | `Get-EventLog -LogName Security -Newest 10` |
| 按事件ID筛选 | `Get-EventLog -LogName System \| Where-Object {$_.EventID -eq 1001}` |
| 按时间筛选 | `Get-EventLog -LogName System -After (Get-Date).AddDays(-7)` |
| 使用Get-WinEvent查询 | `Get-WinEvent -LogName System -MaxEvents 10` |
| 按XML筛选 | `Get-WinEvent -FilterXPath "*[System[EventID=1001]]"` |
| 清除事件日志 | `Clear-EventLog -LogName System` |

## 十四、模块管理

| 用途 | 命令 |
|------|------|
| 查看已安装模块 | `Get-Module -ListAvailable` |
| 查看已加载模块 | `Get-Module` |
| 导入模块 | `Import-Module 模块名` |
| 安装模块 | `Install-Module -Name 模块名` |
| 更新模块 | `Update-Module -Name 模块名` |
| 卸载模块 | `Uninstall-Module -Name 模块名` |
| 查找模块 | `Find-Module -Name 关键词` |
| 查看模块命令 | `Get-Command -Module 模块名` |

## 十五、远程管理

| 用途 | 命令 |
|------|------|
| 启用PSRemoting | `Enable-PSRemoting -Force` |
| 进入远程会话 | `Enter-PSSession -ComputerName 计算机名` |
| 创建远程会话 | `New-PSSession -ComputerName 计算机名` |
| 在远程执行命令 | `Invoke-Command -ComputerName 计算机名 -ScriptBlock { 命令 }` |
| 退出远程会话 | `Exit-PSSession` |
| 移除远程会话 | `Remove-PSSession -Session 会话` |
| 测试远程连接 | `Test-WSMan -ComputerName 计算机名` |

## 十六、文件压缩与解压

| 用途 | 命令 |
|------|------|
| 压缩文件/目录 | `Compress-Archive -Path 源路径 -DestinationPath 目标.zip` |
| 压缩多个文件 | `Compress-Archive -Path 文件1.txt, 文件2.txt -DestinationPath 目标.zip` |
| 追加到已有压缩包 | `Compress-Archive -Path 新文件.txt -DestinationPath 目标.zip -Update` |
| 解压缩 | `Expand-Archive -Path 压缩包.zip -DestinationPath 目标目录` |
| 解压缩并覆盖 | `Expand-Archive -Path 压缩包.zip -DestinationPath 目标目录 -Force` |

## 十七、字符串和数组操作

| 用途 | 命令 |
|------|------|
| 创建数组 | `$数组 = @(元素1, 元素2, 元素3)` |
| 创建哈希表 | `$哈希表 = @{键1="值1"; 键2="值2"}` |
| 字符串替换 | `"字符串" -replace "原词","新词"` |
| 字符串拆分 | `"字符串" -split "分隔符"` |
| 字符串连接 | `$字符串1 + $字符串2` |
| 字符串转大写 | `"字符串".ToUpper()` |
| 字符串转小写 | `"字符串".ToLower()` |
| 判断是否包含 | `"字符串" -contains "子串"` |
| 判断是否匹配 | `"字符串" -match "正则"` |
| 数组添加元素 | `$数组 += 新元素` |
| 数组删除元素 | `$数组 = $数组 \| Where-Object {$_ -ne 要删除的元素}` |
| 获取数组长度 | `$数组.Count` |

## 十八、日期时间

| 用途 | 命令 |
|------|------|
| 获取当前时间 | `Get-Date` |
| 获取当前日期 | `Get-Date -Format "yyyy-MM-dd"` |
| 格式化时间 | `Get-Date -Format "HH:mm:ss"` |
| 计算未来日期 | `(Get-Date).AddDays(7)` |
| 计算过去日期 | `(Get-Date).AddDays(-7)` |
| 日期差计算 | `(Get-Date 2024-01-01) - (Get-Date)` |
| 创建特定日期 | `Get-Date -Year 2024 -Month 1 -Day 1` |

## 十九、常用别名对照

| 别名 | 原命令 |
|------|--------|
| `ls`, `dir` | `Get-ChildItem` |
| `cd`, `chdir` | `Set-Location` |
| `pwd` | `Get-Location` |
| `ps` | `Get-Process` |
| `kill` | `Stop-Process` |
| `cp` | `Copy-Item` |
| `mv` | `Move-Item` |
| `rm`, `del` | `Remove-Item` |
| `ren` | `Rename-Item` |
| `cat`, `type` | `Get-Content` |
| `echo` | `Write-Output` |
| `where` | `Where-Object` |
| `select` | `Select-Object` |
| `sort` | `Sort-Object` |
| `group` | `Group-Object` |
| `measure` | `Measure-Object` |
| `ft` | `Format-Table` |
| `fl` | `Format-List` |
| `%` | `ForEach-Object` |
| `?` | `Where-Object` |

## 二十、特殊变量

| 变量 | 说明 |
|------|------|
| `$_` 或 `$PSItem` | 管道中的当前对象 |
| `$?` | 上一条命令是否成功 |
| `$^` | 上一条命令的第一个参数 |
| `$$` | 上一条命令的最后一个参数 |
| `$Error` | 错误记录数组 |
| `$Host` | 当前主机信息 |
| `$Profile` | PowerShell配置文件路径 |
| `$PSVersionTable` | PowerShell版本信息 |
| `$MyInvocation` | 当前脚本调用信息 |
| `$PWD` | 当前工作目录 |
| `$HOME` | 用户主目录 |
| `$null` | 空值 |
| `$true` / `$false` | 布尔值 |
| `$args` | 脚本/函数参数数组 |

## 二十一、常用快捷键

| 快捷键 | 说明 |
|--------|------|
| `Ctrl + C` | 中断当前命令 |
| `Ctrl + L` | 清屏 |
| `上箭头` | 上一条命令 |
| `下箭头` | 下一条命令 |
| `Ctrl + R` | 反向搜索历史 |
| `Tab` | 自动补全 |
| `Ctrl + 空格` | 显示所有补全选项 |
| `Ctrl + 左/右箭头` | 跳过一个单词 |
| `Home` | 跳到行首 |
| `End` | 跳到行尾 |
| `Ctrl + A` | 跳到行首 |
| `Ctrl + E` | 跳到行尾 |
| `Ctrl + K` | 删除到行尾 |
| `Ctrl + U` | 删除到行首 |
| `Ctrl + Y` | 粘贴剪切的内容 |
| `F7` | 显示历史命令列表 |

## 二十二、PowerShell专属高级功能

| 用途 | 命令 |
|------|------|
| 查看所有可用模块 | `Get-Module -ListAvailable` |
| 创建COM对象 | `New-Object -ComObject 对象名` |
| 调用静态方法 | `[类名]::方法名(参数)` |
| 查看类型成员 | `变量 \| Get-Member` |
| 创建自定义对象 | `[PSCustomObject]@{属性1="值1"; 属性2="值2"}` |
| 并行执行 | `$数组 \| ForEach-Object -Parallel { 命令 } -ThrottleLimit 5` |
| 使用类（PowerShell 5.0+） | `class 类名 { [string]$属性; 方法() {代码} }` |
| 创建后台作业 | `Start-Job -ScriptBlock { 命令 }` |
| 查看后台作业 | `Get-Job` |
| 接收作业结果 | `Receive-Job -Job $作业` |
| 移除作业 | `Remove-Job -Job $作业` |
| 计划任务脚本 | `Register-ScheduledJob -Name 任务名 -ScriptBlock { 命令 } -Trigger (New-JobTrigger -Daily -At "09:00")` |