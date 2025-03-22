# fnOS系统安装部署

这里我使用[VMware WorkStation](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)做演示  
开始之前首先先下载[飞牛](https://www.fnnas.com/)的镜像


## 配置虚拟机
1. 打开VMware WorkStation，点击【文件】-【新建虚拟机】  
![fnOS1](https://github.com/user-attachments/assets/af5cebfa-f623-432b-9007-e8c6148532f5)  

2. 选择【自定义（高级）】  
![fnOS2](https://github.com/user-attachments/assets/68f6bd5a-4b86-4e25-8cb3-a352e6a8a40d)  

3. 兼容性选择最高版本  
![fnOS3](https://github.com/user-attachments/assets/49846df5-a745-43d2-abe9-22d5bec5dbdd)  

4. 点击选择【稍后安装操作系统】接着点击【下一步】  
![fnOS4](https://github.com/user-attachments/assets/a2b3f298-fc97-49de-a3cb-17fd016b2cc9)  

5. 操作系统选择【Linux】，版本选择【Debian 12.x 64位】（如果没有“Debian 12.x 64位”这个选项，则选择“Debian 64位”）  
![fnOS5](https://github.com/user-attachments/assets/d39e1b32-2449-45e7-acbb-8dc25a93a0b7)  

6. 改个虚拟机的名称（随意），位置尽量不要在C盘  
![fnOS6](https://github.com/user-attachments/assets/6b70d1e8-eb20-4d69-b106-c932aff2a06e)  

7. 处理器的设置看情况给  
![fnOS7](https://github.com/user-attachments/assets/5f5db14e-6bb9-4e8c-bd8d-8ecf55b82b2e)  

8. 给虚拟机分配内存少说也得给个2GB（建议是给4GB或以上）  
![fnOS8](https://github.com/user-attachments/assets/bd1824dd-6ea2-41ae-b1e2-d3dc58571c9a)  

9. 网络部分选择【Nat模式】  
![fnOS9](https://github.com/user-attachments/assets/c0d5beb4-bc28-4986-8ca8-b0ec15a9c313)  

10. I/O控制器类型选择（推荐）的就好  
![fnOS10](https://github.com/user-attachments/assets/52ff5f42-57e2-4bfe-b488-a804accb5d0f)  

11. 虚拟磁盘类型建议也是选择推荐（如果你是NvMe协议的硬盘，可以选择NvMe）  
![fnOS11](https://github.com/user-attachments/assets/a9422c7c-84f2-4902-9044-cf9b289734a7)  

12. 磁盘选择【创建新的虚拟磁盘】  
![fnOS12](https://github.com/user-attachments/assets/b43fbfd6-6c1d-4a20-a11e-029e3375da8a)  

磁盘大小这个地方就要注意一下了，因为飞牛OS是NAS系统，主要的服务就是数据存储服务，那分配的空间稍微多一些（官方建议是64GB给到飞牛OS系统作为存储和运行空间，4GB作为Swap区）那么如果要加上数据服务20GB，则需要给到100GB左右的空间  
当然了，如果你只是体验一下，那分配给飞牛OS系统的空间可以在20GB左右也行  
![fnOS13](https://github.com/user-attachments/assets/1441cb87-a6a8-42b8-b4f2-cba7fe932750)  

接着就是下一步了  
![fnOS14](https://github.com/user-attachments/assets/ac53afe3-3c8e-4705-a8be-9628435fc83e)  

点击完成  
![fnOS15](https://github.com/user-attachments/assets/aa6dcf77-49bc-4a80-8f6d-1745c92eae29)  

13. 点击编辑虚拟机设置  
![fnOS16](https://github.com/user-attachments/assets/16d5dbdd-08e8-4c16-9a7b-29037a949429)  

14. 在【CD/DVD(SATA)】选项中添加正确的ISO文件然后点击【确定】   
![fnOS17](https://github.com/user-attachments/assets/f81451ac-bc72-487c-b0f0-cd52769be4df)  


## 进入飞牛OS安装流程
1. 点击【开启此虚拟机】  
![fnOS18](https://github.com/user-attachments/assets/bc361d72-d33c-462f-bcdd-bef338fb23d9)  

2. 就会出现这个蓝色界面，直接按【回车】即可  
![fnOS19](https://github.com/user-attachments/assets/c2644dbe-9cc0-4b9e-8d39-d16318fc7f5e)  

3. 然后等待几分钟  

4. 到达下面这个界面之后，直接点击【下一步】  
![fnOS20](https://github.com/user-attachments/assets/3ddc10a2-389c-4dbf-8c34-d996adaffa9e)  

5. 这个界面就是飞牛OS建议的设置量，当然，你也可以设置最低的要求空间  
![fnOS21](https://github.com/user-attachments/assets/d3d46c30-92ea-4b45-bc3c-377c92c6a980)  

Swap区是数据交换区的意思，类似于Windows上的虚拟内存  
设置完之后点击【下一步】-【确定】  
![fnOS22](https://github.com/user-attachments/assets/16106756-ce79-4441-b465-7d354a781fea)  

接着等待安装完成即可  

系统安装完成之后，点击【下一步】  
![fnOS23](https://github.com/user-attachments/assets/7a3957ab-215b-4c79-97f2-6bf964e96f01)  

6. 网络按照DHCP默认分配即可  
![fnOS24](https://github.com/user-attachments/assets/42222de7-735d-4486-98b8-a3c49ac096aa)  

点击【保存】之后会出现是否重启系统这个提示  

7. 把安装盘弹出，按【Ctrl】+【Alt】释放鼠标到宿主机上，找到虚拟机界面右下角的位置，有个**光盘的图标**  
![fnOS25](https://github.com/user-attachments/assets/d0c95aea-5cfe-436c-8c27-20bb9e0d8a77)  

8. 点击它，选择【断开连接】  
![fnOS26](https://github.com/user-attachments/assets/c3ced0c5-4246-4b72-8ea5-6a86416032d2)  

9. 点击【是】  

10. 然后点击虚拟机界面上的【确定】  
![fnOS27](https://github.com/user-attachments/assets/1408b1cf-42c5-4c17-9230-4e5a44f66962)  

11. 等待虚拟机重启  

12. 重启到这个界面就算飞牛OS安装完成了  
![fnOS28](https://github.com/user-attachments/assets/09cae7a3-06dd-4cd2-81e7-abca2a4bdb4a)  


## 进入到飞牛OS系统
1. 在刚刚那个界面找到登录的Web UI地址，我这里是`192.168.66.112:5666`  
如果没有跳出就查看飞牛系统的ip地址：
```
ip a
```

2. 打开电脑浏览器，在地址栏输入刚刚找到的UI地址(一定要输入英文状态下的冒号)  

3. 输入正确之后，回车就能进入到飞牛OS首次进入的画面，点击【开启NAS之旅】  
![fnOS29](https://github.com/user-attachments/assets/4716c730-9ea0-48cb-a05b-f082c4a1800c)   

4. 在这个界面输入的内容一定`不要有中文或者中文符号`创建管理员账户和密码  
![fnOS30](https://github.com/user-attachments/assets/d2e6ca54-6d1e-43be-82a9-ddbccf41e38f)  

5. 设置完成之后就可以使用飞牛系统了  

6. 接下来是添加存储空间的操作  
![fnOS31](https://github.com/user-attachments/assets/2961b498-5911-408a-930d-0d9cb7ca5513)  
![fnOS32](https://github.com/user-attachments/assets/3a9a5fde-35a4-47fd-94d3-0dd6e5f127ca)  
![fnOS33](https://github.com/user-attachments/assets/01a1a226-fda8-4896-8eca-ade026e7f7bf)  
![fnOS34](https://github.com/user-attachments/assets/f4c624f3-36d2-4228-94d4-5b3c3e5d7f4f)  
![fnOS35](https://github.com/user-attachments/assets/f29bcd7c-342b-4a02-b313-95ee5670e2a3)  
![fnOS36](https://github.com/user-attachments/assets/0647400e-3a80-48d5-9efc-c2c5b2b960ee)  

--End--
