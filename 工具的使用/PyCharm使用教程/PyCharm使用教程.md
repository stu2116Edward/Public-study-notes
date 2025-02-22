# PyCharm使用教程

### PyCharm默认语言配置
将Pycharm默认语言为中文/英文：
打开Pycharm系统设置，点击File -> Settings -> Appearance & Behavior -> System Settings -> Language and Region 进行操作，在右侧Language中选择中文/英文  
点击【Apply】之后会弹出弹窗询问是否重启Pycharm以应用设置，根据实际情况选择即可  

### 配置python解释器
1. 打开Pycharm，点击File -> Settings -> Project:当前项目的名称 -> Python Interpreter
2. 点击右上角齿轮，点击Add
3. 选择Existing environment，点击...，选择python.exe的路径
4. 点击OK，完成配置

### 安装第三方库
1. 打开Pycharm，点击File -> Settings -> Project:当前项目的名称 -> Python Interpreter
2. 点击右上角+号，搜索需要的库，点击Install Package
3. 等待安装完成

### 创建虚拟环境
**创建venv虚拟环境：**
> [!Note]  
说明：venv虚拟环境是在当前项目中创建的，与实体环境是隔离的，不会影响实体环境中的库  
1. 打开Pycharm，点击File -> Settings -> Project:当前项目的名称 -> Python Interpreter
2. 点击右上角齿轮，点击Add
3. 选择Virtualenv Environment，点击...，选择本地的实体环境来创建venv虚拟环境`E:\Python\python.exe`(根据实际情况选择)
4. 点击OK，完成配置

**创建conda虚拟环境：**  
> [!Note]  
说明：conda虚拟环境是在全局环境中创建的，与venv虚拟环境是隔离的，不会影响venv虚拟环境中的库  
1. 打开Pycharm，点击File -> Settings -> Project:当前项目的名称 -> Python Interpreter
2. 点击右上角齿轮，点击Add
3. 选择Conda Environment，点击...，选择conda环境的路径`E:/Anaconda/envs/tensorflow/python.exe`(根据实际情况选择)
4. 点击OK，完成配置

![PycharmConda1](https://github.com/user-attachments/assets/6d6fbd3d-f47b-4f9f-908c-6e1a62566b8c)  
![PycharmConda2](https://github.com/user-attachments/assets/9f0c36ef-ea81-499f-a656-58f347698111)  
