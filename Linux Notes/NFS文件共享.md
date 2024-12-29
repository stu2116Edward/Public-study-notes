# NFS文件共享


### CentOS系统下的NFS配置命令及解释

#### 1. 安装NFS服务软件包

```bash
yum install -y nfs-utils rpcbind
```

**解释**：安装NFS客户端和服务端所需的工具，`nfs-utils` 提供NFS服务功能，`rpcbind` 提供RPC服务。

#### 2. 启动NFS服务

```bash
systemctl start rpcbind
systemctl start nfs
systemctl enable rpcbind
systemctl enable nfs
```

**解释**：启动RPC绑定服务和NFS服务，并设置它们开机自启。

#### 3. 配置NFS共享目录

编辑 `/etc/exports` 文件，添加需要共享的目录。

```bash
vim /etc/exports
```

**解释**：使用文本编辑器（如vi）编辑NFS的配置文件，定义哪些目录可以被远程挂载以及它们的权限。

#### 4. 导出共享目录

```bash
exportfs -a
```

**解释**：应用`/etc/exports`文件中的配置，使共享目录生效。

#### 5. 重启NFS服务

```bash
systemctl restart nfs
```

**解释**：重启NFS服务，使配置更改立即生效。

#### 6. 防火墙设置

```bash
firewall-cmd --permanent --add-service=nfs
firewall-cmd --reload
```

**解释**：在防火墙中添加NFS服务规则，允许NFS流量通过，并重新加载防火墙规则。

#### 7. 客户端挂载NFS共享目录

```bash
mount 192.168.1.1:/home /mnt
```

**解释**：将远程NFS服务器上的`/home`目录挂载到本地的`/mnt`目录。

#### 8. 永久挂载配置

编辑 `/etc/fstab` 文件，添加以下内容：

```plaintext
192.168.1.1:/home /mnt nfs defaults 0 0
```

**解释**：在`/etc/fstab`文件中添加条目，使得系统启动时自动挂载NFS共享目录。

#### 取消挂载的命令

```bash
umount /mnt
```

**解释**：卸载`/mnt`目录，断开与NFS共享目录的连接。

### Ubuntu系统下的NFS配置命令及解释

#### 1. 安装NFS服务软件包

```bash
sudo apt update
sudo apt install nfs-kernel-server
```

**解释**：更新软件包列表，安装NFS服务软件包。

#### 2. 启动NFS服务

```bash
sudo systemctl start rpcbind
sudo systemctl start nfs-kernel-server
sudo systemctl enable rpcbind
sudo systemctl enable nfs-kernel-server
```

**解释**：启动RPC绑定服务和NFS服务，并设置它们开机自启。

#### 3. 配置NFS共享目录

创建共享目录并设置权限：

```bash
sudo mkdir /var/nfs/share
sudo chmod 755 /var/nfs/share
```

**解释**：创建一个新的目录用于NFS共享，并设置适当的权限。

编辑 `/etc/exports` 文件，添加以下内容：

```bash
/var/nfs/share 192.168.1.100(rw,sync,no_subtree_check)
```

**解释**：在`/etc/exports`文件中定义共享目录和权限。

#### 4. 导出共享目录

```bash
sudo exportfs -r
```

**解释**：重新读取`/etc/exports`文件，并应用配置。

#### 5. 客户端挂载NFS共享目录

```bash
sudo mount 192.168.1.1:/var/nfs/share /mnt
```

**解释**：将远程NFS服务器上的`/var/nfs/share`目录挂载到本地的`/mnt`目录。

#### 6. 永久挂载配置

编辑 `/etc/fstab` 文件，添加以下内容：

```plaintext
192.168.1.1:/var/nfs/share /mnt nfs defaults 0 0
```

**解释**：在`/etc/fstab`文件中添加条目，使得系统启动时自动挂载NFS共享目录。

#### 取消挂载的命令

```bash
sudo umount /mnt
```

**解释**：卸载`/mnt`目录，断开与NFS共享目录的连接。

如果遇到挂载点无法正常卸载的情况，可以使用以下命令强制卸载：

```bash
sudo umount -l /mnt
```

**解释**：`-l`选项表示拉取（lawn）操作，即使有进程正在使用挂载点，也能强制卸载。
