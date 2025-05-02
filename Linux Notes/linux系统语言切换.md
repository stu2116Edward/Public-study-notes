# linux系统语言切换

1. 系统语言切换：
```bash
cd /etc/default
```

2. 打开系统语言配置文件：
```bash
gedit locale
```

备注：如果系统提示没有安装【gedit】，可以使用以下命令安装后，重复上面的命令打开配置文件：
```bash
apt-get install gedit
```

3. 修改系统文件内容：
修改系统语言为中文：
```
LANG="zh_CN.UTF-8"
LANGUAGE="zh_CN:zh"
```
修改系统语言为英文：
```
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
```

4. 保存修改后的文档

5. 重启系统：
```bash
reboot
```