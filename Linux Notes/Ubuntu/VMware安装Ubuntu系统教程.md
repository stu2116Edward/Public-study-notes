# VMware安装Ubuntu系统保姆级教程

准备工作：
1. 下载 [Ubuntu 镜像文件](https://mirrors.pku.edu.cn/ubuntu-releases)
2. 下载 [VMware 虚拟机软件](https://softwareupdate.vmware.com/cds/vmw-desktop/ws/)


## 配置 VMware
1. 打开 VMware，点击创建新的虚拟机  

2. 选择自定义，点击【下一步】  

3. 选择稍后安装操作系统，点击【下一步】  

4. 选择操作系统类型为【Linux】版本为【Ubuntu 64位】，点击【下一步】  

5. 处理器按需配置，点击【下一步】  

6. 内存按需配置，建议 2G 以上，点击【下一步】  

7. 网络类型选择【NAT模式】，点击【下一步】  

8. I/O 控制器选择默认的【LSI Logic】，点击【下一步】  

9. 磁盘类型选择【SCSI】，点击【下一步】  

【创建新虚拟磁盘】，点击下一步，磁盘大小按需配置，建议 40G 以上，勾选【将虚拟磁盘存为单个文件】点击【下一步】  

点击【下一步】  

点击【完成】

10. 点击【编辑虚拟机设置】

选择**CD/DVD(SATA)**添加你所下载的Ubuntu iso镜像文件的位置，点击【确定】  


## 安装 Ubuntu 系统
1. 点击开启虚拟机，进入安装界面  

这里需要小等一会等其加载完成  

2. 选择语言【中文(简体)】，点击【安装 Ubuntu】  

3. 键盘布局设置为Chinese然后【回车】  

4. 使用如下的默认配置，这里要按2~3下Tab键然后点击回车  

5. 点击【现在安装】  

6. 点击继续  

7. 位置选择`Shanghai`，点击【继续】  

8. 设置账户密码，点击【继续】  

9. 等待其安装完成  

10. 点击【现在重启】  

11. 提示按下回车  

12. 点击【跳过】  

13. 点击【前进】  

14. 可以自行选择，点击【前进】  

15. 点击【前进】  

16. 点击【完成】  

17. 这里需要重新安装一下**VMware Tools**但是这里并没有显示所以需要重启一下系统  

18. 重启系统  

19. 重启后点击**重新安装VMware Tools**这里点击【是】  

20. 双击桌面上的文件夹进入  

21. 找到**VMwareTools-x-x.tar.gz**右键选择【用归档管理器打开】  

22. 右键，【提取】  

23. 我这里提取到了桌面  

提取完成点击关闭  

24. 右键提取出的文件夹，点击【在终端中打开】  

25. 手动输入以下命令，在输入yes之后全部点击回车  
```bash
sudo ./vmware-install.pl
```
输入密码  
然后输入yes  
之后点击回车  
安装完成  

安装完成后需要**重启才能生效**  

26. 重启后需要安装`open-vm-tools-desktop`才能**实现物理机与虚拟机之间的交互**  
内容参考自：https://www.cnblogs.com/wutou/p/17629408.html  
open-vm-tools-desktop 和 VMware-tools 区别：  
- open-vm-tools-desktop 是 ubuntu 系统提供的开源工具。
- VMware-tools 是 VM 虚拟机官方提供的工具。  
经测试，两者使用区别：  
- open-vm-tools-desktop：安装后，拖拽、复制、粘贴 都可以正常使用，但 共享文件夹 不行。
- VMware-tools：安装后，共享文件夹可以正常使用，但是 拖拽、复制、粘贴 又不行。 
如何让虚拟机，又能 拖拽、复制、粘贴、还可以 共享文件夹？解决方法：open-vm-tools-desktop 和 VMware-tools 都装上  

手动输入以下命令：  
```bash
sudo apt-get install open-vm-tools-desktop
```
回车后输入y  
然后一直回车  
安装完成  

安装完成后需要**重启才能生效**  

可以自行测试是否可以实现物理机与虚拟机之间的复制粘贴的交互行为  

卸载VMware-tools命令：  
1. 卸载官方的 tools 工具：
```bash
sudo vmware-uninstall-tools.pl
```
2. 卸载 ubuntu 开源的 tools 工具：
```bash
sudo apt-get remove open-vm-tools
sudo apt-get remove --auto-remove open-vm-tools
sudo apt-get purge open-vm-tools
sudo apt-get purge --auto-remove open-vm-tools
```

### 系统安装后必装的工具：  
安装文本编辑器：
```bash
apt install vim
```
安装ssh远程连接服务：
```bash
apt install ssh
```

### 进阶操作
- 使用root用户实现登陆与ssh远程登陆
请参考下面的文章：  
[Ubuntu使用root用户登录系统](https://github.com/stu2116Edward/Public-study-notes/blob/main/Linux%20Notes/Ubuntu/Ubuntu%E4%BD%BF%E7%94%A8root%E7%94%A8%E6%88%B7%E7%99%BB%E5%BD%95%E7%B3%BB%E7%BB%9F.md)  
[Linux开启ssh并允许root登录](https://github.com/stu2116Edward/Public-study-notes/blob/main/Linux%20Notes/Linux%E5%BC%80%E5%90%AFssh%E5%B9%B6%E5%85%81%E8%AE%B8root%E7%99%BB%E5%BD%95.md)  


- 关闭Ubuntu20.04使用过程中总是弹出检测到系统程序出现问题的弹窗提示  


**方法一**：  
在终端输入以下指令：
```
sudo rm /var/crash/*
```
这个操作会删除所有在`/var/crash`目录下的所有内容。这样你就不会再被这些报告以前程序错误的弹窗所扰。但是如果又有一个程序崩溃了，你就会再次看到“检测到系统程序错误”的错误。你可以再次删除这些报告文件  

**方法二**：  
或者你可以选择彻底地摆脱Ubuntu中的系统错误弹窗，要禁止Apport，并且彻底地摆脱Ubuntu系统中的程序崩溃报告，打开一个终端，输入以下命令：
```bash
gedit /etc/default/apport
```
把文件最后一行的`把enabled=1改为enabled=0`保存并关闭文件。完成之后你就再也不会看到弹窗报告错误了。如果我们想重新开启错误报告功能，只要再打开这个文件，把enabled设置为1就可以了。  

- 禁止/开启Ubuntu自动更新升级  
1、打开终端，修改配置文件1，输入：
```bash
sudo gedit /etc/apt/apt.conf.d/10periodic
```
如果要`禁止`自动更新配置文件设为如下：
```
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
```
如果要`打开`自动更新配置文件设为如下：
```
APT::Periodic::Update-Package-Lists "2";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "1";
```
2、修改配置文件2，输入：
```bash
sudo gedit /etc/apt/apt.conf.d/20auto-upgrades
```
如果要`禁止`自动更新配置文件设为如下：
```
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "0";
```
如果要`打开`自动更新配置文件设为如下：
```
APT::Periodic::Update-Package-Lists "2";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Unattended-Upgrade "1";
```
保存退出  
两个文件都要修改，直接修改配置文件可能需要重启  
输入：
```bash
reboot
```
一般情况下不建议安装“提前释放出的更新  
