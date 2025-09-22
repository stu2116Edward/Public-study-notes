# 解决EmEditor自动分隔导致卡顿或者崩溃

EmEditor在查看超过1G的文件时，一直都是首选工具，但是如果文件中存在`,` `;` `|`等特殊字符时，会默认触发工具的分隔功能，导致软件打开较慢或者崩溃。关闭如下选项可解决此问题：  

## 1.去掉CSV文件检测相关符号
**工具** -> **所以配置的属性** -> **文件**  
<img width="640" height="122" alt="emeditor_1" src="https://github.com/user-attachments/assets/71f7c776-ed43-44be-812b-5ab1a6d5cafa" />  
<img width="685" height="564" alt="emeditor_2" src="https://github.com/user-attachments/assets/4bca7165-f42d-489f-8029-2b59c9541914" />  

## 2.去掉自动切换到单元格选择模式
**工具** -> **自定义** -> **CSV**  
<img width="592" height="243" alt="emeditor_3" src="https://github.com/user-attachments/assets/eea7acec-baca-48f9-9945-08ab87567095" />  
<img width="686" height="710" alt="emeditor_4" src="https://github.com/user-attachments/assets/0dbbb1f1-388f-4543-8e4a-d45aefd23390" />  
