# VMware安装Centos7系统教程

准备工作：  
下载和安装好[VMware Workstation](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)  
[CentOS7](https://mirrors.pku.edu.cn/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso)的iso下载

## VMware Workstation 配置
1. 打开“VMware Workstation”软件，选择“创建新的虚拟机”  
![VMC7d1](https://github.com/user-attachments/assets/bbacac27-2047-4d28-8465-936dc2730b1f)  

2. 选择“典型”选项，然后下一步  
![VMC7d2](https://github.com/user-attachments/assets/850931a3-e73e-4630-b3ee-99d5bf84517d)  

3. 选择“稍后安装操作系统”，点击下一步  
![VMC7d3](https://github.com/user-attachments/assets/9de72320-f5f3-466e-a312-1c2a234e0a74)  

4. 客户机操作选择“Linux”,版本选择“CentOS 7 64位”，点击下一步  
![VMC7d4](https://github.com/user-attachments/assets/cf11aa7b-e81a-4d15-afcd-b87d31c6d461)  

5. 输入“虚拟机名称”，选择虚拟机文件保存的位置，点击下一步  
![VMC7d5](https://github.com/user-attachments/assets/8afdfd07-9666-4fef-8ef5-441f46d00727)  

6. 最大磁盘默认20G大小即可，然后选择“将虚拟机磁盘存储为单个文件”，下一步  
![VMC7d6](https://github.com/user-attachments/assets/1a6bee83-6737-481c-a456-6cc2c72274cb)  

7. 点击“自定义硬件配置”  
![VMC7d7](https://github.com/user-attachments/assets/6e9739ac-3129-4015-974b-be35cf6ad69c)  

8. 选中“新CD/DVD”，选择“使用ISO映像文件”，然后设置CentOS7的ISO映像路径，点击关闭  
![VMC7d8](https://github.com/user-attachments/assets/a99514d0-6fd6-42b1-8b2c-73e9aa149f5b)  

9. 网络适配器默认NAT就好  
点击完成，如下
![VMC7d9](https://github.com/user-attachments/assets/9cfb3458-50b1-4758-97f7-747af92a4128)


## CentOS7的安装
1. 选中刚刚配置的CentOS7，然后点击“开启此虚拟机”  
![VMC7d10](https://github.com/user-attachments/assets/13d9076a-17c8-447b-a98b-c0ae8319d127)  

2. 虚拟机启动之后会出现如下界面（白色表示选中），默认选中的是Test this media & install CentOS  7我们将鼠标移入到虚拟机中，并按下键盘中的“↑”键，选择**Install CentOS 7**，最后按下“Enter 键”  
![VMC7d11](https://github.com/user-attachments/assets/abb0478f-4f4c-475f-b14b-6bfe1184c69a)  

界面说明：
<pre>
Install CentOS 7                    安装CentOS 7

Test this media & install CentOS  7 测试安装文件并安装CentOS  7

Troubleshooting                     修复故障
</pre>

3. 按下Enter进行安装  
![VMC7d12](https://github.com/user-attachments/assets/8f95e3d9-57b0-4c1f-b272-1f00e0a58927)  

4. 等待系统加载完成  
![VMC7d13](https://github.com/user-attachments/assets/ed449b21-afeb-455a-8af2-3c6982cd14e4)  

5. 选择使用哪种语言，推荐使用英文。但如果是第一次安装，建议先安装中文版的熟悉一下，之后再选择英文的进行实践，这里就介绍中文的，下滑至底部选择中文  
![VMC7d14](https://github.com/user-attachments/assets/fbc6ac4b-ad68-46d3-b89b-aabb96c628a9)  

6. 【本地化】只配置日期和时间，键盘和语言支持没有特殊情况默认就好  
![VMC7d15](https://github.com/user-attachments/assets/cc802943-7349-49e4-b28a-178aae96e9ca)  

7. 中国范围内都选择为上海（因为只有上海可选），并选择为24小时制，设置完成后单击完成按钮  
![VMC7d16](https://github.com/user-attachments/assets/db0af5f6-6b19-46a8-a9d3-450dacbf89ef)  

8. 【软件】中只配置软件选择，安装源系统会自动识别，所以不用管  
![VMC7d17](https://github.com/user-attachments/assets/003cdc8c-8b69-4e8d-8004-59f9982061e8)  

9. 然后我们选择安装的系统是否含有界面，界面一般对于我们来说用处不大，而且CentOS的界面不好操作，所以这里选择最小安装  
![VMC7d18](https://github.com/user-attachments/assets/1c176113-965f-4fd7-890a-7c172e2bb268)  

10. 【系统】中只配置安装位置，指的是系统如何分区，其它的都默认就好  
![VMC7d19](https://github.com/user-attachments/assets/863b85f5-3c82-4873-acb7-2abf23233fa4)  

11. 对分区不清楚的就选择自动配置分区，这里演示我要配置分区  
![VMC7d20](https://github.com/user-attachments/assets/517e3580-4530-4cf6-808e-1939a150768b)  

12. 手动分区我们要选择标准分区，然后点击下面的“+”添加分区  
![VMC7d21](https://github.com/user-attachments/assets/ba305848-7d69-4d11-8ce8-e41b80136f06)  

我们分别创建三个分区：`/boot`区、`swap`交换分区、根分区`/`  

13. 添加 `/boot`分区，用来放启动文件，大小300MB足矣，然后点击“添加挂载点”  
![VMC7d22](https://github.com/user-attachments/assets/4a4c117e-e5a1-498f-9fb5-72623e43608f)  
![VMC7d23](https://github.com/user-attachments/assets/68b02e67-480c-4814-a025-8f1c7aef05a8)  

14. 添加 swap分区，这个是交换分区，一般情况`是物理内存的2倍大小`，单位MB，用于物理内存不足时使用，可能造成系统不稳定  
![VMC7d24](https://github.com/user-attachments/assets/837dc127-6eb0-46db-a4b9-f3ae1a2ea3fd)  
![VMC7d25](https://github.com/user-attachments/assets/dfb92855-f02f-4a76-b428-51c2c0a946a1)  

15. 增加根分区，表示所有空间大小，这里`不填写大小，即默认剩余的空间都给根分区`，然后点击“添加挂载点”  
![VMC7d26](https://github.com/user-attachments/assets/885d5a4f-89cf-4fa9-9335-2db392f0dced)  
![VMC7d27](https://github.com/user-attachments/assets/a523da91-3e15-45b6-a576-d6a639773be3)  

16. 点击“完成”  
![VMC7d28](https://github.com/user-attachments/assets/7997ee6b-9236-498f-9bcb-a0f5ec7dcc4e)  

17. 点击“接受更改”  
![VMC7d29](https://github.com/user-attachments/assets/1496a2b1-1e06-448a-8ded-e2e6a9e9c41a)  

18. 回到界面，点击“开始安装”  
![VMC7d30](https://github.com/user-attachments/assets/487100bb-46f5-46fa-8ead-80c627c20a37)  

19. 接下来配置用户设置  
- 1. 设置管理员ROOT密码，这是最高权限root用户的密码（默认账号为root）  
实际中root密码越复杂越好，这个密码非常重要，请务必牢记  
![VMC7d31](https://github.com/user-attachments/assets/4ca4cd26-8d8c-4c91-80ac-e93991d786c6)  
![VMC7d32](https://github.com/user-attachments/assets/8aa90f79-5b86-4233-91ac-dd2286cf9d4a)  

- 2. 创建用户，这里就是普通的用户，权限比较低，这一步我们可以省略  
![VMC7d33](https://github.com/user-attachments/assets/beef50f2-a25f-49b9-ae55-c4c60a4ecd9d)  

20. 用户设置好了之后，等待CentOS安装完成，然后点击“完成配置”  
![VMC7d34](https://github.com/user-attachments/assets/809f4c88-2fc0-4f21-ab35-5fb8358aae57)  

21. 等待配置全部完成后点击“重启”  
![VMC7d35](https://github.com/user-attachments/assets/e05831a8-37b0-4929-b20a-981d2aef4610)  

22. CentOS的启动之后的界面如下  
![VMC7d36](https://github.com/user-attachments/assets/72102b81-6dd4-49bb-bd85-92541902cbc5)  

23. 下面我们来登录CentOS，使用默认账号为root，密码为 你在前面安装时设置的root密码  

24. 使用普通用户登录，普通用户的权限较低，很多地方不能操作，所以使用较少  

至此，CentOS7的安装全部完成了  

## 系统优化教程
配置命令终端打开方式快捷键
```
/usr/bin/gnome-terminal
```
