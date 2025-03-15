# Windows开启SMB文件共享

## 安装SMB服务
1. 打开控制面板  
![smb1](https://github.com/user-attachments/assets/33fe64b7-9c79-4ccd-a98f-52868226e066)  

2. 打开程序和功能  
![smb2](https://github.com/user-attachments/assets/cb86f83f-4be8-443f-9917-c46e719d2e1f)  

3. 启用或关闭Windows功能  
![smb3](https://github.com/user-attachments/assets/d4cd7e67-8fdf-4be1-86b0-5a1e72d12e54)  

4. 找到SMB 1.0/CIFS文件共享支持，并勾选  
![smb4](https://github.com/user-attachments/assets/1c94415f-7348-446c-9ad2-3b3fd4fa6217)  

点击确定，等待**安装完成后并重启**  


## 开启SMB文件共享

1. 右击文件选择**属性**,选择**共享**  
![smb5](https://github.com/user-attachments/assets/85657c13-726c-4eed-a50d-18ef2e6d562c)  

**点击共享**  

2. 添加可共享的用户  
![smb6](https://github.com/user-attachments/assets/37e54183-7afa-47ef-aa25-821d1cb22656)

3. 配置 everyone 用户，表示任何人都可以访问这个文件夹  
![smb7](https://github.com/user-attachments/assets/5ebd4d57-c32f-4e99-af16-0a54f176161b)  

4. 赋予相应权限，点击共享  
![smb8](https://github.com/user-attachments/assets/24cc8757-84d7-424a-b429-6d9eb2ef2291)  

完成共享  


## 在另一台电脑上进行访问
1. 首先需要知道这台开启SMB共享电脑的ip地址或者主机名  
2. 输入:`\\ip地址`  
![smb9](https://github.com/user-attachments/assets/03b82f64-76d0-42bd-87f7-c2463615e31b)  
![smb10](https://github.com/user-attachments/assets/ca70ffbf-754d-42d4-937c-0dbf0ee58921)  

3. 输入用户名和密码(如果开启密码的话)  
![smb11](https://github.com/user-attachments/assets/97fe0ae7-c8bf-4359-8f46-140c845342a9)  


## 配置无需用户名和密码访问
1. 找到共享文件夹 右击属性选择共享，点击网络和共享中心：  
![smb12](https://github.com/user-attachments/assets/d6fcd8d5-1498-4df8-9379-4c1c476a719b)  

2. 找到密码保护的共享，选择无密码保护的共享  
![smb13](https://github.com/user-attachments/assets/1f339ef5-4942-41a8-b694-ed9371de0035)  

3. 输入:`\\ip地址`，接下来访问就不需要用户名和密码了  
![smb14](https://github.com/user-attachments/assets/8ceb3c0e-da92-4cf6-841b-14c6f928bd97)  
