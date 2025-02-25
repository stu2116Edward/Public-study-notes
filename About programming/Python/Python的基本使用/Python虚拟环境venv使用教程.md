# Python虚拟环境venv使用教程

### 1. 安装虚拟环境工具  
从 Python 3.3 开始，Python 自带了 venv 模块，无需额外安装。你可以直接使用它来创建虚拟环境  

### 2. 创建venv虚拟环境
这里我使用了 venv 来创建虚拟环境，并且命名为 venv，你也可以选择任何其他名称  
```
python -m venv .venv
```
这条命令会在当前目录下创建一个名为 .venv 的虚拟环境和文件夹  
如果你有多个 Python 版本，你可能需要指定 Python 版本，如 python3.8 或 python3.10，以确保使用正确的版本  

**查看虚拟环境文件**  
虚拟环境创建后，会在当前目录下生成一个名为 .venv 文件夹。里面包含了虚拟环境所需的文件和目录结构：  

- bin：包含虚拟环境的可执行文件（如 python）
- lib：包含虚拟环境的库文件
- include：包含用于编译 C 扩展模块的头文件
- Scripts（Windows）：包含 activate.bat 等脚本

### 3. 激活虚拟环境

在 Windows 上，你可以使用以下命令来激活虚拟环境：  
```
.\.venv\Scripts\activate
```
在 macOS 和 Linux 上，你可以使用以下命令来激活虚拟环境：  
```
source .venv/bin/activate
```
激活虚拟环境后，你的命令行提示符会显示虚拟环境的名称，如 (venv) $。这表示你现在正在使用虚拟环境，而不是系统默认的 Python 环境。  

### 4. 使用虚拟环境
当虚拟环境激活后，你可以在虚拟环境中安装和管理 Python 包。所有通过 pip 安装的包只会影响当前虚拟环境，而不会影响全局的 Python 安装  

**安装依赖包**  
你可以在虚拟环境中使用 pip 来安装你需要的依赖包：
```
pip install <package_name>
```

**查看安装的包**
你可以使用 pip list 查看虚拟环境中安装的所有包：
```
pip list
```

**卸载包**
如果你不再需要某个包，可以使用 pip uninstall 卸载它：
```
pip uninstall <package_name>
```

### 5. 生成 requirements.txt文件
requirements.txt 文件是记录项目依赖包的常见方式，通常用于分享和复现环境，你可以使用以下命令生成 requirements.txt 文件：
```
pip freeze > requirements.txt
```
这将会把虚拟环境中所有已安装的包及其版本号写入 requirements.txt 文件中。你可以使用以下命令来安装 requirements.txt 文件中列出的所有包：
```
pip install -r requirements.txt
```

### 6. 退出虚拟环境
当你完成工作后，可以通过以下命令退出虚拟环境：
```
deactivate
```
这将返回到系统默认的 Python 环境。

### 7. 删除虚拟环境
如果你不再需要某个虚拟环境，可以删除它。只需要删除包含虚拟环境的文件夹即可（通常是 .venv 文件夹）  
在 Linux 上，你可以使用以下命令删除虚拟环境：
```
rm -rf .venv
```
在 Windows 上，你可以使用以下命令删除虚拟环境：
```
rmdir /s /q .venv
```

### 8. 使用虚拟环境的好处
- 隔离依赖：每个项目都有自己的依赖包，避免版本冲突。
- 干净的工作环境：不同项目之间的库版本不会互相影响。
- 便于部署：通过 requirements.txt 文件，你可以轻松地为其他开发者或生产环境部署项目
