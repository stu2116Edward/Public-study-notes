# Linux下七种文件类型、文件属性及其查看方法

## 七种文件类型

在Linux系统中，文件类型可以通过文件属性的第一个字符来区分。以下是七种基本的文件类型及其属性标识：

### 普通文件
- **属性标识**：`-`
- **描述**：这是Linux中最多的一种文件类型，包括纯文本文件（ASCII）、二进制文件（binary）、数据格式的文件（data）以及各种压缩文件。

### 目录文件
- **属性标识**：`d`
- **描述**：目录文件，即文件夹，可以使用`cd`命令进入，包含其他文件和子目录。

### 块设备文件
- **属性标识**：`b`
- **描述**：块设备文件，通常是指硬盘设备，例如`/dev/sda`等，用于存储数据供系统存取。

### 字符设备文件
- **属性标识**：`c`
- **描述**：字符设备文件，如键盘、鼠标等，通过串行端口与计算机通信。

### 套接字文件
- **属性标识**：`s`
- **描述**：用于网络通信的文件类型，允许数据在不同程序间传输，通常用于网络服务监听。

### 管道文件（FIFO）
- **属性标识**：`p`
- **描述**：先进先出的命名管道，用于进程间通信，解决多个程序同时存取一个文件所造成的错误。

### 链接文件
- **属性标识**：`l`
- **描述**：类似于Windows下的快捷方式，硬链接或符号链接，指向另一个文件的引用。


## 查看文件类型的三种方法

### 方法一：使用`ls`命令
- **命令**：`ls -l` 或 `ll`
  - `ls -l`：列出包括文件类型、权限、所有者等详细信息的目录内容。
  - `ls -ld`：列出指定目录的详细信息，包括目录的类型和属性。
- **示例**：
```bash
ll anaconda-ks.cfg                       // 查看第一个字符确定文件类型
-rw-------. 1 root root 2460 6月 1 23:37 anaconda-ks.cfg
```
在这个示例中，`-`表示`anaconda-ks.cfg`是一个普通文件。
```bash
ls -ld /etc
drwxr-xr-x. 81 root root 4096 Jan 29 03:25 /etc
```
在这个示例中，`d`表示`/etc`是一个目录文件。

### 方法二：使用`file`命令
- **命令**：`file` 文件名
  - 这个命令用于确定文件的类型，根据文件内容而不是文件名。
- **示例**：
```bash
file a.txt
```
输出可能是：
```
a.txt: ASCII text
```
这表明`a.txt`是一个ASCII文本文件。

### 方法三：使用`stat`命令
- **命令**：`stat` 文件名
  - 这个命令显示文件的详细属性，包括文件大小、块大小、IO块大小、文件类型、设备编号、inode编号、链接数、权限、所有者ID、组ID以及文件的访问、修改和状态改变时间。
- **示例**：
```bash
stat a.txt
```
输出可能是：
```
File: `a.txt'
Size: 3               Blocks: 8          IO Block: 4096   regular file
Device: 803h/2051d      Inode: 544365      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/root)   Gid: (    0/root)
Access: 2018-01-28 20:56:01.965885036 +0800
Modify: 2018-01-28 20:55:27.181876154 +0800
Change: 2018-01-28 20:55:27.181876154 +0800
```
在这个示例中，`regular file`表明`a.txt`是一个普通文件。`Access`、`Modify`和`Change`时间分别表示文件的最后访问时间、最后修改时间和状态最后改变时间。


## Linux中文件扩展名

## 3. Linux中文件扩展名

在Linux系统中，文件扩展名用于帮助用户和程序识别文件类型。虽然Linux不依赖扩展名来确定文件类型，但它们在实践中被广泛使用以提高可读性和兼容性。以下是Linux中常见的文件扩展名及其对应的文件类型：

### 压缩文件
- **.tar**、**.tar.gz**、**.tgz**、**.zip**、**.tar.bz2**：表示压缩文件，通常使用`tar`、`gzip`、`zip`、`bzip2`等命令创建和解压。

### 脚本文件
- **.sh**：表示Shell脚本文件，通过Shell语言开发的程序。
- **.pl**：表示Perl语言文件，通过Perl语言开发的程序。
- **.py**：表示Python语言文件，通过Python语言开发的程序。

### 网页文件
- **.html**、**.htm**：表示HTML文档，用于网页内容的标记语言。
- **.php**：表示PHP脚本文件，通常用于服务器端的网页编程。
- **.jsp**：表示Java Server Pages文件，用于Java Web应用。
- **.do**：表示Apache服务器配置文件中的指令块。

### 配置文件
- **.conf**：表示系统服务的配置文件。
- **.yaml**、**.yml**：表示YAML配置文件，YAML是一种用于配置文件的人友好的数据序列化标准。

### 安装包文件
- **.rpm**：表示RPM安装包文件，用于Red Hat系列Linux系统的软件包管理。
- **.deb**：表示Debian软件包文件，用于Debian和Ubuntu系列Linux系统的软件包管理。

### 其他常见文件扩展名
- **.txt**：表示纯文本文件。
- **.log**：表示日志文件，记录系统或应用程序的运行信息。
- **.cfg** 或 **.config**：表示配置文件，用于各种应用程序的设置。
- **.bin**：表示二进制文件，可能包含可执行程序或其他二进制数据。
- **.jar**：表示Java Archive文件，用于存储Java应用程序的类文件和相关资源。
- **.iso**：表示光盘映像文件，可以被刻录到CD/DVD或作为虚拟光驱使用。
- **.doc** 或 **.docx**：表示Microsoft Word文档。
- **.xls** 或 **.xlsx**：表示Microsoft Excel电子表格。
- **.ppt** 或 **.pptx**：表示Microsoft PowerPoint演示文稿。
- **.csv**：表示逗号分隔值文件，常用于数据存储和交换。


## 文件属性
## 4. 文件属性

在Linux系统中，文件属性提供了关于文件的详细信息，包括文件类型、权限、所有者、大小和时间戳等。以下是如何查看和解释文件属性的方法：

### 使用`ls -lhi`命令查看文件属性

`ls -lhi`命令以易于阅读的格式显示文件的属性，包括文件大小（以人类可读的方式）、文件类型和权限、所有者和组、以及文件的最后修改时间
```bash
ls -lhi
```
- **示例输出**：
<pre>
total 90K
    12 dr-xr-xr-x.  2 root root 4.0K Jan 28 18:30 bin
     2 dr-xr-xr-x.  5 root root 1.0K Aug  7  2016 boot
     4 drwxr-xr-x. 18 root root 3.7K Jan 29 01:29 dev
652802 drwxr-xr-x. 81 root root 4.0K Jan 29 03:25 etc
130563 drwxr-xr-x.  3 root root 4.0K Jan 29 00:57 home
    13 dr-xr-xr-x. 12 root root 4.0K Jan 28 18:30 lib
391685 dr-xr-xr-x.  9 root root  12K Jan 28 18:30 lib64
    11 drwx------.  2 root root  16K Aug  7  2016 lost+found
130564 drwxr-xr-x.  2 root root 4.0K Sep 23  2011 media
391689 drwxr-xr-x.  2 root root 4.0K Sep 23  2011 mnt
130565 drwxr-xr-x.  3 root root 4.0K Aug  7  2016 opt
     1 dr-xr-xr-x. 97 root root    0 Jan 29  2018 proc
391682 dr-xr-x---.  2 root root 4.0K Jan 28 21:08 root
130566 dr-xr-xr-x.  2 root root  12K Jan 28 18:30 sbin
     1 drwxr-xr-x.  7 root root    0 Jan 29  2018 selinux
    15 drwxr-xr-x.  2 root root 4.0K Sep 23  2011 srv
     1 drwxr-xr-x. 13 root root    0 Jan 29  2018 sys
522242 drwxrwxrwt.  5 root root 4.0K Jan 29 05:15 tmp
522244 drwxr-xr-x. 14 root root 4.0K Jan 28 20:04 usr
261121 drwxr-xr-x. 20 root root 4.0K Aug  7  2016 var
</pre>

<pre>
544365 -rw-r–r–. 1 root root 3 Jan 28 20:55 a.txt
</pre>

### 文件属性详解
- node 索引节点编号：544365
- 文件类型 ：文件类型是’-',表示这是一个普通文件
- 文件权限：rw-r–r-- 表示文件可读、可写、可执行，文件所归属的用户组可读可执行，其他用户可读可执行
- 硬链接个数 表示a.txt这个文件没有其他的硬链接，因为连接数是1，就是他本身
- 文件属主 表示这个文件所属的用户，这里的意思是a.txt文件被root用户拥有，是第一个root
- 文件属组 表示这个文件所属的用户组，这里表示a.txt文件属于root用户组，是第二个root
- 文件大小 文件大小是3个字节
- 文件修改时间 这里的时间是该文件最后被更新（包括文件创建、内容更新、文件名更新等）的时间可用如下命令查看文件的修改、访问、创建时间


### 使用`stat`命令查看文件属性

`stat`命令提供了文件的详细属性，包括文件大小、块大小、IO块大小、文件类型、设备编号、inode编号、链接数、权限、所有者ID、组ID以及文件的访问、修改和状态改变时间
```bash
stat a.txt
```
- **示例输出**：
<pre>
File: `a.txt'
  Size: 3               Blocks: 8          IO Block: 4096   regular file
Device: 803h/2051d      Inode: 544365      Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2018-01-28 20:56:01.965885036 +0800       ----------访问时间
Modify: 2018-01-28 20:55:27.181876154 +0800       ----------修改时间
Change: 2018-01-28 20:55:27.181876154 +0800     ----------创建时间
</pre>


### Inode索引节点

在Linux文件系统中，inode（索引节点）扮演着至关重要的角色。以下是关于inode的详细信息和如何通过文件名访问inode和block的过程：  

Inode的作用:  
当您对硬盘进行分区、格式化并创建文件系统时，磁盘被分为两个主要部分：inode和block  
- **block**：用于存储实际的数据内容，例如文档、图片、视频等文件数据
- **inode**：用于存储文件的元数据，包括文件大小、属主、所属用户组、读写权限、文件类型、修改时间等。这些信息对应于`ls -l`命令的输出结果

Inode包含的属性信息:
- 文件大小
- 文件属主（所有者）
- 归属的用户组
- 读写权限
- 文件类型
- 修改时间
- 指向文件实体指针的功能，即inode节点到block的对应关系

需要注意的是，inode中**不包含文件名**  

访问文件的过程:  
访问一个文件的过程涉及通过文件名找到对应的inode，然后通过inode找到存储文件数据的block  
1. **通过文件名找到inode**：文件系统通过文件名和目录结构查找对应的inode  
```bash
stat <文件名>
```
例如，如果您想查看a.txt文件的inode信息，您可以使用：
```bash
stat a.txt
```

2. **通过inode找到block**：一旦找到inode，文件系统就可以通过inode中的指针找到实际存储文件数据的block  
这个过程确保了文件数据的快速访问和检索  
记录下stat命令输出中的inode编号  
使用debugfs命令进入交互模式：
```bash
debugfs /dev/sda1
```
在debugfs的提示下，使用ic命令来查看特定inode的详细信息：
```bash
ic <inode编号>
```
这将显示inode的详细信息，包括文件的大小、权限、所有者、组、以及指向文件数据的block列表  

如果您的系统中没有 debugfs，您可以通过包管理器来安装它  
在 Ubuntu 中安装 debugfs：
```bash
sudo apt update
sudo apt install e2fsprogs
```
在 CentOS 中安装 debugfs
```bash
sudo yum install e2fsprogs
```
或者，如果您使用的是较新的 CentOS 版本，可能需要使用 dnf：
```bash
sudo dnf install e2fsprogs
```

#### 查看inode大小的命令
要查看inode的大小，您可以使用以下命令：
```bash
dumpe2fs /dev/sda1 | grep -i "Inode size"
```
这条命令的输出结果为：
<pre>
dumpe2fs 1.41.12 (17-May-2010)
Inode size:               128
</pre>
这表明在您的文件系统中，每个inode占用128字节的空间。
