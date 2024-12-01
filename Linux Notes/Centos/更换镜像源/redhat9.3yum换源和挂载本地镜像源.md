# redhat9.3配置国内yum阿里源和挂载本地镜像源

### 挂载本地镜像源

#### 逻辑分析
- 本地仓库主要是 Linux 自带的安装包，位于 ISO 镜像文件中。
- 需要在 `/etc/yum.repos.d` 中配置 AppStream 和 BaseOS 两个存储库。

#### 实验步骤
1. **查看 ISO 文件**
```bash
df -h
```
![redhy1](https://github.com/user-attachments/assets/911024a9-6f7f-4197-8647-8d81110b360c)  

找到 ISO 文件，通常是 8GB 左右。

2. **创建挂载点**
```bash
mkdir -p /my/iso
```

3. **挂载 ISO 文件**
```bash
mount /dev/sr0 /my/iso
```

4. **查看挂载内容**
```bash
ls /my/iso
```
![redhy2](https://github.com/user-attachments/assets/3c37c7a3-91aa-43f0-8d21-5f3062d025ee)  

5. **配置文件**
在 `/etc/yum.repos.d` 中创建 `red9.repo` 文件：
```bash
cd /etc/yum.repos.d/
vim red9.repo
```
编辑文件，添加以下内容：
```ini
[BaseOS]
name=red9-BaseOS
baseurl=file:///my/iso/BaseOS
gpgcheck=0
 
[AppStream]
name=red9-AppStream
baseurl=file:///my/iso/AppStream
gpgcheck=0
```

6. **查看仓库**
```bash
yum repolist
```

### 配置国内 Yum 源

#### 实验步骤
1. **新建 Yum 源文件并配置**
```bash
cd /etc/yum.repos.d/
vim aliyun-yum.repo
```
编辑文件，添加以下内容：
```ini
[ali_baseos]
name=ali_baseos
baseurl=https://mirrors.aliyun.com/centos-stream/9-stream/BaseOS/x86_64/os/
gpgcheck=0

[ali_appstream]
name=ali_appstream
baseurl=https://mirrors.aliyun.com/centos-stream/9-stream/AppStream/x86_64/os/
gpgcheck=0
```

2. **创建软件缓存信息**
```bash
yum makecache
```

3. **更新软件**
```bash
yum -y update
```

4. **尝试下载软件包**
```bash
yum install php
```

### 注意事项
- 确保 ISO 文件已正确挂载。
- 确保 `/etc/yum.repos.d` 中的 `.repo` 文件配置正确。
- 如果无法访问阿里云镜像源，可能是网络问题或链接问题，请检查链接的合法性并适当重试。
