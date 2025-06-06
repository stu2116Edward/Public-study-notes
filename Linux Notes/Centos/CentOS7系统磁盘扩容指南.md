# Centos系统磁盘扩容指南

## 基本概念和术语

### 分区的基本概念
无论是 Linux 还是 Windows，都要把硬盘分成一块一块的区域来管理，Linux中这些区域就叫“分区”，Windows中叫卷（Volume）。就好比把一个大房间分成几个小房间，每个小房间可以放不同的东西。

- 主分区
主分区是硬盘上的独立分区，通常用于安装操作系统的核心组件。
例如：  
  - 根分区（/）：包含操作系统的所有基本文件和目录，是系统启动和运行的基础。  
  - 启动分区（/boot）：包含启动 Linux 系统所需的关键文件，如内核文件（vmlinuz）和启动加载器（grub）的相关文件。单独划分 /boot 分区可以提高系统的安全性和灵活性。  

- 扩展分区
扩展分区本身不能直接使用，它的主要作用是容纳逻辑分区。通过创建扩展分区，用户可以在硬盘上创建更多的逻辑分区，从而突破主分区数量的限制（一块硬盘最多只能有 4 个主分区）。扩展分区是创建逻辑分区的“容器”。  

- 逻辑分区
逻辑分区是在扩展分区上划分的分区，数量没有限制。它们通常用于存储用户数据或其他需要独立存储空间的目录。
例如：  
  - 用户数据分区（/home）：用于存储用户数据，包括个人文件和配置文件。单独划分 /home 分区可以保护用户数据，即使系统分区出现问题，用户数据也不会丢失。  
  - 临时文件分区（/tmp）：用于存储临时文件，这些文件在系统重启时通常会被清空。单独划分 /tmp 分区可以避免临时文件占用过多空间，影响系统性能。  
  - 交换分区（/swap）：是 Linux 系统的虚拟内存分区，当系统的物理内存不足时，交换分区会被用作临时存储空间。  


**Windows 卷 vs Linux 分区对比**

| 特性          | Windows 卷 (Volume) | Linux 分区 (Partition) |
|---------------|---------------------|------------------------|
| 术语          | 卷 (Volume)         | 分区 (Partition)       |
| 主分区        | 主卷                | 主分区                 |
| 扩展分区      | 扩展卷              | 扩展分区               |
| 逻辑分区      | 逻辑卷              | 逻辑分区               |
| 文件系统      | NTFS/FAT32/exFAT    | ext4/xfs/btrfs         |
| 挂载方式      | 驱动器号 (C:, D:等) | 挂载点 (如 `/mnt`)     |
| 扩展性        | 需转换为动态磁盘    | 原生支持 LVM 动态扩展  |
| 管理工具      | 磁盘管理            | `fdisk`/`parted`/`gparted` |

传统分区结构示例：  
<pre>
┌─────────────┐
│  主分区1    │ ← /boot
├─────────────┤
│  主分区2    │ ← /
├─────────────┤
│  扩展分区   │
│ ┌─────────┐ │
│ │逻辑分区1│ │ ← /home
│ ├─────────┤ │
│ │逻辑分区2│ │ ← /swap
│ └─────────┘ │
└─────────────┘
</pre>



### LVM基本概念和术语
1. 物理存储介质：  
指的是物理的硬盘，在`/dev`目录下看到的`sda`，`sdb`，`sdc`，`hda`，`hdb`，`hdc`等  

2. 分区：
分区是硬盘上的一个独立区域，用于存储数据，分区可以被初始化为物理卷（PV）  

2. 物理卷（Pisical Volume）：  
指的是物理硬盘上的分区或逻辑上与磁盘分区具有相同功能能的设备，是LVM的基本存储块，但和分区来比，却包含了与LVM管理相关的参数。这个就是前面讲的存储池  

3. 卷组（Volume Group）：  
LVM的卷组类似于物理硬盘，卷组上边可以建立多个虚拟的“分区”，LVM卷组由一个或多个物理卷组成  

4. 逻辑卷（Logical Volume）：  
LVM的逻辑卷类似于非LVM系统中的硬盘分区，在逻辑卷上边可以建立文件系统，用于mount到不同的挂载点，提升分区空间（这是真正跟用户打交道的部分）  

5. PE （Physical Extent）  
每一个物理卷被划分为一个个的基本存储单元，每一个PE都具有唯一的编址（这个东西类似于物理硬盘上的磁盘地址）。PE的大小默认为4MB  

6. LE（Logical Extent）  
每一个逻辑卷也被划分为一个个的基本存储单元，每一个LE也具有一个唯一的编址。在同一个卷组中，LE和PE的大小是相等的  

综上所述：一个或者多个物理硬盘上都可以划分出一个或者多个LVM分区，然后这些分区可以组成一个物理卷（PV），形成一个存储池。用 户把这个存储池划分出来一个或者多个逻辑卷（LV），挂载到不同的分区上去使用，这个就是LVM的基本原理，也是建立LVM的过程  

LVM 的层级关系图:  
```mermaid
graph TD
    A[物理硬盘] --> B[分区]
    B -->|pvcreate| C[物理卷 PV]
    C -->|vgcreate| D[卷组 VG]
    D -->|lvcreate| E[逻辑卷 LV]
    E -->|mkfs| F[文件系统]
    F -->|mount| G[挂载点]
```
传统分区 vs LVM 结构对比:
<pre>
# 传统分区
┌─────────────┐
│  /dev/sda1  │ ← /boot (固定大小)
├─────────────┤
│  /dev/sda2  │ ← / (无法动态扩展)
└─────────────┘

# LVM结构
┌─────────────┐     ┌─────────────┐
│  PV(sda1)   │     │  PV(sdb1)   │
└─────────────┘     └─────────────┘
        ↓               ↓
        └───────────────┘
                ↓
           [卷组 VG] ← 可动态添加PV
                ↓
        ┌───────┴───────┐
        ↓               ↓
┌─────────────┐ ┌─────────────┐
│ LV(root)    │ │ LV(home)    │ ← 可在线扩展
└─────────────┘ └─────────────┘
</pre>
关键优势对比：

| 特性          | 传统分区 (Traditional Partitioning) | LVM (Logical Volume Management) |
|---------------|-------------------------------------|----------------------------------|
| 扩展性        | 固定大小，难以调整                   | 动态调整，灵活扩展               |
| 多磁盘管理    | 独立管理，每块磁盘单独分区           | 统一存储池，整合多块磁盘         |
| 快照功能      | 不支持                               | 支持，可创建数据快照             |
| 复杂度        | 操作简单，易于上手                   | 需要学习相关概念，操作稍复杂     |
| 适用场景      | 适合简单分区需求                     | 适合需要灵活扩展和管理的场景     |


## **新增磁盘fdisk创建分区扩容**

fdisk语法格式：
```bash
fdisk [参数] [设备]
```
参数：  
| 选项 | 描述 |
|------|------|
| `-b <分区大小>` | 指定每个分区的大小 |
| `-l` | 列出指定的外围设备的分区表状况 |
| `-s <分区编号>` | 将指定的分区大小输出到标准输出上，单位为区块 |
| `-u` | 搭配 `-l` 参数列表，会用分区数目取代柱面数目，来表示每个分区的起始地址 |
| `-v` | 显示版本信息 |

分区菜单操作说明：  
| 选项 | 描述 |
|------|------|
| `m` | 显示菜单和帮助信息 |
| `a` | 活动分区标记/引导分区 |
| `d` | 删除分区 |
| `l` | 显示分区类型 |
| `n` | 新建分区 |
| `p` | 显示分区信息 |
| `q` | 退出不保存 |
| `t` | 设置分区号 |
| `v` | 进行分区检查 |
| `w` | 保存修改 |
| `x` | 扩展应用，高级功能 |

#### 1. 添加硬盘  


#### 2. 扫描新硬件  
```bash
echo "- - -" > /sys/class/scsi_host/host0/scan
```

#### 3. 查看新磁盘设备  
```bash
sudo lsblk
```
或者
```bash
sudo fdisk -l
```

#### 4. 对新磁盘进行分区  
```bash
sudo fdisk /dev/sdb
```
在 fdisk 交互模式中：
- 输入 `n` 创建新分区
- 选择分区类型:
   - 输入 `p` 表示`主分区`（如果需要多个分区，第一个必须是主分区。可直接输空格）
   - 输入 `e` 表示`扩展分区`（如果需要创建逻辑分区，即只有先创建扩展分区后才能创建逻辑分区）
   - 输入 `l` 表示`逻辑分区`（在扩展分区中创建）
- 如果要修改分区类型可以使用 `t` 选项:
   - 输入 `8e` 表示 LVM 分区（用于创建逻辑卷管理分区）
   - 输入 `83` 表示 Linux 文件系统
   - 输入 `82` 表示 swap 分区（Linux 交换分区）
- 输入分区编号。（可直接输空格）
- 输入`起始扇区`或者使用默认值来创建
- 输入`结束扇区`或者使用默认值来创建
- 输入 `p` 查看分区表，确认新分区已正确创建
- 输入 `d` 删除分区（如果需要删除分区）
- 输入 `w` 保存分区表并退出

通知内核重新读取分区表：
```bash
sudo partprobe /dev/sdb
```

#### 5. 格式化分区  
格式化分区是指创建一个新的文件系统，并将其应用到一个分区上。这通常是在分区创建后、首次使用之前进行的操作  
格式化新分区为 `ext4`（小文件） 或 `xfs`（大文件） 文件系统：  
如果是 `ext4` 文件系统：
```bash
sudo mkfs.ext4 /dev/sdb1
```
如果是 `xfs` 文件系统：
```bash
sudo mkfs.xfs /dev/sdb1
```

#### 6. 创建挂载点并挂载分区  
创建挂载点：
```bash
sudo mkdir -p /mnt/mynewdisk
```
挂载分区：
```bash
sudo mount /dev/sdb1 /mnt/mynewdisk
```
如果要取消挂载：
```bash
sudo umount /dev/sdb1
```

#### 7. 设置开机自动挂载  
查看分区的 UUID：
```bash
blkid
```
记住`/dev/sdb1`的 UUID  
使用文本编辑器打开 `/etc/fstab` 文件  
```bash
sudo vim /etc/fstab
```
在fstab文件中添加：
```plaintext
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx /mnt/mynewdisk ext4 defaults 0 0
```
或
```plaintext
/dev/sdb1 /mnt/mynewdisk ext4 defaults 0 0
```
后保存退出  
解释说明：
- `UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`：分区的 UUID（唯一标识符），可以使用 `blkid` 命令获取。
- `/dev/sdb1`：新分区的设备路径。
- `/mnt/mynewdisk`：挂载点。
- `ext4`：文件系统类型（根据实际格式化类型填写，如 `xfs`）。
- `defaults`：默认挂载选项。
- `0`：表示该分区不需要被 `dump` 备份工具备份。
- `0`：表示在启动时会检查文件系统（1 表示根分区，2 表示其他分区，0 表示不检查）。

#### 8. 重启使配置生效
```bash
sudo reboot
```

#### 9. 验证挂载点
使用 `df` 命令来检查分区是否已正确挂载并显示大小  
```bash
df -h
```

新硬盘已经成功添加到系统，并且可以在 `/mnt/mynewdisk` 下访问  
可以使用`du -sh`命令查看当前文件夹下所占用文件的大小  


## **LVM扩容**

说明：如果是在原磁盘LVM分区基础上加上一块新硬盘实现对原有分区扩容，则无需创建新的卷组和逻辑卷，只需在原有卷组和逻辑卷上进行扩容操作即可。如果你要实现加入两块新的硬盘在两块新硬盘中实现两块不同硬盘之间的LVM分区合并（说白了就是两块硬盘的空间组合成一共大小的空间），则需要按照以下步骤进行操作。  

#### 1. 添加和扩展硬盘  
**添加一块新的硬盘**  
![ccpkr1](https://github.com/user-attachments/assets/1eb9b86b-8001-4e7d-bfcd-caa4641cee31)  
![ccpkr2](https://github.com/user-attachments/assets/37fce2db-6531-4a59-96f5-006840db3e33)  
![ccpkr3](https://github.com/user-attachments/assets/0bbd388f-d273-4027-b281-e4b582353712)  
![ccpkr4](https://github.com/user-attachments/assets/7b466524-2c76-47b2-ac0a-6ef4b76c26fb)  

**扩大原磁盘空间**  

操作：
- 关闭虚拟机
- 进入虚拟机设置
- 选择需要扩展磁盘的虚拟机，点击“设备”中的“硬盘”
- 在虚拟机设置界面的右侧，点击“扩展”按钮
- 在弹出的“扩展磁盘容量”对话框中，输入需要扩展的磁盘大小
- 点击“扩展”按钮，等待系统自动完成扩展操作
- 点击“确定”按钮，完成虚拟机磁盘的扩展

![CO7cpkz1](https://github.com/user-attachments/assets/499e3e9d-a768-4168-8a25-2dedd67388b9)  
![CO7cpkz2](https://github.com/user-attachments/assets/1202ed42-43ad-4011-a5d4-65c75b9380f9)  
![CO7cpkz3](https://github.com/user-attachments/assets/e6341880-2eee-4eee-8dd6-a18247d02e7d)  
![CO7cpkz4](https://github.com/user-attachments/assets/5c3cf00a-f5b0-4fe5-9911-769e34cc0da6)  
![CO7cpkz5](https://github.com/user-attachments/assets/81701be2-92ec-4c08-a4c6-916ce4d92dff)  

#### 2. 扫描新硬件  
```bash
echo "- - -" > /sys/class/scsi_host/host0/scan
```

#### 3. 安装 LVM 工具
```bash
sudo yum update
sudo yum install lvm2
```

#### 4. 查看磁盘和物理卷  
```bash
sudo lsblk
```
```bash
pvdisplay
```

#### 5. 使用 fdisk 命令创建需要合并的分区：
```bash
sudo fdisk /dev/sdb
```
操作步骤:
- `n` = 创建新分区
- `p` = 创建主分区
- `1` = 成为磁盘上的首个分区
输入两次 `enter` 键扩展到使用所有可用的空闲空间

更改分区类型：
- `t` = 更改分区类型
- `8e` = 更改为 LVM 分区类型

核实信息并写入硬盘：
- `p` = 查看分区设置
- `w` = 写入到磁盘

这里只对`/dev/sdb`这一个磁盘进行操作,因为`/dev/sda`磁盘中已经创建了`/dev/sda2`LVM分区（这里和Ubuntu还是有所差别的,Ubuntu中的主分区是通过创建扩展分区然后再创建逻辑分区实现的）

#### 6. 通知内核重新读取分区表：
```bash
sudo partprobe /dev/sdb
```

#### 7. 将新分区初始化为物理卷（PV）
```bash
sudo pvcreate /dev/sdb1
```
如果想要取消则输入：
```bash
sudo pvremove /dev/sdb1
```
查看物理卷（PV）信息：
```bash
sudo pvdisplay
```
或
```bash
pvs
```

#### 8. 确认卷组名称  
在执行 `vgextend` 之前，确认系统中存在的卷组名称：
```bash
sudo vgdisplay
```
或
```bash
vgs
```
如果系统中没有卷组，您需要创建一个新的卷组。如果存在卷组，记下卷组的名称  
<pre>
[root@localhost ~]# vgdisplay
  --- Volume group ---
  VG Name               centos
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <19.00 GiB
  PE Size               4.00 MiB
  Total PE              4863
  Alloc PE / Size       4863 / <19.00 GiB
  Free  PE / Size       0 / 0   
  VG UUID               v2AggR-P1bx-puQl-O4jv-qF7P-jh0n-g3o9lY
</pre>
例如这里的卷组名称为**centos**  
**所以这里我们无需创建新的卷组，即直接在原有的卷组中实现LVM扩容**  

#### 9. 创建新的卷组(如果卷组不存在)  
命令格式如下：
```bash
sudo vgcreate <卷组名> <物理卷设备>
```
***注意：这里必须带上物理卷设备名称***  
例如：
```bash
sudo vgcreate centos /dev/sdb1
```
如果要删除卷组：
```bash
sudo vgremove <卷组名>
```
例如：
```bash
sudo vgremove centos
```

#### 10. 将新物理卷加入卷组（VG）
```bash
sudo vgextend centos /dev/sdb1
```
如果想要取消则输入：
```bash
sudo vgreduce centos /dev/sdb1
```
查看vg的扩容前后对比：
```bash
sudo vgdisplay
```
或
```bash
vgs
```
这里我是在原有的`/dev/sda2`lvm分区中实现的扩容所以无需创建逻辑卷（LV），所以推进到[14. 扩展逻辑卷（LV）](#lv-expand)的操作执行  

#### 11. 创建逻辑卷（LV）  
使用所有可用空间创建逻辑卷：
```bash
sudo lvcreate -l +100%FREE -n root centos
```
- `lvcreate`：用于创建逻辑卷的命令
- `-l +100%FREE`：指定逻辑卷的大小。-l 表示基于物理扩展（PE）的数量来分配空间，+100%FREE 表示使用卷组中所有可用的空闲空间
- `-n root`：指定逻辑卷的名称为 root
- `centos`：指定卷组的名称

指定固定大小创建逻辑卷：
```bash
sudo lvcreate -L 20G -n root centos
```
- `-L 20G`：指定逻辑卷的大小为 20GB
- `-n root`：指定逻辑卷的名称为 root
- `centos`：指定卷组的名称

删除逻辑卷  
**在删除逻辑卷之前，必须确保它没有被挂载**:
确认是否被挂载：
```bash
df -h
```
取消挂载：
```bash
sudo umount /dev/centos/root
```
运行以下命令删除逻辑卷：
```bash
sudo lvremove /dev/centos/root
```

#### 12. 格式化逻辑卷  
对于 ext4 文件系统：
```bash
sudo mkfs.ext4 /dev/centos/root
```
对于 XFS 文件系统：
```bash
sudo mkfs.xfs /dev/centos/root
```

#### 13. 挂载逻辑卷
创建挂载目录：
```bash
sudo mkdir -p /mnt/newlv
```
挂载逻辑卷：
```bash
sudo mount /dev/centos/root /mnt/newlv
```

#### <a name="lv-expand">14. 扩展逻辑卷（LV）</a>
检查LV路径:
```bash
sudo lvdisplay
```
或
```bash
lvs
```
查看逻辑卷路径：
```bash
df -h
```
假设需要扩展的逻辑卷路径为 `/dev/mapper/centos-root` 将其扩展到使用所有可用空间：
```bash
sudo lvextend -l +100%FREE /dev/mapper/centos-root
```
- `-l`：指定扩展的大小基于物理扩展（PE）的数量。
- `+100%FREE`：表示将逻辑卷扩展到使用所有可用的空闲空间。
- `/dev/mapper/centos-root`：目标逻辑卷的路径。

使用 -L 参数（指定固定大小）：
```bash
sudo lvextend -L +10G /dev/mapper/centos-root
```
- `-L`：指定扩展的大小为一个固定的值。
- `+10G`：表示将逻辑卷的大小增加 20GB。如果需要指定其他单位，可以使用 M（兆字节）、G（吉字节）、T（太字节）等。
- `/dev/mapper/centos-root`：目标逻辑卷的路径。

刷新逻辑卷（LV）的空间，使其生效：
```bash
lvscan
```

#### 15. 调整文件系统大小
确认文件系统类型:
```bash
sudo blkid /dev/mapper/centos-root
```
对于 ext4 文件系统：
```bash
sudo resize2fs /dev/mapper/centos-root
```
对于 XFS 文件系统：
```bash
sudo xfs_growfs /dev/mapper/centos-root
```

#### 16. 验证扩容结果
```bash
df -h
```
```bash
sudo lsblk
```


## **使用parted扩展fdisk创建的分区**
这里如果你使用的是fdisk的方式实现先创建扩展分区，然后再创建逻辑分区，那么直接在原有磁盘的空闲空间对扩展分区扩容然后再对逻辑分区扩容即可实现对当前分区的挂载点扩容（首先对扩展分区扩容，然后才能对其中的逻辑分区扩容）  

#### 1. 确认分区编号：
```bash
sudo lsblk
```
或
```bash
sudo fdisk -l
```

#### 2. 卸载挂载点(如果已被挂载需要先卸载)
```bash
sudo umount /dev/sdb5
```

#### 3. 启动 parted：
```bash
sudo parted /dev/sdb
```

#### 4. 查看当前分区表：
```bash
print free
```
primary：主分区 extended：扩展分区 logical：逻辑分区  

#### 5. 先对扩展分区(extended)扩容：
```bash
resizepart 1
```
确认：`yes`  
指定分区大小：
```
21.5GB
```
查看当前分区表：
```bash
print free
```
可以看到扩展分区已被扩容到指定的大小  

#### 6. 对逻辑分区(logical)扩容：
```bash
resizepart 5
```
确认：`yes`  
指定分区大小：
```bash
21.5GB
```
查看当前分区表：
```bash
print free
```
可以看到逻辑分区已被扩容到指定的大小  
退出 parted：
```bash
quit
```

#### 7. 调整文件系统大小：
运行 e2fsck 检查文件系统:
```bash
sudo e2fsck -f /dev/sdb5
```
确认文件系统类型:
```bash
sudo blkid /dev/sdb5
```
对于 ext4 文件系统：
```bash
sudo resize2fs /dev/sdb5
```
对于 xfs 文件系统：
```bash
sudo xfs_growfs /mnt/sdb5
```

#### 8. 重新挂载分区：
```bash
sudo mount /dev/sdb5 /mnt/mynewdisk
```

#### 9. 验证
查看是否扩容  
```bash
df -h
```

在更新 /etc/fstab 文件后，建议重新挂载分区以确保一切正常：
```bash
sudo mount -a
```

注意扩容完成之后无法再缩小分区，只能扩大分区，除非删除重新创建。


## 删除分区
#### 1. 确认分区编号
在删除分区之前，务必确认要删除的分区编号，以避免误操作。可以使用以下命令查看分区信息：
```bash
sudo fdisk -l
```
或者：
```bash
sudo lsblk
```
查看分区的 UUID：
```bash
blkid
```
这些命令会列出所有分区及其详细信息，包括分区编号、大小和挂载点。

#### 2. 取消挂载分区
如果要删除的分区已经挂载，需要先取消挂载。使用以下命令取消挂载分区：
```bash
sudo umount /dev/sda3
```
如果分区正在被使用，系统会提示无法取消挂载。在这种情况下，需要先关闭使用该分区的程序或服务  
如果提示分区正在使用，可以强制取消挂载：
```bash
sudo umount -f /dev/sda3 
```
#### 3. 启动 fdisk
启动 fdisk 工具，指定要操作的磁盘设备：
```bash
sudo fdisk /dev/sda
```
#### 4. 删除分区
在 fdisk 界面中，执行以下操作：
- 输入 `d`，表示删除分区。
- 输入要删除的分区编号（例如 3，表示删除 /dev/sda3）。
- 输入 `w`，保存更改并退出 fdisk。

#### 5. 更新内核分区表
删除分区后，运行以下命令确保内核同步：
```bash
sudo partprobe /dev/sda
```
或最彻底的方法：
```bash
sudo reboot
```

#### 6. 验证分区是否删除
退出 fdisk 后，再次运行以下命令确认分区是否已被删除：
```bash
sudo fdisk -l
```
或者：
```bash
sudo lsblk
```
如果分区已经被删除，将不再显示在列表中。


## 总结
Linux扩容的三种方式：  
1. 给虚拟机新增一块磁盘，为这块磁盘新建一个分区，将新分区挂载，或在原有磁盘的空闲空间中新建分区，然后将新分区挂载
2. 给虚拟机新增一块磁盘，并把磁盘空间扩容到原有分区
3. 直接给 /(根) 分区（或者某一分区）扩容，直接在原有磁盘上增大空间
