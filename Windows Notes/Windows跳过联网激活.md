# Windows跳过联网激活

## 一，win11初次开机跳过联网激活-方法1
1、首次进入Windows11家庭版系统并进行设置，到联网界面，按下`Shift+F10`快捷键（无效可试下`FN+Shfit+F10`）  
2、在出现的命令提示符页面输入 `OOBE\BYPASSNRO` ，按回车键，等待电脑重启完成  
3、重启后，在联网界面会有 `我没有Internet连接` 选项，点击此选项即可跳过联网  

## 二，win11初次开机跳过联网激活-方法2
1、按下 `Shift+F10` 或者是 `Fn+Shift+F10` 快捷键调出命令提示符窗口  
2、输入 `taskmgr` ，并按下回车键  
3、接着就会出现任务管理器页面，我们点击“详细信息”  
4、找到 `Network Connection Flow` 进程或者是 `网络连接流` 进程，点击 `结束任务`  
5、这样就可以跳过联网  

## 三、通过修改注册表跳过联网界面-方法3
１、`按Shift键+F10键`（不成功按`Fn+Shift+F10`）；
２、弹出命令提示符窗口，输入 `regedit` 回  
３、然后在打开的注册表编辑器界面中，找到下方路径——计算机 `\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE`  
４、接下来在注册表的右侧空白处鼠标右键，在弹出的右键菜单项中，新建一个DWORD(32位)值(D)。新建的值重命名为: `BypassNRO` ，双击打开BypassNRO这个值，然后在编辑DWORD(32位)值窗口，将数值数据修改为【1】，再点击【确定】  
５、最后在cmd窗口再输入命令：`logoff` ，回车  
６、可以跳过联网  
end.
