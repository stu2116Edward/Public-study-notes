# openssl证书申请

## 检查OpenSSL
检查是否已经安装openssl：
```bash
openssl version
```
如果没有安装，则安装：  
- centos安装openssl：
```bash
yum install openssl
```
- ubuntu安装openssl：
```bash
sudo apt-get install openssl
```

## 生成自签名的SSL证书和私钥

### 生成私钥
新建证书和私钥的存放路径`/etc/ssl/certs/ip.stu2116hhr.net`
```bash
mkdir /etc/ssl/certs/ip.stu2116hhr.net -p
```
```bash
cd /etc/ssl/certs/ip.stu2116hhr.net
```
并进入，后执行命令：
```bash
openssl genrsa -des3 -out server.key 2048
```
**输入一个4位以上的密码**

### 生成CSR(证书签名请求)
```bash
openssl req -new -key server.key -out server.csr -subj "/C=CN/ST=Zhejiang/L=JinHua/O=shanhai/OU=shanhai/CN=ip.stu2116hhr.net"
```
**输入刚刚设置的密码**

参数说明如下：
| 字段 | 字段含义 | 示例 |
| --- | --- | --- |
| `/C=` | Country 国家 | CN |
| `/ST=` | State or Province 省 | Zhejiang |
| `/L=` | Location or City 城市 | JinHua |
| `/O=` | Organization 组织或企业 | shanhai |
| `/OU=` | Organization Unit 部门 | shanhai |
| `/CN=` | Common Name 域名或IP | ip.stu2116hhr.net |

### 去除私钥中的密码
在第1步创建私钥的过程中，由于必须要指定一个密码。而这个密码会带来一个副作用，那就是在每次启动Web服务器时，都会要求输入密码  
这显然非常不方便。要删除私钥中的密码，操作如下:
```bash
openssl rsa -in server.key -out server.key
```
**再次输入密码**

### 生成自签名SSL证书
***-days 证书有效期-天***
```bash
# -days 证书有效期-天
openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
```
需要用到的证书文件为：`server.crt` 和 `server.key`  
X.509证书包含三个文件：`key`，`csr`，`crt`  
`key`是服务器上的`私钥`文件，用于对发送给客户端数据的加密，以及对从客户端接收到数据的解密  
`csr`是证书`签名请求文件`，用于提交给证书颁发机构（CA）对证书签名  
`crt`是由证书颁发机构（CA）签名后的`证书`，或者是开发者自签名的证书，包含证书持有人的信息，持有人的公钥，以及签署者的签名等信息  
***备注：在密码学中，X.509是一个标准，规范了公开秘钥认证、证书吊销列表、授权凭证、凭证路径验证算法等***

### 生成 dhparam.pem 文件
使用 Diffie-Hellman 参数来增加安全性
```bash
openssl dhparam -out /etc/ssl/certs/ip.stu2116hhr.net/dhparam.pem 2048
```
确保文件权限设置为只有 root 可读：
```bash
sudo chmod 600 /etc/ssl/certs/ip.stu2116hhr.net/dhparam.pem
```

### 在nginx配置文件中配置使用ssl证书
最终的配置如下：
```conf
user  www-data;
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    gzip  on;

    # HTTP 到 HTTPS 重定向
    server {
        listen       80;
        server_name  ip.stu2116hhr.net;
        return       301 https://$server_name$request_uri; # 使用 return 而不是 rewrite 可能更高效
    }

    # HTTPS 服务器配置
    server {
        listen       443 ssl;
        keepalive_timeout   70;
        server_name  ip.stu2116hhr.net;

        # SSL 证书和密钥配置
        ssl_certificate      /etc/ssl/certs/ip.stu2116hhr.net/server.crt;
        ssl_certificate_key  /etc/ssl/certs/ip.stu2116hhr.net/server.key;

        # 安全配置
        add_header          X-Frame-Options DENY;
        add_header          X-Content-Type-Options nosniff;
        add_header          X-Xss-Protection 1;
        ssl_prefer_server_ciphers on;
        ssl_dhparam         /etc/ssl/certs/ip.stu2116hhr.net/dhparam.pem;

        # SSL 协议和加密套件配置
        ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers         "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4";

        # 性能优化
        ssl_session_cache   shared:SSL:10m;
        ssl_session_timeout 10m;

        # 反向代理配置
        location / {
            proxy_pass http://127.0.0.1:2017;  
            proxy_redirect default;
            client_max_body_size 10m; # 最大上传限制
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Scheme $scheme;
        }

        # 错误页面配置
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}
```
在浏览器中访问显示https不安全那就在你当前的内网环境下手动添加证书  
`【Win+R】输入 certmgr.msc 在受信任的根证书颁发机构中添加你的server.crt证书选择“所有任务” > “导入”`
