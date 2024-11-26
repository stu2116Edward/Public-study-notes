# 设置非root账号不用sudo直接执行docker命令

**环境信息**:  
- 操作系统：Ubuntu 20.04 LTS 桌面版  
- Docker：19.03.10  

当前账号是willzhao，直接执行`docker xxx`命令会报以下错误：
<pre>
willzhao@ideapad:~$ docker images
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/images/json: dial unix /var/run/docker.sock: connect: permission denied
</pre>

执行`sudo docker xxx`命令，会提示输入当前账号密码，然后可以成功：
<pre>
willzhao@ideapad:~$ sudo docker images
[sudo] willzhao 的密码： 
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
bolingcavalry/probedemo   0.0.1               803f83e12d88        3 hours ago         508MB
hello-world               latest              bf756fb1ae65        5 months ago        13.3kB
openjdk                   8u212-jdk-stretch   03b20c1fa768        11 months ago       488MB
</pre>

## 设置

1. **创建名为docker的组，如果之前已经有该组就会报错，可以忽略这个错误**：
```bash
sudo groupadd docker
```

2. **将当前用户加入组docker**：
```bash
sudo gpasswd -a ${USER} docker
```

3. **重启docker服务(生产环境请慎用)**：
```bash
sudo systemctl restart docker
```

4. **添加访问和执行权限**：
```bash
sudo chmod a+rw /var/run/docker.sock
```

5. **操作完毕，验证一下，现在可以不用带sudo了**：
<pre>
willzhao@ideapad:~$ docker images
REPOSITORY                TAG                 IMAGE ID            CREATED             SIZE
bolingcavalry/probedemo   0.0.1               803f83e12d88        4 hours ago         508MB
hello-world               latest              bf756fb1ae65        5 months ago        13.3kB
openjdk                   8u212-jdk-stretch   03b20c1fa768        11 months ago       488MB
</pre>

## 撤销

如果你需要撤销上述操作，可以按照以下步骤进行：

1. **查看docker组内的用户**:
```bash
sudo getent group docker
```
输出示例：
<pre>
docker:x:998:edwardhu
- docker：组名
- x：表示组账户有效
- 998：组ID
- edwardhu：组内用户
</pre>
1. **移除访问和执行权限**：
这一步会将`/var/run/docker.sock`的权限恢复到默认状态，移除之前添加的`a+rw`权限。
```bash
sudo chmod a-rw /var/run/docker.sock
```

1. **从docker组中移除当前用户**：
这一步会将用户从docker组中移除。
```bash
sudo gpasswd -d ${USER} docker
```

1. **重启docker服务**：
这一步是为了确保上述更改生效。如果你在生产环境中操作，确保这是安全的。
```bash
sudo systemctl restart docker
```

1. **删除docker组（如果需要）**：
如果你确定不再需要docker组，可以删除它。但请注意，如果系统中还有其他用户属于这个组，这个命令会失败。
```bash
sudo groupdel docker
```
如果docker组中还有其他用户，你可能需要先移除那些用户，或者使用`--force`选项强制删除组（这将从组中移除所有用户）：
```bash
sudo groupdel --force docker
```

