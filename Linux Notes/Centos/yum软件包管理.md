# yum 命令列表：

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
   sudo yum remove <package_name>
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
    sudo yum check dependencies
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
    sudo yum localinstall ./my_package.rpm
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
    
