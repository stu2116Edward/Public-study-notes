# Linux screen 命令

### screen 是什么

screen 是 GNU 的终端多路复用器（Terminal Multiplexer），允许你在一个终端中创建多个虚拟终端，并支持断线后继续运行任务。
核心能力包括：  
- 会话持久化：SSH 断开后任务仍继续运行
- 多窗口管理：一个会话内可开多个窗口
- 分屏 Pane：窗口内可上下/左右分割
- 会话共享：多人同时连接同一会话


### 安装 screen

Debian/Ubuntu：
```
sudo apt install screen
```

CentOS/RHEL：
```
sudo yum install screen
```
Or：
```
sudo dnf install screen
```

Arch Linux：
```
sudo pacman -S screen
```

验证：
```
screen --version
```


### screen 基础命令

#### 创建会话
```
screen              		# 创建默认会话
screen -S backup    	# 创建名为 backup 的会话（推荐）
```

#### 查看会话
```
screen -ls
```
输出示例：
<pre>
12345.backup (Detached)
67890.dev    (Attached)
</pre>

#### 连接会话
```
screen -r backup     	# 连接名称为 backup 的会话
screen -r 12345      	# 通过 ID 连接
screen -d -r backup  	# 强制断开其他终端并重连
```

#### 分离会话（最常用）  
在会话内按：`Ctrl + a + d`  
会话进入后台继续运行  

#### 退出会话  
在会话内执行：`exit` 或 `Ctrl + d`  
强制关闭：
```
screen -X -S backup quit
```

#### 窗口管理  
***常用快捷键（均需先按 Ctrl + a）***  

| 快捷键 | 功能 |
|---|---|
| c | 创建新窗口 |
| n | 下一个窗口 |
| p | 上一个窗口 |
| 0-9 | 切换到第 n 个窗口 |
| A | 重命名窗口 |
| k | 关闭当前窗口 |

#### 分屏（Pane）管理

| 快捷键 | 功能 |
|---|---|
| " | 上下分屏 |
| % | 左右分屏 |
| Tab | 切换面板 |
| Q | 关闭其他面板 |
| x | 关闭当前面板 |
| :resize | 调整面板大小 |

#### 会话日志
开启/关闭日志：
```
Ctrl + a + H
```
日志文件默认：`screenlog.0`  
可在 `~/.screenrc` 自定义路径  
