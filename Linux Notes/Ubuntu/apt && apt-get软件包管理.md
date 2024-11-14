## apt && apt-get软件包管理

1.更新软件包列表：  
```
sudo apt update
sudo apt-get update
```
2.安装新软件：  
```
sudo apt install <package_name>
sudo apt-get install <package_name>
```
3.升级已安装的软件包（不会删除软件包）：  
```
sudo apt upgrade
sudo apt-get upgrade
```
4.完全升级（可能会删除软件包以解决依赖问题）：  
```
sudo apt full-upgrade
sudo apt-get dist-upgrade
```
5.删除软件包（保留配置文件）：  
```
sudo apt remove <package_name>
sudo apt-get remove <package_name>
```
6.清除包（删除软件包及其配置文件）：  
```
sudo apt purge <package_name>
sudo apt-get purge <package_name>
```
7.搜索包：  
```
apt search <package_name>
apt-cache search <package_name>
```
8.列出已安装的软件包：  
```
apt list --installed  
dpkg --list
```
9.检查包裹详细信息：  
```
apt show <package_name>
apt-cache showpkg <package_name>
```
10.清理未使用的依赖项：  
```
sudo apt autoremove
sudo apt-get autoremove
```
11.使用 Deborphan 识别未使用的软件包（需要额外安装deborphan）：  
```
sudo apt install deborphan
```
```
deborphan
```
12.更新单个软件包：  
```
sudo apt install --only-upgrade <package_name>
sudo apt-get install --only-upgrade <package_name>
```
13.下载软件包而不安装：  
通常APT下载的软件包会存放在/var/cache/apt/archives/目录  
```
apt download <package_name>
apt-get download <package_name>
```
14.检查损坏的依赖关系：  
```
sudo apt -f install
sudo apt-get -f install
```
15.列出可升级的软件包：  
```
apt list --upgradable
apt-get upgrade --list
```
16.查找包提供程序：  
```
dpkg -S keyword
```
17.检查包依赖关系：  
```
apt depends <package_name>
apt-cache rdepends <package_name>
```
18.搜索软件包提供程序：  
```
sudo apt update && sudo apt install apt-file
sudo apt-get update && sudo apt-get install apt-file
```
更新 apt-file 的数据库  
```
sudo apt-file update
```
搜索提供文件或命令的包  
```
apt-file search keyword
```
19.安装本地软件包文件：  
```
sudo apt install ./my_package.deb  
sudo dpkg -i ./my_package.deb  # 也可以使用 dpkg 安装，但建议使用 apt 以处理依赖关系
```
20.列出所有已安装的软件包  
```
dpkg --list
```
21.查看软件包的详细信息（包括依赖关系、安装大小等）：
```
apt policy <package_name>
```
这个命令提供了关于软件包的更多信息，包括其版本、来源、优先级和依赖关系等  
清理下载的.deb包文件（这些文件通常存储在`/var/cache/apt/archives/`目录中）：  
```
sudo apt clean
sudo apt-get clean
```
这个命令会删除已下载的.deb包文件，但不会删除已安装的软件包或配置文件

## 存放位置  
- 下载的软件包：  
使用apt或apt-get下载的软件包通常存储在/var/cache/apt/archives/目录下  
这个目录用于缓存下载的软件包，以便在需要时重新安装或更新  
- 安装后的软件包：  
安装后的软件包通常存储在系统的标准位置，如/usr/bin/（可执行文件）、/usr/lib/或/usr/lib/x86_64-linux-gnu/（共享库）等  
这些位置是系统范围内的标准位置，安装的应用程序可以被系统上的所有用户访问  
