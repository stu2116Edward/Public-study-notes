# Ubuntu 系统磁盘拓展指南

## 一、分区基本概念
无论是 Linux 还是 Windows，都要把硬盘分成一块一块的区域来管理，Linux中这些区域就叫“分区”，Windows中叫卷（Volume）。就好比把一个大房间分成几个小房间，每个小房间可以放不同的东西。

- **主分区**：独立的分区，通常对应磁盘的第一个分区，一般`用于安装系统`，如 C 盘。一块硬盘最多可以有 4 个主分区。
- **扩展分区**：`用于容纳逻辑分区`，本身不能直接使用。一块硬盘最多只能有一个扩展分区。
- **逻辑分区**：在扩展分区上划分的分区，数量没有限制，`用于存储数据`，如 D 盘、E 盘等。

**对比：Windows卷与Linux分区**：

| 特性          | Windows卷（Volume） | Linux分区（Partition） |
|---------------|---------------------|------------------------|
| 术语          | 卷（Volume）        | 分区（Partition）      |
| 主分区        | 主卷                | 主分区                 |
| 扩展分区      | 扩展卷              | 扩展分区               |
| 逻辑分区      | 逻辑卷              | 逻辑分区               |
| 格式化        | NTFS、FAT32等       | ext4、xfs、FAT32等     |
| 挂载方式      | 分配驱动器号（C:, D:等） | 挂载到挂载点（如`/mnt`） |
| 管理工具      | 磁盘管理（Disk Management） | `fdisk`、`parted`、`gparted`等 |

## 二、查看分区情况
1. **查看分区信息**：打开终端，输入以下命令查看分区情况：
```bash
sudo fdisk -l
```
![ucpkr1](https://github.com/user-attachments/assets/0bd39954-1949-46d3-af0b-bce1e94667df)  

或者：
```bash
sudo lsblk
```
![ucpkr2](https://github.com/user-attachments/assets/42ebf56a-c7d0-47aa-83d9-b5e70d4a183c)  
这个命令会列出所有硬盘及其分区信息，包括分区大小、类型等。

2. **查看磁盘使用情况**：输入以下命令查看磁盘使用情况：
```bash
df -h
```
这个命令会显示已挂载分区的使用情况，包括总容量、已用空间、可用空间等。  
![ucpkr3](https://github.com/user-attachments/assets/ae8db20a-cfb1-4fdf-8c33-80724c6b2392)  


## 三、分区操作
### 创建新分区
***这里的操作类似与在Windows系统中创建新的卷***  

#### 1. **配置分区工具**：
进入分区工具：
```bash
sudo fdisk /dev/sda
```
![ucpkr4](https://github.com/user-attachments/assets/0b1d0996-dbdd-4152-b762-c8dd90e6b5fd)  

**操作步骤**：
   - 输入 `m` 查看菜单，了解可用命令。
   - 输入 `p` 查看当前分区表，确认当前没有分区。
   - 输入 `n` 新建分区。
     - 选择主分区，输入 `p`。
        - 输入分区号，如 `3`。
        - 输入起始扇区号（例如 83884032），直接按回车，fdisk 会自动选择当前分区表中第一个可用的扇区作为起始扇区
        - 输入结束扇区号（例如 90000000），或者按回车使用所有剩余空间
     - 选择建立逻辑分区，输入 `l`。
        - 输入分区号，如 `5`。
        - 输入起始扇区号（例如 90000001），直接按回车，fdisk 会自动选择当前分区表中第一个可用的扇区作为起始扇区
        - 输入结束扇区号（例如 104857599），或者按回车使用所有剩余空间
   - 输入 `p` 打印分区表，确认新建的扩展分区
   - 输入 `w` 写入分区表并退出 fdisk 界面。

![ucpkr5](https://github.com/user-attachments/assets/d21fd22f-8848-4a37-9f57-c30bc8c446f2)  

#### 2. **通知内核重新读取分区表**
如果格式化分区失败的话可以尝试通知内核重新读取分区表：
```
sudo partprobe /dev/sda
```

#### 3. **格式化分区**：
- 确认分区名称：使用 `fdisk -l` 或 `lsblk` 命令确认要格式化的分区名称，例如 `/dev/sda3`。
- 查看文件系统类型：在格式化之前，可以查看当前分区的文件系统类型（如果已经格式化过）：
```bash
sudo lsblk -f
```
或:
```bash
sudo blkid /dev/sda3
```
- 格式化分区：输入以下命令进行格式化（以 ext4 文件系统为例）：  
   ext4主要处理小文件：
```bash
sudo mkfs.ext4 /dev/sda3
```
  - 如果需要格式化为其他文件系统，例如 XFS，可以使用以下命令：
  xfs主要处理大文件：
```bash
sudo mkfs.xfs /dev/sda3
```

![ucpkr6](https://github.com/user-attachments/assets/82453b0f-b5c7-42a7-bc5b-4a7025021ce1)  


#### 4. **挂载分区**：
- 创建挂载点：在根目录下新建一个文件夹，作为挂载点，例如：
```bash
sudo mkdir -p /mnt/new_disk1
```
   - 建议使用 `/mnt` 或 `/media` 下的目录作为挂载点，这些目录通常用于挂载外部存储设备。
- 挂载分区：将分区挂载到新建的文件夹下：
```bash
sudo mount /dev/sda3 /mnt/new_disk1
```

- 查看挂载情况：输入以下命令查看挂载的磁盘：
```bash
df -h
```
   - 确认 `/dev/sda3` 已正确挂载到 `/mnt/new_disk1`。

![ucpkr7](https://github.com/user-attachments/assets/c8d43648-6620-4384-8fb3-b24e1ee3303c)  
![ucpkr8](https://github.com/user-attachments/assets/120ab5a2-abbe-4f1c-9300-11f167405694)  
![ucpkr9](https://github.com/user-attachments/assets/730305a6-4c48-465f-816b-a7f71cc358ed)  

#### 5. **设置开机自动挂载**
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
- 保存并退出文件：保存文件并退出编辑器。

![ucpkr10](https://github.com/user-attachments/assets/db320703-cf9e-4015-98c5-b107783104fe)  

- 重启系统以确保所有更改生效：
```bash
sudo reboot
```

#### 6. **删除分区**：
- **1.确认分区编号**
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

- **2.取消挂载分区**
如果要删除的分区已经挂载，需要先取消挂载。使用以下命令取消挂载分区：
```bash
sudo umount /dev/sda3
```
如果分区正在被使用，系统会提示无法取消挂载。在这种情况下，需要先关闭使用该分区的程序或服务  
如果提示分区正在使用，可以强制取消挂载：
```bash
sudo umount -f /dev/sda3 
```

- **3.启动 fdisk**  
启动 `fdisk` 工具，指定要操作的磁盘设备：
```bash
sudo fdisk /dev/sda
```

- **4.删除分区**  
在 `fdisk` 界面中，执行以下操作：
1. 输入 `d`，表示删除分区。
2. 输入要删除的分区编号（例如 `3`，表示删除 `/dev/sda3`）。
3. 输入 `w`，保存更改并退出 `fdisk`。

![ucpkr11](https://github.com/user-attachments/assets/349569e4-1e47-4a0e-b3f9-4434f34fe9e6)  

- **5.更新内核分区表**  
删除分区后，运行以下命令确保内核同步：
```bash
sudo partprobe /dev/sda
```
或最彻底的方法：
```
sudo reboot
```

- **6.验证分区是否删除**  
退出 `fdisk` 后，再次运行以下命令确认分区是否已被删除：
```bash
sudo fdisk -l
```
或者：
```bash
sudo lsblk
```
如果分区已经被删除，将不再显示在列表中。

删除分区后如果想要重新创建一般会出现下面信息：
<pre>
命令(输入 m 获取帮助)： n
分区类型
   p   主分区 (1个主分区，1个扩展分区，2空闲)
   l   逻辑分区 (从 5 开始编号)
选择 (默认 p)： p
分区号 (3,4, 默认  3): 3
第一个扇区 (83884032-104857599, 默认 83884032): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (83884032-104857599, 默认 104857599): 

创建了一个新分区 3，类型为“Linux”，大小为 10 GiB。
分区 #3 包含一个 ext4 签名。

您想移除该签名吗？ 是[Y]/否[N]： 
</pre>
直接输入 Y 并回车，fdisk 会自动清除该区域的签名，无需额外操作  
这种提示的出现是为了确保用户在创建新分区时，不会因为旧的文件系统签名而产生混淆或错误  


### 扩展现有分区
在使用MSDOS分区表的情况下，Ubuntu（以及大多数使用MSDOS分区表的Linux系统）需要先对扩展分区扩容，然后才能对其中的逻辑分区扩容  
确认分区编号：
```bash
sudo fdisk -l
```
启动 parted：
```bash
sudo parted /dev/sda
```
查看当前分区表：
```bash
print free
```
<pre>
(parted) print free
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sda: 53.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：

编号  起始点  结束点  大小    类型      文件系统  标志
      1024B   1049kB  1048kB            可用空间
 1    1049kB  538MB   537MB   primary   fat32     启动
      538MB   539MB   1048kB            可用空间
 2    539MB   42.9GB  42.4GB  extended
 5    539MB   42.9GB  42.4GB  logical   ext4
      42.9GB  53.7GB  10.7GB            可用空间
</pre>
primary：主分区
extended：扩展分区
logical：逻辑分区

#### 先对扩展分区扩容：
```bash
resizepart 2
```
确认：
```
yes
```
指定分区大小：
```
53.7GB
```
查看当前分区表：
```bash
print free
```
<pre>
(parted) print free                                                       
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sda: 53.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：

编号  起始点  结束点  大小    类型      文件系统  标志
      1024B   1049kB  1048kB            可用空间
 1    1049kB  538MB   537MB   primary   fat32     启动
      538MB   539MB   1048kB            可用空间
 2    539MB   53.7GB  53.1GB  extended
 5    539MB   42.9GB  42.4GB  logical   ext4
      42.9GB  53.7GB  10.7GB            可用空间
</pre>

#### 再对逻辑分区扩容：
```bash
resizepart 5
```
确认：
```
yes
```
指定分区大小：
```
53.7GB
```
查看当前分区表：
```bash
print free
```
<pre>
(parted) print free                                                       
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sda: 53.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：

编号  起始点  结束点  大小    类型      文件系统  标志
      1024B   1049kB  1048kB            可用空间
 1    1049kB  538MB   537MB   primary   fat32     启动
      538MB   539MB   1048kB            可用空间
 2    539MB   53.7GB  53.1GB  extended
 5    539MB   53.7GB  53.1GB  logical   ext4
</pre>
退出 parted：
```bash
quit
```

![ucpkr12](https://github.com/user-attachments/assets/6ee248c5-811f-4da0-8baa-7f85bd62c3b3)  

调整文件系统大小：
- 对于 ext4 文件系统：
```bash
sudo resize2fs /dev/sda5
```
- 对于 xfs 文件系统：
```bash
sudo xfs_growfs /mnt/sda5
```
![ucpkr13](https://github.com/user-attachments/assets/3a3675f7-4dcf-44e1-a71e-52714c8c6eb0)  


检查当前的挂载点:
```bash
df -h
```
在更新 `/etc/fstab` 文件后，建议重新挂载分区以确保一切正常：
```bash
sudo mount -a
```
验证调整结果:
```bash
df -h
```
注意扩容完成之后无法再缩小分区，只能扩大分区。

![ucpkr14](https://github.com/user-attachments/assets/5182a72e-d5ba-4c30-a819-5dc2c163bf02)  


### **常见错误及解决方法**  
如果分区表损坏，可以使用 `parted` 重新创建分区表：
```bash
sudo parted /dev/sda
```
在 parted 界面中，输入以下命令：
```bash
mklabel msdos
```
这将创建一个新的 DOS 分区表，覆盖旧的分区表

### 注意事项
1. **备份数据**
   - 在删除分区之前，建议备份重要数据，以防操作过程中出现意外导致数据丢失。

2. **确认分区编号**
   - 在操作前仔细确认分区编号，避免误操作。

3. **检查分区使用情况**
   - 在取消挂载分区之前，可以使用以下命令检查分区是否正在被使用：
```bash
sudo lsof | grep /mnt/new_disk1
```
如果有进程正在使用该分区，需要先关闭这些进程。

4. **分区大小计算**
   - 分区大小的计算方法为：
     \[
     \text{分区大小（MB）} = \frac{\text{End} - \text{Start} + 1}{2048}
     \]
     - `Start` 和 `End` 是分区的起始和结束扇区号，单位为扇区（每个扇区 512 字节）。

5. **主分区和扩展分区**
   - 一般情况下，系统盘会包含一个主分区（用于安装系统）和一个扩展分区（用于逻辑分区）。对于新增的非系统盘，可以直接划分为逻辑分区，无需主分区。

6. **文件系统选择**
   - 选择文件系统时，`ext4` 是最常用的文件系统，适用于大多数场景；`xfs` 适用于大容量存储和高性能需求的场景。

7. **查看文件系统类型**
   - 在操作过程中，可以随时使用以下命令查看分区的文件系统类型：
```bash
sudo lsblk -f
```
这个命令会列出所有分区及其文件系统类型，帮助你确认分区状态。


### 四、验证和清理
1. **检查文件系统状态**：在扩容操作完成后，建议检查文件系统状态（建议在未挂载时进行）：
```bash
sudo umount /mnt/new_disk
sudo fsck /dev/sda3
sudo mount /dev/sda3 /mnt/new_disk
```
   - 注意：`fsck` 通常用于未挂载的文件系统。如果文件系统已经挂载，运行 `fsck` 可能会导致数据丢失或其他问题。因此，建议在单用户模式或从 Live CD/USB 启动时运行 `fsck`。
2. **清理临时文件**：扩容完成后，清理系统中的临时文件，释放空间：
```bash
sudo rm -rf /tmp/*
```

### 五、备份数据
在进行任何磁盘操作之前，建议备份重要数据，以防操作过程中出现意外导致数据丢失。可以使用以下命令备份数据：
```bash
sudo tar -czvf backup.tar.gz /path/to/important/data
```
