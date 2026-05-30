# VMware Workstation部署OpenWrt系统


### 制作VMDK镜像
本次使用x86-64版本，下载链接如下：
```
https://downloads.openwrt.org/releases/25.12.0/targets/x86/64/
```
下载 `generic-ext4-combined-efi.img.gz` 这个文件  

<img width="1739" height="666" alt="vmop1" src="https://github.com/user-attachments/assets/8cf9b969-6e15-4924-be4d-d5cc67b1b6a3" />

下载完成后，解压得到 `openwrt-25.12.0-x86-64-generic-ext4-combined-efi.img` 这个文件  

然后用 `StarWindConverter` 这个工具来把 `img` 镜像文件转换成VMware支持的 `vmdk` 文件，工具下载链接如下：  
https://www.starwindsoftware.com/tmplink/starwindconverter.exe


转换前的文件选择“Local file”（本地文件）  

<img width="1011" height="1122" alt="vmop2" src="https://github.com/user-attachments/assets/c293fbc4-ba38-4b9c-afa4-4604c5f2de44" />

在File处选中要转换的IMG文件  

<img width="1008" height="1107" alt="vmop3" src="https://github.com/user-attachments/assets/cc4b8e58-3871-4c7f-a348-a11f6b9b4e2c" />

转换后的目标文件也选择“Local File”，将文件保存在本地  

<img width="1004" height="1112" alt="vmop4" src="https://github.com/user-attachments/assets/b480c30c-c05e-4f36-9fab-cca36a3f3057" />

目标文件格式选择“VMDK”  

<img width="1010" height="1114" alt="vmop5" src="https://github.com/user-attachments/assets/6e8867d0-52e7-4238-9c53-15e34bb93397" />

转换后的磁盘类型，选择 VMWare Workstation growable image 格式的VMDK，磁盘空间按需增长  

<img width="1007" height="1115" alt="vmop6" src="https://github.com/user-attachments/assets/6c12de34-d758-4a39-8870-1d68fc326c28" />

选择输出文件位置  

<img width="1008" height="1113" alt="vmop7" src="https://github.com/user-attachments/assets/65846446-4c6c-4d8e-b21a-69fb5e1274d8" />

转换完成  

<img width="1015" height="1118" alt="vmop8" src="https://github.com/user-attachments/assets/717392ea-4f67-437f-a2df-ebf2b9ca0087" />

创建新的虚拟机

<img width="1294" height="652" alt="vmop9" src="https://github.com/user-attachments/assets/31e31fae-4488-4cf2-bd3d-1533860e597c" />

类型选择“自定义（高级）”  

<img width="708" height="663" alt="vmop10" src="https://github.com/user-attachments/assets/c0122717-b8d3-4d29-bbc3-3db2d279146f" />

硬件兼容性选择 Workstation 17.5.x

<img width="705" height="667" alt="vmop11" src="https://github.com/user-attachments/assets/423f3a30-08c6-4109-88cd-829c06763486" />

稍后安装操作系统  

<img width="705" height="664" alt="vmop12" src="https://github.com/user-attachments/assets/974e26a6-887d-4aa2-97c6-e4a5498bf4f5" />

系统选择“Linux”→“其他Linux 5.x或更高版本内核64位”  

<img width="702" height="656" alt="vmop13" src="https://github.com/user-attachments/assets/6ee93384-deb7-45f8-a6fb-a49239bd51d5" />

命名虚拟机并选择存储位置  

<img width="704" height="663" alt="vmop14" src="https://github.com/user-attachments/assets/d7c4be24-621d-43ca-9a7f-ac71f16b7035" />

处理器配置选择 "2 核CPU"  

<img width="703" height="661" alt="vmop15" src="https://github.com/user-attachments/assets/41020cfc-9fbb-4a89-8e4e-c5db4de52770" />

内存分配 "2 GB"  

<img width="705" height="662" alt="vmop16" src="https://github.com/user-attachments/assets/a987758c-ebf9-4eb9-99e3-3ecb9b89353e" />

网络类型先选择“NAT”  

<img width="706" height="666" alt="vmop17" src="https://github.com/user-attachments/assets/b36d6d98-a9e4-4d2e-aefd-b114b837e3d2" />

I/O控制器类型保持默认推荐的“LSI Logic”  

<img width="704" height="661" alt="vmop18" src="https://github.com/user-attachments/assets/be8d089c-ea40-45d7-82f2-355b848bfcf8" />

虚拟磁盘类型跟转换的镜像保持一致，选择“IDE”  

<img width="705" height="669" alt="vmop19" src="https://github.com/user-attachments/assets/03e5a078-9bc7-408e-8198-a7cda365481e" />

磁盘选择“使用现有虚拟磁盘”  

<img width="705" height="663" alt="vmop20" src="https://github.com/user-attachments/assets/6e46450c-0ca2-4e36-9bb0-21d847d9c0fd" />

选择刚才已转换好的vmdk文件  

<img width="702" height="661" alt="vmop21" src="https://github.com/user-attachments/assets/92f9f643-a3d6-4eba-b5c3-ea9340176421" />

这期间可能会提示更新磁盘格式，择了“转换”  

<img width="705" height="664" alt="vmop22" src="https://github.com/user-attachments/assets/57505eb9-95b0-4198-be43-3b0ff97388cb" />

确认虚拟机配置，没有问题的话，点击“完成”即可  


直接启动虚拟机，启动保持默认选项即可  
按一下回车进入系统  

可以看到启动欢迎页面显示的“OpenWrt”字样，提示说明当前的root账号没有密码，可以使用passwd命令设置新密码  
```
passwd root
```

将网卡地址修改为VMnet8所在的这个网段  
```
vim /etc/config/network
```
修改完成后，执行命令重启网络服务
```
/etc/init.d/network restart
```
<img width="740" height="445" alt="vmop23" src="https://github.com/user-attachments/assets/6e0f3d02-3749-45ad-aeb3-cd2cb41bc9a9" />

<img width="2070" height="950" alt="vmop24" src="https://github.com/user-attachments/assets/78dc43b8-7585-495e-b4a1-eaf6e4c4eb42" />

