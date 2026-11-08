# 沙箱环境中Docker的运行配置


### 1. 查看当前代理
```
env | grep -i proxy
```
<pre>
root@main:/workspace# env | grep -i proxy
no_proxy=localhost,127.0.0.1,::1
NODE_USE_ENV_PROXY=1
https_proxy=http://127.0.0.1:3128
NO_PROXY=localhost,127.0.0.1,::1
HTTPS_PROXY=http://127.0.0.1:3128
HTTP_PROXY=http://127.0.0.1:3128
http_proxy=http://127.0.0.1:3128
</pre>


### 2. 创建配置目录
```
sudo mkdir -p /etc/systemd/system/docker.service.d
```


### 3. 写入代理配置（使用你环境变量里的地址）
```
sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://127.0.0.1:3128"
Environment="HTTPS_PROXY=http://127.0.0.1:3128"
Environment="NO_PROXY=localhost,127.0.0.1,::1"
EOF
```


### 4. 修改 Docker 守护进程配置
```
sudo tee /etc/docker/daemon.json <<EOF
{
  "storage-driver": "vfs"
}
EOF
```
将 "storage-driver": "vfs" 写入 /etc/docker/daemon.json，是让 Docker 守护进程放弃默认的 overlay2 驱动，转而使用 vfs 驱动，根据 Docker 官方文档，vfs 驱动虽然不是联合文件系统、性能较差且更占空间，但它的优点是健壮、稳定，并且几乎可以在任何环境下工作。


### 5. 重新加载配置并重启 Docker
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
