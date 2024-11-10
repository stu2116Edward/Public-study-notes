# kali换源教程

## 1、进入控制台
- 在kali桌面右键选择Open Terminal Here
![69ef6a57571e44f0a4fb8d8eadd36d91](https://github.com/user-attachments/assets/72b8edb9-91c4-4f0f-af5c-25c159f28272)  

## 2、root配置权限
- 进入root权限，未修改前kali默认密码是kali  
```
sudo -s
```
或修改密码
```
sudo su root
```

### 3、更新软件源
- 在控制台输入
```
vim /etc/apt/sources.list
```
![407d95e9339a457ebcfcf7062cdc1ae8](https://github.com/user-attachments/assets/50091e7d-3517-420d-95ba-8b838f2a2e3d)  
在进入这个界面  
输入 “i” 后会显示出现下图的insert，这个表示进入了插入模式可以进行修改  
![22f3b672a67043448198a3cc8650a213](https://github.com/user-attachments/assets/6f7cf82f-6c85-4334-8f2b-7ede3cb03c66)  
将旧的源插入#进行注释  
`#deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware`  
![422fc7e81c1543c1ad6b4e657333b5f2](https://github.com/user-attachments/assets/95b62463-0f16-4081-84a7-86ab04330219)  

从下面的源内选择一个复制下来准备粘贴进去（选其一即可）  
```
# 阿里云Kali镜像源
deb http://mirrors.aliyun.com/kali kali-rolling main non-free non-free-firmware contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free non-free-firmware contrib
```
```
# 中科大Kali镜像源
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free non-free-firmware contrib
deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free non-free-firmware contrib
```
```
# 清华大学Kali镜像源
deb http://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free non-free-firmware
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main contrib non-free non-free-firmware
```
将上面的源复制进去即可，如下  
![24b74add7e584ace9ab85cd170b7ea62](https://github.com/user-attachments/assets/40b95324-dcaf-459a-abc6-2f03f57152ad)  
按键盘上的“ESC”键，左下角的“insert”消失说明操作正确  
![0be2f95b8258410284784c8caaeff10d](https://github.com/user-attachments/assets/76fdd035-54f9-40b2-9d41-e8d08ac6a366)  
输入“:wq”（注意使用英文输入法），回车后即保存配置并退出  
- 更新软件源  
```
apt update
```
![dc30d0663366433ba69ea56b7739b8a4](https://github.com/user-attachments/assets/31370d7d-0dbf-4c76-aa40-2a92c8a4cecf)  
如果你使用以前的旧版本源会显示报错，这是因为2024版使用的软件仓库是non-free-firmvare和non-free共同使用，因此需要添加non-free-firmvare的源  
- 旧版本源（前面提供的是新版本源）  
<pre>
# 中科大Kali镜像源 
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free contrib
</pre>
- 新版本源  
<pre>
# 中科大Kali镜像源
deb http://mirrors.ustc.edu.cn/kali kali-rolling main non-free non-free-firmware contrib
deb-src http://mirrors.ustc.edu.cn/kali kali-rolling main non-free non-free-firmware contrib
</pre>
更新后重新update一次即可  
![b6294a86b7db4aeeaa7e4227a87433e3](https://github.com/user-attachments/assets/0d1ecb3e-0841-4e64-a055-146a8f0ea5d2)  

如果遇到这样的信息  
`990 packages can be upgraded. Run 'apt list --upgradable' to see them.`  
这部分提示的是查询到可升级的软件，由于之前用过旧版本源会提示软件升级，如果直接用新版本源则不会提示  

### 软件源升级  
- 命令1：
```
apt-get upgrade
```
- 命令说明：
  - 1、这个命令会升级所有已安装的软件包到最新版本，但不会改变软件包的依赖关系
  - 2、它只会升级那些与当前安装的软件包版本兼容的软件包
  - 3、如果升级某个软件包需要安装新软件包或删除其他软件包，这个命令不会执行这样的操作

- 命令2：
```
apt-get dist-upgrade
```
- 命令说明：
  - 1、这个命令也会升级所有已安装的软件包，但它会尝试解决软件包之间的依赖关系，即使这意味着需要安装新软件包或删除旧软件包
  - 2、它通常用于发行版升级，比如从Ubuntu 20.04升级到20.10，因为它会处理那些需要改变依赖关系的重大更新
  - 3、dist-upgrade 命令在处理依赖关系时更为激进，可能会改变系统的配置

- 命令3：
```
apt-get dist-upgrade -y
```

- 命令说明：
  - -y 的意思是提示选择时默认确认  
![e3a55a8fdd964c9aa632afebb6f830de](https://github.com/user-attachments/assets/1a1fe399-69ce-46fe-8242-ef52ba5cd994)  
安装提示输入y即可
![bf7a85d9117d458e8caa5bb67d91e9c2](https://github.com/user-attachments/assets/420cd2f2-0cac-4aa9-8c9d-f8fd6ed56289)  
安装或更新完成后，会遗留一些软件的安装包，会占用部分硬盘空间，可使用下面的命令来对其进行清理
```
apt-get clean
```
