# ubuntu20.04 使用root用户登录系统

**文章目录**  
- 1. 以普通用户登录系统，创建root用户的密码
- 2. 修改`50-ubuntu.conf`文件
- 3. 修改`gdm-autologin`文件
- 4. 修改`gdm-password`文件
- 5. 修改`/root/.profile`文件
- 6. 注销当前用户，登录root用户

### 1. 以普通用户登录系统，创建root用户的密码
在终端输入命令：
```
sudo passwd root
```
先输入当前普通用户（如用户coco）的密码，用于提权  

然后再输入为root用户所设置的密码，输入两次，这样就完成设置root用户密码了（注意Linux系统下密码是没有回显的）  

### 2. 修改50-ubuntu.conf文件
在终端输入命令：
```
sudo gedit /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf
```
在文件末尾增加如下两行并保存：
```
greeter-show-manual-login=true #手工输入登陆系统的用户名和密码  
allow-guest=false #不允许guest登录（可选）  
```

### 3. 修改gdm-autologin文件
在终端输入命令：
```
sudo gedit /etc/pam.d/gdm-autologin
```
在第三行前面加`#`以注释掉`auth required pam_succeed_if.so user != root quiet_success`，随后保存并退出  

### 4. 修改gdm-password文件
在终端输入命令：
```
sudo gedit /etc/pam.d/gdm-password
```
在第三行前面加`#`以注释掉`auth required pam_succeed_if.so user != root quiet_success`，随后保存并退出  

### 5. 修改/root/.profile文件
在终端输入命令：
```
sudo gedit /root/.profile
```
将文件末尾的`mesg n 2> /dev/null || true`这一行注释掉，并随后添加：
```
tty -s&&mesg n || true
```

### 6. 注销当前用户，登录root用户
一般修改完配置后最好重启一下  
在终端输入命令：  
```
reboot
```

点击未列出?  

输入root然后按回车键  

输入你之前设置root账户的密码然后按回车键，即可成功登录  
