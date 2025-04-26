# Edge浏览器修改自动填充数据的方法

用户输入无论正确与否的数据都会被浏览器记录，自动填充时都会显示形成干扰，或其他诸如此类不完善的体验  
![edge_list_history](https://github.com/user-attachments/assets/428ae043-dc0e-4fa2-a35d-d05425e11b32)  
和Chrome浏览器不同Chrome浏览器可以通过快捷键`Shift + Delete`的方式删除但是目前的Edge无法实现该功能所以可以使用以下方法实现：

1. 在C盘找到Edge的本地数据目录，具体地址：
```
C:\Users\Admin\AppData\Local\Microsoft\Edge\User Data\Default
```
其中`Admin`代表电脑账号名，AppData是隐藏文件夹  

2. 在以上目录下找到一个名为**Web Data**的文件，`没有后缀名`；**关闭Edge浏览器并用任务管理器继续关闭Edge后台进程**，再将该文件重命名添加`.db`的后缀  

3. 使用Navicat此类数据库软件，建立SQLite连接并打开以上重命名后的`Web Data.db`的文件  

4. 打开数据库中名为`autofill`的表，这里面记录的就是详细的自动填充数据，其中value列就是被填充到文本框的具体数值，例如数字、地址、名称等；使用Navicat筛选功能就可以找到目标数值，根据需要修改或删除。其中最后一列的count，记录的是该数据被使用次数；例如使用自动填充时，直接在文本框用鼠标左键弹出的下拉框中是按这个count从高到低排列的  

5. 处理完毕后，关闭Navicat，**将Web Data.db重命名为Web Data**，重新打开Edge就可以继续使用  
