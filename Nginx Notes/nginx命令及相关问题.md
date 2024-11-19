安装好nginx后将/etc/nginx/目录下的nginx.conf配置文件修改或更换为自己的  
使用命令重新加载 Nginx 的配置文件  
```
nginx -s reload
```
如果nginx的 PID 加载异常并且nginx反向代理语法没有问题那就重启vps重启可以解决百分之90%的问题  
遇到类似错误  
<pre>
root@linux:~# nginx -s reload  
nginx: [error] invalid PID number "" in "/run/nginx.pid" 
</pre>
先重启nginx:  
```
systemctl restart nginx
```
如果不行直接重启vps

检查 Nginx 语法类似如下就是正常的  
<pre>
root@linux:~# nginx -t  
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
nginx: configuration file /etc/nginx/nginx.conf test is successful  
</pre>

### 安装 Nginx
```bash
sudo apt update
sudo apt install nginx
```

### 启动 Nginx
```bash
sudo systemctl start nginx
```

### 检查 Nginx 状态
```bash
sudo systemctl status nginx
```

### 重新启动 Nginx 服务
```bash
sudo systemctl restart nginx
```

### 如果 Nginx 无法启动
1. **检查 Nginx 配置文件**
   ```bash
   sudo nginx -t
   ```
   如果配置文件有错误，Nginx 会指出错误的位置。

2. **检查 PID 文件路径**
   ```bash
   ls -l /run/nginx.pid
   ```
   如果 PID 文件不存在，确保 Nginx 服务已经启动。

3. **重新加载 Nginx 配置**
   ```bash
   sudo systemctl reload nginx
   ```

### 更新包列表
```bash
sudo apt update
```

### 卸载 Nginx
卸载 Nginx 及其核心模块：  
```bash
sudo apt-get remove --purge nginx nginx-common nginx-core
```  
再次执行自动删除未使用的依赖：  
```bash
sudo apt-get autoremove
```

### 删除 Nginx 生成的文件
```bash  
sudo rm -rf /var/log/nginx /etc/nginx
```
删除 Nginx 的文档和缓存  
```bash  
sudo rm -rf /var/lib/nginx
```
清理残留的配置文件  
```bash  
sudo apt-get purge 'nginx*'
```
清理本地仓库  
```bash  
sudo apt-get clean
```
更新包列表  
```bash  
sudo apt-get update
```
### 验证 Nginx 是否已被卸载  
```bash
sudo apt list --installed | grep nginx
```
如果没有输出，说明 Nginx 已经被卸载。

### 其他常用 Nginx 命令
- **停止 Nginx 服务**
  ```bash
  sudo systemctl stop nginx
  ```

- **查看 Nginx 版本**
  ```bash
  sudo nginx -v
  ```

- **查看 Nginx 配置文件路径**
  ```bash
  sudo nginx -V 2>&1 | grep -oP '/configfile\s*\S+'
  ```

- **查看 Nginx PID 文件路径**
  ```bash
  sudo nginx -V 2>&1 | grep -oP '.pid\s*\S+'
  ```

- **查看 Nginx 服务日志**
  ```bash
  sudo tail -f /var/log/nginx/access.log
  sudo tail -f /var/log/nginx/error.log
  ```

- **设置 Nginx 服务开机自启**
  ```bash
  sudo systemctl enable nginx
  ```

- **禁用 Nginx 服务开机自启**
  ```bash
  sudo systemctl disable nginx
  ```
