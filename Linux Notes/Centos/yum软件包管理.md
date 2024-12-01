# yum 命令列表：

软件包（Package）  
定义：软件包是Linux系统中最小的软件部署单元。它包含程序及其所有依赖项，用于执行特定任务。  
内容：一个软件包通常包含程序文件、库文件、配置文件和文档等。  
独立性：软件包是独立的，可以单独安装、升级或删除，而不影响系统中的其他软件包。  
依赖性：软件包在安装时会自动处理其依赖关系，确保所有必需的依赖软件包也被安装。  
管理：软件包可以通过yum或dnf等包管理器进行搜索、安装、升级、卸载等操作。  

软件包组（Package Group）  
定义：软件包组是一组功能相关的软件包的集合，它们通常用于完成一类特定的任务或应用场景。  
便利性：软件包组为用户提供了一种方便的方式来一次性安装多个相关的软件包，而不是单独安装每个软件包。  
示例：例如，"Development Tools" 软件包组可能包括编译器、调试器、库和其他开发工具。  
依赖性：安装一个软件包组时，包管理器会自动处理该组内所有软件包的依赖关系。  
管理：软件包组也可以通过包管理器进行安装、卸载等操作，但操作的是整个组，而不是单个软件包。  

### 软件包管理：  
1. 更新软件包列表：
```
sudo yum makecache
```

2. 安装新软件：
```
sudo yum install <package_name>
```

3. 升级所有软件包：
```
sudo yum update
```

4. 升级特定软件包：
```
sudo yum update <package_name>
```

5. 删除软件包（保留配置文件）：
```
sudo yum remove <package_name>
```

6. 清除包（删除软件包及其配置文件）：
```
sudo yum remove -y <package_name>
```

7. 搜索包：
```
yum search <package_name>
```

8. 列出已安装的软件包：
```
yum list installed
```

9. 检查包裹详细信息：
```
yum info <package_name>
```

10. 清理未使用的依赖项：
```
sudo yum clean all
```

11. 更新单个软件包：
```
sudo yum update <package_name>
```

12. 下载软件包而不安装：
```
sudo yum download <package_name>
```

13. 检查损坏的依赖关系：
```
yum check
```

14. 列出可升级的软件包：
```
yum list updates
```

15. 查找包提供程序：
```
yum whatprovides <keyword>
```

16. 检查包依赖关系：
```
yum deplist <package_name>
```

17. 安装本地软件包文件：
```
sudo yum localinstall /path/to/your_package.rpm
```

18. 列出所有已安装的软件包：
```
yum list installed
```

19. 查看软件包的详细信息（包括依赖关系、安装大小等）：
```
yum info <package_name>
```

20. 清理下载的.rpm包文件（这些文件通常存储在`/var/cache/yum/$basearch/$releasever`目录中）：
```
sudo yum clean all
```

### 软件包组管理：
21. 安装软件包组：
```
sudo yum groupinstall "Development Tools"
```

22. 列出已安装的软件包组：
```
yum grouplist installed
```
列出特定软件包组的信息：
```
yum grouplist "Development Tools"
```

23. 查看软件包组信息：
```
yum groupinfo "Development Tools"
```

24. 卸载软件包组：
```
sudo yum groupremove "Development Tools"
```
