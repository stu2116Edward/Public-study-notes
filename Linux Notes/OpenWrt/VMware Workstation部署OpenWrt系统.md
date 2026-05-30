# VMware Workstation部署OpenWrt系统


### 制作VMDK镜像
本次使用x86-64版本，下载链接如下：
```
https://downloads.openwrt.org/releases/25.12.0/targets/x86/64/
```
下载 `generic-ext4-combined-efi.img.gz` 这个文件  



下载完成后，解压得到 `openwrt-25.12.0-x86-64-generic-ext4-combined-efi.img` 这个文件  



然后用 `StarWindConverter` 这个工具来把 `img` 镜像文件转换成VMware支持的 `vmdk` 文件，工具下载链接如下：  
https://www.starwindsoftware.com/tmplink/starwindconverter.exe



转换前的文件选择“Local file”（本地文件）  



在File处选中要转换的IMG文件  



转换后的目标文件也选择“Local File”，将文件保存在本地  



目标文件格式选择“VMDK”  



转换后的磁盘类型，选择 VMWare Workstation growable image 格式的VMDK，磁盘空间按需增长  



选择输出文件位置  



转换完成  



创建新的虚拟机，类型选择“自定义（高级）”  



硬件兼容性选择 Workstation 17.5.x



稍后安装操作系统  



系统选择“Linux”→“其他Linux 5.x或更高版本内核64位”  



命名虚拟机并选择存储位置  



处理器配置选择 "2 核CPU"  



内存分配 "2 GB"  



网络类型先选择“NAT”  



I/O控制器类型保持默认推荐的“LSI Logic”  



虚拟磁盘类型跟转换的镜像保持一致，选择“IDE”  



磁盘选择“使用现有虚拟磁盘”  



选择刚才已转换好的vmdk文件  



这期间可能会提示更新磁盘格式，择了“转换”  



确认虚拟机配置，没有问题的话，点击“完成”即可  



直接启动虚拟机，启动保持默认选项即可



软件启动页面到下面这个界面就已经启动完成了，但是不会自动进入系统  



按一下回车即可  



可以看到启动欢迎页面显示的“OpenWrt”字样，提示说明当前的root账号没有密码，可以使用passwd命令设置新密码  


将网卡地址修改为VMnet8所在的这个网段  
```
vim /etc/config/network
```
修改完成后，执行命令重启网络服务
```
/etc/init.d/network restart
```

