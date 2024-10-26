在可视化的Ubuntu或者Redhat等操作系统中无法使用快捷键打开终端窗口的解决方法  
在右上角电源处选择设置  
点击键盘  
名称自定义  
比如：Run a terminal  
add cmd：/usr/bin/gnome-terminal  
添加快捷方式：Ctrl + Shift + T  

常用于验证文件的完整性：  
查看当前文件夹下所有文件总大小  
du -sh  
查看当前文件夹下指定文件的大小  
du -sh 文件名  

查找文件所在位置：  
find <查找的起始路径> -name <要查找的文件名>  
查找当前目录下的test.txt文件示例：  
find ./ -name test.txt  

在文件内容中查找文本所在的行号：  
grep -n "文本内容" <文件名>  

查看文件内容  
cat -n 文件名  

在编辑器中显示行号  
vim 文件名  
:set nu  
