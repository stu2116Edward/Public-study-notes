# Sqlmap封装教程

把sqlmap的代码封装成一个sqlmap.exe文件然后再用cmd运行sqlmap.exe文件  

### 准备工作：
Anaconda: https://www.anaconda.com/download  
Sqlmap下载链接：https://sqlmap.org/  

在conda虚拟环境中安装`pyinstaller`本地环境可能会失败  
```
conda env list
conda activate tensorflow
pip install pyinstaller
```

首先进入到已经下载的sqlmap解压过后的目录里面


输入cmd打开cmd命令框，路径为本路径(win+R健要转到本路径)


直接输入
```
pyinstaller -F sqlmap.py
```
等待它打包完成后这时我们找到打包后在dist目录里面exe文件，运行会报错  



一般运行错误都为找不到文件


解决办法:  
解决参考：新建`hook-thirdparty.py`文件,写入内容如下:
```py
from PyInstaller.utils.hooks import collect_data_files
datas = collect_data_files("thirdparty")
```
保存后将此py文件放入`Pyinstaller`下的`hooks`的文件夹中(路径为你安装python的路径)


conda中的路径参考：`E:\ProgramData\anaconda3\envs\tensorflow\Lib\site-packages\PyInstaller\hooks\hook-thirdparty.py`

再次运行sqlmap.exe报错


解决办法：
在cmd命令框再次输入语句打包  
```
pyinstaller -F -p data/;lib/;extra/;plugins/;tamper/;thirdparty/; sqlmap.py --hidden-import lib.utils.versioncheck
```


再次运行sqlmap.exe报错

解决办法：

将sqlmap下的lib目录与data目录移动至dist\sqlmap.exe下同级目录下。
由于不知道到底有多少依赖,建议将sqlmap下所有目录都移动到sqlmap.exe下。(不包括 pycache、build、dist目录)

成功运行


这时候运行还是要用cmd命令框再运行sqlmap.exe文件，所以用python写了个简单的调用
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

文件目录结构

