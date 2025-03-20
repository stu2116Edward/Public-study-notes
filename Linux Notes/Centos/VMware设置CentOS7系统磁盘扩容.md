# VMware 设置 CentOS 7 系统磁盘扩容指南

## **步骤 1：在虚拟机软件中扩展磁盘容量**

### **1. 关闭虚拟机**
- **操作**：确保虚拟机处于关闭状态，因为某些虚拟机软件在关机状态下才能扩展磁盘。

### **2. 进入虚拟机设置**
- **操作**：打开虚拟机软件，选择需要扩展磁盘的虚拟机，点击“设备”中的“硬盘”。

### **3. 扩展磁盘容量**
- **操作**：
  1. 在虚拟机设置界面的右侧，点击“扩展”按钮。
  2. 在弹出的“扩展磁盘容量”对话框中，输入需要扩展的磁盘大小。
  3. 点击“扩展”按钮，等待系统自动完成扩展操作。
  4. 点击“确定”按钮，完成虚拟机磁盘的扩展。

![CO7cpkz1](https://github.com/user-attachments/assets/499e3e9d-a768-4168-8a25-2dedd67388b9)  
![CO7cpkz2](https://github.com/user-attachments/assets/1202ed42-43ad-4011-a5d4-65c75b9380f9)  
![CO7cpkz3](https://github.com/user-attachments/assets/e6341880-2eee-4eee-8dd6-a18247d02e7d)  
![CO7cpkz4](https://github.com/user-attachments/assets/5c3cf00a-f5b0-4fe5-9911-769e34cc0da6)  
![CO7cpkz5](https://github.com/user-attachments/assets/81701be2-92ec-4c08-a4c6-916ce4d92dff)  


## **步骤 2：在 CentOS 系统中扩展磁盘容量**

### **1. 启动虚拟机**
- **操作**：启动虚拟机，进入 CentOS 系统。
- 查看磁盘大小：
```bash
df -h
```
![CO7cpkz6](https://github.com/user-attachments/assets/002f76eb-c6c7-4002-9222-a0b1765524dc)  

### **2. 查看磁盘分区信息**
- **操作**：打开终端，输入以下命令查看磁盘分区信息：
  ```bash
  fdisk -l
  ```
![CO7cpkz7](https://github.com/user-attachments/assets/0ab819eb-96c0-4774-8acf-66dadb19c45c)  

### **3. 创建新的分区**
- **操作**：
  1. 输入以下命令进入分区工具：
     ```bash
     fdisk /dev/sda
     ```
  ![CO7cpkz8](https://github.com/user-attachments/assets/7addf0ea-bb75-4df3-9bfb-31b24fca558e)  

  2. 按照以下步骤操作：
     - 输入 `p` 查看当前分区信息。
     - 输入 `n` 创建新的分区。
     - 输入 `p` 选择主分区。
     - 输入分区号（例如 `3`）。
     - 按回车键接受默认的起始扇区。
     - 按回车键接受默认的结束扇区（使用所有剩余空间）。
     - 输入 `t` 设置分区类型，输入 `8e`（Linux LVM）。
     - 输入 `p` 查看分区信息，确认新分区已创建。
     - 输入 `w` 保存并退出。
![CO7cpkz9](https://github.com/user-attachments/assets/0febc4ca-bc09-42f1-b014-08538d6d41e8)  
![CO7cpkz10](https://github.com/user-attachments/assets/afeba173-f4a5-49d3-9c7d-4336cfd22864)  
![CO7cpkz11](https://github.com/user-attachments/assets/214e035d-4e54-4014-b897-d421d45e9f55)  
![CO7cpkz12](https://github.com/user-attachments/assets/8a02a468-bd91-4a49-9497-9c88086eb1fc)  

### **4. 刷新分区信息**
- **操作**：输入以下命令刷新分区信息：
  ```bash
  partprobe /dev/sda
  ```

### **5. 初始化新分区为物理卷**
- **操作**：输入以下命令初始化新分区为物理卷：
  ```bash
  pvcreate /dev/sda3
  ```
![CO7cpkz13](https://github.com/user-attachments/assets/6e856195-7db6-4773-beaf-a2139253cd0b)  

### **6. 将新分区添加到卷组**
- **操作**：输入以下命令将新分区添加到卷组：
  ```bash
  vgextend centos /dev/sda3
  ```
![CO7cpkz14](https://github.com/user-attachments/assets/62f77e6f-ed5a-4ae1-adae-db8c314e3af6)  


### **7. 查看卷组的详细信息**
- **操作**：输入以下命令查看卷组的详细信息：
  ```bash
  vgdisplay
  ```

### **8. 扩展逻辑卷**
- **操作**：
  - 假设要扩展根文件系统 `/dev/mapper/centos-root`，可以选择以下方法之一：
    - **使用所有剩余空间**：
      ```bash
      lvextend -l +100%FREE /dev/mapper/centos-root
      ```
    - **指定新大小**（例如，将逻辑卷扩展到 50 GiB）：
      ```bash
      lvextend -L 50G /dev/mapper/centos-root
      ```
    - **指定增加的具体大小**（例如，增加 10 GiB）：
      ```bash
      lvextend -L +10G /dev/mapper/centos-root
      ```

### **9. 扩展文件系统**
- **操作**：
  - 根据文件系统类型，使用以下命令扩展文件系统：
    - 查看文件系统类型的命令：
      ```bash
      lsblk -f
      ```
      或
      ```bash
      df -T
      ```
    - **对于 `ext4` 文件系统**：
      ```bash
      resize2fs /dev/mapper/centos-root
      ```
    - **对于 `xfs` 文件系统**：
      ```bash
      xfs_growfs /dev/mapper/centos-root
      ```

### **10. 验证扩容结果**
- **操作**：输入以下命令查看文件系统的大小，确认扩容成功：
  ```bash
  df -h
  ```

## **步骤 3：验证和清理**

### **1. 检查文件系统状态**
- **操作**：确保文件系统状态正常，没有错误。可以使用以下命令检查文件系统状态：
  ```bash
  fsck /dev/mapper/centos-root
  ```
  **注意**：`fsck` 通常用于未挂载的文件系统。如果文件系统已经挂载，运行 `fsck` 可能会导致数据丢失或其他问题。因此，建议在单用户模式或从 Live CD/USB 启动时运行 `fsck`。

### **2. 检查卷组和逻辑卷状态**
- **操作**：使用以下命令检查卷组和逻辑卷的状态：
  ```bash
  vgdisplay
  lvdisplay
  ```

### **3. 清理临时文件**
- **操作**：扩容完成后，清理系统中的临时文件，释放空间：
  ```bash
  rm -rf /tmp/*
  ```

## **注意事项**
- **备份数据**：在进行磁盘扩容操作之前，建议备份重要数据，以防操作过程中出现意外导致数据丢失。
- **分区类型**：确保新分区的类型设置为 `8e`（Linux LVM），以便 LVM 可以正确识别和管理物理卷。
- **文件系统类型**：根据你的文件系统类型（`ext4` 或 `xfs`），使用相应的命令扩展文件系统。
- **在线扩展**：`xfs_growfs` 和 `resize2fs` 都支持在线扩展，即在文件系统挂载状态下进行扩展，但建议在低负载时操作以避免潜在问题。
