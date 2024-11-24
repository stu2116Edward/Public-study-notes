# Linux 系统目录结构

登录系统后，在当前命令窗口下输入命令：  
```
ls / 
```
![mljg1](https://github.com/user-attachments/assets/850e299f-c53f-4ae1-993a-ea6ef4a3de3c)  

树状目录结构：
![mljg2](https://github.com/user-attachments/assets/01dc22fa-4bad-4a63-b6d0-4b419a674fc7)  

## 1. Linux 目录结构概述

Linux 文件系统采用树形结构，以根目录 `/` 为起始点，所有文件和目录都在此之下。这种结构有助于组织和存取文件，同时也反映了 Linux 系统的层次和组织逻辑。

## 2. 根目录 `/` 及其子目录

<table border="1" cellspacing="0" cellpadding="5">
    <tr>
        <th>目录路径</th>
        <th>描述</th>
    </tr>
    <tr>
        <td>/bin</td>
        <td>存放最经常使用的命令，如 ls、cp 等，这些命令在单用户模式下也可使用。</td>
    </tr>
    <tr>
        <td>/boot</td>
        <td>存放启动 Linux 时使用的一些核心文件，包括一些连接文件以及镜像文件。</td>
    </tr>
    <tr>
        <td>/dev</td>
        <td>存放 Linux 的外部设备文件，访问设备的方式和访问文件的方式相同。</td>
    </tr>
    <tr>
        <td>/etc</td>
        <td>存放系统管理所需要的配置文件和子目录。</td>
    </tr>
    <tr>
        <td>/home</td>
        <td>用户的主目录，每个用户都有一个自己的目录，一般以用户的账号命名。</td>
    </tr>
    <tr>
        <td>/lib</td>
        <td>存放系统最基本的动态连接共享库，类似于 Windows 里的 DLL 文件。</td>
    </tr>
    <tr>
        <td>/lost+found</td>
        <td>一般情况下为空，系统非法关机后，这里存放了一些文件。</td>
    </tr>
    <tr>
        <td>/media</td>
        <td>Linux 系统自动识别的设备，如 U 盘、光驱等，挂载到这个目录下。</td>
    </tr>
    <tr>
        <td>/mnt</td>
        <td>用于临时挂载别的文件系统，如光驱挂载。</td>
    </tr>
    <tr>
        <td>/opt</td>
        <td>存放额外安装的软件，如 ORACLE 数据库。默认为空。</td>
    </tr>
    <tr>
        <td>/proc</td>
        <td>虚拟文件系统，存储当前内核运行状态的一系列特殊文件，内容在内存里。</td>
    </tr>
    <tr>
        <td>/root</td>
        <td>系统管理员（root 用户）的主目录。</td>
    </tr>
    <tr>
        <td>/sbin</td>
        <td>存放系统管理员使用的系统管理程序。</td>
    </tr>
    <tr>
        <td>/selinux</td>
        <td>Red Hat/CentOS 特有的安全机制目录，存放 Selinux 相关的文件。</td>
    </tr>
    <tr>
        <td>/srv</td>
        <td>存放服务启动之后需要提取的数据。</td>
    </tr>
    <tr>
        <td>/sys</td>
        <td>集成了 proc、devfs、devpts 文件系统的信息，反映内核设备树。</td>
    </tr>
    <tr>
        <td>/tmp</td>
        <td>存放临时文件，系统重启时，这个目录下的文件应该被清除。</td>
    </tr>
    <tr>
        <td>/usr</td>
        <td>存放用户的很多应用程序和文件，类似于 Windows 的 Program Files 目录。</td>
    </tr>
    <tr>
        <td>/usr/bin</td>
        <td>系统用户使用的应用程序。</td>
    </tr>
    <tr>
        <td>/usr/sbin</td>
        <td>超级用户使用的高级管理程序和系统守护程序。</td>
    </tr>
    <tr>
        <td>/usr/src</td>
        <td>内核源代码默认的放置目录。</td>
    </tr>
    <tr>
        <td>/var</td>
        <td>存放经常变化的文件，如日志文件、邮件等。</td>
    </tr>
    <tr>
        <td>/run</td>
        <td>临时文件系统，存储系统启动以来的信息，重启时清除。</td>
    </tr>
</table>

## 3. 重要目录详解

### /etc
- 包含所有系统配置文件，更改这些文件可能会导致系统无法启动。

### /bin, /sbin, /usr/bin, /usr/sbin
- 存放系统预设的执行文件，其中 `/bin` 和 `/usr/bin` 为普通用户使用，`/sbin` 和 `/usr/sbin` 为 root 用户使用。

### /var
- 存放系统运行过程中产生的数据，如日志文件。

## 4. 文件系统层次结构标准 (FHS)

FHS 定义了 Linux 目录结构的标准，以确保不同 Linux 发行版之间的一致性。它将目录分为可分享的和不可分享的，以及不变的和可变动的。

### 可分享的 (Shareable)
- `/usr`、`/etc`、`/opt`、`/boot`

### 不可分享的 (Unshareable)
- `/dev`、`/proc`、`/sys`

### 不变的 (Static)
- `/usr`、`/etc`

### 可变动的 (Variable)
- `/var`、`/tmp`

## 5. 路径类型

### 绝对路径 (Absolute Path)
- 从根目录 `/` 开始的路径，如 `/home/user`.

### 相对路径 (Relative Path)
- 相对于当前目录的路径，如 `./file` 或 `../directory`.

## 6. 特殊目录符号

### .
- 表示当前目录。

### ..
- 表示上一级目录。
