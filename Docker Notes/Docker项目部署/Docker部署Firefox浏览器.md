# Docker部署Firefox浏览器

### 1，创建外部挂载目录
```
mkdir -p /data/firefox/config
```

### 2，输入执行下面命令启动运行
```
docker run -d \
    --name=firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    -e ENABLE_CJK_FONT=1 \
    jlesage/firefox
```

**参数介绍**
<pre>
-e TZ=Asia/Hong_Kong # 设置时区
-e DISPLAY_WIDTH=1920
-e DISPLAY_HEIGHT=1080 #设置显示的高宽
-e KEEP_APP_RUNNING=1 # 保持启动状态
-e ENABLE_CJK_FONT=1 # 防止显示页面时中文乱码
-e SECURE_CONNECTION=1 # 启用HTTPS功能
-e VNC_PASSWORD=admin #设置VNC的访问密码,自定义即可
-p 5800:5800 #访问firefox的web端口
-p 5900:5900 #VNC端口
-v /data/firefox/config:/config:rw #容器挂载目录，存放 Firefox 数据
--shm-size 2g #设置容器的内存资源为2g
</pre>

### 开始使用
运行完成后，在浏览器输入 http://本地IP:5800，会显示下面登录页，把设置的密码 admin 输入进去，点击【Submit】按钮即可
