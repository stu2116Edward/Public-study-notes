# kali 配置NAT模式网卡连外网

## 1.打开终端，输入ipconfig，发现没有地址  
![1](https://github.com/user-attachments/assets/b15d26c8-a92b-40dd-a80a-c9948dc0dec2)

## 2.打开虚拟网卡配置  
![2](https://github.com/user-attachments/assets/16b8824c-a5d2-494e-aa0d-62bd94ef7ccb)  
![3](https://github.com/user-attachments/assets/bb6863f2-6284-4814-b822-e06718515b66)  
![4](https://github.com/user-attachments/assets/109352a7-6554-41a8-8e2c-6d29705c5a80)  
![5](https://github.com/user-attachments/assets/8d625d24-1a57-41d2-811b-3211a4f2d1b1)  
![6](https://github.com/user-attachments/assets/b2f0a28f-99a6-459d-96a2-d3da9d48878b)  

## 3.打开本地VMnet8设置  
![7](https://github.com/user-attachments/assets/c789bab2-90b7-4259-b319-b846d10772a5)  
![8](https://github.com/user-attachments/assets/f41db619-035a-4820-a119-01cc7fc0a8d8)  
![9](https://github.com/user-attachments/assets/b9e9714b-64ed-4f4f-9c80-48cf2e6bd8c0)  
![10](https://github.com/user-attachments/assets/507efd74-0298-44d1-95da-8d715e0c7424)  
保存退出。  


## 4.回到终端,进入网卡配置，输入以下内容  
```
vim /etc/network/interfaces
```
![11](https://github.com/user-attachments/assets/7dfe1722-7261-47fd-a8dd-88425308212f)  
![12](https://github.com/user-attachments/assets/37c0d5bd-5948-4100-a99c-32d765e45e5a)  
按esc键输入`:wq` 保存退出。（注意，冒号是英文输入法下的）  

## 5.配置DNS，添加以下内容  
```
vim /etc/resolv.conf
```
![13](https://github.com/user-attachments/assets/d78c2dd2-c20a-46c1-88d0-58934da7f289)  
![14](https://github.com/user-attachments/assets/a5e1b39f-044b-4e38-a708-bce81ec8523a)  
按esc键输入`:wq`  
保存退出。（注意，冒号是英文输入法下的）  

## 6.重启网卡  
```
systemctl restart networking.service
```
![15](https://github.com/user-attachments/assets/f03b4197-a783-4f22-8c1c-0d8854add74b)  

再输入`ifconfig`  
![16](https://github.com/user-attachments/assets/cd0d7bc4-c964-4525-a6a1-2880c915617f)  
发现有了刚才配的ip地址  

## 7.测试ping 百度，可以上外网，成功  
![17](https://github.com/user-attachments/assets/83f2d0ee-aba4-463d-aa70-57b6790482f2)  
