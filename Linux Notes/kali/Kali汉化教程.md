# Kali汉化教程

## Kali Linux语言设置成中文

### 一、更新软件包列表
- 打开Kali Linux的终端。  
- 输入以下命令来更新软件包列表：  
```
sudo apt-get update
```

### 二、安装语言包
- 输入以下命令来安装locales包：  
```
sudo apt-get install -y locales
```

### 三、配置语言环境
- 输入以下命令来配置语言环境：  
```
sudo dpkg-reconfigure locales
```
- 在出现的语言选择界面中，找到并选择“中文（简体）”，对应的编码为zh_CN.UTF-8。通常通过空格键来选择，然后按回车键确认  
![3d711d833c414012994e734503e76dd5](https://github.com/user-attachments/assets/218066b8-1113-4d5e-b28b-ce0caf957986)

### 四、设置系统语言
- 编辑系统语言设置文件，输入以下命令：
```
sudo vim /etc/default/locale
```
- 在打开的文件中，将LANG变量的值设置为zh_CN.UTF-8，如下所示：
```
LANG="zh_CN.UTF-8"
```
![61896ffdf0f64b14bd1fd8e91bbe3243](https://github.com/user-attachments/assets/c04d087e-7b1d-4245-b09d-404a89876899)  

- 保存并关闭文件

### 五、安装中文字体
- 输入以下命令来安装一种流行的中文字体，如文泉驿正黑字体
```
sudo apt-get install fonts-wqy-zenhei
```

### 六、重启系统
- 输入以下命令来重启系统，以使更改生效：
```
sudo reboot
```
![59eb0a30911f4126b288ad2109c0903a](https://github.com/user-attachments/assets/fa572e74-a440-45da-97d3-843bfee0634e)  

### 七、安装中文输入法
- 如果需要输入中文，可以安装中文输入法。例如，安装Fcitx或IBus输入法框架  
  - 安装Fcitx的命令是：  
  ```
  sudo apt-get install fcitx fcitx-googlepinyin
  ```
  - 安装IBus的命令是：
  ```
  sudo apt-get install ibus ibus-pinyin
  ```
- 安装完输入法后，通过系统设置中的“区域和语言”部分进行配置  
![99ed7c4a94b24dc98f9085362715ab5c](https://github.com/user-attachments/assets/94e2c412-77ab-4c9f-935e-a9c46169d90b)  

在配置工具中，你还可以设置切换输入法的快捷键。通常，默认的快捷键是 `Ctrl+空格` 或 `Super+空格`（Super键即Windows键），但你可以根据自己的习惯进行修改  
完成以上步骤后，Kali Linux的系统界面、终端以及应用程序等应该都会显示为简体中文，同时你也可以使用中文输入法进行文字输入  
![4317c1bfdace48dfa334dd36906e31dc](https://github.com/user-attachments/assets/ce9228a7-dd0a-4c55-b5a9-9f25156c7917)  

### 更换软件包源
- 查看自己内核信息，内核版本太低需要的源不用
```
uname -a
```
- 进入配置文件配置镜像源
```
vim /etc/apt/sources.list
```
- 使用命令更新同步源的索引，升级软件包
```
apt-get update && apt-get upgrade
```

### Kali Linux中英文切换
- Kali linux默认为英语，可以执行以下命令切换为中文：  
```
echo LANG="zh_CN.UTF-8" > /etc/default/locale
```
切换好，执行重启即可  
```
sudo reboot
```
同理，切换为英文  
```
echo LANG="en_US.UTF-8" > /etc/default/locale
```
切换好，执行重启即可  
```
sudo reboot
```
建议中英文分别创建一个快照  
