# 部署Alist直链网盘

## 项目部署
```bash
docker run -d --restart=unless-stopped -v /etc/alist:/opt/alist/data -p 5244:5244 -e PUID=0 -e PGID=0 -e UMASK=022 --name="alist" xhofe/alist:latest
```

这里的`/etc/alist`是你的挂载路径`/opt/alist/data`是根文件夹路径你也可以自行修改  
进入容器内部
```bash
docker exec -it alist /bin/bash
```
添加空文件夹
```bash
mkdir temp
```
然后你的根文件路径就是`/opt/alist/temp`了  
查看密码
```bash
docker exec -it alist ./alist admin
```
手动设置一个密码，`NEW_PASSWORD`是指您需要设置的密码
```bash
docker exec -it alist ./alist admin set NEW_PASSWORD
```
或随机生成一个密码
```bash
docker exec -it alist ./alist admin random
```

## 创建直链：
主页-管理-设置-全局-`取消勾选签名所有`-保存  
主页-管理-存储-添加-驱动选择本机存储-挂载路径是物理机路径`/etc/alist`(具体看docker配置参数)-取消启用签名(一般默认取消)-根文件路径设置为你修改后容器的内部存储路径`/opt/alist/temp`最后保存  