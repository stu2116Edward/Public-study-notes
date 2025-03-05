# docker更换镜像

修改镜像配置文件：
```
vim /etc/docker/daemon.json
```
配置文件内容：
```json
{
  "registry-mirrors":
   [
      "https://registry.hub.docker.com",
      "https://docker.itelyou.cf",
      "https://abc.itelyou.cf",
      "https://docker.ywsj.tk",
      "https://docker.xuanyuan.me",
      "http://image.cloudlayer.icu",
      "http://docker-0.unsee.tech",
      "https://dockerpull.pw",
      "https://docker.hlmirror.com"
   ],
  "insecure-registries" :["修改成自己的服务器IP:端口"]
}
```
`registry-mirrors`这个是公共镜像的地址，`insecure-registries`这个是私有镜像的地址，修改成自己的服务器IP:端口  
将镜像重新加载：
```
systemctl daemon-reload && systemctl restart docker
```

下面是我所整理的供大家使用：
```
https://docker.itelyou.cf
```
```
https://abc.itelyou.cf
```
```
https://docker.ywsj.tk
```
```
https://docker.xuanyuan.me
```
```
http://image.cloudlayer.icu
```
```
http://docker-0.unsee.tech
```
```
https://dockerpull.pw
```
```
https://docker.hlmirror.com
```
