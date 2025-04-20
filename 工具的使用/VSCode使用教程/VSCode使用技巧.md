# VSCode使用技巧

## VSCode切换默认终端
***目的：切换终端的目的是为了切换特定的终端环境***  
**注意：Windows系统中首次安装VSCode时，默认终端为PowerShell（这里需要去微软商店里面自行下载），如果要切换为cmd，则需要进行以下操作：**  
**较方便的方法：**  
1. 在终端窗口处点击 + 号右边的 ﹀ 箭头，点击 选择默认配置文件  
![vs1](https://github.com/user-attachments/assets/960b0e98-a307-44ec-9247-5600256a8e91)  

2. 点击选择第二个 Command Prompt 即可切换 cmd 为默认终端  
![vs2](https://github.com/user-attachments/assets/af3cc79d-1a58-4c3e-8c20-04f2c8aeee7c)  

3. 切换完成  
![vs3](https://github.com/user-attachments/assets/10255fe6-b6f7-4276-9d94-5ed5e1e52b12)  


**较复杂的方法：**  
1. 这里选择打开 **命令面板** 的方式来切换  
鼠标右键任意 空白处 或 点击工具栏的 “查看” 按钮, 或者使用快捷键（ **Ctrl + Shift + P** ）打开命令面板  

2. 点击输入框输入 **select default profile** 即可找到 终端：选择默认配置文件 ，然后点击进入  

3. 点击选择 Command Prompt 即可切换 cmd 为默认终端  

4. 成功更换 cmd 为默认终端  

## VSCode如何配置Python环境
### 安装必要工具
确保已在系统中安装 [Python](https://www.python.org/downloads/)  
安装 VS Code 和 Python 扩展：  
**Ctrl + Shift + X** 打开市场，搜索并安装 Python 扩展


### 配置虚拟环境（可选）
如果你希望在虚拟环境中运行 Python 项目:  
虚拟环境可以使用在当前项目下创建的**本地虚拟环境venv**，也可以使用**全局的虚拟环境conda**  


### 选择Python解释器
1. 使用快捷键（ **Ctrl + Shift + P** ）打开 **命令面板**  
2. 输入 **Python: Select Interpreter** 即可找到 Python: Select Interpreter ，然后点击进入  
3. 选择你需要的解释器即可  


### 配置 launch.json（调试和运行）
如果需要自定义运行设置，可以配置 launch.json 文件：
1. 点击左侧 运行和调试 图标或 使用快捷键（ **Ctrl + Shift + D** ）打开调试视图  
2. 点击 创建一个 **launch.json** 文件  
3. 在配置文件中添加 Python 配置，例如：
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Python: Current File",
            "type": "python",
            "request": "launch",
            "program": "${file}",
            "console": "integratedTerminal",
            "env": {
                "PYTHONPATH": "${workspaceFolder}"
            }
        }
    ]
}

```
`program`: 指定运行的 Python 文件。
`console`: 设置为 `"integratedTerminal"`，以便在终端中查看输出。


### 选择默认的Python解释器路径
1. 打开 VS Code 的设置（**Ctrl+,**）
2. 搜索 **Python Default Interpreter Path**
3. 填写你需要的Python解释器路径，例如：`C:\Programs\Python\Python38\python.exe`


### 配置终端的默认环境
如果需要在终端运行特定环境：  
1. 打开 VS Code 的设置（**Ctrl+,**）  
2. 搜索 **Python Terminal Activate Environment**  
3. 勾选该选项，确保在终端中自动激活选择的 Python 解释器  


### 安装额外的Python依赖
前提是当前工作目录下有**requirements.txt**文件  
在项目目录下运行：
```
pip install -r requirements.txt
```
以安装项目依赖，确保环境完整


### 强迫症舒畅
如何关闭VScode粘性滚动预览,类似于 Excel 的冻结首行  
![gdyl1](https://github.com/user-attachments/assets/7dbe14c0-5a0f-47eb-b865-84b5e73487c6)  

按下快捷键**ctrl + ,** 输入 **sticky** 找到下面的选项然后取消勾选  
![gdyl2](https://github.com/user-attachments/assets/4acd01db-c5fa-4c74-afd3-dd762e8c2ef7)  


### 常用快捷方式
查询指定字符串：`Ctrl + F`  
查找并替换指定字符串：`Ctrl + H`,`Enter`替换单个,`Ctrl + Alt + Enter`替换全部  
向下复制当前行功能快捷键：`Shift + Alt + ↓`  
