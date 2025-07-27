# 一键部署高防Nginx

部署支持 `HTTP/3+QUIC`、带 `WAF`、支持 `Brotli/Zstd` 双压缩的高性能的`Nginx` 服务  

### 下载配置文件
```bash
mkdir -p /data/nginx cd /data/nginx \
&& mkdir -p data/nginx/html /data/nginx/certs /data/nginx/conf.d /data/nginx/log/nginx
wget -O /data/nginx/nginx.conf https://gh.kejilion.pro/raw.githubusercontent.com/kejilion/nginx/main/nginx10.conf
wget -O /data/nginx/conf.d/default.conf https://gh.kejilion.pro/raw.githubusercontent.com/kejilion/nginx/main/default10.conf
```

### 开启Waf功能
```bash
sed -i 's|# load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;|load_module /etc/nginx/modules/ngx_http_modsecurity_module.so;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# modsecurity on;|\1modsecurity on;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# modsecurity_rules_file /etc/nginx/modsec/modsecurity.conf;|\1modsecurity_rules_file /etc/nginx/modsec/modsecurity.conf;|' /data/nginx/nginx.conf > /dev/null 2>&1
```

### 开启 Brotli
```bash
sed -i 's|# load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;|load_module /etc/nginx/modules/ngx_http_brotli_filter_module.so;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|# load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;|load_module /etc/nginx/modules/ngx_http_brotli_static_module.so;|' /data/nginx/nginx.conf > /dev/null 2>&1

sed -i 's|^\(\s*\)# brotli on;|\1brotli on;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# brotli_static on;|\1brotli_static on;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# brotli_comp_level \(.*\);|\1brotli_comp_level \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# brotli_buffers \(.*\);|\1brotli_buffers \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# brotli_min_length \(.*\);|\1brotli_min_length \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# brotli_window \(.*\);|\1brotli_window \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# brotli_types \(.*\);|\1brotli_types \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i '/brotli_types/,+6 s/^\(\s*\)#\s*/\1/' /data/nginx/nginx.conf
```

### 开启 Zstd
```bash
sed -i 's|# load_module /etc/nginx/modules/ngx_http_zstd_filter_module.so;|load_module /etc/nginx/modules/ngx_http_zstd_filter_module.so;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|# load_module /etc/nginx/modules/ngx_http_zstd_static_module.so;|load_module /etc/nginx/modules/ngx_http_zstd_static_module.so;|' /data/nginx/nginx.conf > /dev/null 2>&1

sed -i 's|^\(\s*\)# zstd on;|\1zstd on;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# zstd_static on;|\1zstd_static on;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# zstd_comp_level \(.*\);|\1zstd_comp_level \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# zstd_buffers \(.*\);|\1zstd_buffers \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# zstd_min_length \(.*\);|\1zstd_min_length \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i 's|^\(\s*\)# zstd_types \(.*\);|\1zstd_types \2;|' /data/nginx/nginx.conf > /dev/null 2>&1
sed -i '/zstd_types/,+6 s/^\(\s*\)#\s*/\1/' /data/nginx/nginx.conf
```

### 创建默认证书
1. 进入证书目录
```bash
cd /data/nginx/certs
```
2. 一次生成 10 年有效期自签名证书
```bash
openssl req -x509 -newkey rsa:4096 -sha256 -nodes \
  -keyout default_server.key -out default_server.crt \
  -days 3650 -subj "/CN=localhost"
```
3. 赋权
```bash
chmod 600 default_server.*
```

### 启动 Nginx 容器
```bash
docker run -d \
--name nginx \
--restart always \
--network host \
-v "/data/nginx/nginx.conf:/etc/nginx/nginx.conf" \
-v "/data/nginx/conf.d:/etc/nginx/conf.d" \
-v "/data/nginx/certs:/etc/nginx/certs" \
-v "/data/nginx/html:/var/www/html" \
-v "/data/nginx/log/nginx:/var/log/nginx" \
--tmpfs /var/cache/nginx:rw,noexec,nosuid,size=2048m \
kjlion/nginx:alpine
```

### 添加你自建的网站
1. 将ssl证书放到`/data/nginx/certs/`目录下
2. 将网站的`.conf`配置文件放到`/data/nginx/conf.d/`目录下

http和https共存:  
```conf
server {
    listen 80;
    server_name www.example.com;
    
    location / {
        # 你的后端地址
        proxy_pass http://127.0.0.1:8090/;
        # 添加代理相关的设置
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_http_version 1.1;
        proxy_intercept_errors on;
    }
}

server {
    listen 443 ssl;
    server_name www.example.com;
    
    # SSL证书地址
    ssl_certificate /etc/nginx/certs/www.example.com/cert.crt;
    ssl_certificate_key /etc/nginx/certs/www.example.com/private.key;

    location / {
        # 你的后端地址
        proxy_pass http://127.0.0.1:8090/;
        # 添加代理相关的设置
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_http_version 1.1;
        proxy_intercept_errors on;
    }
}
```

强制https配置：  
```conf
server {
    listen 80;
    server_name www.example.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name www.example.com;
    
    # SSL证书地址
    ssl_certificate /etc/nginx/certs/www.example.com/cert.crt;
    ssl_certificate_key /etc/nginx/certs/www.example.com/private.key;

    location / {
        # 你的后端地址
        proxy_pass http://127.0.0.1:8090/;
        # 添加代理相关的设置
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_buffering off;
        proxy_request_buffering off;
        proxy_http_version 1.1;
        proxy_intercept_errors on;
    }
}
```

### 重启配置生效
```bash
docker restart nginx
docker exec nginx nginx -t
docker exec nginx nginx -s reload
```