## Windows跳过开机密码

### 只适用于Win11 和 Win10 (21H2)以上版本
1. 开机
2. 按住`Shift`鼠标移动到右下角点击`重启`(如果出现蓝屏重启后重复执行上述步骤)
3. 进入选项界面选择`疑难解答`，选择`高级选项`，选择`命令提示符`
4. 在终端输入以下命令：
```
copy C:\Windows\System32\Utilman.exe C:\Windows\System32\Utilman.exebak
```
```
copy C:\Windows\System32\cmd.exe C:\Windows\System32\Utilman.exe
```
输入`yes`  
关闭终端  
点击`继续`  
**重启**  
5. 鼠标右下角点击电源左侧的`辅助按钮`开启终端输入以下命令：
如果没有显示登陆账号或者忘记登陆账号的话(显示当前电脑的管理员用户名)：
```
net localgroup administrators
```
<pre>
C:\Windows\System32>net localgroup administrators
别名     administrators
注释     管理员对计算机/域有不受限制的完全访问权

成员

-------------------------------------------------------------------------------
Admin
Administrator
命令成功完成。
</pre>
找到账号后重置一下登陆密码
```
net user Admin *
```
回车  
输入用户密码  
再次确认密码  
回车

6. 最后使用管理员模式打开cmd恢复辅助图标功能
```
copy C:\Windows\System32\Utilman.exebak C:\Windows\System32\Utilman.exe
```

### 如果Windows系统过于老旧
1. 打开[Hiren’s BootCD PE](https://www.hirensbootcd.org/)官网，点击顶部的`Download`，在下面找到`HBCD_PE_x64.iso`下载到本地
2. 下载[Rufus](https://rufus.ie/zh/)写盘工具
3. 准备一个至少10G的U盘插入电脑(提前备份U盘中的重要数据)
4. 打开`Rufus`写盘工具在`设备`处选中你插入的U盘
5. 引导类型选择`HBCD_PE_x64.iso`
6. 点击`开始`点击`确定`(这将清除U盘中的所有数据)
7. 将U盘插入到要破击开机密码的电脑上
8. 按下电源开机并迅速敲击键盘上的`Delete`键进入Bios界面(不同电脑进入Bios的按键可能不同)
9. 把U盘设置为第一启动项保存并重启
10. 启动后进入PE系统界面，点击左下角的Windows图标后再点击`All Programs`，接着点击`Security`，点击`Password`，点击`NT Password Edit`
11. 打开后确保Path路径为`C:\WINDOWS\SYSTEM32\CONFIG\SAM`然后点击Open按钮，接着点击你的管理员账号，点击`Change password`修改登陆密码或者直接留空这样登陆的时候就不用输入密码了，最后点击`Save changes`
12. 拔掉U盘然后重启电脑
