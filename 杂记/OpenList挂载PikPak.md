# OpenList挂载PikPak

参考官方文档 https://doc.oplist.org/guide/drivers/pikpak#_1-pikpak%E6%8C%82%E8%BD%BD

### 1. 登录OpenList  
浏览器打开 `http://127.0.0.1:5244`  
账号默认 `admin`  
密码默认 `admin`  
可自行修改  

### 2. 进入OpenList后台
点击下方的管理  
点击左侧存储  
点击添加  
驱动选择PikPak  
挂载路径设置为 `/vol2/1000/PikPak`  
禁用索引 `勾选`  
启用签名 `勾选`  
用户名 `example@outlook.com` (你的邮箱)  
密码 `password` (你的密码)
平台 `网页`  

### 3. 刷新令牌（关键）
Web端 Refresh Token 的获取  
通过 https://mypikpak.com/ 网页端获取  

在官方网页登录后，打开 `F12` 控制台，进入下图中的页面（以 Chrome 为例）  
在上方选项卡选择 `Application` 然后在左侧 `Storage` 选项卡下的 `Local Storage` 下拉框中选择 `https://mypikpak.com`  
<img width="1004" height="304" alt="pikpak-token-1" src="https://github.com/user-attachments/assets/0e2cd565-0a67-40b9-b663-cb277fc2b2a7" />  

找到以 `credentials` 开头的选项，选中后，观察下方的信息栏，从中可以获取到 `Refresh token`，如下图所示
<img width="170" height="73" alt="pikpak-token-2" src="https://github.com/user-attachments/assets/91472353-b3e6-4123-93f3-ffadfe357d07" />


### PikPak分享挂载
- 只需要填写 用户名 ，密码，分享ID 三项即可 ，根文件夹ID 可写可不写，不写默认为root目录（根目录）  
- 根文件夹ID：如果是多层目录，你想让哪个目录展示当根目录你就写哪个根目录.（参考下方获取根文件夹ID方法）  
- 分享密码：分享的有密码就写，没有就不写  

<img width="1706" height="584" alt="pikpak-share" src="https://github.com/user-attachments/assets/7c379be0-0bea-4fd2-b8a9-43480860e66b" />

获取根文件夹ID  

<img width="860" height="566" alt="pikpak-share-rootfolder" src="https://github.com/user-attachments/assets/3fc4d0f4-0a4a-4ba2-a626-ad82c05caf1c" />

**当前pikpak分享的根目录ID已经无法在地址中获取，需要查看接口返回的数据**  

打开 `F12` 控制台，进入 `网络（Network）` 选项卡  
刷新页面，搜`detail`，找到最后一个 `detail` 请求  
选择 `detail`，在 `响应（Response）` 中找到 `files`  
找到对应的文件夹名称，查看其id字段内容即为根文件夹ID（可以通过name字段来确认对应的文件夹）  

**使用转码地址**  
默认不启用，打开后 下载地址将使用转码后的地址，可获取 完整的转码后的文件  

打开 使用转码地址 选项后，无法使用 OpenList 网页版播放视频，但可正常下载或使用第三方播放器  
批量添加PikPak分享挂载  
使用的软件：https://github.com/yzbtdiy/alist_batch  



### 遇到验证码问题
出现下图情况：`Failed load storage: failed init storage: Your operation is too frequent, please try again later`  

<img width="335" height="51" alt="pikpak-error-1" src="https://github.com/user-attachments/assets/0d80fb99-c82c-42a5-894f-25b7c321f507" />  

则表明 `Refresh token` 无效，请重新获取
