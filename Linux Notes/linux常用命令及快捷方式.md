# 常用命令及快捷方式

在可视化的Ubuntu或者Redhat等操作系统中无法使用快捷键打开终端窗口的解决方法  
在右上角电源处选择设置  
点击键盘  
名称自定义  
比如：
`Run a terminal`
add cmd：
`/usr/bin/gnome-terminal`
添加快捷方式：`Ctrl + Shift + T`


## 基本操作

### 文件和目录操作

- 创建多个文件：
  ```bash
  touch file1 file2 file3...
  ```
- 创建多个文件夹：
  ```bash
  mkdir folder1 folder2 folder3...
  ```
- 查看所有用户：
  ```bash
  vim /etc/passwd
  ```
- 下载文件：
  ```bash
  wget [网址]
  ```
- 拷贝文件到目录：
  ```bash
  cp /root/test.txt ~root/
  ```
- 拷贝文件到文件夹并重命名：
  ```bash
  cp /root/桌面/test.txt ~root/tests.txt
  ```
- 拷贝文件夹：
  ```bash
  cp -r /root/[目录名] ~root/
  ```
- 拷贝文件保留属性：
  ```bash
  cp -p /root/[目录名] ~root/
  ```
- 移动文件或文件夹：
  ```bash
  mv /root/桌面/[文件名|文件夹名] ~root/
  ```
- 重命名文件：
  ```bash
  mv [旧文件名] [新文件名]
  ```
- 删除文件：
  ```bash
  rm -rf *.txt
  ```

### 压缩和解压

- 打包文件：
  ```bash
  tar -cf [打包后的文件名] [路径|文件名]
  ```
- 查看打包文件内容：
  ```bash
  tar -tf [打包的文件名]
  ```
- 添加文件到打包文件：
  ```bash
  tar -f [打包的文件名] -r [新文件]
  ```
- 解压文件：
  ```bash
  tar -xf [打包的文件名]
  ```
- 压缩文件：
  ```bash
  gzip [文件名]
  ```
- 解压文件：
  ```bash
  gzip -d [文件名]
  ```
- 解压并解包：
  ```bash
  tar -zxf [打包的文件名]
  ```

### 链接

- 创建硬链接：
  ```bash
  ln [源文件] [目标文件]
  ```

### 查看文件内容

- 查看文件内容：
  ```bash
  cat [文件名]
  ```
- 分页查看文件内容：
  ```bash
  less [文件名]
  ```
- 查看文件前十行：
  ```bash
  head -n 10 [文件名]
  ```
- 查看文件后十行：
  ```bash
  tail -n 10 [文件名]
  ```

### 查找文件

- 查找文件：
  ```bash
  find / -name [文件名]
  ```
- 查找UID大于1001的文件：
  ```bash
  find / -uid +1001
  ```
- 查找从属组为kali的文件：
  ```bash
  find / -group kali
  ```
- 查找三天内修改的文件：
  ```bash
  find / -mtime -3 -ls
  ```
- 查找小于3k的文件：
  ```bash
  find / -size -3k -ls
  ```
- 查找用户是root的文件和属性：
  ```bash
  find / -user root -ls
  ```

### 重定向

- 覆盖文件内容：
  ```bash
  > [文件名]
  ```
- 追加文件内容：
  ```bash
  >> [文件名]
  ```
- 将正确输出重定向：
  ```bash
  1> [文件名]
  ```
- 将错误输出重定向：
  ```bash
  2> [文件名]
  ```
- 标准输入流：
  ```bash
  0>
  ```

## 系统管理

### 网络配置

- 移除网络接口的IP地址：
  ```bash
  sudo ip addr del <ip>/<mask> dev <interface>
  ```

### 包管理

- Kali Linux升级apt换源：
  ```bash
  apt-get update && apt-get upgrade
  ```

### 文件完整性验证

- 查看当前文件夹下所有文件总大小：
  ```bash
  du -sh
  ```
- 查看当前文件夹下指定文件的大小：
  ```bash
  du -sh <文件名>
  ```

### 快捷键设置

- 在Ubuntu或Redhat等操作系统中无法使用快捷键打开终端窗口的解决方法：
  1. 在右上角电源处选择设置
  2. 点击键盘
  3. 名称自定义
  4. 比如：`Run a terminal`
  5. 添加命令：`/usr/bin/gnome-terminal`
  6. 添加快捷方式：`Ctrl + Shift + T`

### 编辑器设置

- 在编辑器中显示行号：
  ```bash
  vim <文件名>
  ```
  ```bash
  :set nu
  ```
