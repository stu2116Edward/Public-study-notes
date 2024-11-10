# Ubuntu 和 Debian .deb 软件包管理
dpkg的使用说明：  
dpkg 是 Debian 包管理器，用于管理 .deb 软件包。Ubuntu 是基于 Debian 的，因此也使用 dpkg 来处理 .deb 文件  
dpkg 主要用于安装、卸载和管理 .deb 文件。它不处理软件包的依赖关系，如果需要处理依赖关系，通常会使用 apt 或 apt-get 命令  

1. **安装软件包**：
   ```
   dpkg -i <file name.deb>...
   ```
   安装指定的 `.deb` 软件包，可以指定一个或多个 `.deb` 文件名进行安装

2. **卸载软件包**（保留配置文件）：
   ```
   dpkg -r <package>...
   ```
3. **完全卸载软件包**（包括配置文件）：
   ```
   dpkg -P <package>...
   ```
4. **列出已安装的软件包及其版本信息**：
   ```
   dpkg -l [<pattern>...]
   ```
5. **显示指定软件包的状态信息**：
   ```
   dpkg -s <package>...
   ```
6. **列出软件包的文件**：
   ```
   dpkg -L <package>...
   ```
7. **验证软件包的完整性**：
   ```
   dpkg -V [<package>...]
   ```
8. **根据文件名查询所属的软件包**：
   ```
   dpkg -S <filename_pattern>...
   ```
9. **配置软件包**：
   ```
   dpkg --configure <package>...
   ```
10. **显示当前已安装的软件包列表**：
    ```
    dpkg --get-selections [<pattern>...]
    ```
11. **删除软件包的 Available 信息**：
    ```
    dpkg --clear-avail
    ```
12. **查找仅部分安装的软件包信息**：
    ```
    dpkg -C
    ```
13. **比较同一个包的不同版本之间的差别**：
    ```
    dpkg --compare-versions <ver1> <op> <ver2>
    ```
14. **显示帮助信息**：
    ```
    dpkg --help
    ```
15. **显示 dpkg 的 Licence**：
    ```
    dpkg --licence
    ```
16. **显示 dpkg 的版本号**：
    ```
    dpkg --version
    ```
17. **建立一个 deb 文件**：
    ```
    dpkg -b directory [<filename>]
    ```
18. **显示一个 Deb 文件的目录**：
    ```
    dpkg -c <filename>
    ```
19. **显示一个 Deb 的说明**：
    ```
    dpkg -I <filename> [<control-file>]
    ```
20. **搜索 Deb 包**：
    ```
    dpkg -l <package-name-pattern>
    ```
21. **显示包含该软件包的所有目录**：
    ```
    dpkg -S <filename-search-pattern>
    ```
22. **显示包的具体信息**：
    ```
    dpkg -p <package-name>
    ```
