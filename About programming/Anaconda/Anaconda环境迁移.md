# 如何将C盘的Anaconda环境转移到D盘？

参考：https://zhuanlan.zhihu.com/p/651593144  

### 虚拟环境迁移
1. 首先进入c盘用户找到`.conda`文件夹，里面有2个文件夹和一个.txt文件  
<pre>
C:\Users\admin\.conda\envs
C:\Users\admin\.conda\pkgs
C:\Users\admin\.conda\environments.txt
</pre>

2. 进入`envs`文件夹，**复制里面的文件夹**（虚拟环境文件夹），到你安装Anaconda的目录，比如**D盘的Anaconda目录**，然后进入找到**envs文件夹**然后把你复制的文件夹粘贴进去    
<pre>
D:\Anaconda\envs\复制的虚拟环境文件夹
</pre>

3. 同理复制`pkgs`文件夹到D盘的Anaconda目录，然后进入找到**pkgs文件夹**（已安装软件包及其依赖项文件夹）然后把你复制的文件夹粘贴进去  
<pre>
D:\Anaconda\pkgs\复制已安装软件包及其依赖项文件夹
</pre>

4. 将在C盘的`.conda`文件夹中的**environments.txt**文件里面的**C盘路径换成D盘的路径**修改之后把文件复制到D盘的Anaconda文件夹中  
**注意：这里的.conda文件夹中的environments.txt文件一定要和D盘的environments.txt文件保持一致**  
***这里建议保留C:\Users\admin\.conda\environments.txt文件是为了备份以防万一***  
<pre>
C:\Users\admin\.conda\environments.txt
D:\Anaconda\environments.txt
</pre>
修改environments.txt中的环境路径内容，将C盘路径换成D盘的路径:
<pre>
C:\Users\admin\.conda\envs\tensorflow
修改为
D:\Anaconda\envs\tensorflow
</pre>
复制到指定位置：
<pre>
D:\Anaconda\environments.txt
</pre>

5. 在C盘用户中找到`C:\Users\admin\.condarc`文件使用记事本打开并添加如下四行
```
envs_dirs:
- D:\Anaconda\envs
pkgs_dirs:
- D:\Anaconda\pkgs
```
当然你也可以参考我的完整配置
```
envs_dirs:
  - D:\Anaconda\envs
pkgs_dirs:
  - D:\Anaconda\pkgs
channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/linux-64/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  - defaults
show_channel_urls: true
auto_activate_base: false
```
envs_dirs:这个是修改环境路径  
pkgs_dirs:这个是修改已安装软件包及其依赖项文件夹路径  
**这两个路径一定要修改因为Anaconda会默认使用C盘的路径，修改之后就会使用D盘的路径安装虚拟环境及其依赖项**  
还有这里最重要的一定就是要在D盘安装Anaconda的目录下**将envs文件夹和pkgs文件夹中的Users权限修改为完全控制**，否则创建虚拟环境会报错  
修改方法：**右键envs文件夹** → **属性** → **安全** → **编辑** →  **选择Users** → **勾选完全控制** → **确定** → **确定** → **确定**  
**同理修改pkgs文件夹的权限！！！**  
channels:这个是镜像源可以自行修改  
show_channel_urls: true 这个是设置搜索时显示通道地址（可选）  
auto_activate_base: false 这个是设置创建虚拟环境后是否自动激活即一打开终端就默认进入conda的base环境（建议改为false）  


### 环境变量校验
右键我的电脑然后搜索环境变量，进入环境变量，点下面的系统变量**Path**把.conda的环境全部替换成Anaconda的环境（如果有C盘.conda文件的环境变量直接删除），然后保存，没有就添加anaconda相关环境变量  
```
D:\Anaconda
D:\Anaconda\Scripts
D:\Anaconda\Library\bin
D:\Anaconda\Library\mingw-w64\bin
```

### 测试
打开命令行输入`conda info`查看配置是否正确  
然后输入:
```
conda env list
```
查看虚拟环境是否成功迁移到对应的位置
激活虚拟环境
```
conda activate <虚拟环境名称>
```
然后输入：
```
python
```
查看是否成功  
再进行一次创建虚拟环境查看是否创建再D盘的D:\Anaconda\envs\目录下  
如果都成功那么就说明Anaconda环境迁移成功了

### 删除C盘的Anaconda环境
如果使用D盘同名称的环境测试成功，那么就可以删除C盘的Anaconda环境了  
注意这里只需要删除虚拟环境和软件包及依赖就行了  
```
C:\Users\admin\.conda\envs
C:\Users\admin\.conda\pkgs
```
**注意：迁移后这里的C:\Users\Admin\.conda目录千万不要删除了只需要删除里面的两个文件夹就行了（envs和pkgs文件夹），environments.txt文件请不要删除**  
创建环境以及安装包都是在D盘，C盘的空间就不用担心炸了  
