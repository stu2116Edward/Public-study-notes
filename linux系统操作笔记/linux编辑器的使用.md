vim 编辑器  
启动 Vim  
打开文件：vim filename  
创建新文件：vim newfile  


命令模式（Normal Mode）  
这是 Vim 的默认模式，用于执行命令。  
移动光标：h（左移），j（下移），k（上移），l（右移）  
移动到首部：gg  
移动到尾部：G  

插入模式（Insert Mode）  
插入文本：按 i 进入插入模式，在光标前插入文本  
追加文本：按 a 进入插入模式，在光标后追加文本  
打开新的一行：按 o 在当前行下方打开新行  
替换模式：按 R 进入替换模式，逐字符替换  

编辑文本  
删除字符：x（删除光标下的字符）  
删除整行：dd（删除光标所在的行）  
复制粘贴：yy（复制光标所在的行），p（粘贴）  

查找替换  
查找文本：/pattern（向下查找），?pattern（向上查找）  
替换文本：:%s/old/new/g（替换所有匹配的文本）  

保存退出  
保存文件：:w  
保存并退出：:wq 或 ZZ  
退出不保存：:q!  

设置选项  
设置行号显示：:set number  
设置自动缩进：:set autoindent  

高级编辑  
撤销：u  
重做：Ctrl + r  
跳转到行：:123（跳转到文件的第123行）  

窗口分割  
水平分割：:split  
垂直分割：:vsplit  

宏录制  
录制宏：q<register>（开始录制），q（结束录制）  
执行宏：@<register>  

Vi 编辑器  
Vi 是 Vim 的前身，它的功能较少，但基本原理与 Vim 相同。  

Nano 编辑器  
Nano 是一个简单易用的文本编辑器，适合初学者。  

启动 Nano  
打开文件：nano filename  
创建新文件：nano newfile  

基本操作  
移动光标：使用箭头键  
退出：按 Ctrl + X，然后按 Y 保存更改，按 N 不保存。  

编辑文本  
插入文本：直接键入即可  
删除字符：Backspace  
删除整行：Ctrl + U  

查找文本：按 Ctrl + W，输入搜索内容  
替换文本：按 Ctrl + ^，输入搜索内容和替换内容  

查看帮助：按 Ctrl + G  
 
保存文件：按 Ctrl + O，然后按 Enter 确认文件名  
  
退出 Nano：按 Ctrl + X  
