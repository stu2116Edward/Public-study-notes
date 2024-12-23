# FTP服务器搭建保姆级教程

### CentOS系统下的FTP配置命令及解释

#### 1. 安装vsftpd服务

```bash
yum install -y vsftpd
```

**解释**：使用`yum`安装`vsftpd`软件包，这是运行FTP服务器所必需的。

#### 2. 启动vsftpd服务并设置开机自启

```bash
systemctl start vsftpd
systemctl enable vsftpd
```

**解释**：启动FTP服务，并使用`systemctl enable`命令设置开机自启动。

#### 3. 停止防火墙服务（如果需要）

```bash
systemctl stop firewalld
```

**解释**：停止`firewalld`服务，以便FTP服务可以正常工作。如果你的服务器使用其他防火墙管理工具，也需要相应地配置或停止服务。

#### 4. 配置SELinux（如果需要）

```bash
setenforce 0
```

**解释**：将SELinux设置为宽容模式，以避免权限问题。这不是推荐的长期解决方案，最好是配置SELinux策略允许vsftpd运行。

#### 5. 编辑vsftpd配置文件

```bash
vim /etc/vsftpd/vsftpd.conf
```

**解释**：使用文本编辑器打开vsftpd的主配置文件进行编辑。

#### 6. 配置匿名访问（如果需要）

```plaintext
anonymous_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES
```

**解释**：在`vsftpd.conf`中设置允许匿名访问、上传和创建目录的参数。

#### 7. 重启vsftpd服务以应用更改

```bash
systemctl restart vsftpd
```

**解释**：重启FTP服务以使配置更改生效。

#### 8. 设置FTP目录权限

```bash
chmod 777 /var/ftp/pub
```

**解释**：设置FTP目录的权限为777，允许所有用户读写执行。出于安全考虑，这通常不是推荐的做法，建议根据实际需要设置更严格的权限。

#### 9. 创建本地用户（如果需要本地用户访问）

```bash
useradd -d /web/www/html team1
useradd -d /web/www/html team2
```

**解释**：创建本地用户，并设置他们的家目录为`/web/www/html`。

#### 10. 设置本地用户密码

```bash
echo "123" | passwd --stdin team1
echo "123" | passwd --stdin team2
```

**解释**：为本地用户设置密码。

#### 11. 配置PAM文件

```bash
vim /etc/pam.d/vsftpd
```

**解释**：编辑PAM配置文件以配置用户认证。

#### 12. 配置虚拟用户数据库（如果需要）

```bash
db_load -T -t hash -f /etc/vsftpd/vuser /etc/vsftpd/vuser.db
```

**解释**：从文本文件生成数据库文件，用于虚拟用户认证。

#### 13. 配置主被动模式（如果需要）

```plaintext
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=31000
```

**解释**：在`vsftpd.conf`中启用被动模式，并设置被动模式的端口范围。

#### 14. 取消挂载FTP

```bash
umount /var/ftp/pub
```

**解释**：如果FTP目录被挂载，使用此命令卸载。

### Ubuntu系统下的FTP配置命令及解释

#### 1. 安装vsftpd服务

```bash
sudo apt update
sudo apt install vsftpd
```

**解释**：更新软件包列表，然后安装`vsftpd`软件包，这是运行FTP服务器所必需的。

#### 2. 启动vsftpd服务并设置开机自启

```bash
sudo systemctl start vsftpd
sudo systemctl enable vsftpd
```

**解释**：启动FTP服务，并使用`systemctl enable`命令设置开机自启动。

#### 3. 编辑vsftpd配置文件

```bash
sudo nano /etc/vsftpd.conf
```

**解释**：使用文本编辑器（这里使用`nano`）打开vsftpd的主配置文件进行编辑。

#### 4. 配置匿名访问（如果需要）

```plaintext
anonymous_enable=YES
anon_upload_enable=YES
anon_mkdir_write_enable=YES
```

**解释**：在`/etc/vsftpd.conf`中设置允许匿名访问、上传和创建目录的参数。

#### 5. 重启vsftpd服务以应用更改

```bash
sudo systemctl restart vsftpd
```

**解释**：重启FTP服务以使配置更改生效。

#### 6. 设置FTP目录权限

```bash
sudo chmod 777 /var/ftp
```

**解释**：设置FTP目录的权限为777，允许所有用户读写执行。出于安全考虑，这通常不是推荐的做法，建议根据实际需要设置更严格的权限。

#### 7. 创建本地用户（如果需要本地用户访问）

```bash
sudo useradd -m -d /home/ftpuser ftpuser
```

**解释**：创建一个新用户，并设置其家目录为`/home/ftpuser`。

#### 8. 设置本地用户密码

```bash
sudo passwd ftpuser
```

**解释**：为本地用户设置密码。

#### 9. 配置PAM文件（如果需要）

```bash
sudo nano /etc/pam.d/vsftpd
```

**解释**：编辑PAM配置文件以配置用户认证。

#### 10. 配置虚拟用户数据库（如果需要）

```bash
sudo db_load -T -t hash -f /etc/vsftpd/vuser_list /etc/vsftpd/vuser_list.db
```

**解释**：从文本文件生成数据库文件，用于虚拟用户认证。

#### 11. 配置主被动模式（如果需要）

```plaintext
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=31000
```

**解释**：在`/etc/vsftpd.conf`中启用被动模式，并设置被动模式的端口范围。

#### 12. 取消挂载FTP

```bash
sudo umount /var/ftp
```

**解释**：如果FTP目录被挂载，使用此命令卸载。
