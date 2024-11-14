## CentOS 和 Red Hat .rpm 软件包管理

rpm 是 Red Hat 包管理器，用于管理 .rpm 软件包。CentOS 和 Red Hat 都使用 rpm 来处理 .rpm 文件。以下是 rpm 的一些常用命令：

1. **安装软件包**：
   ```
   sudo rpm -ivh <file name.rpm>...
   ```
   安装指定的 `.rpm` 软件包，可以指定一个或多个 `.rpm` 文件名进行安装。

2. **卸载软件包**（保留配置文件）：
   ```
   sudo rpm -e <package>...
   ```

3. **完全卸载软件包**（包括配置文件）：
   ```
   sudo rpm -e --nodeps <package>...
   ```

4. **列出已安装的软件包及其版本信息**：
   ```
   rpm -qa [<pattern>...]
   ```

5. **显示指定软件包的状态信息**：
   ```
   rpm -qi <package>...
   ```

6. **列出软件包的文件**：
   ```
   rpm -ql <package>...
   ```

7. **验证软件包的完整性**：
   ```
   rpm -V <package>...
   ```

8. **根据文件名查询所属的软件包**：
   ```
   rpm -qf <filename>...
   ```

9. **配置软件包**：
   ```
   sudo rpm -Uvh <file name.rpm>...
   ```
   用于升级软件包，如果软件包尚未安装，则会进行安装。

10. **显示当前已安装的软件包列表**：
    ```
    rpm -qa
    ```

11. **删除软件包的 Available 信息**：
    ```
    rpm --rebuilddb
    ```
    重建 rpm 数据库，以确保所有软件包的元数据都是最新的  

12. **查找仅部分安装的软件包信息**：
    ```
    rpm -q --part <package>...
    ```

13. **比较同一个包的不同版本之间的差别**：
    ```
    rpm -q <package> --qf '%{VERSION}\n'
    ```
    这个命令用于显示软件包的版本信息，但不是比较不同版本之间的差别。比较版本通常需要手动进行或使用其他工具  

14. **显示帮助信息**：
    ```
    rpm --help
    ```

15. **显示 rpm 的 Licence**：
    ```
    rpm --showrc
    ```
    这个命令不正确，rpm 没有 --showrc 选项。如果您想查看 rpm 的许可证信息，可以使用 rpm --showrc 查看配置文件路径，但这不是许可证信息  
    
17. **显示 rpm 的版本号**：
    ```
    rpm --version
    ```
    
18. **建立一个 rpm 文件**：
    ```
    rpmbuild -ba <specfile>
    ```
    从 spec 文件构建 rpm 包。

19. **显示一个 Rpm 文件的目录**：
    ```
    rpm -qlp <filename>
    ```

20. **显示一个 Rpm 的说明**：
    ```
    rpm -qpi <filename>
    ```

21. **搜索 Rpm 包**：
    ```
    rpm -qa | grep <package-name-pattern>
    ```

22. **显示包含该软件包的所有目录**：
    ```
    rpm -ql <package>
    ```

23. **显示包的具体信息**：
    ```
    rpm -qi <package-name>
    ```
    
