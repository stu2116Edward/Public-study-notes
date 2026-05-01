### 关于MobaXterm的tab键无法补齐和回车键无法使用

使用文本编辑器编辑 `MobaXterm.ini`  
新增如下内容：
```
[MottyOptions]
localEcho=1
LocalEdit=1
```
重启即可恢复