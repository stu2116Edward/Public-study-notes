# OpenWrt实现远程唤醒本地电脑


`Wake-on-LAN` 也叫 WoL，指通过网络消息打开或唤醒计算机  

网络唤醒功能在远程办公环境下显得十分必要，比如位于家中或公司的计算机，出于经济和环保的目的，不使用时一般也会进入低功耗状态，睡眠、休眠甚至是关机。一旦进入低功耗状态，就需要适当的外部刺激才能让其重新恢复至工作模式  

这时借助 WoL 通过特定网络信号进行「唤醒」便是一个不错的选择  

配合`内网穿透`、`IPv6 DDNS`可谓是真正的达到了远程操作/访问的终极目标  



## BIOS设置
启用适当的 BIOS 设置才能使用 WoL 功能，具体方法每块主板叫法略有不同，可以查找自己主板的参数名称  

参考的关键词：  
- Automatic Power On
- Wake on LAN/WLAN
- Power Management
- Power On by Onboard LAN
- Power On by PCI-E Devices
- Wake on PCI-E



## 网卡设置

在 Windows 中，通过控制面板或者右下角网络图标，打开`【网络连接】`（也可以 `Win+R` – `ncpa.cpl` ），然后找到使用的有线网卡，右键点击`【属性】`  

<img width="306" height="291" alt="01" src="https://github.com/user-attachments/assets/e2198bd2-ce68-45e1-acc0-c1a325c29e30" />

选择`【配置】` – `【电源管理】`，勾选`【允许此设备唤醒计算机】`以及`【只允许幻数据包唤醒计算机】`  

<img width="463" height="304" alt="02" src="https://github.com/user-attachments/assets/d5ddba2f-0e64-4e79-b572-9ee02b9a58c6" />

***这边勾选【只允许幻数据包唤醒计算机】是为了防止主板在接收其他信号时导致误开机，情况不是很常见，可选可不选***  


再次选择`【高级】`，找到`【唤醒魔包】/【Wake on Magic Packet】`，将其`【开启】`  

<img width="463" height="435" alt="03" src="https://github.com/user-attachments/assets/27dfdb69-a342-4e8f-a424-279c1e4dcd08" />



## OpenWrt路由器设置

来到 OpenWrt 管理后台，在 `【系统】`-`【软件包】`中搜索 `luci-app-wol` ，安装 `luci-app-wol` 软件包以及 `luci-i18n-wol-zh-cn` 语言包  

<img width="1211" height="567" alt="04" src="https://github.com/user-attachments/assets/7651c0e9-85e9-42b2-b273-5670981b3860" />

刷新界面，来到`【服务】`-`【Wake on LAN】`，网络接口这边一般不用动，在`【Host to wake up】`唤醒的主机选择需要被唤醒的设备，点击下方的`【Wake up host】`进行唤醒  

<img width="1143" height="366" alt="05" src="https://github.com/user-attachments/assets/ee7a0700-af36-4564-832b-f1f1950f335c" />  
<img width="592" height="294" alt="06" src="https://github.com/user-attachments/assets/1527fd1c-d1d7-41eb-bef9-c8f1d3b3664c" />

***提前查看被唤醒设备的MAC或者IP，Windows系统可以通过CMD或者Powershell输入 `ipconfig /all` 命令查看，Linux系统可以通过 `ip add` 命令查看***
