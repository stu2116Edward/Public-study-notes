# kali 配置NAT模式网卡连外网

## 1.打开终端，输入ipconfig，发现没有地址

## 2..打开虚拟网卡配置

## 3.打开本地VMnet8设置

保存退出。

## 4.回到终端输入，vi /etc/network/interfaces ,进入网卡配置，输入以下内容

按esc键输入:wq 保存退出。（注意，冒号是英文输入法下的）

## 5.输入 vim /etc/resolv.conf ,打开dns配置，添加以下内容

按esc键输入:wq 保存退出。（注意，冒号是英文输入法下的）

## 6.重启网卡，systemctl restart networking.service

## 7.再输入ifconfig，发现有了刚才配的ip地址

## 8.测试ping 百度，可以上外网，成功
