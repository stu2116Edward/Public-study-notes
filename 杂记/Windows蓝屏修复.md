# Windows蓝屏修复

首先打开`图吧工具箱`查看`BlueScreenView`工具，查看蓝屏日志，找到蓝屏原因，然后根据原因进行修复  

## 运行SFC（系统文件检查器）工具
```
sfc /scannow
```
如果SFC扫描完成后没有发现问题，会显示验证完成的信息。如果发现问题但无法修复，会提示相关信息，并建议查看`CBS.Log`日志文件，通常位于`C:\Windows\Logs\CBS\CBS.log`  
如果没有问题提示：  
<pre>
开始系统扫描的验证阶段。
验证 100% 已完成。
</pre>

如果存在问题提示：
<pre>
Windows 资源保护找到了损坏文件但无法修复  
其中某些文件。`CBS.Log windir\Logs\CBS\CBS.log` 中有详细信息。  
例如 `C:\Windows\Logs\CBS\CBS.log`。  
</pre>

## 运行DISM（部署映像服务和管理）工具
```
DISM /Online /Cleanup-Image /ScanHealth
```
```
DISM /Online /Cleanup-Image /CheckHealth
```
```
DISM /Online /Cleanup-Image /RestoreHealth
```
完成后重启电脑，再次输入：
```
sfc /scannow
```

## Windows 内存诊断工具
以`管理员身份`运行:
```
mdsched.exe
```
如果内存诊断工具发现了问题，会提示你修复内存问题

## 使用CHKDSK检查硬盘健康状况：
在开始菜单上单击右键或按下`Win+X`，点击命令提示符（`管理员`），输入:
```
chkdsk c: /f
```
按下回车键，输入Y确认，然后重启电脑让系统自修复

## 蓝屏代码
### 蓝屏代码page_fault_in_nonpaged_area (0x00000050)
方法一： 关闭快速启动  
“Win+X”-电源选项-其他电源设置-选择电源按钮的功能-更改当期不可用的设置-去掉“启用快速启动（推荐）”前的对勾-保存修改-重启电脑  

方法二：虚拟内存设置  
1. 桌面右击此电脑图标，在右键菜单选择 属性-选择 高级系统设置 选项  
2. 在打开的计算机属性窗口，选择【高级】选项卡，然后点击【性能】组的【设置】选项  
3. 在打开的【性能选项】界面，选择【高级】选项卡，然后点击【虚拟内存】组的【更改】选项，取消【自动管理…】前面的选中状态，然后选择【系统管理的大小】，然后点击【确定】，然后重启就行了  
注：此方法主要针对调整过虚拟内存的用户

方法三：  
另一可能原因是Windows defender的内存隔离功能，所以只需要关闭它即可  
1. 右键开始菜单，选择“运行”，输入“regedit”回车  
2. 在弹出的注册表编辑器界面，我们依次展开以下路径  
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity`里面有一个`Enable`，双击它，将它的数值数据修改成 `0` 即可  
3. 最后重启下电脑  
注：如果你的电脑`一直无限蓝屏重启`，无法操作以上步骤，可以先进入windows的`安全模式`，再进行操作  

### 以下是常见蓝屏代码的参考：
1. `0x0000009C` 内存条故障引起，建议更换新内存条  
2. `0x0000007B` 硬盘分区引导错误  
3. `0x00000050` 磁盘坏道，建议使用DiskGenius软件修复  
4. 软件兼容问题蓝屏代码：`0x000000BE`、`0x0000000A`  
5. 驱动兼容问题蓝屏代码：`0x0000000A`、`0x000000B4`、`0X000000D1`  
[更多详情请跳转CSDN](https://blog.csdn.net/gelinwangzi_juge/article/details/109177813)  
