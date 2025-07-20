# SamWaf部署教程

### 创建存储路径
```bash
mkdir -p /data/samwaf/{conf,data,logs,ssl}
```


### 使用Docker部署
使用命令一键部署
```bash
docker run -d --name=samwaf-instance \
  --restart=always \
  -p 26666:26666 \
  -p 8080:80 \
  -p 8443:443 \
  -v /data/samwaf/conf:/app/conf \
  -v /data/samwaf/data:/app/data \
  -v /data/samwaf/logs:/app/logs \
  -v /data/samwaf/ssl:/app/ssl \
  samwaf/samwaf
```

初次登陆账号密码：`admin/admin868`  
