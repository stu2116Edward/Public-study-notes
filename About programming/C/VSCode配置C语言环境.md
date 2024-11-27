# VSCode配置C语言环境

## 下载安装VSCode
下载地址：https://code.visualstudio.com/  

## 安装MinGW
下载地址：https://github.com/niXman/mingw-builds-binaries/releases  
我的是windows x64位的系统所以下的是`x86_64-14.2.0-release-win32-seh-ucrt-rt_v12-rev0.7z`
i686开头的是x86位，x86_64开头的是x64位，根据自己系统选择下载  

这是我的安装目录`E:\mingw64\bin`

查看自己的includepath路径,在cmd下输入:
```
gcc -v -E -x c++ -
```

## 配置调试功能
首先在一个你希望的位置建一个文件夹，随意起名就可以（注意`不可以用中文！`），以后的C/C++代码文件都要放在这个文件夹里才可以正常调试  
然后进入VSCode,点击`Open Folder`或者点击左上角`File -> Open Folder`，然后打开刚刚建的文件夹，选择信任父级文件夹  
点击这个图标新建一个文件夹，命名为`.vscode`（注意必须是这个名字！）  
![vc1](https://github.com/user-attachments/assets/03bb30f2-4612-46f5-82e0-1ae407772518)  
![vc2](https://github.com/user-attachments/assets/cf841f15-3f62-4a5b-ac81-8d266e74066d)  

创建完成后再点击这个图标新建四个文件，文件名分别是:  
```
c_cpp_properties.json
```
```
launch.json
```
```
settings.json
```
```
tasks.json
```
![vc3](https://github.com/user-attachments/assets/9a1d9e1d-3056-4fad-9347-1f525ff2affb)  

接下来复制粘贴这四个文件的内容:  

### 首先是c_cpp_properties.json
注意这里要修改为你的g++.exe文件路径
```json
{
  "configurations": [
    {
      "name": "Win64",
      "includePath": ["${workspaceFolder}/**"],
      "defines": ["_DEBUG", "UNICODE", "_UNICODE"],
      "windowsSdkVersion": "10.0.18362.0",
      "compilerPath": "E:\\mingw64\\bin\\g++.exe",
      "cStandard": "c17",
      "cppStandard": "c++17",
      "intelliSenseMode": "gcc-x64"
    }
  ],
  "version": 4
}
```
注意`compilerPath`这一项要把路径改成刚才`g++的安装路径`：找到`mingw64`的安装文件夹`->mingw64->bin->g++.exe` ,然后复制或者手动把`g++.exe`的路径敲上去，格式要跟上面代码段一样  

### 然后是launch.json
注意这里要修改为你的gdb.exe文件路径
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "(gdb) Launch", 
      "type": "cppdbg", 
      "request": "launch", 
      "program": "${fileDirname}\\${fileBasenameNoExtension}.exe", 
      "args": [], 
      "stopAtEntry": false,
      "cwd": "${workspaceRoot}",
      "environment": [],
      "externalConsole": true, 
      "MIMode": "gdb",
      "miDebuggerPath": "E:\\mingw64\\bin\\gdb.exe",
      "preLaunchTask": "g++",
      "setupCommands": [
        {
          "description": "Enable pretty-printing for gdb",
          "text": "-enable-pretty-printing",
          "ignoreFailures": true
        }
      ]
    }
  ]
}
```
注意`miDebuggerPath`这一项也要把路径改成刚才`gdb的安装路径`：找到刚刚的安装文件夹`->mingw64->bin->gdb.exe` ,然后复制或者手动把`gdb.exe`的路径敲上去，格式要跟上面代码段一样  

### 接下来是settings.json
这里无需修改直接复制粘贴
```json
{
  "files.associations": {
    "*.py": "python",
    "iostream": "cpp",
    "*.tcc": "cpp",
    "string": "cpp",
    "unordered_map": "cpp",
    "vector": "cpp",
    "ostream": "cpp",
    "new": "cpp",
    "typeinfo": "cpp",
    "deque": "cpp",
    "initializer_list": "cpp",
    "iosfwd": "cpp",
    "fstream": "cpp",
    "sstream": "cpp",
    "map": "c",
    "stdio.h": "c",
    "algorithm": "cpp",
    "atomic": "cpp",
    "bit": "cpp",
    "cctype": "cpp",
    "clocale": "cpp",
    "cmath": "cpp",
    "compare": "cpp",
    "concepts": "cpp",
    "cstddef": "cpp",
    "cstdint": "cpp",
    "cstdio": "cpp",
    "cstdlib": "cpp",
    "cstring": "cpp",
    "ctime": "cpp",
    "cwchar": "cpp",
    "exception": "cpp",
    "ios": "cpp",
    "istream": "cpp",
    "iterator": "cpp",
    "limits": "cpp",
    "memory": "cpp",
    "random": "cpp",
    "set": "cpp",
    "stack": "cpp",
    "stdexcept": "cpp",
    "streambuf": "cpp",
    "system_error": "cpp",
    "tuple": "cpp",
    "type_traits": "cpp",
    "utility": "cpp",
    "xfacet": "cpp",
    "xiosbase": "cpp",
    "xlocale": "cpp",
    "xlocinfo": "cpp",
    "xlocnum": "cpp",
    "xmemory": "cpp",
    "xstddef": "cpp",
    "xstring": "cpp",
    "xtr1common": "cpp",
    "xtree": "cpp",
    "xutility": "cpp",
    "stdlib.h": "c",
    "string.h": "c"
  },
  "editor.suggest.snippetsPreventQuickSuggestions": false,
  "aiXcoder.showTrayIcon": true
}
```

### 最后是tasks.json
这里无需修改直接复制粘贴
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "g++",
      "command": "g++",
      "args": [
        "-g",
        "${file}",
        "-o",
        "${fileDirname}/${fileBasenameNoExtension}.exe"
      ],
      "problemMatcher": {
        "owner": "cpp",
        "fileLocation": ["relative", "${workspaceRoot}"],
        "pattern": {
          "regexp": "^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$",
          "file": 1,
          "line": 2,
          "column": 3,
          "severity": 4,
          "message": 5
        }
      },
      "group": {
        "kind": "build",
        "isDefault": true
      }
    }
  ]
}
```
保存这四个文件就配置完成了！  

**再次强调：以后的C/C++代码文件必须放在这个Code文件夹里，或者说有.vscode文件夹的文件夹里，如果调试放在其他位置的代码文件会报错！**

如果上述流程你都完成了，那么现在你已经可以新建一个.c或者.cpp文件写代码测试一下你刚刚配置好的VSCode啦！（注意文件名也不能用中文！）

## 其他事项
### 1.中文显示乱码  
首先点击左下角的齿轮按钮，打开Settings（设置）  
![vc4](https://github.com/user-attachments/assets/52f23938-737c-4cae-a4bc-452dd4ed5d2c)  

打开设置搜索框快捷键：`Ctrl+,`  
在搜索框中输入`Encoding`,然后如图把Encoding`改成GBK`(原来应该是UTF-8)  
![vc5](https://github.com/user-attachments/assets/8341cb22-a2ee-49e5-9af7-b2636596c5a1)  

设置完之后编辑有中文的文件就不会显示乱码啦！  

### 2.在终端中运行
如果不喜欢每次都弹出一个小黑框的话，可以选择在终端中运行，效果如图  
![vc6](https://github.com/user-attachments/assets/36564c8c-8b29-43e1-8cbc-b2eae094834b)  

这个设置也很简单，打开设置，搜索`run in terminal`,找到这个选项打勾就可以啦  
![vc7](https://github.com/user-attachments/assets/ef689ac3-8052-4801-b3d8-539eada3a47c)  

之后就可以点击右上角这个按钮在下面的终端运行/调试，或者按快捷键`Ctrl+Alt+N`运行  
注意在终端运行之前一定要先保存，否则运行的是保存之前代码（可以在File中勾选自动保存）  
![vc8](https://github.com/user-attachments/assets/4c55d1ef-50a7-477c-bc11-52c9a349bcbe)  

补充一点：  
这里可以使用快捷键 `Ctrl+Shift+D` 呼出  
![屏幕截图 2024-11-27 120401](https://github.com/user-attachments/assets/b1cd82ae-3281-4dc2-8bc6-c3af24db260b)  
如果按F5调试右下角显示 `"launch.json" 中缺少配置“C/C++: g++.exe 生成和调试活动文件”。`  
那就先使用`gdb`运行然后使用`C/C++`调试  

当然也依旧可以选择按F5使用小黑框进行运行调试的,但是两个进程是冲突的，只是多了一种选择，是不可以同时用的！比如我正在终端运行代码的时候，再按F5调试代码就会出错  

### 3.调试时显示“找不到g++”
首先检查一下是不是g++的安装路径或者文件名里面存在中文，如果存在中文需要把中文名改掉或者更换其他路径安装  

如果不存在中文的话，右键点击VSCode的图标，选择“属性”  
然后选择“兼容性”，勾选“以管理员身份运行此程序” ，然后依次点击“应用”，‘确定’即可（部分电脑需要选择这个选项）  
![vc9](https://github.com/user-attachments/assets/b0d4475f-99a8-48e3-bbdc-01e99c9a4bf8)  
