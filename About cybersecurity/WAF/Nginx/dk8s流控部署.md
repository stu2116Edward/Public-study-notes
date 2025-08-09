# dk8s部署入站流控系统

Openresty 是一个基于 Nginx 与 Lua 的高性能 Web 平台，其内部集成了大量精良的 Lua 库、第三方模块以及大多数的依赖项。. 用于方便地搭建能够处理超高并发、扩展性极高的动态 Web 应用、Web 服务和动态网关  

***注：dk8s就是openresty就是nginx***

### 启动一个空的Openresty容器
```bash
OPENRESTY_VERSION=$(wget -q -O - https://openresty.org/en/download.html | grep -oEi 'openresty [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n1 | awk '{print $2}')

docker create \
--name temp_openresty \
openresty/openresty:${OPENRESTY_VERSION}-bookworm-fat
```

### 把相关文件复制出来
```bash
mkdir -p /data/openresty/conf.d

docker cp temp_openresty:/usr/local/openresty/nginx/html /data/openresty/
docker cp temp_openresty:/usr/local/openresty/nginx/conf /data/openresty/
docker cp temp_openresty:/etc/nginx/conf.d /data/openresty
```

### 删除临时容器
```bash
docker rm temp_openresty
```

### 防CC版本Openresty(占用端口80 443 可在配置文件修改)
```bash
DIR=/data/dk8sfirewall
# GH=https://gitee.com/azhaoyang_admin/DK8sDDosFirewall/raw/main
GH=https://gitee.com/white-wolf-vvvk/DK8sDDosFirewall/raw/main

mkdir -p "$DIR"
cd "$DIR"

for f in nginx.conf env.conf cert.crt cert.key protect.lua record.lua stats.lua; do
  curl -L --retry 3 -o "$DIR/$f" "$GH/$f"
done

docker run -d \
--name dk8s-ddos-fw \
--restart always \
--user=root \
--network host \
--cap-add=NET_ADMIN \
--cap-add=NET_RAW \
--cap-add=SYS_ADMIN \
-v "$DIR:/app:rw" \
bailangvvking/dk8sddosfirewall:latest
```

### 修改配置文件
注意修改`域名`，`端口`，`证书`:
证书存放于`/data/dk8sfirewall/`目录下的`cert.crt`和`cert.key`文件
```conf
# 配置ssl证书和密钥
ssl_certificate /app/cert.crt;
ssl_certificate_key /app/cert.key;
```
`nginx.conf`配置参考：
```conf
user root;
daemon off;
# 绑定cpu亲核性，减少cache未命中，请根据实际情况修改
worker_processes 1;
worker_cpu_affinity 1;
# 日志输出到标准输出
error_log /dev/stdout;
events {
    # 设置单个worker连接数
    worker_connections 10240;
    use epoll;
}

http {
    # 增加哈希桶大小，解决server_name哈希表构建失败问题
    server_names_hash_bucket_size 64;  # 添加这一行
    # 配置名为access的log输出格式
    log_format access '$remote_addr $server_port - $http_host [$time_local] '
                      '"$request" $status $body_bytes_sent '
                      '"$http_referer" "$http_user_agent" '
                      '$http_x_forwarded_for|$http_x_real_ip|$limit_key';
    # log日志输出到标准输出
    # access_log /dev/stdout access;
    # 关闭日志，提高性能。开启日志，排查问题
    access_log off;

    # 白名单不限速
    geo $limit {
        default 1;
        192.168.0.0/24 0;
        10.0.0.0/8 0;
        127.0.0.0/8 0;
    }

    # Header有X-Forwarded-IP就用xff，没有就用数据包的源IP
    map $http_x_forwarded_for $real_ip {
        default         $remote_addr;
        "~^(?P<ip>[^,]+)" $ip;
    }

    # 匹配到白名单就为空不限速，没匹配到就限速
    map $limit $limit_key {
        0 "";
        1 $real_ip;
    }

    geo $whitelist {
        default 0;
        1.1.1.0/24 1;  # cdn的ip访问白名单
    }

    # 请求超过阈值，断开连接
    limit_req_status 444;
    # 限制单个ip的请求数，避免单个ip打爆服务，请根据实际业务进行修改
    limit_req_zone $limit_key   zone=req_ip:10m   rate=5r/s;
    # 限制单个服务的请求数，避免请求过载打爆服务，请根据实际业务进行修改
    limit_req_zone $server_name zone=req_svr:1m   rate=1000r/s;
    # 限制单个uri的请求数，避免带宽被打爆，请根据实际业务进行修改
    limit_req_zone $uri         zone=req_res:10m  rate=3r/s;
    # 连接数超过阈值，断开连接
    limit_conn_status 444;
    # 限制单个ip的连接数
    limit_conn_zone $limit_key zone=con_ip:10m;
    # 限速的共享内存，如果不够可以改大
    lua_shared_dict traffic_stats 50m;
    # 引入lua模块
    lua_package_path "/app/?.lua;;";
    server {
        # 设置dns解析
        resolver 8.8.8.8 ipv6=off;
        # 监听80和443端口
        listen 80;
        listen 443 ssl;
        # 关闭文件索引，避免文件结构泄漏
        autoindex off;
        # 设置静态文件的目录
        root /www;
        # 开启OCSP装订，加速TLS握手效率
        ssl_stapling off;
        ssl_stapling_verify off;
        # 配置ssl证书和密钥
        ssl_certificate /app/cert.crt;
        ssl_certificate_key /app/private.key;
        # SSL会话有效期
        ssl_session_timeout 5m;
        # 使用SSL版本，加密算法
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
        ssl_prefer_server_ciphers on;
        # 开启HSTS，强制用户浏览器使用https协议
        add_header Strict-Transport-Security "max-age=2592000";

        # 开启gzip压缩，配置压缩文件类型，压缩等级，最小压缩长度，关闭IE浏览器压缩
        gzip on;
        gzip_types *;
        gzip_comp_level 6;
        gzip_min_length 256;
        gzip_buffers 16 8k;
        gzip_proxied any;
        gzip_vary on;
        gzip_disable "MSIE [1-6]\.(?!.*SV1)";

        # 配置匹配的域名 (重要，必须修改)
        server_name example.com;

        # 限制下行带宽
        limit_rate 100k;
        limit_rate_after 1m;

        # 限制连接数
        limit_conn con_ip 40;

        # 检查客户浏览器端是否断开连接
        lua_check_client_abort on;

        # 引入限速配置文件
        include /app/env.conf;

        # 开启CDN源IP访问白名单
        # deny all;
        # allow $whitelist;

        # --- 添加以下两行来记录请求开始时间 ---
        access_by_lua_block {
            ngx.ctx.start_clock = os.clock()
        }
        # ---------------------------------------

        # 如果后段服务为http服务，请保留这一段，并修改后段服务地址
        location / {

            # 对单个ip进行限速，请根据实际业务进行修改
            limit_req zone=req_ip burst=100 delay=200;
            # 对整个服务进行限速，请根据实际业务进行修改
            limit_req zone=req_svr burst=1000 delay=2000;
            # 向后端传递host名
            proxy_set_header Host $host;
            # 对请求IP进行限速处理
            access_by_lua_file /app/protect.lua;
            # # 对请求IP流量进行统计
            # log_by_lua_file /app/record.lua;
            # 调试使用
            # lua_code_cache off;
            # access_by_lua_file /app/protect.lua;
            # log_by_lua_file /app/record.lua;
            # 如果是纯静态网站，请保留index，并删除proxy_pass。
            # index index.php index.html index.htm;
            # 后段服务地址，请 根据实际情况修改
            proxy_pass http://127.0.0.1:8090;

            # 对请求IP流量进行统计 一定要放在最后 否则统计不准确
            log_by_lua_file /app/record.lua;
        }

        # 后段服务为php-fpm。请保留这一段，否则删除
        # location / {
        #     # 对单个ip进行限速，请根据实际业务进行修改
        #     limit_req zone=req_ip burst=100 delay=200;
        #     # 对整个服务进行限速，请根据实际业务进行修改
        #     limit_req zone=req_svr burst=1000 delay=2000;
        #     # 向后端传递host名
        #     proxy_set_header Host $host;
        #     # 对请求IP进行限速处理
        #     access_by_lua_file /app/protect.lua;
        #     # 对请求IP流量进行统计
        #     log_by_lua_file /app/record.lua;
        #     # 调试使用
        #     # lua_code_cache off;
        #     # access_by_lua_file /app/protect.lua;
        #     # log_by_lua_file /app/record.lua;
        #     # 逐个匹配php、html、htm
        #     index index.php index.html index.htm;
        # }

        # 后段服务为php-fpm。请保留这一段，否则删除
        # location ~ \.php$ {
        #     # 对单个ip进行限速，请根据实际业务进行修改
        #     limit_req zone=req_ip burst=100 delay=200;
        #     # 对整个服务进行限速，请根据实际业务进行修改
        #     limit_req zone=req_svr burst=1000 delay=2000;
        #     # 向后端传递host名
        #     proxy_set_header Host $host;
        #     # 对请求IP进行限速处理
        #     access_by_lua_file /app/protect.lua;
        #     # 对请求IP流量进行统计
        #     log_by_lua_file /app/record.lua;
        #     # 调试使用
        #     # lua_code_cache off;
        #     # access_by_lua_file /app/protect.lua;
        #     # log_by_lua_file /app/record.lua;
        #     # php-fpm的地址，请 根据实际情况修改
        #     fastcgi_pass   127.0.0.1:9000;
        #     fastcgi_index  index.php;
        #     fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        #     include        fastcgi_params;
        # }

        # 查看ip的统计信息
        location /dk8s.stats {
            # 对单个ip进行限速
            limit_req zone=req_ip burst=100 delay=200;
            # 对整个服务进行限速
            limit_req zone=req_svr burst=1000 delay=2000;
            # lua_code_cache off;
            # access_by_lua_file /app/protect.lua;
            # log_by_lua_file /app/record.lua;
            access_by_lua_file /app/protect.lua;
            content_by_lua_file /app/stats.lua;
            log_by_lua_file /app/record.lua;
        }

        # 图片资源等信息，用作配置浏览器缓存。请修改后段服务地址，或删除proxy_pass，并把图片存到/www/所在位置
        location ~* \.(jpg|png|jpeg)$ {
            # 对单个ip进行限速
            limit_req zone=req_ip burst=100 delay=200;
            # 对整个服务进行限速
            limit_req zone=req_svr burst=1000 delay=2000;
            # 对uri进行限速，防止刷单个资源，导致带宽被打爆
            limit_req zone=req_res burst=200 delay=1000;
            # lua_code_cache off;
            # access_by_lua_file /app/protect.lua;
            # log_by_lua_file /app/record.lua;
            # 设置浏览器资源过期时间
            expires 7d;
            proxy_set_header Host $host;
            access_by_lua_file /app/protect.lua;
            # log_by_lua_file /app/record.lua;
            # 后段服务地址，请 根据实际情况修改。如果资源存在/www/所在的位置，请删除proxy_pass
            proxy_pass http://127.0.0.1:8090;

            # 对请求IP流量进行统计 一定要放在最后 否则统计不准确
            log_by_lua_file /app/record.lua;
        }

        # 样式资源等信息，用作配置浏览器缓存。请修改后段服务地址，或删除proxy_pass，并把js，css存到/www/所在位置
        location ~* \.(js|css|svg|woff|woff2)$ {
            # 对单个ip进行限速
            limit_req zone=req_ip burst=100 delay=200;
            # 对整个服务进行限速
            limit_req zone=req_svr burst=1000 delay=2000;
            # 对uri进行限速，防止刷单个资源，导致带宽被打爆
            limit_req zone=req_res burst=200 delay=1000;
            # lua_code_cache off;
            # access_by_lua_file /app/protect.lua;
            # log_by_lua_file /app/record.lua;
            # 设置浏览器资源过期时间
            expires 1d;
            # 向后端传递host名
            proxy_set_header Host $host;
            # 让浏览器每次请求检查资源是否过期
            add_header Cache-Control no-cache;
            access_by_lua_file /app/protect.lua;
            # log_by_lua_file /app/record.lua;
            # 后段服务地址，请 根据实际情况修改。如果资源存在/www/所在的位置，请删除proxy_pass
            proxy_pass http://127.0.0.1:8090;

            # 对请求IP流量进行统计 一定要放在最后 否则统计不准确
            log_by_lua_file /app/record.lua;
        }

        error_page 429 @429;
        location @429 {
            return 429 "error";
        }

        # location /control_group {
        #     # 测速的对照组，生产环境请删除
        #     proxy_set_header Host $host;
        #     proxy_pass http://127.0.0.1:3000;
        #     access_by_lua_block {
        #         ngx.exit(429)
        #     }
        #     log_by_lua_block {
        #         local a=0;
        #     }
        # }
    }

    # 注意避免端口冲突
    server {
        # 未匹配的域名，断开连接，防止源站被扫描
        listen 80;
        listen 443 ssl;
        ssl_reject_handshake on;
        return 444;
    }
}
```