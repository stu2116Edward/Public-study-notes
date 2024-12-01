# yum 命令列表：

**yum命令简介**  
yum 是一种强大的包管理工具，用于在基于 RPM 包管理系统的 Linux 发行版中管理软件包。它可以自动解决软件包之间的依赖关系，简化了软件包的安装、更新和删除过程

**软件包和软件包组**  
软件包（Package）  
- 定义：软件包是Linux系统中最小的软件部署单元。它包含程序及其所有依赖项，用于执行特定任务。  
- 内容：一个软件包通常包含程序文件、库文件、配置文件和文档等。  
- 独立性：软件包是独立的，可以单独安装、升级或删除，而不影响系统中的其他软件包。  
- 依赖性：软件包在安装时会自动处理其依赖关系，确保所有必需的依赖软件包也被安装。  
- 管理：软件包可以通过yum或dnf等包管理器进行搜索、安装、升级、卸载等操作。  

软件包组（Package Group）  
- 定义：软件包组是一组功能相关的软件包的集合，它们通常用于完成一类特定的任务或应用场景。  
- 便利性：软件包组为用户提供了一种方便的方式来一次性安装多个相关的软件包，而不是单独安装每个软件包。  
- 示例：例如，"Development Tools" 软件包组可能包括编译器、调试器、库和其他开发工具。  
- 依赖性：安装一个软件包组时，包管理器会自动处理该组内所有软件包的依赖关系。  
- 管理：软件包组也可以通过包管理器进行安装、卸载等操作，但操作的是整个组，而不是单个软件包。  


### 软件包管理命令列表
- **更新软件包列表**：
```
sudo yum makecache
```
- **安装新软件**：
```
sudo yum install <package_name>
```
- **自动安装不进行交互**：
```
sudo yum -y install <package_name>
```
- **检查可更新的软件有哪些**:
```
yum check-update
```
- **升级所有软件包**：
```
sudo yum update
```
- **更新指定程序包**：
```
sudo yum update <package_name>
```
- **升级指定程序包**：
```
yum upgrade <package_name>
```
- **有时候需要将高版本的依赖降级到低版本，降级命令如下**：
```
yum downgrade <package_name>
```
- **删除软件包（保留配置文件）**：
```
sudo yum remove <package_name>
```
- **清除包（删除软件包及其配置文件）**：
```
sudo yum remove -y <package_name>
```
- **搜索包**：
```
yum search <package_name>
```
- **显示所有已经安装和可以安装的程序包**：
```
yum list
```
- **显示特定安装包信息，包括包名、版本和仓库名**：
```
yum list <package_name>
```
- **列出已安装的软件包**：
```
yum list installed
```
- **列出可升级的软件包**：
```
yum list updates
```
- **查询所有的yum仓库**：
```
yum list repolist all
```
- **检查包裹详细信息**：
```
yum info <package_name>
```
- **显示程序组group信息**：
```
yum groupinfo <group_name>
```
- **清理未使用的依赖项**：
```
sudo yum clean all
```
- **清除缓存目录下的软件包，清空的是 /var/cache/yum 下的缓存**：
```
yum clean packages
```
- **清除缓存目录下的 headers**：
```
yum clean headers
```
- **清除缓存目录下旧的 headers**：
```
yum clean oldheaders
```
- **更新单个软件包**：
```
sudo yum update <package_name>
```
- **下载软件包而不安装**：
```
sudo yum install --downloadonly --downloaddir=/path/to/download/directory <package_name>
```
- **检查损坏的依赖关系**：
```
yum check
```
- **查找包提供程序**：
```
sudo yum provides <keyword>
```
- **检查包依赖关系**：
```
sudo yum deplist <package_name>
```
- **安装本地软件包文件**：
```
sudo yum localinstall /path/to/your_package.rpm
```


### 软件包组管理命令列表
- **安装软件包组**：
```
sudo yum groupinstall <group_name>
```
- **卸载软件包组**：
```
sudo yum groupremove <group_name>
```
- **列出已安装的软件包组**：
```
yum grouplist installed
```
- **列出特定软件包组的信息**：
```
yum grouplist <group_name>
```
- **查看软件包组信息**：
```
yum groupinfo <group_name>
```
