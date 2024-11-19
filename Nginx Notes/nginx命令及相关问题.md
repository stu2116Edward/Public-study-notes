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


### 备份配置文件

在对 Nginx 配置文件进行任何修改之前，建议先进行备份，以便在遇到问题时能够迅速恢复到原始状态。备份命令如下：

```bash
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
```

这样，无论何时需要恢复，都可以轻松地将备份文件复制回原始位置。

### 配置文件的权限和所有权

为了确保 Nginx 配置文件的安全性，建议设置正确的文件权限和所有权。这可以通过以下命令完成：

```bash
sudo chown root:root /etc/nginx/nginx.conf
sudo chmod 644 /etc/nginx/nginx.conf
```

这些设置确保只有 root 用户可以修改配置文件，而其他用户只能读取，从而提高了系统的安全性。

### 使用环境变量

通过在 Nginx 配置文件中使用环境变量，可以提高配置的灵活性和可维护性。例如：

```nginx
server {
    listen 80;
    server_name $MY_SERVER_NAME;
    ...
}
```

在启动 Nginx 之前，设置环境变量：

```bash
export MY_SERVER_NAME=example.com
```

这种方法允许你在不修改配置文件的情况下，通过环境变量动态调整服务器名称，非常适合在不同的部署环境中快速切换配置。

### 日志轮转

为了有效管理 Nginx 的日志文件并避免它们占用过多磁盘空间，建议使用日志轮转工具 `logrotate`。首先，安装 `logrotate`：

```bash
sudo apt install logrotate
```

然后，编辑 `/etc/logrotate.conf` 或 `/etc/logrotate.d/nginx` 文件，添加日志轮转配置：

```bash
/var/log/nginx/*.log {
    weekly
    rotate 52
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
    endscript
}
```

这些配置将每周轮转一次日志文件，并保留 52 周的日志记录。压缩旧日志文件，延迟压缩最新日志文件，仅在日志文件非空时进行轮转，并在轮转后重新加载 Nginx 配置。

### 性能监控

为了监控 Nginx 的性能和资源使用情况，可以使用 `htop` 或 `top` 这样的工具。首先，安装 `htop`：

```bash
sudo apt install htop
```

然后，启动 `htop`：

```bash
sudo htop
```

这些工具提供了实时的系统资源使用情况，包括 CPU、内存、磁盘 I/O 和进程列表，有助于识别性能瓶颈。

### 安全加固

为了提高 Nginx 的安全性，建议采取以下措施：

- 确保 Nginx 服务只监听必要的端口。
- 使用 HTTPS 加密传输，确保数据传输的安全性。
- 定期更新 Nginx 到最新版本，以修复已知的安全漏洞。

### 配置文件的模块化

为了提高 Nginx 配置的可维护性和可读性，建议将不同的配置模块化。例如，将静态文件、代理、SSL 配置等分别放在不同的文件中，然后在主配置文件中引入这些模块：

```nginx
include /etc/nginx/modules/*.conf;
```

这种方法使得配置文件更加清晰，易于管理和扩展。

### 使用 Nginx Plus
如果你需要更高级的功能，如负载均衡、健康检查等，可以考虑使用 Nginx Plus。Nginx Plus 是 Nginx 的商业版本，提供了额外的高级功能和商业支持。
- [Nginx Plus 官方文档](https://nginx.org/en/docs/stream/ngx_stream_core_module.html)

### 日志分析
为了更好地了解流量和性能，可以使用日志分析工具，如 `ELK Stack` 或 `Grafana`。这些工具可以帮助你收集、存储、搜索、分析和可视化日志数据，从而提供深入的洞察。
- **ELK Stack**：由 Elasticsearch、Logstash 和 Kibana 组成，用于日志数据的收集、处理和可视化。
  - [ELK Stack 官方文档](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- **Grafana**：一个跨平台的开源分析和监控解决方案。
  - [Grafana 官方文档](https://grafana.com/docs/grafana/latest/)

### 文档和帮助
为了帮助用户在遇到问题时能够快速查找解决方案，建议提供一些 Nginx 配置的文档和帮助链接。这包括官方文档、社区论坛、常见问题解答等资源，以便用户能够轻松获取所需的信息。
- **Nginx 官方文档**：提供了全面的配置指南、模块说明和使用示例。
  - [Nginx 官方文档](https://nginx.org/en/docs/)
- **Nginx 社区论坛**：Nginx 官方论坛是一个专门讨论 Nginx 的社区，用户可以在这里交流经验、分享配置和解决方案。
  - [Nginx 论坛](https://forum.nginx.org/)
- **Stack Overflow 上的 Nginx 标签**：一个广泛使用的技术问答社区，用户可以在这里提问和回答与 Nginx 相关的问题。
  - [Stack Overflow Nginx 标签](https://stackoverflow.com/questions/tagged/nginx)


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
