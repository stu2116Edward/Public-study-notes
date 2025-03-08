# Dism++系统备份恢复保姆级教程

### 首先关闭Windows Defender
![WD1](https://github.com/user-attachments/assets/0a3a6e88-b6d5-4b62-b1e2-96d7cf8cefcf)  
![WD2](https://github.com/user-attachments/assets/cc754af4-e04a-458b-a57e-d071b675c2e6)  
![WD3](https://github.com/user-attachments/assets/203d594f-b2eb-4e11-823c-dabcdd409371)  
![WD4](https://github.com/user-attachments/assets/6982108f-8f14-4b1f-8bbf-9a296f620458)  

### 打开对应版本的Dism++
这里如果你下载了WPS需要操作这一步  
![Dism++1](https://github.com/user-attachments/assets/a651cfe4-8ae4-4aeb-aad5-4643d56d50ef)  
![Dism++2](https://github.com/user-attachments/assets/9fb7143b-ad6f-44de-8eaf-b961ddc4c25f)  
![Dism++3](https://github.com/user-attachments/assets/68ac99cd-4eeb-40e9-8e66-f32255dd5949)  
```
Users\*\WPSDrive
Users\*\WPSDrive - *
```
点击完成  
开始备份和还原  
![Dism++4](https://github.com/user-attachments/assets/b36f7429-52ea-4d79-8fcd-af28d8b0c140)  
这里选择除系统盘以外的路径进行备份(避免冲突)  
![Dism++5](https://github.com/user-attachments/assets/3a617369-e397-4afb-b829-2862d1618220)  
选择你所备份好的wim文件进行还原(可以正常进入系统)  
![Dism++6](https://github.com/user-attachments/assets/b9a4ace3-92a8-47e0-adad-e65d9d378eef)
这里建议添加系统引导

如果你系统已经损坏并且无法正常进入你的系统那就得使用PE启动盘在启动盘中选中你所备份的系统文件进行还原系统  
- 1.制作启动盘：  
[微PE下载地址](https://www.wepe.com.cn/download.html)
准备一个8G以上的U盘，最好是USB3.0的，插入电脑后，双击下载好的微PE:
![PE1](https://github.com/user-attachments/assets/ece11c10-e57f-4e0d-b159-0b5abcd5784e)  
点击U盘图标，安装到U盘（注意不要点立即安装进系统 ）  
![PE2](https://github.com/user-attachments/assets/0256aea3-3ccd-46ab-a68e-6a6fed61855a)  
各个选项默认即可，PE壁纸可以选个自己喜欢的壁纸，也可以默认
![PE3](https://github.com/user-attachments/assets/6e067b6a-4ca3-42c7-a5bc-1ae25a5e821a)  
关闭安全软件，制作过程会格式化U盘，要提前备份好U盘内的资料
![PE4](https://github.com/user-attachments/assets/c03bf334-7077-4afc-9099-e9870b2cf559)  
制作中，等待ing...  
制作后的装机盘变成了两个，一个是EFI分区，一个是可以当成普通U盘使用的分区
[微软操作系统镜像官方下载地址](https://www.microsoft.com/zh-cn/software-download/)  
把下载好的系统镜像文件或备份好的wim文件复制到U盘内，即可使用此U盘安装与维护系统了  
- 2.插上PE启动盘开机疯狂按启动键进入PE系统  
![openPE](https://github.com/user-attachments/assets/4ca9ff9a-2c20-467d-98fb-e7d4987738d4)  
- 3.打开Dism++进行还原或重装系统  
还原系统时一定要把C盘格式化，否则C盘里面原有的系统会和还原后的系统共存导致冲突,最后勾选上添加引导  
