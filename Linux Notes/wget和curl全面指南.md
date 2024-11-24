# wget和curl全面指南

在网络开发、系统管理和自动化脚本中，wget 和 curl 是两个不可或缺的命令行工具。它们允许用户通过命令行接口与各种网络资源进行交互。这篇博客将深入探讨这两个工具，比较它们的功能、用法，并通过具体的示例展示如何在实际工作中使用它们  

## 一、什么是 wget 和 curl?

### wget 简介
wget 是一个免费的命令行工具，用于从网络下载文件。wget 的名字来源于 “World Wide Web” 与 “get” 的组合。这个工具可以通过 HTTP、HTTPS 和 FTP 协议从网络服务器下载文件，并且能够自动处理下载中断和继续下载  
wget 的一个显著特点是它的递归下载功能，这意味着它可以下载整个网站的内容并保持站点的结构。这在需要备份网站或下载静态资源时非常有用  

### curl 简介
curl 是一个用来传输数据的命令行工具。与 wget 不同，curl 更侧重于发送请求和获取数据，它支持许多协议，如 HTTP、HTTPS、FTP、SFTP、SMTP、POP3 等。curl 的名字来源于 “Client for URLs”，反映了它的主要功能是与 URL 打交道  
curl 的强大之处在于它不仅可以下载文件，还可以发送各种类型的 HTTP 请求（如 GET、POST、PUT、DELETE），支持表单提交、文件上传、以及处理复杂的认证和 cookie  

## 二、wget 和 curl 的主要区别
尽管 wget 和 curl 都可以用于下载文件和与网络资源交互，但它们在设计目标和使用场景上有所不同。以下是一些关键区别：  

### 主要用途
wget：专注于下载文件，特别是从 HTTP/HTTPS 服务器下载文件。wget 可以自动处理下载中断，并且能够递归下载整个网站  
curl：设计用于与 URL 进行交互，可以执行复杂的 HTTP 操作，如提交表单、上传文件、与 RESTful API 交互等  

### 递归下载
wget：支持递归下载，可以下载整个网站并保留其目录结构  
curl：不支持递归下载，通常用于单一文件或资源的下载  

### 数据传输协议
wget：支持 HTTP、HTTPS 和 FTP  
curl：支持更多协议，包括 HTTP、HTTPS、FTP、SFTP、SMTP、POP3、LDAP、IMAP、RTSP 等  

### 命令行选项
wget：专注于下载相关的命令行选项，如断点续传、递归下载等  
curl：提供了丰富的命令行选项，可以进行各种 HTTP 操作，如设置请求头、发送数据、处理认证等  

## 三、wget 的常见用法

### 命令参数表格

#### 启动参数
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>-V</td>
    <td>--version</td>
    <td>显示wget的版本后退出</td>
  </tr>
  <tr>
    <td>-h</td>
    <td>--help</td>
    <td>打印语法帮助</td>
  </tr>
  <tr>
    <td>-b</td>
    <td>--background</td>
    <td>启动后转入后台执行</td>
  </tr>
  <tr>
    <td>-e</td>
    <td>--execute=COMMAND</td>
    <td>执行`.wgetrc’格式的命令，wgetrc格式参见/etc/wgetrc或~/.wgetrc</td>
  </tr>
</table>

#### 记录和输入文件参数
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>-o</td>
    <td>--output-file=FILE</td>
    <td>把记录写到FILE文件中</td>
  </tr>
  <tr>
    <td>-a</td>
    <td>--append-output=FILE</td>
    <td>把记录追加到FILE文件中</td>
  </tr>
  <tr>
    <td>-d</td>
    <td>--debug</td>
    <td>打印调试输出</td>
  </tr>
  <tr>
    <td>-q</td>
    <td>--quiet</td>
    <td>安静模式（没有输出）</td>
  </tr>
  <tr>
    <td>-v</td>
    <td>--verbose</td>
    <td>冗长模式（这是缺省设置）</td>
  </tr>
  <tr>
    <td>-nv</td>
    <td>--non-verbose</td>
    <td>关掉冗长模式，但不是安静模式</td>
  </tr>
  <tr>
    <td>-i</td>
    <td>--input-file=FILE</td>
    <td>下载在FILE文件中出现的URLs</td>
  </tr>
  <tr>
    <td>-F</td>
    <td>--force-html</td>
    <td>把输入文件当作HTML格式文件对待</td>
  </tr>
  <tr>
    <td>-B</td>
    <td>--base=URL</td>
    <td>将URL作为在-F -i参数指定的文件中出现的相对链接的前缀</td>
  </tr>
  <tr>
    <td></td>
    <td>--sslcertfile=FILE</td>
    <td>可选客户端证书</td>
  </tr>
  <tr>
    <td></td>
    <td>--sslcertkey=KEYFILE</td>
    <td>可选客户端证书的KEYFILE</td>
  </tr>
  <tr>
    <td></td>
    <td>--egd-file=FILE</td>
    <td>指定EGD socket的文件名</td>
  </tr>
</table>

#### 下载参数
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td></td>
    <td>--bind-address=ADDRESS</td>
    <td>指定本地使用地址（主机名或IP，当本地有多个IP或名字时使用）</td>
  </tr>
  <tr>
    <td>-t</td>
    <td>--tries=NUMBER</td>
    <td>设定最大尝试链接次数（0表示无限制）</td>
  </tr>
  <tr>
    <td>-O</td>
    <td>--output-document=FILE</td>
    <td>把文档写到FILE文件中</td>
  </tr>
  <tr>
    <td>-nc</td>
    <td>--no-clobber</td>
    <td>不要覆盖存在的文件或使用.#前缀</td>
  </tr>
  <tr>
    <td>-c</td>
    <td>--continue</td>
    <td>接着下载没下载完的文件</td>
  </tr>
  <tr>
    <td></td>
    <td>--progress=TYPE</td>
    <td>设定进程条标记</td>
  </tr>
  <tr>
    <td>-N</td>
    <td>--timestamping</td>
    <td>不要重新下载文件除非比本地文件新</td>
  </tr>
  <tr>
    <td>-S</td>
    <td>--server-response</td>
    <td>打印服务器的回应</td>
  </tr>
  <tr>
    <td></td>
    <td>--spider</td>
    <td>不下载任何东西</td>
  </tr>
  <tr>
    <td>-T</td>
    <td>--timeout=SECONDS</td>
    <td>设定响应超时的秒数</td>
  </tr>
  <tr>
    <td>-w</td>
    <td>--wait=SECONDS</td>
    <td>两次尝试之间间隔SECONDS秒</td>
  </tr>
  <tr>
    <td></td>
    <td>--waitretry=SECONDS</td>
    <td>在重新链接之间等待1…SECONDS秒</td>
  </tr>
  <tr>
    <td></td>
    <td>--random-wait</td>
    <td>在下载之间等待0…2*WAIT秒</td>
  </tr>
  <tr>
    <td>-Y</td>
    <td>--proxy=on/off</td>
    <td>打开或关闭代理</td>
  </tr>
  <tr>
    <td>-Q</td>
    <td>--quota=NUMBER</td>
    <td>设置下载的容量限制</td>
  </tr>
  <tr>
    <td></td>
    <td>--limit-rate=RATE</td>
    <td>限定下载速率</td>
  </tr>
</table>

#### 目录参数
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>-nd</td>
    <td>--no-directories</td>
    <td>不创建目录</td>
  </tr>
  <tr>
    <td>-x</td>
    <td>--force-directories</td>
    <td>强制创建目录</td>
  </tr>
  <tr>
    <td>-nH</td>
    <td>--no-host-directories</td>
    <td>不创建主机目录</td>
  </tr>
  <tr>
    <td>-P</td>
    <td>--directory-prefix=PREFIX</td>
    <td>将文件保存到目录 PREFIX/…</td>
  </tr>
  <tr>
    <td></td>
    <td>--cut-dirs=NUMBER</td>
    <td>忽略NUMBER层远程目录</td>
  </tr>
</table>

#### HTTP 选项参数
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td></td>
    <td>--http-user=USER</td>
    <td>设定HTTP用户名为USER</td>
  </tr>
  <tr>
    <td></td>
    <td>--http-passwd=PASS</td>
    <td>设定HTTP密码为PASS</td>
  </tr>
  <tr>
    <td>-C</td>
    <td>--cache=on/off</td>
    <td>允许/不允许服务器端的数据缓存（一般情况下允许）</td>
  </tr>
  <tr>
    <td>-E</td>
    <td>--html-extension</td>
    <td>将所有text/html文档以.html扩展名保存</td>
  </tr>
  <tr>
    <td></td>
    <td>--ignore-length</td>
    <td>忽略`Content-Length’头域</td>
  </tr>
  <tr>
    <td></td>
    <td>--header=STRING</td>
    <td>在headers中插入字符串STRING</td>
  </tr>
  <tr>
    <td></td>
    <td>--proxy-user=USER</td>
    <td>设定代理的用户名为USER</td>
  </tr>
  <tr>
    <td></td>
    <td>--proxy-passwd=PASS</td>
    <td>设定代理的密码为PASS</td>
  </tr>
  <tr>
    <td></td>
    <td>--referer=URL</td>
    <td>在HTTP请求中包含`Referer: URL’头</td>
  </tr>
  <tr>
    <td>-s</td>
    <td>--save-headers</td>
    <td>保存HTTP头到文件</td>
  </tr>
  <tr>
    <td>-U</td>
    <td>--user-agent=AGENT</td>
    <td>设定代理的名称为AGENT而不是Wget/VERSION</td>
  </tr>
  <tr>
    <td></td>
    <td>--no-http-keep-alive</td>
    <td>关闭HTTP活动链接（永远链接）</td>
  </tr>
  <tr>
    <td></td>
    <td>--cookies=off</td>
    <td>不使用cookies</td>
  </tr>
  <tr>
    <td></td>
    <td>--load-cookies=FILE</td>
    <td>在开始会话前从文件FILE中加载cookie</td>
  </tr>
  <tr>
    <td></td>
    <td>--save-cookies=FILE</td>
    <td>在会话结束后将cookies保存到FILE文件中</td>
  </tr>
</table>

#### FTP 选项参数
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>-nr</td>
    <td>--dont-remove-listing</td>
    <td>不移走.listing文件</td>
  </tr>
  <tr>
    <td>-g</td>
    <td>--glob=on/off</td>
    <td>打开或关闭文件名的globbing机制</td>
  </tr>
  <tr>
    <td></td>
    <td>--passive-ftp</td>
    <td>使用被动传输模式（缺省值）</td>
  </tr>
  <tr>
    <td></td>
    <td>--active-ftp</td>
    <td>使用主动传输模式</td>
  </tr>
  <tr>
    <td></td>
    <td>--retr-symlinks</td>
    <td>在递归的时候，将链接指向文件（而不是目录）</td>
  </tr>
</table>

#### 递归下载参数
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>-r</td>
    <td>--recursive</td>
    <td>递归下载——慎用!</td>
  </tr>
  <tr>
    <td>-l</td>
    <td>--level=NUMBER</td>
    <td>最大递归深度 (inf 或 0 代表无穷)</td>
  </tr>
  <tr>
    <td></td>
    <td>--delete-after</td>
    <td>在下载完毕后局部删除文件</td>
  </tr>
  <tr>
    <td>-k</td>
    <td>--convert-links</td>
    <td>转换非相对链接为相对链接</td>
  </tr>
  <tr>
    <td>-K</td>
    <td>--backup-converted</td>
    <td>在转换文件X之前，将之备份为 X.orig</td>
  </tr>
  <tr>
    <td>-m</td>
    <td>--mirror</td>
    <td>等价于 -r -N -l inf -nr</td>
  </tr>
  <tr>
    <td>-p</td>
    <td>--page-requisites</td>
    <td>下载显示HTML文件的所有图片</td>
  </tr>
</table>

#### 递归下载中的包含和不包含(accept/reject)：
<table border="1">
  <tr>
    <th>短格式</th>
    <th>长格式</th>
    <th>说明</th>
  </tr>
  <tr>
    <td>-A</td>
    <td>--accept=LIST</td>
    <td>分号分隔的被接受扩展名的列表</td>
  </tr>
  <tr>
    <td>-R</td>
    <td>--reject=LIST</td>
    <td>分号分隔的不被接受的扩展名的列表</td>
  </tr>
  <tr>
    <td>-D</td>
    <td>--domains=LIST</td>
    <td>分号分隔的被接受域的列表</td>
  </tr>
  <tr>
    <td></td>
    <td>--exclude-domains=LIST</td>
    <td>分号分隔的不被接受的域的列表</td>
  </tr>
  <tr>
    <td></td>
    <td>--follow-ftp</td>
    <td>跟踪HTML文档中的FTP链接</td>
  </tr>
  <tr>
    <td></td>
    <td>--follow-tags=LIST</td>
    <td>分号分隔的被跟踪的HTML标签的列表</td>
  </tr>
  <tr>
    <td>-G</td>
    <td>--ignore-tags=LIST</td>
    <td>分号分隔的被忽略的HTML标签的列表</td>
  </tr>
  <tr>
    <td>-H</td>
    <td>--span-hosts</td>
    <td>当递归时转到外部主机</td>
  </tr>
  <tr>
    <td>-L</td>
    <td>--relative</td>
    <td>仅仅跟踪相对链接</td>
  </tr>
  <tr>
    <td>-I</td>
    <td>--include-directories=LIST</td>
    <td>允许目录的列表</td>
  </tr>
  <tr>
    <td>-X</td>
    <td>--exclude-directories=LIST</td>
    <td>不被包含目录的列表</td>
  </tr>
  <tr>
    <td>-np</td>
    <td>--no-parent</td>
    <td>不要追溯到父目录</td>
  </tr>
</table>

### 使用实例

<pre>
wget命令的常用选项
-b：后台下载
-q：静默模式，不输出信息
-i：从文件中读取URL进行下载
-t：设置最大重试次数
--timeout：设置下载超时时间
--user 和 --password：设置FTP或HTTP认证的用户名和密码
--proxy：设置代理服务器
</pre>

#### 基本下载
最简单的`wget`用法是下载文件。以下命令下载一个文件并保存到当前目录中：
```bash
wget http://example.com/file.zip
```

#### 下载到指定目录
可以使用`-P`选项指定下载的保存目录：
```bash
wget -P /path/to/directory http://example.com/file.zip
```

#### 断点续传
如果下载过程中断，`wget`可以使用`-c`选项继续下载未完成的文件：
```bash
wget -c http://example.com/largefile.zip
```

#### 下载并以不同文件名保存
`wget`默认会以URL最后一个符合”/”后面的字符来命名文件。使用`-O`参数可以指定一个文件名：
```bash
wget -O wordpress.zip http://example.com/download.aspx?id=1080
```

#### 递归下载整个网站
`wget`可以递归下载一个网站的所有内容，并保留站点的目录结构：
```bash
wget -r http://example.com/
```
递归下载指定 URL 中的所有链接，并保存到指定的目录：
```bash
wget -r -np -nH --cut-dirs=2 http://example.com/dir/ -P /path/to/save
```

#### 设置下载速度限制
在网络环境不佳或需要节约带宽的情况下，可以使用`--limit-rate`选项限制下载速度：
```bash
wget --limit-rate=100k http://example.com/largefile.zip
```

#### 限速下载
当你需要限制下载速度以节省带宽时，可以使用`--limit-rate`参数：
```bash
wget --limit-rate=300k http://example.com/wordpress-3.1-zh_CN.zip
```

#### 后台下载
对于下载非常大的文件，可以使用`-b`参数进行后台下载：
```bash
wget -b http://example.com/wordpress-3.1-zh_CN.zip
```

#### 静默模式
```bash
wget -q http://example.com/file.txt
```

#### 自动确认下载
在执行操作时自动回答 “yes”，省去用户确认步骤：
```bash
wget -y http://example.com/file.zip
```

#### 设置最大重试次数
```bash
wget -t 5 http://example.com/file.txt
```

#### 设置下载超时时间
```bash
wget --timeout=30 http://example.com/file.txt
```

#### 伪装代理名称下载
有些网站能通过判断代理名称不是浏览器而拒绝下载请求。使用`--user-agent`参数可以伪装：
```bash
wget --user-agent="Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/534.16 (KHTML, like Gecko) Chrome/10.0.648.204 Safari/534.16" http://example.com/wordpress-3.1-zh_CN.zip
```

#### 测试下载链接
使用`--spider`参数测试下载链接是否有效：
```bash
wget --spider http://example.com/url
```

#### 增加重试次数
如果网络有问题或下载一个大文件失败，可以使用`--tries`增加重试次数：
```bash
wget --tries=40 http://example.com/url
```

#### 下载多个文件
首先，保存一份下载链接文件，然后使用`-i`参数下载：
```bash
wget -i filelist.txt
```

#### 镜像网站
下载整个网站到本地(非常适合做网站备份或离线浏览)：
```bash
wget --mirror -p --convert-links -P ./local http://example.com
```
--mirror：启用镜像下载  
-p：下载页面所需的所有文件（例如图片）  
--convert-links：将下载后的链接转换为本地链接  
-P ./local：将下载的文件保存到指定目录  

#### 通过代理服务器下载
如果在受限网络中，可以使用代理服务器进行下载
```bash
wget -e use_proxy=yes -e http_proxy=proxy.example.com:8080 http://example.com/file.txt
```
-e use_proxy=yes：启用代理  
-e http_proxy=proxy.example.com:8080：设置HTTP代理服务器  

#### 下载带有认证的文件
对于需要用户名和密码的下载，可以使用以下命令：
```bash
wget --user=username --password=password http://example.com/securefile.zip
```
--user：设置用户名  
--password：设置密码  

#### 过滤指定格式下载
下载一个网站，但不希望下载图片，可以使用`--reject`参数：
```bash
wget --reject=gif http://example.com/
```

#### 把下载信息存入日志文件
不希望下载信息直接显示在终端而是在一个日志文件，可以使用`-o`参数：
```bash
wget -o download.log http://example.com/file.zip
```

#### 限制总下载文件大小
当你想要下载的文件超过一定大小而退出下载，可以使用`-Q`参数：
```bash
wget -Q5m -i filelist.txt
```

#### 下载指定格式文件
下载一个网站的所有PDF文件：
```bash
wget -r -A.pdf http://example.com/
```

#### FTP下载
使用`wget`匿名FTP下载：
```bash
wget ftp://example.com/ftp-url
```

使用`wget`用户名和密码认证的FTP下载：
```bash
wget --ftp-user=USERNAME --ftp-password=PASSWORD ftp://example.com/ftp-url
```

#### 编译安装
使用如下命令编译安装`wget`：
```bash
# tar zxvf wget-1.9.1.tar.gz
# cd wget-1.9.1
# ./configure
# make
# make install
```

#### 定时下载数据
使用cron结合wget，可以实现定时下载数据的任务。例如，每天凌晨3点下载最新的数据文件：
```bash
0 3 * * * /usr/bin/wget -q -O /path/to/localfile http://example.com/datafile.csv
```


## 四、curl 的常见用法

### 基本下载
curl 最基本的用法是下载文件并将其保存到指定文件中：
```
curl -o file.zip http://example.com/file.zip
```

### 下载并显示内容
curl 默认会将下载的内容显示在终端，可以使用 `-O` 选项将文件保存到本地：
```
curl -O http://example.com/file.zip
```

### 发送 GET 请求
默认情况下，curl 发送的是 GET 请求，并返回服务器响应的内容：
```
curl http://api.example.com/resource
```

### 发送 POST 请求
可以使用 `-d` 选项发送 POST 请求，并传递数据：
```
curl -X POST -d "key1=value1&key2=value2" http://api.example.com/resource
```

### 设置请求头
curl 允许设置自定义的 HTTP 请求头，使用 `-H` 选项：
```
curl -H "Content-Type: application/json" \
     -H "Authorization: Bearer token" \
     http://api.example.com/resource
```

### 处理文件上传
使用 `-F` 选项可以上传文件：
```
curl -F "file=@/path/to/file.zip" http://api.example.com/upload
```

## 五、进阶使用：在实际项目中的应用

### 使用 wget 批量下载文件
假设你需要下载一系列文件，可以使用 wget 的批处理功能。首先，`将所有 URL 放在一个文本文件`中：  
文件名'urls.txt'
<pre>
http://example.com/file1.zip
http://example.com/file2.zip
http://example.com/file3.zip
</pre>
然后使用 wget 批量下载这些文件：
```
wget -i urls.txt
```

### 使用 curl 与 API 交互
在开发过程中，经常需要与 RESTful API 进行交互。以下是一个使用 curl 发送 POST 请求并上传 JSON 数据的例子：
```
curl -X POST -H "Content-Type: application/json" \
     -d '{"key1":"value1", "key2":"value2"}' \
     http://api.example.com/resource
```

### 结合 curl 和 jq 处理 JSON 响应
jq 是一个处理 JSON 数据的命令行工具。你可以将 curl 的输出通过管道传给 jq 以解析和格式化 JSON 响应：
```
curl -s http://api.example.com/resource | jq '.key1'
```

## wget 与 curl 的比较与选择
当需要选择 wget 或 curl 时，可以根据具体的需求进行判断：
- 如果你需要批量`下载文件`或递归下载整个网站，`wget` 是更好的选择
- 如果你需要与 API 进行交互，处理复杂的 `HTTP 请求`或`上传文件`，`curl` 更加合适

## 总结
wget 和 curl 是两个强大的命令行工具，各有其独特的功能和应用场景。在实际工作中，灵活使用这两个工具可以大大提高效率，无论是简单的文件下载还是复杂的 API 调用  
通过本文，你应该对 wget 和 curl 有了更深入的了解，并掌握了如何在实际项目中应用它们的技能。无论你是系统管理员、开发人员，还是 DevOps 工程师，这些工具都能在你的日常工作中发挥重要作用  
