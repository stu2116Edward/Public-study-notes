# 基本 Conda 命令

1. **查看 Conda 版本和配置信息**：
```bash
conda --version
conda config --show-sources
conda info
```
- `conda --version` 显示当前安装的 Conda 版本。
- `conda config --show-sources` 显示 Conda 配置文件的位置。
- `conda info` 提供有关当前 Conda 安装的详细信息，包括环境和包的信息。

2. **初始化 Conda**：
```bash
conda init
```
- `conda init` 初始化 Conda，使其能够在新的命令行会话中使用。这通常在安装 Anaconda 后自动完成，但有时可能需要手动运行。

### 环境管理

3. **列出所有 Conda 环境**：
```bash
conda env list
conda info --envs
```
- 这两个命令都会列出所有已创建的 Conda 环境及其路径。

4. **创建新的环境**：
```bash
conda create -n <env_name> python=3.8
```
- 创建一个名为 `env_name` 的新环境，并指定 Python 版本为 3.8。

5. **激活环境**：
```bash
conda activate <env_name>
```
- 激活名为 `env_name` 的环境。

6. **退出当前环境**：
```bash
conda deactivate
```
- 退出当前激活的 Conda 环境。

7. **删除环境**：
```bash
conda env remove -n <env_name>
```
- 删除名为 `env_name` 的环境。

8. **更新环境**：
```bash
conda update --all
conda update <package_name>
```
- 更新所有已安装的包。
- 更新指定的包 `package_name`。

9. **克隆环境**：
```bash
conda create --name <new_env_name> --clone <env_name>
```
- 克隆名为 `env_name` 的环境，并创建一个名为 `new_env_name` 的新环境。

### 包管理

10. **搜索包**：
 ```bash
 conda search <package_name>
 ```
 - 在 Conda 仓库中搜索 `package_name`。

11. **安装包**：
 ```bash
 conda install <package_name>
 conda install <package_name>=version
 ```
 - 安装 `package_name`。
 - 安装特定版本的 `package_name`。

12. **卸载包**：
 ```bash
 conda remove <package_name>
 ```
 - 从当前激活的环境中卸载 `package_name`。

13. **列出环境中的包**：
 ```bash
 conda list
 ```
 - 列出当前激活环境中安装的所有包及其版本。

### 更新和配置

14. **更新 Conda**：
 ```bash
 conda update conda
 ```
 - 更新 Conda 本身到最新版本。

15. **配置 Conda**：
 ```bash
 conda config --add channels <channel_name>
 conda config --remove channels <channel_name>
 ```
 - 添加一个新的通道 `channel_name` 到 Conda 配置。
 - 从 Conda 配置中移除一个通道 `channel_name`。

16. **查看 Conda 配置**：
```bash
conda config --show
```
- 显示当前 Conda 配置的所有设置。

### 环境管理
**备份和导入环境**  
17. **导出环境**：  
```bash
conda env export > environment.yml
```
- 将当前环境的配置导出到 `environment.yml` 文件中。

18. **导入环境**：
```bash
conda env create -f environment.yml
```
- 从 `environment.yml` 文件中创建一个新的环境。

#### 查看环境中的解释器：
这里使用 Python 解释器做演示
<pre>
C:\Users\Admin>conda env list
# conda environments:
#
tensorflow               C:\Users\Admin\.conda\envs\tensorflow
base                     E:\Anaconda
</pre>
激活环境:
```bash
conda activate base
```
查看 Python 解释器的位置:  
**在 Unix/Linux/macOS 上**
```bash
which python
```
**在 Windows 上**
```bash
where python
```
查看当前环境下的解释器版本
```bash
python --version
```

### 包管理

19. **查找可更新的包**：
```bash
conda update --all --dry-run
```
- 查找当前环境中可更新的包。

20. **清理未使用的包**：
```bash
conda clean --all
```
- 清理所有未使用的包，包括缓存和不再需要的包。

### 更新和配置

21. **查看 Conda 仓库中的包**：
```bash
conda search --info <package_name>
```
- 查看 Conda 仓库中 `package_name` 的详细信息。

22. **设置 Conda 仓库通道**：
```bash
conda config --set channel_priority <strict|flexible|disabled>
```
- 这个命令用于设置通道优先级，其中 <strict|flexible|disabled> 是一个占位符，您需要用 strict、flexible 或 disabled 中的一个替换它来设置通道优先级的行为  

### 高级操作

23. **查看环境变量**：
```bash
conda env config vars list
```
- 查看当前环境的环境变量。

24. **查看环境的活动通道**：
```bash
conda config --show channels
```
- 查看当前环境的活动通道。

25. **修复环境**：
```bash
conda env repair
```
- 修复损坏的环境。
