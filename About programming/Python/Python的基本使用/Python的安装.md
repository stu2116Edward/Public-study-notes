# Python安装教程


## Windows安装配置Python环境
参考：https://blog.csdn.net/maiya_yayaya/article/details/131450517

### 官网下载Python安装包
[Python官网](https://www.python.org/)
在下载页面可以看到很多不同版本的下载链接。其中，标记 **x86 的为 32 位安装包**，**x86-64 为 64 位安装包**。executable installer为完整的安装包，下载完即可安装；web-based installer 体积更小，但安装时仍需联网下载其他部分。一般网络不好时选择 **executable installer**，以保证安装过程不会中断  

确定操作系统的位数可通过以下操作：**右击此电脑 -> 点击属性 -> 查看位数；一般是64位**  

### python 版本简介
python 包括 python2、python3 两个大版本，其中 python3 改进了 python2 的一些不足，但由于以前很多应用是用 python2 开发的，维护这些应用还需用到 python2，故 python2 尚未被完全淘汰。  
此外，版本也不是越高越好，因为有的模块（库）不支持太高版本的 python  

### 安装Python
1. 双击下载的安装包，进入安装界面
2. 勾选 **Add Python 3.x to PATH**，这样可以将 Python 添加到环境变量中，方便在命令行中直接使用 python 命令
3. 点击 **Customize installation**，进入自定义安装界面
4. 点击 **Next**，进入下一步
5. 勾选 **Install for all users**，将 Python 安装到所有用户
6. 选择安装路径，点击 **Browse...**，选择安装路径，点击 **Install Now**，开始安装
7. 安装完成后，如下操作打开命令行：同时按 “Windows+R” -> 输入 “cmd” -> 点击确定
8. 输入 `python`，如果出现python版本信息说明安装成功
若没有则需要手动配置环境变量  
1. 右击此电脑 -> 单击属性
2. 点击左侧的"高级系统设置"
3. 点击 “环境变量”（有的电脑可能要手动选择上面的 “高级” 选项卡）
4. 单击选中系统变量中的"Path" -> 单击编辑
5. 打开 python 的安装路径（安装时设置的，目录下有python.exe文件的路径） -> 点击地址栏 -> “Ctrl+C” 复制路径
6. 在 “编辑环境变量” 选项卡 单击新建
7. 粘贴路径 -> 点击确定
我们可以看到 “用户变量” 与 “系统变量” 两种变量，两种变量的区别是：用户变量是对单一用户生效，系统变量对所有用户生效。如果电脑设置了多个用户，设置用户变量会使得安装软件只能供单一用户使用，设置系统变量则所有用户都能使用  

### python 多版本共存配置
由于特殊需要，我们可能要在一台电脑安装多个版本的 python。示例安装了 python2.7，顺便提一下，该安装包是"MSI installer"，这跟"executable installer"基本相同
安装完成 python2.7 后打开环境变量配置将python2.7的路径添加到环境变量中注意这里如果将python2.7的路径放到python3.x版本的上方那么系统会优先使用python2.7同理python3.x版本也是一样的

怎么进入 python3 呢？以 python2 为例，如下操作：
1. 打开 python2 目录 -> 复制 “python.exe” -> 直接粘贴，得到一个副本  
2. 将副本重命名为可区分的名字（此处为python2）
经过上述操作，在命令行键入"python2"即可进入 python2  
同样的步骤可以应用在 python3 及 不同版本的 pip 工具中


## Linux安装配置Python环境

### Ubuntu系统安装Python
查看所有已安装的 Python 版本:
```bash
ls /usr/bin/python*
```
或者
```bash
sudo find / -type f -name "python*" 2>/dev/null | grep -E "/python[0-9.]*$"
```
### 使用包管理器安装：
1. 在开始安装Python之前，确保你的Ubuntu系统是最新的:
```bash
sudo apt update
sudo apt upgrade
```
2. 安装Python 3.8：
```bash
sudo apt install python3.8
```
3. 查看已安装的Python版本：
```bash
python3 --version
```
安装Python 3.8的依赖库（可选）
```bash
sudo apt install python3-pip
```
安装对应版本的 pip:
```bash
sudo apt install python3.8-distutils
```

#### 设置默认Python版本（可选）  
使用软链接的方式设置默认Python版本：  
1. 检查是否存在旧的链接：
```bash
ls -l /usr/bin/python* | grep "python\|python3"
```
2. 如果存在旧的软链接，先备份旧链接：
```bash
sudo mv /usr/bin/python /usr/bin/python.bak
sudo mv /usr/bin/python3 /usr/bin/python3.bak
```
3. 删除旧的软链接：
```bash
sudo rm /usr/bin/python
sudo rm /usr/bin/python3
```
4. 创建新的软链接：
```bash
sudo ln -s /usr/bin/python3.8 /usr/bin/python3
sudo ln -s /usr/bin/python3.8 /usr/bin/python
```
5. 如果要恢复旧的软链接：
```bash
sudo mv /usr/bin/python.bak /usr/bin/python
sudo mv /usr/bin/python3.bak /usr/bin/python3
```
通过别名设置默认Python版本：  
1. 编辑`~/.bashrc`或`~/.profile`文件，添加以下内容：  
```bash
vim ~/.bashrc
```
2. 在文件的末尾添加以下内容：
```bash
alias python=/usr/bin/python3.8
```
3. 如果你想同时设置pip的默认版本，也可以添加：
```bash
alias pip=/usr/bin/pip3.8
```
**确保你希望优先生效的别名定义在文件的最后**  
4. 保存文件后，运行以下命令使更改生效：
```bash
source ~/.bashrc
```

### 使用源码编译安装：
众所周知， Ubuntu中自带 Python（有些只带 2有些只带 3，有些两个都带）  
我们首先查看一下当前系统自带的Python版本及指向：
```bash
ls -l /usr/bin | grep python
```
**下载Python安装包**  
下载链接：https://www.python.org/ftp/python/  
下载安装包这里以Python-3.8.5.tgz为例  
在Ubuntu里我们需要下载安装Python到自己指定的路径(这以~为例)  
进入安装包所在目录，执行以下命令：
```bash
sudo wget https://www.python.org/ftp/python/3.8.5/Python-3.8.5.tgz
```

**安装Python**
##### 默认安装路径:  
安装一下编译环境：
```bash
sudo apt-get install zlib1g-dev libbz2-dev libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev tk-dev libgdbm-dev libdb-dev libpcap-dev xz-utils libexpat1-dev liblzma-dev libffi-dev libc6-dev
```
解压安装包到当前目录下并且进入：
```bash
sudo tar -zxvf Python-3.8.5.tgz
cd Python-3.8.5
```
然后我们进行初始化：
```bash
sudo ./configure
```
先编译：
```bash
make
```
再安装：
```bash
sudo make altinstall
```
在终端输入：
```
python3.8 --version
```
> [!Note]
> 这时候Python已经安装完成，可执行文件在/usr/local/bin下，库文件在/usr/local/lib下，配置文件在/usr/local/include下，其他资源文件在/usr/local/share下，大家用Pycharm等编辑器使用Python时就用这些路径

##### 自定义安装路径：
安装一下编译环境：
```bash
sudo apt-get install zlib1g-dev libbz2-dev libssl-dev libncurses5-dev libsqlite3-dev libreadline-dev tk-dev libgdbm-dev libdb-dev libpcap-dev xz-utils libexpat1-dev liblzma-dev libffi-dev libc6-dev
```
这里按同样，解压安装包到当前目录下并且进入：
```bash
sudo tar -zxvf Python-3.8.5.tgz
cd Python-3.8.5
```
然后我们进行和方法一不一样的初始化：
```bash
sudo ./configure --prefix=/usr/local/python3.8.5
```
> [!Note]
> 解释：--prefix后面的参数为指定安装路径
注意：如果这里初始化有问题则与方法一的解决方式一样

后面和上面方法一安装过程一样，完成后再编译测试安装：  
先编译：
```bash
make
```
再安装：
```bash
sudo make altinstall
```
然后我们需要添加一下环境变量  
为了使环境变量永久生效，可以将其添加到 **~/.bashrc** 或 **~/.profile** 文件中：
```bash
vim ~/.bashrc
```
添加如下内容
```bash
PATH=$PATH:$HOME/bin:/usr/local/python3.8.5/bin
```
让环境变量生效
```bash
source ~/.bashrc
```
好了，安装完了（大家可以输入：echo $PATH 查看一下环境变量有没有添加进去）  

#### 更新命令‘python’默认指向为我们所安装的版本
我们回到本文最开头的查看Python指向命令:
```bash
ls -l /usr/bin | grep python
```
现在有两种情况：
1. 你安装的是对应你这个系统的Python当前版本号
2. 你安装的是其他Python版本号

> [!Note]
> 什么是Python当前版本号，什么是其他版本号？
> 我们输入命令：python3 对应的版本为python3.6.9，那么，我们安装的版本如果是python3.6.11，或者是python3.6.5啥的，只要是在这个3.6的版本内就是当前版本号，本文安装的版本号为3.8，所以安装的是其他版本号

#### 创建软链接：  
因为我们安装的Python3.8是不同于系统自带python的版本号，不在/usr/bin下而在/usr/local/bin或者/usr/local/python3.8.5/bin下（取决于前面执行的是./configure还是./configure --prefix=/usr/local/python3.8.5，因此需要先加一条软链接并且把之前的python命令改为python.bak，同时pip也需要更改  

若Python3.8安装时，执行的是`./configure`，则依次输入：  
将原python与python3命令改为python.bak与python.bak：
```bash
sudo mv /usr/bin/python /usr/bin/python.bak
sudo mv /usr/bin/python3 /usr/bin/python3.bak
```
将我们刚装的python3.8.5指定运行命令为python与python3:
```bash
sudo ln -s /usr/local/bin/python3.8 /usr/bin/python
sudo ln -s /usr/local/bin/python3.8 /usr/bin/python3
```
将原pip和pip3命令改为pip.bak与pip3.bak:
```bash
sudo mv /usr/bin/pip /usr/bin/pip.bak
sudo mv /usr/bin/pip3 /usr/bin/pip3.bak
```
将我们刚装的python3.8.5的pip指定运行命令为pip与pip3:
```bash
sudo ln -s /usr/local/bin/pip3.8 /usr/bin/pip
sudo ln -s /usr/local/bin/pip3.8 /usr/bin/pip3
```

> [!Note]
> 如果你的系统不自带Python2，则第一句与第五句命令会报错，或者你的系统不自带Python3，则第二句与第六句命令会报错，pip也一样，这是正常的，不用理会，报错内容如下（报错意思其实就是你没有这个）：
上面的思路梳理一下：
更改完成之后，现在输入python或者是python3将会指向python3.8.5
输入python.bak或者是python3.bak将会分别指向系统自带的python2与python3
输入pip或者是pip3将会指向python3.8.5的将会指向pip

若Python3.8安装时，执行的是`./configure --prefix=/usr/local/python3.8.5`（自定义安装路径），则依次输入：
将原python与python3命令改为python.bak与python.bak:
```bash
sudo mv /usr/bin/python /usr/bin/python.bak
sudo mv /usr/bin/python3 /usr/bin/python3.bak
```
将我们刚装的python3.8.5指定运行命令为python与python3:
```bash
sudo ln -s /usr/local/python3.8.5/bin/python3.8 /usr/bin/python
sudo ln -s /usr/local/python3.8.5/bin/python3.8 /usr/bin/python3
```
将原pip和pip3命令改为pip.bak与pip3.bak:
```bash
sudo mv /usr/bin/pip /usr/bin/pip.bak
sudo mv /usr/bin/pip3 /usr/bin/pip3.bak
```
将我们刚装的python3.8.5的pip指定运行命令为pip与pip3:
```bash
sudo ln -s /usr/local/python3.8.5/bin/pip3.8 /usr/bin/pip
sudo ln -s /usr/local/python3.8.5/bin/pip3.8 /usr/bin/pip3
```

### Ubuntu卸载Python
#### 卸载Python软件包版本
1. 卸载Python 3.8及其依赖包：
```bash
sudo apt purge python3.8
```
2. 清理不再需要的依赖包
```bash
sudo apt autoremove -y
```
3. 更新包列表
```bash
sudo apt update
```
处理可能出现的错误:  
**解决 needrestart 和 dpkg 错误(一般在重装时候出现)**:
如果出现类似错误：
<pre>
installed python3.8 package post-installation script subprocess returned error exit status 127
Errors were encountered while processing:
 python3.8
needrestart is being skipped since dpkg has failed
E: Sub-process /usr/bin/dpkg returned an error code (1)
</pre>
可以尝试以下方法:  
修复损坏的包
```bash
sudo apt --fix-broken install
```
重新配置 dpkg
```bash
sudo dpkg --configure -a
```
强制移除损坏的包
```bash
sudo dpkg --remove --force-remove-reinstreq python3.8
```
手动删除残留文件
```bash
sudo rm -rf /usr/bin/python3.8
sudo rm -rf /usr/lib/python3.8
sudo rm -rf /usr/local/lib/python3.8
sudo rm -rf /usr/local/bin/python3.8
```
清理不再需要的依赖包
```bash
sudo apt autoremove -y
```
清理缓存
```bash
sudo apt clean
```
更新包列表
```bash
sudo apt update
```
验证是否卸载成功
```bash
python3.8 --version
```

#### 卸载源码编译安装的Python
1. **确定安装路径**
首先，你需要确定 Python 的安装路径。如果你在安装时使用了 `--prefix` 参数（例如 `--prefix=/usr/local/python3.8.5`），那么 Python 的安装路径就是你指定的路径。如果没有指定 `--prefix`，默认安装路径通常是 `/usr/local`。

2. **删除 Python 的可执行文件和相关文件**
根据你的安装路径，删除 Python 的可执行文件和相关文件。以下是一些常见的文件和目录：

如果安装路径是 `/usr/local`：
```bash
sudo rm /usr/local/bin/python3.8
sudo rm /usr/local/bin/pip3.8
sudo rm /usr/local/bin/pydoc3.8
sudo rm /usr/local/bin/idle3.8
sudo rm /usr/local/bin/2to3-3.8
sudo rm /usr/local/bin/easy_install-3.8
```

如果安装路径是自定义路径（例如 `/usr/local/python3.8.5`）：
```bash
sudo rm /usr/local/python3.8.5/bin/python3.8
sudo rm /usr/local/python3.8.5/bin/pip3.8
sudo rm /usr/local/python3.8.5/bin/pydoc3.8
sudo rm /usr/local/python3.8.5/bin/idle3.8
sudo rm /usr/local/python3.8.5/bin/2to3-3.8
sudo rm /usr/local/python3.8.5/bin/easy_install-3.8
```

3. **删除 Python 的库文件**
Python 的库文件通常安装在 `/usr/local/lib` 或自定义路径的 `lib` 目录下。你可以删除这些文件：

如果安装路径是 `/usr/local`：
```bash
sudo rm -rf /usr/local/lib/python3.8
```

如果安装路径是自定义路径：
```bash
sudo rm -rf /usr/local/python3.8.5/lib/python3.8
```

4. **删除 Python 的配置文件**
Python 的配置文件通常在 `/usr/local/include` 或自定义路径的 `include` 目录下。删除这些文件：

如果安装路径是 `/usr/local`：
```bash
sudo rm -rf /usr/local/include/python3.8
```

如果安装路径是自定义路径：
```bash
sudo rm -rf /usr/local/python3.8.5/include/python3.8
```

5. **删除 Python 的其他资源文件**
Python 的其他资源文件（如文档、示例代码等）通常在 `/usr/local/share` 或自定义路径的 `share` 目录下。删除这些文件：

如果安装路径是 `/usr/local`：
```bash
sudo rm -rf /usr/local/share/man/man1/python3.8.1
```

如果安装路径是自定义路径：
```bash
sudo rm -rf /usr/local/python3.8.5/share/man/man1/python3.8.1
```

6. **删除安装目录（如果适用）**
如果你在安装时解压了源码到某个目录（例如 `~/Python-3.8.5`），可以删除这个目录：
```bash
rm -rf ~/Python-3.8.5
```

7. **清理环境变量**
如果你在安装时修改了环境变量（例如在 `~/.bashrc` 或 `~/.profile` 文件中添加了路径），需要删除这些路径。打开文件并删除相关行：
```bash
vim ~/.bashrc
```
删除类似以下的内容：
```bash
PATH=$PATH:$HOME/bin:/usr/local/python3.8.5/bin
```

然后重新加载配置文件：
```bash
source ~/.bashrc
```

8. **恢复默认的 Python 指向（如果需要）**
如果你之前更改了 `/usr/bin/python` 或 `/usr/bin/python3` 的指向，可以恢复默认指向：
```bash
sudo mv /usr/bin/python.bak /usr/bin/python
sudo mv /usr/bin/python3.bak /usr/bin/python3
sudo mv /usr/bin/pip.bak /usr/bin/pip
sudo mv /usr/bin/pip3.bak /usr/bin/pip3
```

9. **验证卸载**
最后，验证 Python 是否已完全卸载：
```bash
python3.8 --version
```
如果返回 `command not found`，则说明卸载成功。

**注意事项**  
1. **备份重要数据**：在删除任何文件之前，建议备份重要数据。
2. **不要删除系统自带的 Python**：系统自带的 Python 是系统运行的一部分，不要删除它。
3. **谨慎操作**：使用 `rm -rf` 命令时要非常小心，避免误删其他重要文件。



### Centos系统安装Python
查看当前存在的Python可执行文件路径：
```bash
sudo find / -name "python*" -type f -executable
```
其中`/usr/bin`和`/usr/local`一般为Python的安装目录  
如果出现类似报错：
<pre>
Package openssl11 was not found in the pkg-config search path.
Perhaps you should add the directory containing `openssl11.pc'
to the PKG_CONFIG_PATH environment variable
No package 'openssl11' found
Package openssl11 was not found in the pkg-config search path.
Perhaps you should add the directory containing `openssl11.pc'
to the PKG_CONFIG_PATH environment variable
No package 'openssl11' found
</pre>
则安装 openssl11 和相关开发包：
```bash
sudo yum install -y epel-release
sudo yum install -y openssl11 openssl11-devel
```

#### 通过 yum 或 dnf 安装 Python 3
1. 查看当前系统环境
```bash
cat /etc/os-release
```
2. 安装 Python3:
CentOS 7：
```bash
sudo yum install python3 -y
```
CentOS 8：
```bash
sudo dnf install python3 -y
```
3. 验证安装
```bash
python3 -V
pip3 -V
```
4. 配置 PIP 镜像
```bash
sudo vim /etc/pip.conf
```
在文件中添加以下内容：
```bash
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host = mirrors.aliyun.com
```
5. 创建软链接（可选）
```bash
sudo ln -s /usr/bin/python3 /usr/bin/python
sudo ln -s /usr/bin/pip3 /usr/bin/pip
```

#### 通过源码包安装Python
1. 查看当前系统环境
查看当前系统环境是否为Centos7
```bash
cat /etc/os-release
```

2. 执行如下命令，查看当前Python环境
```bash
python --version
```
Centos是自带python2的，这是yum等系统工具的依赖，请勿卸载  

3. 安装Python相关核心库
更新仓库
```bash
sudo yum update
```
清理并重新生成缓存
```bash
sudo yum clean all
sudo yum makecache
```
执行如下命令安安装python所需依赖
```bash
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make libffi-devel
```

4. 下载linux系统的Python3源码压缩包并解压  
进入[Python源码包官网](https://www.python.org/downloads/release/python-3123/)点击`Gzipped source tarball`下载python3源码压缩包  
然后将该压缩包放到Centos系统的`home目录`下  
```bash
cd /usr/local
```
```bash
sudo wget https://www.python.org/ftp/python/3.12.3/Python-3.12.3.tgz
```
然后使用cd命令进入到home目录下，执行如下命令将压缩包解压  
```bash
tar -zxvf Python-3.12.3.tgz
```

5. 检测并配置Python编译环境
进入到才解压后的Python3.12.3的目录中，执行如下命令检测并配置Python编译环境【提示：如果是重新配置，需先在Python3.12.3目录下执行make clean】  
当前在home目录
```bash
cd Python-3.12.3
```
配置Python编译环境  
将 Python 安装到系统目录：
```bash
sudo ./configure prefix=/usr/local/python3.12.3
```
编译并安装Python
```bash
make
sudo make altinstall
```
小提示：之所以使用`make altinstall`是因为相较于 `make install`，可以避免与系统中已有的默认 Python 版本冲突  

6. 配置环境变量
**全局环境变量配置**  
```bash
vim /etc/profile
```
在文件末尾添加以下内容：
```bash
export PATH="/usr/local/python3.12.3/bin:$PATH"
```
运行以下命令使更改生效：
```bash
source /etc/profile
```

**用户环境变量配置**  
执行如下命令开始配置环境变量
```bash
vim ~/.bashrc
```
在文件末尾添加以下内容
```bash
export PATH="/usr/local/python3.12.3/bin:$PATH"
```
执行如下命令，使新配置的环境立即生效
```bash
source ~/.bashrc
```
验证环境变量配置
```bash
which python3.12
```
如果输出类似以下内容，则说明配置成功：
<pre>
/usr/local/python3/bin/python3.12
</pre>
你还可以运行以下命令验证 Python 版本：
```bash
python3.12 --version
```

7. 创建软链接(可选)
如果已经存在python3.6的版本的软链接但是想要使用python3.12版本：  
先删除python3的软链接
```bash
rm -rf /usr/bin/python3
```
再执行下面的命令  
如果你希望直接使用 python3 和 pip3 命令，可以创建软链接：
```bash
sudo ln -s /usr/local/python3.12.3/bin/python3.12 /usr/bin/python3
sudo ln -s /usr/local/python3.12.3/bin/pip3.12 /usr/bin/pip3
```

8. 验证Python环境
执行以下命令来验证python3的环境是否安装配置成功
```bash
python3 -V
```
```bash
pip3 -V
```

9. 配置PIP镜像
默认的pip在国内下载库很慢，因此配置pip镜像是必要的，进入/etc目录，执行如下命令创建编辑pip.conf文件
```bash
sudo vim /etc/pip.conf
```
加入如下内容保存即可
```bash
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
​
[install]
trusted-host = mirrors.aliyun.com
```

### Centos卸载Python
#### **卸载通过包管理器安装的 Python**：  
1. 如果你是通过 yum 或 dnf 安装的 Python，可以使用以下命令卸载：
```bash
rpm -qa | grep python3
```
输出示例：
<pre>
python3-3.6.8-18.el7.x86_64
</pre>
2. 使用 yum 或 dnf 卸载：
```bash
sudo yum remove python3-3.6.8-18.el7.x86_64
```
将`python3-3.6.8-18.el7.x86_64`替换为你的 Python 包名  
或者(CentOS 8 或更高版本)：
```bash
sudo dnf remove python3-3.6.8-18.el7.x86_64
```
3. 验证卸载
检查 Python 3 是否已卸载
```bash
python3 -V
```
检查 Python 3 的可执行文件是否已删除
```bash
which python3
```

#### **卸载手动安装的 Python**：  
如果你需要卸载 Python 3.12.3，可以按照以下步骤进行：  
1. 删除 Python 安装目录
```bash
sudo rm -rf /usr/local/python3.12
```
2. 清理环境变量
```bash
vim ~/.bashrc
```
删除以下内容：
```bash
export PATH=/usr/local/python3.12/bin:$PATH
```
使更改生效：
```bash
source ~/.bashrc
```
3. 删除软链接
如果创建了软链接（如 /usr/bin/python3），需要手动删除：
```bash
sudo rm /usr/bin/python3
```
4. 验证卸载
检查 Python 3 是否已卸载
```bash
python3 -V
```
检查 Python 3 的可执行文件是否已删除
```bash
which python3
```
