# 修复Docker兼容性问题


“time-namespaces”问题通常出现在 Docker Engine v29.5.0 及更高版本。从该版本开始，Docker 默认在支持的内核上为容器启用私有时间命名空间，这可能导致出现兼容性故障

### Error Feature
<pre>
docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: namespace {"time" ""} does not exist
</pre>

### 修复方案：修改 daemon.json 禁用 time-namespaces

备份原文件：
```
sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
```

新增如下内容
```
{
  "features": {
    "time-namespaces": false
  }
}
```

或直接覆盖
```
sudo tee /etc/docker/daemon.json <<EOF
{
  "features": {
    "time-namespaces": false
  }
}
EOF
```

恢复备份配置
```
sudo cp /etc/docker/daemon.json.bak /etc/docker/daemon.json
```

重新加载配置并重启 Docker
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
