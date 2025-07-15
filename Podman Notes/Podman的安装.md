# 安装 Podman

**使用 Podman 启动容器**  
Podman 是一个开源的容器管理工具，提供了与 Docker 类似的功能，但不依赖于守护进程。以下是使用 Podman 启动容器的基本步骤和命令。  

在不同操作系统上安装 Podman 的步骤如下：  

### 添加Kubic项目仓库（提供最新容器工具）
```bash
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$(lsb_release -rs)/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
```

### 导入仓库GPG密钥
```bash
curl -fsSL "https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_$(lsb_release -rs)/Release.key" | sudo gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/libcontainers.gpg > /dev/null
```

### Ubuntu
```bash
sudo apt update
sudo apt -y install podman
podman --version
```

### CentOS/RHEL
```bash
sudo dnf -y install dnf-plugins-core
sudo dnf -y copr enable rhcontainerbot/container-selinux
sudo dnf -y module disable container-tools:rhel8
sudo dnf -y module enable container-tools:3.0
sudo dnf -y install podman
podman --version
```

### MacOS
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install podman
podman machine init
podman machine start
podman run hello-world
```

### Windows (通过 WSL)
```bat
wsl --install
```
重启电脑后，在 WSL 中运行以下命令  
```bash
sudo apt-get update
sudo apt-get install -y podman
podman --version
```

## 更换镜像源
```bash
vim /etc/containers/registries.conf
```
```conf
unqualified-search-registries = ["docker.io"]

[[registry]]
prefix = "docker.io"
location = "docker.io"
insecure = false

[[registry.mirror]]
location = "abc.itelyou.cf"
insecure = true

[[registry.mirror]]
location = "docker.itelyou.cf"
insecure = true

[[registry.mirror]]
location = "docker-0.unsee.tech"
insecure = true

[[registry.mirror]]
location = "docker.hlmirror.com"
insecure = true

[[registry.mirror]]
location = "dockerpull.pw"
insecure = true

[[registry.mirror]]
location = "docker.1ms.run"
insecure = true

[[registry.mirror]]
location = "docker.xuanyuan.me"
insecure = true
```

刷新DNS缓存
```bash
sudo systemctl restart systemd-resolved
```

重置 Podman 所有状态
```bash
podman system reset --force
```
