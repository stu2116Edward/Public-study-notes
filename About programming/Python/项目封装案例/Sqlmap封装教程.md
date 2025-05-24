# Sqlmap封装教程

把sqlmap的代码封装成一个sqlmap.exe文件然后再用cmd运行sqlmap.exe文件  

### 准备工作：
Anaconda：https://www.anaconda.com/download  
Sqlmap下载链接：https://sqlmap.org/  
Sqlmap GitHub：https://github.com/sqlmapproject/sqlmap/releases  
已经打包好的Sqlmap_v1.9：https://edwardhu.lanzouu.com/iTbxJ2x1dtsh

在conda虚拟环境中安装`pyinstaller`本地环境可能会失败  
```
conda env list
conda activate tensorflow
pip install pyinstaller
```

首先进入到已经下载的sqlmap解压过后的目录里面  
![Sqlmapfz1](https://github.com/user-attachments/assets/0e4de3f7-f13d-4c54-8e35-357747617bbf)  

输入cmd打开cmd命令框，路径为本路径(win+R健要转到本路径)  
![Sqlmapfz2](https://github.com/user-attachments/assets/07e809b0-0281-4933-a764-ceaf9ed5c69b)  

直接输入
```
pyinstaller -F sqlmap.py
```
![Sqlmapfz3](https://github.com/user-attachments/assets/087c26a1-bcbe-444b-a7e7-9c62e56234c3)  
等待它打包完成后这时我们找到打包后在dist目录里面exe文件，运行后会报错  
![Sqlmapfz4](https://github.com/user-attachments/assets/ef3cbc53-4992-4a34-bb1e-9e65306aa266)  
一般运行错误都为找不到文件  
![Sqlmapfz5](https://github.com/user-attachments/assets/685245ac-7170-4246-8b13-a900b96924e5)  

解决办法:  
解决参考：新建`hook-thirdparty.py`文件,写入内容如下:
```py
from PyInstaller.utils.hooks import collect_data_files
datas = collect_data_files("thirdparty")
```
保存后将此py文件放入`Pyinstaller`下的`hooks`的文件夹中(路径为你安装python的路径)  
![Sqlmapfz6](https://github.com/user-attachments/assets/21ddda09-27b3-4d23-9e12-0c7ad5f28877)  

conda中的路径参考：`E:\ProgramData\anaconda3\envs\tensorflow\Lib\site-packages\PyInstaller\hooks\hook-thirdparty.py`  

再次运行sqlmap.exe报错  
![Sqlmapfz7](https://github.com/user-attachments/assets/28d0a499-ccfe-4c46-ac38-0c08c58984f2)  


解决办法：
在cmd命令框再次输入语句打包  
```
pyinstaller -F -p data/;lib/;extra/;plugins/;tamper/;thirdparty/; sqlmap.py --hidden-import lib.utils.versioncheck
```
![Sqlmapfz8](https://github.com/user-attachments/assets/edd77c8c-6f15-495e-89b5-02ec2f0aeffb)  

再次运行sqlmap.exe报错  
![Sqlmapfz9](https://github.com/user-attachments/assets/85ce6bde-528f-48ec-954b-f80974d39fbf)  

解决办法：  
将sqlmap下的lib目录与data目录移动至dist\sqlmap.exe下同级目录下。  
由于不知道到底有多少依赖,建议将sqlmap下所有目录都移动到sqlmap.exe下。(不包括 pycache、build、dist目录)  
![Sqlmapfz10](https://github.com/user-attachments/assets/1ea20da4-8b0b-44a2-ae40-9f3ff48bb6a6)  

成功运行  
![Sqlmapfz11](https://github.com/user-attachments/assets/53e64ccf-1692-4f3b-bbab-3c155c59357e)  

这时候运行还是要用cmd命令框再运行sqlmap.exe文件，所以用python写了个简单的调用,创建`Run.py`文件内容如下：
```py
import os
import colorama
colorama.init(autoreset=True)
def mian():
    while True:
        try:
            print('\033[1;31m[root@Hacker~]# \033[0mSqlmap ', end='')
            run = input()
            c = '.\\dist\\sqlmap.exe ' + run + ' --output-dir=.\\dist\\output\\'
            os.system(c)

        except:
            pass
        continue

if __name__ == "__main__":
    mian()

```
打开cmd用pyinstaller打包：
```
pyinstaller -F Run.py
```
成功运行Run.exe  
![Sqlmapfz12](https://github.com/user-attachments/assets/318b5fef-7a45-4b6b-888d-6b4cc36bdff6)  

文件目录结构  
![Sqlmapfz13](https://github.com/user-attachments/assets/680c2004-ac4c-44e1-a4c8-e6d65939153b)  
![Sqlmapfz14](https://github.com/user-attachments/assets/80e25ee1-9f26-46e4-b9f7-9858b8faf98f)  
