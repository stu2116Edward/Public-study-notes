# Windows（x86）上部署ARM虚拟机（Ubuntu）


### 准备工作
1. 虚拟机  
下载地址：https://qemu.weilnetz.de/w64/qemu-w64-setup-20260811.exe

2. UEFI  
下载地址：https://edwardhu.lanzouu.com/igHb448pvoxg

3. Ubuntu ISO镜像  
下载地址：https://cdimage.ubuntu.com/ubuntu/releases/22.04/release/ubuntu-22.04.5-live-server-arm64.iso



### 安装QEMU虚拟机


我的安装位置：`E:\Program Files\qemu`


### 创建磁盘文件
```
"QEMU安装路径\qemu-img.exe" create -f qcow2 "保存的文件夹\文件名.qcow2" 文件大小
```
Demo  
```
"E:\Program Files\qemu\qemu-img.exe" create -f qcow2 "E:\Virtual Machines\QEMU\ubuntu-22.04.5\Disk_Ubuntu.qcow2" 60G
```


### 安装Ubuntu系统
```
"QEMU安装路径\qemu-system-aarch64.exe" -m 4096 -cpu cortex-a72 -smp 4,sockets=2,cores=2 -M virt -bios "下载的 QEMU_EFI.fd 文件路径" -device VGA -device nec-usb-xhci -device usb-mouse -device usb-kbd -drive if=none,file="刚刚创建的磁盘文件的路径",id=hd0 -device virtio-blk-device,drive=hd0 -drive if=none,file="Ubuntu系统安装包文件路径",id=cdrom,media=cdrom -device virtio-scsi-device -device scsi-cd,drive=cdrom  -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22
```
参数说明：
- `-m 4096`								内存 4 GB
- `-cpu cortex-a72`							模拟的 CPU 型号，ARM Cortex-A72 是 64 位 ARMv8 处理器
- `-smp 4,sockets=2,cores=2`					CPU4 核（2 插槽 × 2 核）
- `-M virt`									使用 QEMU 的 通用虚拟平台（ARM 上最常用的虚拟主板）
- `-bios`									指定 UEFI 固件（ARM 虚拟机通常需要 UEFI，而非传统 BIOS）
- `-device VGA`								添加一块 VGA 显卡（用于图形显示）
- `-device nec-usb-xhci`						添加 USB 3.0 控制器（xhci）
- `-device usb-mouse`						添加 USB 鼠标
- `-device usb-kbd`							添加 USB 键盘
- `-drive if=none,file=...,id=hd0`					定义硬盘后端存储，qcow2 格式系统盘，命名为 hd0
- `-device virtio-blk-device,drive=hd0`			用 virtio-blk 半虚拟化块设备将 hd0 挂载到虚拟机
- `-drive if=none,file=...,id=cdrom,media=cdrom`	定义光驱后端存储，加载 Ubuntu 安装 ISO
- `-device virtio-scsi-device` 					添加 virtio SCSI 控制器（用于挂载光驱）
- `-device scsi-cd,drive=cdrom`					将 cdrom 作为 SCSI 光驱接入虚拟机
- `-net nic`									添加一块虚拟网卡
- `-net user,hostfwd=tcp:127.0.0.1:2222-:22`		使用用户模式网络，并将宿主机 127.0.0.1:2222 端口转发到虚拟机 22 端口（SSH）


最后一个参数 `hostfwd` 是做的 `端口映射`，把虚拟机的端口号为 `22` 的TCP协议映射到主机地址 `127.0.0.1:2222` 中，方便我们使用SSH链接虚拟机  
Demo
```
"E:\Program Files\qemu\qemu-system-aarch64.exe" -m 4096 -cpu cortex-a72 -smp 4,sockets=2,cores=2 -M virt -bios "E:\Virtual Machines\QEMU\QEMU_EFI.fd" -device VGA -device nec-usb-xhci -device usb-mouse -device usb-kbd -drive if=none,file="E:\Virtual Machines\QEMU\ubuntu-22.04.5\Disk_Ubuntu.qcow2",id=hd0 -device virtio-blk-device,drive=hd0 -drive if=none,file="E:\Virtual Machines\QEMU\ubuntu-22.04.5-live-server-arm64\ubuntu-22.04.5-live-server-arm64.iso",id=cdrom,media=cdrom -device virtio-scsi-device -device scsi-cd,drive=cdrom  -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22
```
注意确保物理机 `2222` 端口未被占用 `Win + R`
```
netstat -ano
```
安装时更换镜像
```
http://mirrors.aliyun.com/ubuntu/
```
注意勾选openssh
安装完成会出现 `Reboot`


### 运行已安装好系统的虚拟机
```
"QEMU安装路径\qemu-system-aarch64.exe" -m 4096 -cpu cortex-a72 -smp 4,sockets=2,cores=2 -M virt -bios "下载的 QEMU_EFI.fd 文件路径" -device VGA -device nec-usb-xhci -device usb-mouse -device usb-kbd -drive if=none,file="安装有系统的磁盘文件路径",id=hd0 -device virtio-blk-device,drive=hd0 -drive if=none,file=,id=cdrom,media=cdrom -device virtio-scsi-device -device scsi-cd,drive=cdrom -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22
```
Demo
```
"E:\Program Files\qemu\qemu-system-aarch64.exe" -m 4096 -cpu cortex-a72 -smp 4,sockets=2,cores=2 -M virt -bios "E:\Virtual Machines\QEMU\QEMU_EFI.fd" -device VGA -device nec-usb-xhci -device usb-mouse -device usb-kbd -drive if=none,file="E:\Virtual Machines\QEMU\ubuntu-22.04.5\Disk_Ubuntu.qcow2",id=hd0 -device virtio-blk-device,drive=hd0 -drive if=none,file=,id=cdrom,media=cdrom -device virtio-scsi-device -device scsi-cd,drive=cdrom -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22
```
创建一个cmd启动文件即可

### 端口映射
端口映射只能在 QEMU 启动时通过参数指定，无法在虚拟机内部完成  
```
"E:\Program Files\qemu\qemu-system-aarch64.exe" -m 4096 -cpu cortex-a72 -smp 4,sockets=2,cores=2 -M virt -bios "E:\Virtual Machines\QEMU\QEMU_EFI.fd" -device VGA -device nec-usb-xhci -device usb-mouse -device usb-kbd -drive if=none,file="E:\Virtual Machines\QEMU\ubuntu-22.04.5\Disk_Ubuntu.qcow2",id=hd0 -device virtio-blk-device,drive=hd0 -drive if=none,file=,id=cdrom,media=cdrom -device virtio-scsi-device -device scsi-cd,drive=cdrom -net nic -net user,hostfwd=tcp:127.0.0.1:2222-:22,hostfwd=tcp:0.0.0.0:5757-:5757
```
结尾的`hostfwd=tcp:127.0.0.1:2222-:22,hostfwd=tcp:0.0.0.0:5757-:5757`就是端口映射  
建议每一个服务都分别创建一个`cmd`文件作为启动文件  

hostfwd 的语法：  
```
hostfwd=[tcp|udp]:[hostaddr]:hostport-[guestaddr]:guestport
```
```
hostfwd=[tcp|udp]:[宿主机地址]:宿主机端口-[虚拟机地址]:虚拟机端口
```

| 绑定地址 | 谁能访问 | 访问方式 |
|:---|:---|:---|
| `127.0.0.1` | 只有宿主机自己 | `http://127.0.0.1:2222` |
| `0.0.0.0` | 宿主机 + 局域网所有机器 | `http://127.0.0.1:5757` 或 `http://宿主机局域网IP:5757` |
| 地址留空 | 等价于 `0.0.0.0`，所有接口 | 同上 |
