# podman部署zerotier

### 创建目录
```
mkdir -p /overlay/zerotier-one
```

### 运行容器
```
podman run -d \
  --name zerotier-one \
  --device=/dev/net/tun \
  --net=host
  --cap-add=NET_ADMIN \
  --cap-add=SYS_ADMIN \
  -v /overlay/zerotier-one:/var/lib/zerotier-one \
  zyclonite/zerotier:latest
```

### 进入容器内部
```
podman exec -it zerotier-one sh
```

### 加入你的网络
```
zerotier-cli join <your network ID>
```

### 生成服务文件
```
cat > /etc/init.d/zerotier-one << 'EOF'
#!/bin/sh /etc/rc.common

USE_PROCD=1
START=99
STOP=10

NAME=zerotier-one
PROG=/usr/bin/podman

start_service() {
    mkdir -p /overlay/zerotier-one
    
    if ! $PROG container exists $NAME; then
        $PROG run -d \
            --name $NAME \
            --device=/dev/net/tun \
            --net=host \
            --cap-add=NET_ADMIN \
            --cap-add=SYS_ADMIN \
            --restart unless-stopped \
            -v /overlay/zerotier-one:/var/lib/zerotier-one \
            docker.io/zyclonite/zerotier:latest
    else
        $PROG start $NAME
    fi
}

stop_service() {
    $PROG stop $NAME
}
EOF
```

### 赋予执行权限
```
chmod +x /etc/init.d/zerotier-one
```

### 创建软链接(实现容器开机自启动)
```
ln -sf /etc/init.d/zerotier-one /etc/rc.d/S99zerotier-one
```

### 检查软链接是否存在
```
ls -la /etc/rc.d/ | grep zerotier
```

### 删除软链接(取消容器开机自启动)
```
rm /etc/rc.d/S99zerotier-one
```