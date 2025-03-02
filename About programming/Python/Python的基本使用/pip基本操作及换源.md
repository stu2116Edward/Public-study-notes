# pip 镜像源换源方法以及 pip 基本操作

原文链接：https://blog.csdn.net/weixin_57950978/article/details/142653359  

### 一、临时换源
比如这里，下载某个包的时候临时将镜像源换成清华源
```
pip install <package_name> -i https://pypi.tuna.tsinghua.edu.cn/simple 
```
<package_name> 为要 pip安装的包

### 二、永久换源
通过命令修改配置文件来永久使用某个镜像源：
```
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```
#### Windows环境下手动替换镜像源：  
比如windows账号是 admin 找到配置文件**C:\users\admin\pip\pip.ini**
```
[global]
index-url=https://pypi.tuna.tsinghua.edu.cn/simple
[install]
trusted-host=pypi.tuna.tsinghua.edu.cn
disable-pip-version-check = true
timeout = 6000
```
参数说明：
- timeout = 6000
将 pip 的连接超时时间设置为 6000 秒，避免因网络延迟导致的连接失败  
- disable-pip-version-check = true
禁用 pip 的版本检查功能，减少运行时的网络请求，加快 pip 的执行速度
#### Linux 环境下手动替换镜像源：
同样比例账号为 admin 则需要建立子目录 **\home\admin\pip**; 并在此pip目录下建立内容同上的 **pip.conf**的位置文件  
```
cd ~
mkdir pip
cd pip
vim pip.ini
```
内容同windows环境下


### 三、重置镜像源
通过下面命令查看当前设置的镜像源：
```
pip config list
```
删除全局设置的镜像源:
```
pip config unset global.index-url
```
删除用户级别设置的镜像源:
```
pip config unset user.index-url
```

### 四、其他关于 pip 的操作和设置
检查 pip 的版本：
```
pip --version
```
更新 pip 本身：
```
pip install --upgrade pip
```
查看当前环境中已安装的所有包及其版本信息：
```
pip list
```
安装包与卸载包：  
安装:
```
pip install <package_name>
```
卸载:
```
pip uninstall <package_name>
```
删除当前环境的所有 pip 缓存：
```
pip cache purge
```
删除特定包的缓存：
```
pip cache remove <package_name>
```
希望安装特定版本的包，可以使用 == 语法：
```
pip install <package_name>==1.0.0
```
遇到下载不稳定时，可以设置超时时间：  
例如，将超时时间设置为 10 秒：
```
pip install <package_name> --timeout 10
```
将当前环境的包导出：
```
pip freeze > requirements.txt
```
从 requirements.txt 安装指定包：
```
pip install -r requirements.txt
```
自定义源时的信任设置：  
比如信任清华源：
```
pip install <package_name> --trusted-host pypi.tuna.tsinghua.edu.cn 
```

### 五、附录
下面这几个包往往都需要换源进行pip安装，经常会出现下载速度缓慢的情况…
<pre>
scikit_image
opnecv-python
numpy
numba
matplotlib
</pre>
有时候明明尝试换源了，但是还是很难下载安装对应的安装包，常见以下错误：  
**换源之后下载的包无法匹配其他依赖包:**  
<pre>
ERROR: Could not find a version that satisfies the requirement …
</pre>
**网络连接不上：**
<pre>
WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by ‘NewConnectionError(’<pip._vendor.urllib3.connection.HTTPSConnection object at 0x7f4248ebf7c0>: Failed to establish a new connection: [Errno 101] 网络不可达’)':…
</pre>
<pre>
raise ReadTimeoutError(self._pool, None, “Read timed out.”)
pip._vendor.urllib3.exceptions.ReadTimeoutError: HTTPSConnectionPool(host=‘files.pythonhosted.org’, port=443): Read timed out.
</pre>
**加载超时：**
<pre>
return self._sslobj.read(len, buffer)
socket.timeout: The read operation timed out
During handling of the above exception, another exception occurred:
Traceback (most recent call last):…
</pre>
可以尝试到官网手动下载安装： [Python Package官网](https://pypi.org/)  

比如搜索：numpy  
选择你想要的   
点击左侧的 Release history 选择发布的历史版本  
点击左侧 Download files 下载，然后根据需求下载对应的 whl 文件  
比如：这里选择 numpy1.19.5 ，然后python是3.9选择cp39后缀，然后是linux系统x86 架构则选择  
**numpy-1.19.5-cp39-cp39-manylinux2010_x86_64.whl**  
下载完成后，到对应的环境中使用pip install 命令即可  
```
pip install <package_name>.whl
```
