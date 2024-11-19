# linux命令大全

## Linux文件管理命令教程

### 1. mv命令：移动或改名文件
用法
```
mv [选项] [源文件或目录] [目标文件或目录]
```

常用选项
- `-i`：交互式移动，移动前提示用户。
- `-f`：强制移动，不提示用户。
- `-v`：详细模式，显示移动过程。

示例
- 移动文件：
  ```
  mv file.txt /path/to/destination/
  ```
- 改名文件：
  ```
  mv file.txt newfile.txt
  ```

### 2. ls命令：显示目录中文件及其属性信息

用法
```
ls [选项] [目录或文件]
```

常用选项
- `-l`：长列表格式，显示详细信息。
- `-a`：显示所有文件，包括隐藏文件。
- `-h`：以易读的格式显示文件大小。
- `-t`：按修改时间排序。

示例
- 显示当前目录下的所有文件：
  ```
  ls
  ```
- 以长列表格式显示：
  ```
  ls -l
  ```

### 3. cp命令：复制文件或目录

用法
```
cp [选项] [源文件或目录] [目标文件或目录]
```

常用选项
- `-r`：递归复制，用于目录。
- `-i`：交互式复制，复制前提示用户。
- `-v`：详细模式，显示复制过程。

示例
- 复制文件：
  ```
  cp file.txt /path/to/destination/
  ```
- 递归复制目录：
  ```
  cp -r dir /path/to/destination/
  ```

### 4. mkdir命令：创建目录文件

用法
```
mkdir [选项] [目录名]
```

常用选项
- `-p`：创建多级目录。

示例
- 创建目录：
  ```
  mkdir newdir
  ```
- 创建多级目录：
  ```
  mkdir -p dir1/dir2/dir3
  ```

### 5. pwd命令：显示当前工作目录的路径

用法
```
pwd
```

示例
- 显示当前工作目录：
  ```
  pwd
  ```

### 6. tar命令：压缩和解压缩文件

用法
```
tar [选项] [文件名]
```

常用选项
- `cvzf`：创建gzip压缩文件。
- `xvzf`：解压gzip压缩文件。
- `cvjf`：创建bzip2压缩文件。
- `xvjf`：解压bzip2压缩文件。

示例
- 创建gzip压缩文件：
  ```
  tar cvzf archive.tar.gz file1 file2
  ```
- 解压gzip压缩文件：
  ```
  tar xvzf archive.tar.gz
  ```

### 7. cd命令：切换目录

用法
```
cd [目录名]
```

示例
- 切换到用户主目录：
  ```
  cd ~
  ```
- 切换到上一级目录：
  ```
  cd ..
  ```

### 8. chmod命令：改变文件或目录权限

用法
```
chmod [选项] [权限] [文件或目录]
```

常用选项
- `u`：用户（文件所有者）。
- `g`：组。
- `o`：其他。
- `+`：添加权限。
- `-`：删除权限。
- `=`：设置权限。

示例
- 添加执行权限给所有用户：
  ```
  chmod +x file.txt
  ```
- 设置文件所有者读写权限：
  ```
  chmod u+rw file.txt
  ```

### 9. vim/vi命令：文本编辑器

用法
```
vim [文件名]
```

基本操作
- `i`：进入插入模式。
- `Esc`：退出插入模式。
- `:w`：保存文件。
- `:q`：退出编辑器。
- `:wq`：保存并退出。
- `:q!`：不保存退出。

示例
- 编辑文件：
  ```
  vim file.txt
  ```


## Linux文档编辑命令教程

### 1. cat命令：在终端设备上显示文件内容

用法
```bash
cat [选项] [文件名]
```

常用选项
- `-n`：显示行号。
- `-b`：仅显示非空行的行号。

示例
- 显示文件内容：
  ```bash
  cat file.txt
  ```
- 显示带行号的文件内容：
  ```bash
  cat -n file.txt
  ```

### 2. rm命令：删除文件或目录

用法
```bash
rm [选项] [文件或目录]
```

常用选项
- `-i`：交互式删除，删除前提示用户。
- `-f`：强制删除，不提示用户。
- `-r`：递归删除，用于目录。

示例
- 删除文件：
  ```bash
  rm file.txt
  ```
- 强制删除目录：
  ```bash
  rm -rf dir
  ```

### 3. grep命令：强大的文本搜索工具

用法
```bash
grep [选项] [搜索词] [文件名]
```

常用选项
- `-i`：忽略大小写。
- `-v`：显示不包含搜索词的行。
- `-r`：递归搜索。

示例
- 搜索包含特定词的行：
  ```bash
  grep "word" file.txt
  ```
- 递归搜索目录：
  ```bash
  grep -r "word" /path/to/directory/
  ```

### 4. echo命令：输出字符串或提取后的变量值

用法
```bash
echo [字符串]
```

示例
- 输出字符串：
  ```bash
  echo "Hello, World!"
  ```
- 输出变量值：
  ```bash
  echo $VARIABLE
  ```

### 5. tail命令：查看文件尾部内容

用法
```bash
tail [选项] [文件名]
```

常用选项
- `-f`：实时显示文件新增内容。
- `-n`：显示文件尾部的行数。

示例
- 显示文件尾部10行：
  ```bash
  tail -n 10 file.txt
  ```
- 实时显示文件新增内容：
  ```bash
  tail -f file.txt
  ```

### 6. rmdir命令：删除空目录文件

用法
```bash
rmdir [目录名]
```

示例
- 删除空目录：
  ```bash
  rmdir emptydir
  ```

### 7. sed命令：批量编辑文本文件

用法
```bash
sed [选项] 's/原始文本/替换文本/' [文件名]
```

常用选项
- `-i`：直接修改文件，不输出到标准输出。

示例
- 替换文件中的文本：
  ```bash
  sed 's/old/new/' file.txt
  ```
- 直接修改文件：
  ```bash
  sed -i 's/old/new/' file.txt
  ```


## Linux系统管理命令教程

### 1. find命令：根据路径和条件搜索指定文件

用法
```bash
find [路径] [选项] [表达式]
```

常用选项
- `-name`：按文件名搜索。
- `-type`：按文件类型搜索。
- `-mtime`：按修改时间搜索。

示例
- 搜索名为file.txt的文件：
  ```bash
  find / -name file.txt
  ```
- 搜索修改时间在2天内的文件：
  ```bash
  find / -mtime -2
  ```

### 2. rpm命令：RPM软件包管理器

用法
```bash
rpm [选项] [包名]
```

常用选项
- `-i`：安装包。
- `-e`：卸载包。
- `-q`：查询包信息。

示例
- 安装软件包：
  ```bash
  rpm -ivh package.rpm
  ```
- 查询软件包信息：
  ```bash
  rpm -q package
  ```

### 3. ps命令：显示进程状态

用法
```bash
ps [选项]
```

常用选项
- `-aux`：显示所有进程。
- `-ef`：显示所有进程的详细信息。

示例
- 显示所有进程：
  ```bash
  ps aux
  ```

### 4. startx命令：初始化X-window系统

用法
```bash
startx [选项]
```

示例
- 启动X-window系统：
  ```bash
  startx
  ```

### 5. uname命令：显示系统内核信息

用法
```bash
uname [选项]
```

常用选项
- `-a`：显示所有系统信息。
- `-r`：显示内核版本。

示例
- 显示所有系统信息：
  ```bash
  uname -a
  ```

### 6. kill命令：杀死进程

用法
```bash
kill [选项] [进程号]
```

常用选项
- `-9`：强制杀死进程。

示例
- 杀死进程：
  ```bash
  kill -9 1234
  ```

### 7. resize2fs命令：同步文件系统容量到内核

用法
```bash
resize2fs [选项] [设备名]
```

常用选项
- `-f`：强制执行。

示例
- 同步文件系统容量：
  ```bash
  resize2fs /dev/sda1
  ```

### 8. useradd命令：创建并设置用户信息

用法
```bash
useradd [选项] [用户名]
```

常用选项
- `-m`：创建用户主目录。
- `-s`：指定用户登录shell。

示例
- 创建用户：
  ```bash
  useradd -m -s /bin/bash username
  ```


## Linux磁盘管理命令教程

### 1. df命令：显示磁盘空间使用量情况

用法
```bash
df [选项]
```

常用选项
- `-h`：以易读的格式（例如KB、MB、GB）显示信息。
- `-i`：显示inode信息。

示例
- 显示磁盘空间使用情况：
  ```bash
  df -h
  ```

### 2. fdisk命令：管理磁盘分区

用法
```bash
fdisk [选项] [设备名]
```

常用选项
- `-l`：列出所有分区表。

示例
- 列出所有分区：
  ```bash
  fdisk -l
  ```

### 3. lsblk命令：查看系统的磁盘使用情况

用法
```bash
lsblk
```

示例
- 显示所有块设备信息：
  ```bash
  lsblk
  ```

### 4. mkfs.ext4命令：对磁盘设备进行EXT4格式化

用法
```bash
mkfs.ext4 [选项] [设备名]
```

示例
- 格式化设备为EXT4文件系统：
  ```bash
  mkfs.ext4 /dev/sda1
  ```

### 5. vgextend命令：扩展卷组设备

用法
```bash
vgextend [卷组名] [物理卷设备]
```

示例
- 扩展卷组：
  ```bash
  vgextend vg0 /dev/sda2
  ```

### 6. hdparm命令：显示与设定硬盘参数

用法
```bash
hdparm [选项] [设备名]
```

常用选项
- `-i`：显示硬盘信息。
- `-Tt`：测试硬盘读取速度。

示例
- 显示硬盘信息：
  ```bash
  hdparm -i /dev/sda
  ```

### 7. pvcreate命令：创建物理卷设备

用法
```bash
pvcreate [设备名]
```

示例
- 创建物理卷：
  ```bash
  pvcreate /dev/sda2
  ```

### 8. lvcreate命令：创建逻辑卷设备

用法
```bash
lvcreate [选项] [卷组名] [逻辑卷名] [大小]
```

常用选项
- `-L`：指定逻辑卷大小。
- `-n`：指定逻辑卷名称。

示例
- 创建逻辑卷：
  ```bash
  lvcreate -L 10G -n mylv vg0
  ```


## Linux文件传输命令教程

### 1. tftp命令：上传及下载文件

用法
```bash
tftp [服务器地址]
```

示例
- 连接到TFTP服务器：
  ```bash
  tftp server_ip
  ```

### 2. curl命令：文件传输工具

用法
```bash
curl [选项] [URL]
```

常用选项
- `-O`：保存文件到当前目录。
- `-o`：指定文件保存路径。
- `-u`：提供用户名和密码。

示例
- 下载文件：
  ```bash
  curl -O http://example.com/file.zip
  ```

### 3. fsck命令：检查与修复文件系统

用法
```bash
fsck [选项] [设备名]
```

常用选项
- `-y`：自动修复文件系统错误。
- `-n`：不修复文件系统错误。

示例
- 检查并修复文件系统：
  ```bash
  fsck -y /dev/sda1
  ```

### 4. rsync命令：远程数据同步工具

用法
```bash
rsync [选项] [源] [目标]
```

常用选项
- `-a`：归档模式，保留文件属性。
- `-z`：压缩数据。
- `-v`：详细模式。

示例
- 同步目录：
  ```bash
  rsync -avz /source/ user@remote:/destination/
  ```

### 5. lprm命令：移除打印队列中的任务

用法
```bash
lprm [作业号]
```

示例
- 移除打印作业：
  ```bash
  lprm 123
  ```

### 6. ftpwho命令：显示FTP会话信息

用法
```bash
ftpwho
```

示例
- 显示FTP会话：
  ```bash
  ftpwho
  ```

### 7. ftp命令：文件传输协议客户端

用法
```bash
ftp [服务器地址]
```

示例
- 连接到FTP服务器：
  ```bash
  ftp server_ip
  ```

### 8. lftp命令：优秀的命令行FTP客户端

用法
```bash
lftp [选项] [服务器地址]
```

常用选项
- `-u`：提供用户名和密码。

示例
- 连接到FTP服务器：
  ```bash
  lftp -u username,password server_ip
  ```


## Linux网络通讯命令教程

### 1. ssh命令：安全的远程连接服务

用法
```bash
ssh [选项] [用户名]@[主机地址]
```

常用选项
- `-p`：指定远程服务器的端口号。
- `-i`：指定私钥文件。

示例
- 连接到远程服务器：
  ```bash
  ssh username@remote_host
  ```

### 2. netstat命令：显示网络状态

用法
```bash
netstat [选项]
```

常用选项
- `-a`：显示所有连接和侦听端口。
- `-n`：不解析服务名。
- `-p`：显示进程ID和名称。

示例
- 显示所有网络连接：
  ```bash
  netstat -an
  ```

### 3. dhclient命令：动态获取或释放IP地址

用法
```bash
dhclient [选项] [网络接口]
```

常用选项
- `-r`：释放当前的IP地址。
- `-v`：详细模式。

示例
- 获取IP地址：
  ```bash
  dhclient eth0
  ```

### 4. ifconfig命令：显示或设置网络设备参数信息（已过时，建议使用ip命令）

用法
```bash
ifconfig [网络接口] [选项]
```

常用选项
- `up`：激活网络接口。
- `down`：关闭网络接口。

示例
- 显示网络接口信息：
  ```bash
  ifconfig
  ```

### 5. ip命令：显示或操作路由、设备、策略路由和隧道（包括ip add命令）

用法
```bash
ip [选项] [参数]
```

常用选项
- `link`：显示或设置网络设备。
- `addr`：显示或设置网络设备的IP地址。

示例
- 显示网络接口信息：
  ```bash
  ip link show
  ```

### 6. ping命令：测试主机间网络连通性

用法
```bash
ping [选项] [主机地址]
```

常用选项
- `-c`：指定发送的ECHO_REQUEST数据包数量。
- `-t`：指定超时时间。

示例
- 测试网络连通性：
  ```bash
  ping google.com
  ```

### 7. sshd命令：openssh服务器守护进程

用法
```bash
sshd [选项]
```

示例
- 启动sshd服务：
  ```bash
  /usr/sbin/sshd
  ```

### 8. smbpasswd命令：修改用户的SMB密码

用法
```bash
smbpasswd [选项] [用户名]
```

常用选项
- `-a`：添加新用户。
- `-d`：禁用用户。

示例
- 修改用户密码：
  ```bash
  smbpasswd username
  ```

### 9. iptables命令：防火墙策略管理工具

用法
```bash
iptables [选项] [链] [规则]
```

常用选项
- `-A`：添加规则。
- `-D`：删除规则。

示例
- 添加防火墙规则：
  ```bash
  iptables -A INPUT -p tcp --dport 22 -j ACCEPT
  ```


## Linux设备管理命令教程

### 1. mount命令：将文件系统挂载到目录

用法
```bash
mount [选项] [设备名] [挂载点]
```

常用选项
- `-t`：指定文件系统类型。
- `-o`：指定挂载选项。

示例
- 挂载设备：
  ```bash
  mount /dev/sda1 /mnt
  ```

### 2. lspci命令：显示当前设备PCI总线设备信息

用法
```bash
lspci [选项]
```

常用选项
- `-v`：显示详细信息。

示例
- 显示PCI设备信息：
  ```bash
  lspci
  ```

### 3. sensors命令：检测服务器硬件信息

用法
```bash
sensors
```

示例
- 显示硬件信息：
  ```bash
  sensors
  ```

### 4. setleds命令：设置键盘的LED灯光状态

用法
```bash
setleds [选项] [状态]
```

常用选项
- `-L`：指定键盘LED。
- `-D`：禁用键盘LED。

示例
- 启用Caps Lock LED：
  ```bash
  setleds +capslock
  ```

### 5. rfkill命令：管理蓝牙和Wi-Fi设备

用法
```bash
rfkill [选项] [类型] [动作]
```

常用选项
- `list`：列出所有设备。
- `block`：禁用设备。
- `unblock`：启用设备。

示例
- 列出所有设备：
  ```bash
  rfkill list
  ```

### 6. setpci命令：配置PCI硬件设备参数

用法
```bash
setpci [选项] [设备]
```

常用选项
- `-v`：显示详细信息。
- `-s`：指定设备。

示例
- 配置PCI设备：
  ```bash
  setpci -s 00:00.0 COMMAND=0x100
  ```

### 7. hciconfig命令：配置蓝牙设备

用法
```bash
hciconfig [选项] [设备]
```

常用选项
- `up`：启用设备。
- `down`：禁用设备。

示例
- 启用蓝牙设备：
  ```bash
  hciconfig hci0 up
  ```

### 8. lsusb命令：显示USB设备列表

用法
```bash
lsusb [选项]
```

常用选项
- `-v`：显示详细信息。

示例
- 显示USB设备：
  ```bash
  lsusb
  ```


## Linux备份压缩命令教程

### 1. zip命令：压缩文件

用法
```bash
zip [选项] [压缩文件名] [文件或目录]
```

常用选项
- `-r`：递归地包含目录，也就是说，包括目录以及其内部的所有内容。
- `-q`：安静模式，不显示警告和提示信息。
- `-v`：详细模式，显示所有被压缩的文件。

示例
- 压缩目录：
  ```bash
  zip -r archive.zip directory/
  ```

### 2. gzip命令：压缩和解压文件

用法
```bash
gzip [选项] [文件名]
```

常用选项
- `-c`：压缩后保留原文件。
- `-d`：解压缩文件。
- `-l`：显示压缩文件列表。

示例
- 压缩文件：
  ```bash
  gzip file.txt
  ```
- 解压缩文件：
  ```bash
  gzip -d file.txt.gz
  ```

### 3. unzip命令：解压缩zip格式文件

用法
```bash
unzip [选项] [压缩文件名]
```

常用选项
- `-l`：列出压缩文件内容。
- `-o`：覆盖已存在的文件而不提示。
- `-q`：安静模式，不显示警告和提示信息。

示例
- 解压zip文件：
  ```bash
  unzip archive.zip
  ```

### 4. zipinfo命令：查看压缩文件信息

用法
```bash
zipinfo [选项] [压缩文件名]
```

常用选项
- `-1`：列出文件时按大小排序。
- `-z`：显示压缩文件的总大小。

示例
- 查看压缩文件信息：
  ```bash
  zipinfo archive.zip
  ```

### 5. gunzip命令：解压提取文件内容

用法
```bash
gunzip [选项] [压缩文件名]
```

常用选项
- `-c`：解压缩后保留原文件。

示例
- 解压gzip文件：
  ```bash
  gunzip file.txt.gz
  ```

### 6. unarj命令：解压.arj文件

用法
```bash
unarj [选项] [压缩文件名]
```

常用选项
- `x`：解压缩文件。
- `t`：列出压缩文件内容。

示例
- 解压arj文件：
  ```bash
  unarj x archive.arj
  ```

### 7. zipsplit命令：分割压缩包

用法
```bash
zipsplit [选项] [压缩文件名] [大小]
```

常用选项
- `-b`：指定分割大小。

示例
- 分割zip文件：
  ```bash
  zipsplit -b 10m archive.zip
  ```

### 8. dump命令：备份文件系统

用法
```bash
dump [选项] [级别] [设备名]
```

常用选项
- `0`：完整备份。
- `1`：增量备份。

示例
- 备份文件系统：
  ```bash
  dump 0uf /dev/sda1 /path/to/backup
  ```
