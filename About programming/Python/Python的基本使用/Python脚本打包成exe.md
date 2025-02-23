# Python脚本打包成可执行文件

### 1. 安装pyinstaller
输入以下命令：
```shell
pip install pyinstaller
```

### 2. Pyinstaller打包步骤
1、切换到我们脚本文件所在的目录  
项目结构：
<pre>
├── main.py
├── logo.ico
</pre>
2、执行打包命令
```
pyinstaller -F -w -i logo.ico main.py
```
打包完成后，生成的可执行文件将位于 **dist** 文件夹中  

### PyInstaller 参数详解：
**打包模式**  
| 选项                | 描述                                      |
|---------------------|-------------------------------------------|
| `-F, --onefile`     | 将所有内容打包成一个单独的可执行文件，方便分发 |
| `-D, --onedir`      | 生成一个包含可执行文件和依赖文件的文件夹（默认模式） |


**窗口模式**  
| 选项                | 描述                                      |
|---------------------|-------------------------------------------|
| `-w, --windowed`    | 隐藏命令行窗口，适用于 GUI 应用程序       |
| `-c, --console`     | 显示命令行窗口（默认行为）                |


### **文件和路径**  
| 选项                        | 描述                                      |
|-----------------------------|-------------------------------------------|
| `--add-data <source>:<dest>` | 添加额外的数据文件或目录到打包文件中。格式为 **源路径:目标路径** |
| `--add-binary <source>:<dest>` | 添加额外的二进制文件                       |
| `--distpath <DIR>`          | 指定生成的可执行文件存放目录（dist目录）   |
| `--workpath <DIR>`          | 指定打包过程中的临时工作目录（build目录）  |
| `--specpath <DIR>`          | 指定 `.spec` 文件的生成路径                |

### **其他选项**  
| 选项                            | 描述                                      |
|---------------------------------|-------------------------------------------|
| `-h`                            | 显示帮助信息                              |
| `-v`                            | 显示版本号                                |
| `-n, --name <NAME>`             | 指定生成的可执行文件名称                   |
| `-i, --icon <FILE>`             | 为可执行文件设置图标（Windows 下需要 `.ico` 格式） |
| `--hidden-import <MODULENAME>`  | 添加未被代码直接引用的模块                 |
| `--exclude-module <MODULENAME>` | 排除某些模块                               |
| `--upx-dir <DIR>`               | 指定 UPX 压缩工具路径，用于减小可执行文件体积 |
| `--clean`                       | 清理 PyInstaller 的临时文件和缓存，确保干净的构建环境 |
| `--noconfirm`                   | 不提示确认，直接覆盖输出目录（如果已存在） |
| `--log-level <LEVEL>`           | 设置日志级别（如 `DEBUG`, `INFO`, `WARN`, `ERROR`） |

**示例**
生成单文件可执行文件并设置图标：
```
pyinstaller -F -i icon.ico main.py
```
生成GUI可执行文件并设置图标：
```
pyinstaller -F -w -i icon.ico main.py
```
添加程序内部logo:
```
pyinstaller -F -w -i favicon.ico main.py --add-data "logo.ico;."
```
分号左边的logo.ico 是源路径，表示要打包的文件是当前目录下的 logo.ico 文件  
分号右边的. 是目标路径，表示 logo.ico 文件会被放置在可执行文件的 根目录 下  

**综合使用多个参数的命令示例：**
```
pyinstaller -F -w -n "MyApp" -i "icon.ico" -a "data.txt:." -p "dist/output" -H "module1" main.py
```
