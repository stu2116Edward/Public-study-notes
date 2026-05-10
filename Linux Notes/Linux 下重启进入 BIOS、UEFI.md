# Linux 下重启进入 BIOS、UEFI

在 Linux 系统管理和硬件配置中，有时需要重启进入 BIOS（基本输入输出系统）或 UEFI（统一可扩展固件接口）界面，以调整启动顺序、启用硬件功能（如虚拟化技术）、更新固件或排查启动故障。与 Windows 不同，Linux 系统没有图形化的“重启到 BIOS”按钮，因此需要通过命令行、引导加载程序或传统按键方式实现。  


### 什么是 BIOS 和 UEFI？

#### BIOS（基本输入输出系统）

定义：传统固件接口，诞生于 1975 年，基于 16 位汇编语言，仅支持最大 2.2TB 硬盘、传统 MBR 分区表，启动过程依赖 BIOS 中断服务程序  
特点：功能简单、启动速度较慢、兼容性有限，目前仅在老旧设备（如 2010 年前的主板）中使用  


#### UEFI（统一可扩展固件接口）

定义：2005 年推出的现代固件接口，基于 C 语言，支持 64 位架构、GPT 分区表（无硬盘容量限制）、安全启动（Secure Boot）、图形化界面等高级功能  
特点：启动速度快、功能丰富、兼容性强，目前主流主板（2010 年后）均默认使用 UEFI  

#### 为什么需要进入 BIOS/UEFI？

以下是常见场景，需重启进入 BIOS/UEFI 进行配置：  
- **修改启动顺序**：例如从 USB 启动盘启动以安装系统或修复故障
- **启用硬件功能**：如开启 Intel VT-x/AMD-V 虚拟化技术（用于虚拟机）、调整 SATA 模式（AHCI/IDE）、启用 TPM 模块（用于 Windows 11 升级）
- **更新固件**：通过 BIOS/UEFI 界面刷写主板固件（需提前准备固件文件）
- **排查启动故障**：例如禁用 Secure Boot 解决 Linux 启动失败（部分旧版 Linux 发行版不支持 Secure Boot）
- **调整系统参数**：如修改系统时间、风扇转速、超频设置（需谨慎操作）



### 从 Linux 重启进入 BIOS/UEFI 的方法

根据系统固件类型（UEFI/BIOS）和工具链（如 systemd、GRUB），可选择以下方法：

#### 使用 systemctl 命令（推荐，适用于 UEFI 系统）

原理：`systemd`（主流 Linux 发行版的初始化系统）提供 `reboot` 命令的 `--firmware-setup` 选项，可直接触发 UEFI 固件的“重启到设置界面”功能  

适用条件：  
- 系统使用 **UEFI 固件**（非传统 BIOS）。
- 系统**已安装 systemd**（几乎所有主流发行版，如 Ubuntu、Fedora、Debian、Arch Linux 等）。
- 主板固件支持 UEFI Spec 2.3.1+ 标准（2010 年后的主板通常满足）。


操作步骤：  

1. 打开终端（快捷键 Ctrl+Alt+T）
2. 执行命令：
```
sudo systemctl reboot --firmware-setup
```
3. 系统自动重启，并直接进入 UEFI 设置界面（无需手动按快捷键）

局限性：  
- **不支持传统 BIOS**：若系统为传统 BIOS（非 UEFI），执行此命令会直接重启进入系统，而非 BIOS 界面。
- **部分旧主板兼容问题**：少数老旧 UEFI 主板可能不响应此命令，需改用其他方法。


### 传统方法：重启后按 BIOS/UEFI 快捷键
原理：最通用的方法，适用于所有系统（无论 UEFI/BIOS），但需手动把握按键时机  

操作步骤：  
1. **重启系统**：在 Linux 中执行 `sudo reboot`
2. **快速按下 BIOS/UEFI 快捷键**：在主板 Logo 出现前（通常重启后 1-3 秒内），持续按对应快捷键

常见品牌主板/设备的快捷键：  

| 设备类型 | 品牌 | 进入 BIOS / 固件设置 | 启动菜单 (Boot Menu) | 备注 |
| :--- | :--- | :--- | :--- | :--- |
| **台式机主板** | ASUS（华硕） | `Del` | `F8` | 主流型号通用 |
| | MSI（微星） | `Del` | `F11` | 主流型号通用 |
| | Gigabyte（技嘉） | `Del` | `F12` | 主流型号通用 |
| | ASRock（华擎） | `Del` | `F11` | 主流型号通用 |
| | Intel（英特尔） | `F2` | `F10` | 原厂主板 |
| **笔记本电脑** | ASUS（华硕） | `F2` | `Esc` | 开机后连续按 F2 进 BIOS；按 Esc 唤出启动菜单后再选 Enter Setup |
| | Dell（戴尔） | `F2` | `F12` | 部分型号需按 `Fn+F2` |
| | HP（惠普） | `F10` | `F9` | 部分新款需先按 `Esc` |
| | Lenovo（联想） | `F2` | `F12` | 部分型号需按 `Fn+F2` |
| | ThinkPad（联想商用） | `F1` | `F12` | 按 `Enter` 后按 `F1` 亦可 |
| | Apple（Mac） | `Option` | `Option` | Intel 芯片按 `Option`；M芯片长按电源键 |
| | Huawei（华为） | `F2` | `F12` | 部分型号需按 `Fn+F2` |
| | Honor（荣耀） | `F2` | `F12` | 部分型号需按 `Fn+F2` |
| | Xiaomi（小米） | `F2` | `F12` | 主流型号通用 |
| | Acer（宏碁） | `F2` | `F12` | 部分型号需按 `Fn+F2` |
| | Samsung（三星） | `F2` | `F12` | 主流型号通用 |
| | Microsoft Surface | 音量+键 + 电源键 | 同左 | 关机状态下操作 |
| **服务器** | Dell PowerEdge | `F2` | `F11` | 主流服务器通用 |
| | Inspur（浪潮） | `Del` | `F11` | 主流服务器通用 |
| | Lenovo（IBM System x） | `F1` | `F12` | 主流服务器通用 |
| | Cisco UCS | `F2` | `F6` | 主流服务器通用 |
| | Huawei（华为） | `Del` | `F11` | 主流服务器通用 |
| | HPE | `F9` | `F11` | 开机自检时按提示 |



### 通过 GRUB 引导菜单

原理：GRUB（Grand Unified Bootloader）是 Linux 主流引导加载程序，可通过修改临时引导参数触发重启到 BIOS/UEFI  

适用条件：  
系统使用 **GRUB 2**（几乎所有 Linux 发行版默认引导加载程序）  
适用于 **UEFI** 和 **BIOS** 系统  

#### 操作步骤（临时修改，单次生效）：  

1. **重启系统**，并在 GRUB 菜单出现前按住 Shift 键（BIOS 系统）或 Esc 键（UEFI 系统），强制显示 GRUB 菜单

***提示：若 GRUB 菜单默认隐藏（如 Ubuntu），需在启动时快速按 `Shift/Esc`***

2. **选择要启动的 Linux 内核**（如 “Ubuntu”），按 `e` 键进入编辑模式 

3. **定位到内核参数行**：找到以 `linux /boot/vmlinuz-xxx root=xxx` 开头的行（不同发行版可能略有差异）

4. **添加重启参数**：
- **UEFI 系统**：在行尾添加 `systemctl reboot --firmware-setup`
- **BIOS 系统**：在行尾添加 `reboot=bios`

例如，修改前的内核行：
<pre>
linux /boot/vmlinuz-5.15.0-78-generic root=UUID=abc123... ro quiet splash
</pre>

示例（UEFI 系统）：
```
linux /boot/vmlinuz-5.15.0-78-generic root=UUID=abc123... ro quiet splash systemctl reboot --firmware-setup
```

示例（BIOS 系统）：
```
linux /boot/vmlinuz-5.15.0-78-generic root=UUID=abc123... ro quiet splash reboot=bios
```

5. **应用修改并启动**：按 `Ctrl+X` 或 `F10` 执行引导，系统会重启并进入 BIOS/UEFI 界面



### 通过修改内核参数

原理：通过向 Linux 内核传递 `reboot` 参数，强制系统以特定方式重启（如重启到 BIOS/UEFI）。适用于 systemd 命令失效或需要`永久生效`的场景  

#### 临时修改（单次生效）  

同上 GRUB 编辑模式中添加内核参数：  
- `reboot=bios`：重启到传统 BIOS 界面
- `reboot=efi`：重启到 UEFI 界面（等价于 systemctl reboot --firmware-setup）


#### 永久修改（适用于频繁操作）  
若需长期生效，可修改 GRUB 配置文件：  
1. 编辑 GRUB 配置
```
sudo vim /etc/default/grub
```
2. 修改 `GRUB_CMDLINE_LINUX_DEFAULT` 行：添加 `reboot=efi`（UEFI）或 `reboot=bios`（BIOS），例如：
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash reboot=efi"  # UEFI 系统
```
3. 更新 GRUB 配置：
- **Debian/Ubuntu**：`sudo update-grub`
- **Fedora/RHEL**：`sudo grub2-mkconfig -o /boot/grub2/grub.cfg`
- **Arch Linux**：`sudo grub-mkconfig -o /boot/grub/grub.cfg`

4. 重启系统：`sudo reboot`，此时会自动进入 BIOS/UEFI 界面

***注意：永久修改后，每次重启都会进入 BIOS/UEFI，完成配置后需删除该参数并重新更新 GRUB***  



### 常见问题与解决方案

**问题 1**：`systemctl reboot --firmware-setup` 无反应，重启直接进入系统  
原因：  
- 系统为 **传统 BIOS**（非 UEFI），不支持该命令
- UEFI 固件版本过旧，不支持“重启到设置界面”功能
- Secure Boot 被启用且限制了系统调用（罕见）

解决方案：  
- 改用 **传统方法** 或 **GRUB 引导菜单**
- 更新主板固件（需从官网下载对应型号的 UEFI 更新文件）


**问题 2**：GRUB 菜单无法显示  

原因：  
- GRUB 超时时间设为 0（默认隐藏菜单）
- 系统使用 LVM 或加密分区，GRUB 引导过程被简化

解决方案：  
- 临时显示：重启时持续按 `Shift`（BIOS）或 `Esc`（UEFI）
- 永久调整：编辑 `/etc/default/grub`，设置 `GRUB_TIMEOUT=5`（显示 5 秒），然后 `sudo update-grub`


**问题 3**：BIOS/UEFI 快捷键无效，直接进入 Linux

原因：
- 按键时机过晚（错过 BIOS 初始化阶段）
- 快速启动（Fast Boot）被启用，缩短了 BIOS 检测时间

解决方案：  
- 关闭 Fast Boot：进入 BIOS/UEFI 后，在“Boot”选项中禁用“Fast Boot”（需先通过其他方法进入 BIOS）
- 多次尝试：重启后连续快速按快捷键（而非按住不放）


**问题 4**：修改内核参数后系统无法启动

原因：参数错误（如 `reboot=xxx` 拼写错误）  

解决方案：  
- 重启并进入 GRUB 菜单，编辑内核参数行，删除错误参数，保存后启动。
- 若无法进入 GRUB，使用 Linux 启动盘修复 GRUB 配置（如 `chroot` 后重新生成 `grub.cfg`）



### 建议

1. 优先使用 systemd 命令（UEFI 系统）  
对 UEFI 系统，`systemctl reboot --firmware-setup` 是最便捷的方法，无需手动按键，成功率高

2. 避免永久修改内核参数  
除非需频繁进入 BIOS/UEFI，否则不建议永久修改 `GRUB_CMDLINE_LINUX_DEFAULT`（可能导致每次重启都进入 BIOS/UEFI，增加操作成本）

3. 提前备份 BIOS/UEFI 设置  
修改关键参数（如 Secure Boot、虚拟化）前，建议通过 BIOS/UEFI 界面的“Save Profile”功能备份配置（若支持），以便恢复

4. 禁用 Fast Boot 简化操作  
若需频繁进入 BIOS/UEFI，可在设置中禁用“Fast Boot”（需先进入一次 BIOS/UEFI），延长按键响应时间

5. 谨慎操作超频/固件更新  
修改超频参数或更新固件时，需严格按照主板说明书操作，错误操作可能导致硬件损坏（如“变砖”）
