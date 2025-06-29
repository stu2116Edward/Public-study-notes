# Nginx学习笔记

## Nginx基础命令
Nginx的作用就是别人可以通过网址访问你的Web服务器  
nginx配置文件nginx.conf的主要格式就是在一个块里嵌套另一个块然后在对应指令后面加上英文分号  
安装Nginx  
```bash
apt install -y nginx
```
启动、停止或重启Nginx服务:  
启动Nginx  
```bash
sudo systemctl start nginx
```
配置Nginx开机自启动
```bash
sudo systemctl enable nginx
```
重启Nginx  
```bash
sudo systemctl restart nginx
```
停止Nginx  
```bash
sudo systemctl stop nginx
```
取消Nginx开机自启动
```bash
sudo systemctl disable nginx
```
查看Nginx版本:  
```bash
nginx -v
```
查看Nginx运行状态
```bash
systemctl status nginx
```
或(较旧的系统)
```bash
service nginx status
```


## Nginx默认配置
Nginx 安装目录下, 我们复制一份`nginx.conf`成`nginx.conf.default`作为配置文件备份，然后修改`nginx.conf`  
进入Nginx安装目录：
```bash
cd /etc/nginx
```
复制配置文件:
```bash
cp nginx.conf nginx.conf.default
```
修改nginx.conf文件:
```bash
vim nginx.conf
```
默认Nginx配置说明:
```conf
# 全局配置
user www-data;                      # Nginx进程运行用户（建议使用非root用户如www-data）
worker_processes auto;               # 工作进程数量，auto表示自动设置为CPU核心数
pid /run/nginx.pid;                  # 主进程PID文件存储路径
include /etc/nginx/modules-enabled/*.conf;  # 加载已启用的动态模块配置

# 事件处理模型配置
events {
    worker_connections 768;          # 单个工作进程的最大并发连接数
    # multi_accept on;               # 是否允许工作进程一次性接受所有新连接（高并发时启用）
}

# HTTP服务配置
http {
    ##
    # 基础网络优化配置
    ##
    sendfile on;                     # 启用高效文件传输模式（零拷贝技术）
    tcp_nopush on;                   # 在sendfile模式下，等待数据包填满后再发送（需与sendfile配合）
    tcp_nodelay on;                  # 禁用Nagle算法，提高实时性（高延迟网络建议开启）
    keepalive_timeout 65;            # 客户端连接保持时间（秒）
    types_hash_max_size 2048;        # MIME类型哈希表大小（影响内存使用）
    # server_tokens off;             # 隐藏Nginx版本号（安全建议开启）

    # server_names_hash_bucket_size 64;  # 服务器名哈希表桶大小（长域名需调整）
    # server_name_in_redirect off;   # 是否在重定向时使用server_name（默认关闭）

    ##
    # 文件类型配置
    ##
    include /etc/nginx/mime.types;   # 包含MIME类型定义文件（如.html=text/html）
    default_type application/octet-stream;  # 默认响应类型（未知类型时作为二进制流）

    ##
    # SSL/TLS安全配置
    ##
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;  # 支持的SSL协议版本（已禁用不安全的SSLv3）
    ssl_prefer_server_ciphers on;    # 优先使用服务端定义的加密套件

    ##
    # 日志配置
    ##
    access_log /var/log/nginx/access.log;  # 访问日志存储路径
    error_log /var/log/nginx/error.log;    # 错误日志存储路径

    ##
    # Gzip压缩配置
    ##
    gzip on;                         # 启用响应压缩功能
    # gzip_vary on;                  # 是否在响应头添加"Vary: Accept-Encoding"
    # gzip_proxied any;              # 对代理请求的压缩策略
    # gzip_comp_level 6;             # 压缩级别（1-9，级别越高CPU消耗越大）
    # gzip_buffers 16 8k;            # 压缩缓冲区数量和大小
    # gzip_http_version 1.1;         # 最低压缩所需的HTTP协议版本
    # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;  # 指定压缩的文件类型

    ##
    # 虚拟主机配置
    ##
    include /etc/nginx/conf.d/*.conf;      # 包含conf.d目录下的所有配置文件
    include /etc/nginx/sites-enabled/*;    # 包含sites-enabled目录下的站点配置（通常软链接到sites-available）

    # 注：实际server配置应放在sites-available中，通过ln -s链接到sites-enabled
}

# 邮件代理配置（默认不启用）
#mail {
#    # 参考示例：http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#    # auth_http localhost/auth.php;  # 认证接口地址
#    # pop3_capabilities "TOP" "USER";  # POP3协议扩展支持
#    # imap_capabilities "IMAP4rev1" "UIDPLUS";  # IMAP协议扩展支持
#
#    # POP3服务配置
#    server {
#        listen     localhost:110;    # 监听端口
#        protocol   pop3;             # 协议类型
#        proxy      on;               # 启用代理模式
#    }
#
#    # IMAP服务配置
#    server {
#        listen     localhost:143;    # 监听端口
#        protocol   imap;             # 协议类型
#        proxy      on;               # 启用代理模式
#    }
#}
```


## Nginx配置文件
Nginx中的重要文件夹：  
位置：/etc/nginx  
重点关注 nginx.conf 配置文件  

这里为了教学重写了下配置文件  
备份源配置文件(这里使用mv进行重命名操作)：  
```bash
mv nginx.conf nginx.conf.bak
```
新建配置文件：
```bash
touch nginx.conf
```

校验nginx配置文件是否有问题
```bash
nginx -t
```
提示配置中缺少 events块 (events是用来告诉nginx如何处理连接)  
进入文件写入events:  
```bash
vim nginx.conf
```
写入events:
```conf
events {}
```
如果配置文件有改动需要重新加载一下nginx(热加载)  
```bash
nginx -s reload
```
快速关闭
```bash
nginx -s stop
```
等待工作进程处理完成后关闭
```bash
nginx -s quit
```

在 http 块内写入 server 块  
```conf
events {}

http {
  server {		# server 块中所定义的就是虚拟服务器
    listen 80;	# 提供需要监听的端口号(使用哪个端口访问服务就写哪个端口一般使用80或者443)
    server_name localhost;	# 提供ip地址或者域名

    return 200 "hello world!\n";	# 加上状态码返回对应的消息
  }
}
```

保存配置文件并重新加载  
```bash
nginx -t && nginx -s reload
```

查看状态码和响应消息  
```bash
curl -i <ip地址或者域名>
```

自定义自己的网页  
创建存放网页的文件夹  
```bash
mkdir /var/www/localhost
```
在localhost中存放网页文件`index.html`  
也可以自定义存放位置  
编辑nginx配置文件  
```conf
events {}

http {
  server {		# server 块中所定义的就是虚拟服务器
    listen 80;	# 提供需要监听的端口号(使用哪个端口访问服务就写哪个端口一般使用80或者443)
    server_name localhost;	# 提供ip地址或者域名

    # root指定根目录让nginx去找这个文件夹里面的内容
    root /var/www/localhost;	# 这里删除了状态码如果不删除就会显示状态码的内容
  }
}
```

如果把index.html改为egg.html即目录中没有index.html那么web页面就无法显示处正常的内容  
```bash
mv index.html egg.html
```
说明index.html是nginx其中一个默认会找的文件  
当然可以指定文件名：  
```conf
events {}

http {
  server {		# server 块中所定义的就是虚拟服务器
    listen 80;	# 提供需要监听的端口号(使用哪个端口访问服务就写哪个端口一般使用80或者443)
    server_name localhost;	# 提供ip地址或者域名

    # root指定根目录让nginx去找这个文件夹里面的内容
    root /var/www/localhost;	# 这里删除了状态码如果不删除就会显示状态码的内容
    index egg.html;
  }
}
```

一个网页由多个文件组成  
这里添加了一个css文件用于修改页面背景颜色  
进入浏览器打开调试工具在Network中打开这个styles.css  
如果在Content-Type中显示的内容类型是text/plain (纯文本类型)  
css文件不是纯文本文件所以进行一下修改  
在/etc/nginx/文件夹中有一个mime.types的文件这里标注着各种内容类型所对应的文件后缀  
在nginx.conf中引入这个配置文件就能解决这个问题  
```conf
events {}

http {
  
  # include用于引入其他文件
  include /etc/nginx/mime.types; # 在server块外在http内这样后续就不用在多个server块中复写了

  server {		# server 块中所定义的就是虚拟服务器
    listen 80;	# 提供需要监听的端口号(使用哪个端口访问服务就写哪个端口一般使用80或者443)
    server_name localhost;	# 提供ip地址或者域名

    # root指定根目录让nginx去找这个文件夹里面的内容
    root /var/www/localhost;	# 这里删除了状态码如果不删除就会显示状态码的内容
    index egg.html;
  }
}
```

在`/etc/nginx/conf.d/`中有这样一个文件`default.conf`  
我们一开始能够看到的默认nginx页面就是依靠这个文件的  
也就是说nginx的默认配置本来就拆分为不同的文件  
```bash
cd conf.d
```
这里进行试验  
修改配置文件进行备份  
```bash
vm default.conf default.conf.bak
touch default.conf
```
进入nginx配置文件nginx.conf进行编辑  
```conf
events {}

http {
  
  # include用于引入其他文件
  include /etc/nginx/mime.types; # 在server块外在http内这样后续就不用在多个server块中复写了
  
  include /etc/nginx/conf.d/*.conf; # 这里的星号表示文件夹里所有后缀名为conf的文件都要读取
  
  server {		# server 块中所定义的就是虚拟服务器
    listen 80;	# 提供需要监听的端口号(使用哪个端口访问服务就写哪个端口一般使用80或者443)
    server_name localhost;	# 提供ip地址或者域名

    # root指定根目录让nginx去找这个文件夹里面的内容
    root /var/www/localhost;	# 这里删除了状态码如果不删除就会显示状态码的内容
    index egg.html;
  }
}
```

下一步将 nginx.conf 修改为如下配置  
```conf
events {}

http {
  
  include /etc/nginx/mime.types;
  
  include /etc/nginx/conf.d/*.conf;
  
}
```
将 default.conf 修改为如下配置  
```
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  index egg.html;
}
```

细节部分：  
首先把egg.html改回index.html  
```bash
vm egg.html index.html
```
使用 `location` 指令改写 `default.conf` 里的配置,目的是为了访问localhost的时候就会访问根目录  
```conf
server {
  listen 80;
  server_name localhost;

  location / {
    root /var/www/localhost;
  }
}
```
如果将其改为  
```conf
server {
  listen 80;
  server_name localhost;

  location /app {
    root /var/www/localhost;
  }
}
```

如果有人访问 `http://localhost/app`，Nginx 会在 `/var/www/localhost` 目录下寻找 app 目录或文件来响应请求  
在`/var/www/localhost`中创建一个app文件夹  
```bash
mkdir app
```
然后将index.html移动到app文件夹里面
```bash
vm index.html app/
```
此时向localhost/app发出请求
```bash
curl localhost/app
```
发现还是有问题的  
如果在请求后面加上斜杆 `/`  
```bash
curl localhost/app/
```
或者在url后面加上index.html  
这样访问就不会有问题  
这是为什么呢？  
```conf
location /app {
  root /var/www/localhost;
}
```
首先我们在location指令里指定了 `/app`  
如果我们访问 `http://localhost/app`  
就会在根路径里找有没有app这个文件  
一个文件不一定非得要有后缀名才能是一个文件  
我们没有app这个文件，所以第一次请求就会出错  
接着为什么app/和app/index.html都可以呢?  
`http://localhost/app/`  
`http://localhost/app/index.html`  
那是因为location和匹配路径参数之间还可以再有一个参数  
```
location 参数/app {
  root /var/www/localhost;
}
```
如果我们不填写中间这个参数  
Nginx会匹配以"app"开头的URi和文件路径  
第二个请求以"app"开头，并且多了一个 /  
因此会去找里面的index.html文件  
第三个请求也是以"app"开头  
而且本来就有index.html文件所以匹配成功  
如果确实存在一个叫"apple"的文件夹  
用户也是可以访问localhost/apple/这个URl的  
因为前缀都有"app"这个字符  
再比如说你把index.html移动到app/ppa/文件夹下面了  
`http://localhost/app/ppa/index.html`  
也是可以通过localhost/app/ppa/index.html访问的  
还是一样前缀的"app"学符匹配了  
虽然这样设置让客户端更灵活  
但是容易暴露服务器一些不能公开的文件  
我们能否把URI和文件路径完全一对一呢?  
此时就可以在location和路径中间增加"=" 意思是URI和文件路径完全匹配  
```conf
server {
  listen 80;
  server_name localhost;

  location = /app/index.html {
    root /var/www/localhost;
  }
}
```

现在我们访问app/是不行的  
```bash
curl localhost/app/
```
出现404错误  
在location和路径中间增加"="Nginx不会自动去找里面的index.html  
一定要访问app/index.html  
```bash
curl localhost/app/index.html
```
访问的路径要与实际文件完全一致  
可是这样的形式有时候又不太灵活  
此时就需要正则表达式登场了  
比如我这里有一个videos文件夹  
里面有9个影片文件但是我只想公布6到9号影片  
只需要在location和路径之间写入"～"  
这样就可以启用正则表达式  
```conf
server {
  listen 80;
  server_name localhost;

  location ~ /videos/video[6~9].avi {
    root /var/www/localhost;
  }
}
```

因为每个文件名就只有数字的差别  
因此我们可以用[6-9]样的正则表达式来表示6,7,8,9  
此时如果我们访问9号件是没问题的  
```bash
curl -i localhost/videos/video9.avi
```
访问3号文件会显示失败
```bash
curl -i localhost/videos/video3.avi
```
即使这个文件是存在的正则表达式可以更灵活进行匹配  
文件名统一还好说如果有些文件名大写，有些又小写此时就不行了  
那是因为"～"是会区分大小写的  
我们需要在"～"后面加上"*"表示不区分大小写  
虽然"～*"是用来进行不区分大小写匹配  
但是用户访问还是要与实际文件路径一致的  
如果用户请求的URI是大写的，实际文件名是小写的，也不行  
Nginx这里只是帮你涵盖所有不区分大小写的文件路径  
并不是把请求URI和文件路径不区分大小写进行匹配  

匹配方式：  
1.  = 精确　  
2.  ^～ 优先前缀  
3.  ～和～＊ 正则  
4.  空格 普通前缀  

使用优先前缀匹配也就是用"^～"来匹配功能和前缀匹配是类似以的只不过优先级比较高  
```conf
server {
  listen 80;
  server_name localhost;

  location ^~ /videos/ {
    root /var/www/localhost;
  }
}
```

有了路径的匹配还不够我们经常还需要把匹配到的URI进行临时重定向的操作  
```conf
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;

  location /temp {
    return 307 /app/index.html;
  }
}
```

比如这里我先在location外面设置好根路径  
接着在location指令这里设置路径当用户访问/temp的时候  
就会被临时重定向到根路径下`/app/index.html`了  
```bash
curl -i localhost/temp
```
这里返回的状态码307就是表示临时重定向  
Location中的值就是会被重定向的路径浏览器会自行访问这个地址不过重定向是会改变URI地址用户是可以察觉到的  
为了让重定向的过程更丝滑我们可以直接用rewrite(重写)指令来进行重写而不使用location也就是把一个路径改成另一个路径  
```conf
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  
  rewrite /temp /app/index.html;
}
```

此时如果我们再次进行访问的时候状态码直接就显示200而且响应首部也没有了"Location"就和直接访资源没什么差别了  
重定向和重写虽然很好用但主要是针对单个文件路径的如果要让Nginx有多个文件可以选择不妨试试try_files而且还可以结合$uri变量来使用  
```conf
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  index index.html;

  location / {
    try_files $uri $uri/ =404;  # 第一个$uri的意思是先试一下用户访问的路径文件
					  #  第二个$uri表示如果没有，再看看有没有对应的文件夹，如果有的适就访问里面的index.html因为我们在上面已经设置好了index 如果前面的都不行就返回404
  }
}
```

为了给大家展示$uri的变化  
```conf
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  index index.html;

  location / {
    # 这里增加一个自定义响应首部,并且把首部的值设为$uri
    add_header X-debug-uri "$uri";
    try_files $uri $uri/ =404;
  }
}
```

首先访问这个资源我们可以看到此时$uri的值  
```bash
curl -i localhost/animal/cat.html
```
因为存在这个资源因此try_files在匹配$uri的时候就成功了
X-debug-uri: /animal/cat.html  
如果我们只访问animal/这个文件夹  
```bash
curl -i localhost/animal/
```
此时的Suri就会变成/animal/index.html  
X-debug-uri: /animal/index.html  
因为tryfiles会匹配设置的第2个参数而且我们上面也设置了index  
如果我们访问一个不存在的页面  
curl -i localhost/animal/404  
就会使用tryfiles第3个参数也就是返回404  
这个404页面其实是Nginx默认的页面  
我们应该如何修改为自定义的404页面呢？  
假设我们已经在存放html文件夹里创建了一个404.html文件  
/var/www/localhost/404.html  
此时我们可以在配置文件里面使用error_page来定义404发生时要访问的文件  
```conf
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  index index.html;
  error_page 404 /404.html   # 这里的/404.html就会在根路径里面找

  location / {
    # 这里增加一个自定义响应首部,并且把首部的值设为$uri
    add_header X-debug-uri "$uri";
    try_files $uri $uri/ =404;
  }
}
```

其实500这类状态也是可以设置访问指定文件的  
这一次我们再次访问一个不存在的页面就是属于你的404页面了  
```bash
curl -i localhost/animal/404
```

使用Nginx实现反向代理  
这里我提前创建了两个Next.js项目  
并且把他们的基础路径分别改为/nextjsapp1和/nextjsapp2  
目录结构：  
`/var/www/localhost/next-app1/next.config.mjs`  
`/var/www/localhost/next-app2/next.config.mjs`  
因为我等会要以不同的URI来访问不同的项目  
我们只要知道项目运行在本地服务器的哪个端口就可以了  
比如我在其中一个项目里运行开发环境，会监听3000端口  
另一个项目则是3001端口此时就需要回到Nginx的配置文件里了  
还是使用location指定路径(基础路径)  
如果不设置基础路径，一般直接填写"/"就好了  
```
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  index index.html;
  error_page 404 /404.html   # 这里的/404.html就会在根路径里面找

  location / {	# 设置基础路径(如果不设置其他的基础路径一般将其设置为" / " )
    # 这里的意思是访问指定的路径就会去到指定端口运行的项目(通过不同的server name也可以)
    proxy_pass http://localhost:3000	# 使用proxy_pass进行反向代理操作
  }

  location /nextjsapp1 {	# 设置基础路径
    proxy_pass http://localhost:3000
  }

  location /nextjsapp2 {	# 设置基础路径
    proxy_pass http://localhost:3000
  }
}
```

## Nginx负载均衡:  
当你的网站流量开始增多的时候你很可能会增加服务器来进行分流此时就可以用到Nginx的负载均衡功能了  
我们还是用刚才的那两个项目作为演示只不过这一次我不设置基础路径打算使用默认路径  
回到配置文件添加upstream块也就是要设置上游服务器这个upstream块需要在http块里面并且在server块的外面因为这个文件本来就处在http里面因此我们直接在server块顶部写就好  
我们可以给上游服务器设置名称比如这里的"backend-servers"然后再在里面写入可以调配的服务器  
接着我们还是在location指令里使用proxy_pass并且把域名指向上面upstream自定义的名称其实就是告诉Nginx把流量导到指定的服务器集群再通过负载均衡分配到集群里面的服务器  
```conf
upstream backend-servers {
  server localhost:3000;
  server localhost:3001;
}
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  index index.html;
  error_page 404 /404.html   # 这里的/404.html就会在根路径里面找

  location / {	# 设置基础路径
    proxy_pass http://backend-servers;
  }
}
```

此时如果我们用浏览器访问的时候就可以通过不断刷新来查看到不同访问会被进行分配  
```
http://localhost  
```
这里设置不同的网页内容只是为了让大家知道Nginx确实会进行流量的轮询  
不过这里有个问题现实中服务器的性能配置可能不太一样因此我们就必须把更多的流量分配给高配置的服务器低配的服务器则分担少一点的流量  
此时我们就可以设置weight，并且自定义数值当我们进行多次请求的时候  
weight的数值相对越大，被分配到的次数就会相对越多  
```conf
upstream backend-servers {
  server localhost:3000 weight=2;
  server localhost:3001 weight=6;
}
server {
  listen 80;
  server_name localhost;

  root /var/www/localhost;
  index index.html;
  error_page 404 /404.html   # 这里的/404.html就会在根路径里面找

  location / {	# 设置基础路径
    proxy_pass http://backend-servers;
  }
}
```

我们也可以通过多次响应进行验证  
```
http://localhost
```
