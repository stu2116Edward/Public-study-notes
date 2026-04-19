# 本地部署OpenClaw Agent

### 创建项目目录
```
mkdir -p ~/openclaw/{data,config,openclaw-data}
cd ~/openclaw
```



### 设置权限（1000:1000 是容器内 node 用户的 UID/GID）
```
sudo chown -R 1000:1000 ~/openclaw
sudo chmod -R 755 ~/openclaw
```



### 编写 docker-compose.yml
```bash
touch docker-compose.yml
vim docker-compose.yml
```

```yml
services:
  openclaw:
    image: ghcr.io/openclaw/openclaw:latest
    container_name: openclaw
    ports:
      - "18789:18789"
    volumes:
      - ./data:/app/data
      - ./config:/app/config
      - ./openclaw-data:/home/node/.openclaw
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - NODE_ENV=production
      - TZ=UTC
      - CONTROL_UI_ALLOWED_ORIGINS=http://localhost:18789,http://127.0.0.1:18789,http://192.168.66.113:18789
    restart: unless-stopped
    networks:
      - openclaw-net

networks:
  openclaw-net:
    driver: bridge
```

修改允许访问的IP
```
vim ./openclaw-data/openclaw.json
```
修改如下
```
{
  "gateway": {
    "auth": {
      "mode": "token",
      "token": "17574f2de931510f5a2dfb4382f3653f2f8a2156070f7f4a"
    },
    "controlUi": {
      "allowInsecureAuth": true,  // 允许非安全认证
      "dangerouslyDisableDeviceAuth": true, // 核心：禁用设备身份验证
      "allowedOrigins": [
        "http://localhost:18789",
        "http://127.0.0.1:18789",
        "http://192.168.66.113:18789"
      ]
    }
  },
  "meta": {
    "lastTouchedVersion": "2026.4.15",
    "lastTouchedAt": "2026-04-19T03:44:02.046Z"
  }
}
```
修改`allowedOrigins`添加允许的IP

修改后要重启
```
docker-compose restart openclaw
```



### 启动服务

后台启动
```
docker-compose up -d
```
查看启动日志
```
docker logs openclaw
```



### 访问 Web 控制台
浏览器打开：`http://服务器IP:18789`  
连接时需要 Token，获取方式：  
- 查看 `./data/openclaw.json` 的 `auth.token` 字段
- 或在启动日志中查找自动生成的 Token
查看 openclaw-data 目录中的配置文件  
```
docker exec -it openclaw cat /home/node/.openclaw/openclaw.json | grep -A 5 '"auth"'
```



### Nginx https反向代理
生成自签名证书（局域网/测试）
```
mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout example.com.key -out example.com.pem \
  -subj "/CN=example.com"
```

配置示例
```conf
# HTTP 自动跳转 HTTPS
server {
    listen 80;
    server_name example.com;  # 替换为你的域名
    return 301 https://$server_name$request_uri;
}

# HTTPS 配置
server {
    listen 443 ssl http2;
    server_name example.com;  # 替换为你的域名

    # SSL 证书路径（替换为实际路径）
    ssl_certificate     /path/to/your/cert.pem;
    ssl_certificate_key /path/to/your/key.pem;

    # SSL 安全配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # 安全响应头
    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;

    location / {
        proxy_pass http://127.0.0.1:18789;

        # WebSocket 支持
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        # 标准代理头
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port $server_port;

        # 关闭缓冲
        proxy_buffering off;

        # 超时设置
        proxy_read_timeout 86400s;
        proxy_send_timeout 86400s;
        proxy_connect_timeout 75s;
    }
}
```

应用Nginx配置
```
nginx -t
nginx -s reload
```

修改配置文件
```
    "controlUi": {
      "allowedOrigins": [
        "http://example.com",
        "https://example.com"
      ]
    }
```

重启服务
```
docker-compose restart openclaw
```
