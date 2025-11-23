# Emeditor 使用技巧

下载地址：https://edwardhu.lanzouu.com/b00uzmylaj  
密码：hgvj  

### 使用 Emeditor 删除文件中的空行
使用快捷键`Ctrl + H`替换  
勾选使用**正则表达式**  
查找中输入：
```
^[\s]*\n
```
或者
```
^[\t]*\n
```
- `^`：行首断言
- `[\s]`：`\s` 已包含所有空白字符（空格、TAB、回车、换页、VT 等）
- `[ \t]`：仅匹配空格（ASCII 32）或制表符（TAB，ASCII 9）
- `*`：前述字符出现 0 次或多次
- `\n`：换行符（LF，ASCII 10）

`^[\t]*\n`　→　只认**空格/TAB**构成的空白行  
`^[\s]*\n`　→　认**所有空白字符**构成的空白行

替换为**空**  
点击**替换全部**  

<img width="898" height="568" alt="Emeditor-rmkh" src="https://github.com/user-attachments/assets/9bd10156-6d0e-4530-a757-0747d958ef70" />  

