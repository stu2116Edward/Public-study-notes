1.更新软件包列表：  
sudo apt update  

2.安装新软件：  
sudo apt install package_name  

3.升级已安装的软件包：  
sudo apt upgrade  

4.完全升级：  
sudo apt full-upgrade  

5.删除软件包：  
sudo apt remove package_name  

6.清除包：  
sudo apt purge package_name  

7.搜索包：  
apt search package_name  

8.列出已安装的软件包：  
apt list --installed  

9.检查包裹详细信息：  
apt show package_name  

10.清理未使用的依赖项：  
sudo apt autoremove  

11.使用 Deborphan 识别未使用的软件包：  
sudo apt install deborphan  
deborphan  

12.更新单个软件包：  
sudo apt install --only-upgrade package_name  

13.下载软件包而不安装：  
apt download package_name  

14.检查损坏的依赖关系：  
sudo apt -f install  

15.列出可升级的软件包：  
apt list --upgradable  

16.查找包提供程序：  
dpkg -S keyword  

17.检查包依赖关系：  
apt depends package_name  

18.搜索软件包提供程序：  
sudo apt update && sudo apt install apt-file  
更新 apt-file 的数据库  
sudo apt-file update  
搜索提供文件或命令的包  
apt-file search keyword  

19.安装本地软件包文件：  
sudo apt install ./my_package.deb  

20.列出所有已安装的软件包  
dpkg --list  
