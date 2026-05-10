# Windows进入BIOS、UEFI

BIOS（基本输入/输出系统）是电脑启动时运行的固件程序，负责启动操作系统和管理硬件设备。进入BIOS设置界面可以对计算机的各种参数进行配置和调整  
在这里你可以调整硬件设置，比如启动顺序、超频等  
- **调整启动顺序**：比如优先从U盘启动安装系统  
- **超频或优化硬件**：调整CPU、内存等设置，提升性能  
- **解决系统问题**：比如关闭安全启动来兼容某些软件  

<img width="629" height="450" alt="biosuefi1" src="https://github.com/user-attachments/assets/70971604-bc05-4664-aa63-f483259a4e68" />

### 开机过程中通过按键组合进入

- 在未开机或关机重启进入BIOS

**第一步**：关机后重新启动电脑  

**第二步**：在启动过程中，按下相应品牌电脑的BIOS快捷键，常见的包括`Esc`、`F2`、`F10`、`Delete` 键等  

**第三步**：在正确按下快捷键后，电脑会进入BIOS设置界面  


### 使用操作系统界面进入

- 开机时按 `F2 / Delete` 等快捷键无反应
- 没有物理 `Novo` 键
- 或键盘无法及时响应，错过进入 BIOS 的时机


#### 使用 Shift + 重启（最通用最推荐）

1. 按住 `Shift`，点击“重新启动”（在开始菜单 → 电源按钮中）  
2. 进入“选择一个选项” → “疑难解答” → “高级选项”  
3. 选择 `UEFI 固件设置`，点击“重新启动”  
4. 成功进入 BIOS  


#### 通过 Windows  设置菜单进入 

1 打开“设置” → “系统” → “恢复”  

<img width="1368" height="903" alt="biosuefi2" src="https://github.com/user-attachments/assets/10b03af9-5039-409f-a72e-9b90eaeb8c50" />

2. 点击“高级启动”下的“立即重新启动”  

<img width="1403" height="889" alt="biosuefi3" src="https://github.com/user-attachments/assets/31519250-97a8-4a1b-8c5a-971a90a0ca52" />  
<img width="1391" height="878" alt="biosuefi4" src="https://github.com/user-attachments/assets/c5fcbb36-9267-48ec-89b2-e4032296315d" />  

3. 进入蓝色“选择一个选项”界面  
依次点击如下：  
**1. 疑难解答**  
**2. 高级选项**  
**3. UEFI 固件设置**  
4. 选择 `UEFI 固件设置`，点击“重新启动”  

<img width="1083" height="836" alt="biosuefi5" src="https://github.com/user-attachments/assets/cc4aea8b-2317-4ec5-a678-5ea537febfad" />  
<img width="1068" height="650" alt="biosuefi6" src="https://github.com/user-attachments/assets/217f5731-98f4-49ef-bba9-663058ec3d90" />  
<img width="1334" height="891" alt="biosuefi7" src="https://github.com/user-attachments/assets/4e65e060-8a30-409e-b783-2f15937cc92d" />  
<img width="1310" height="420" alt="biosuefi8" src="https://github.com/user-attachments/assets/d6f17e11-6fbc-48d7-8284-5c3a17cb72c5" />  

5. 成功进入 BIOS  


### 通过cmd命令提示符进入

可以使用命令提示符 `cmd` 或 `PowerShell`，输入以下命令并按回车：
```
shutdown /r /fw /t 0
```
- `/r`：重启  
- `/fw`：进入固件（Firmware）设置  
- `/t 0`：立即执行  

<img width="653" height="229" alt="biosuefi9" src="https://github.com/user-attachments/assets/579864ca-e960-47b4-bc32-2162cc42fa2a" />

执行后系统将直接重启并进入 BIOS  


### 使用 Novo 键（仅限有 Novo 按钮的联想机型）

如果你的设备有 Novo 小孔（通常在侧边或靠近电源键）：  

1. 完全关机  
2. 用卡针轻按 Novo 键  
3. 出现菜单 → 选择“BIOS Setup” 即可进入蓝色界面  
依次点击如下：  
**1. 疑难解答**  
**2. 高级选项**  
**3. UEFI 固件设置**  
**4. BIOS 界面**  
