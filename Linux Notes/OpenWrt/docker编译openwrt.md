# docker编译openwrt


### 1 整体步骤

1. docker构建编译所需的系统镜像
2. 下载源代码
3. 首次编译
4. 选择自己需要的软件再次编译
5. 集成第三方软件包编译/编译单独ipk
- 官网教程： https://openwrt.org/docs/guide-developer/toolchain/start


### 2 docker编译官方openwrt


#### 2.1 构建编译所需的系统镜像

为了不让编译环境污染宿主机，采用docker的方式编译，由docker为我们创建一个专门用于编译openwrt的系统，执行docker build的时候会自动下载编译工具所需要的依赖。你可以使用别人写好的 `Dockerfile` 文件：  
https://github.com/mwarning/docker-openwrt-build-env  
下载 Dockerfile 编译文件  
```
git clone https://github.com/mwarning/docker-openwrt-builder.git
cd docker-openwrt-builder
```
查看Dockerfile，可以看到是基于debian的系统，安装了一些依赖，并创建了一个user用户（原因是不能使用root用户编译，也不能使用sudo执行编译）  
- 不同系统所需依赖： https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem

```
FROM debian:buster

RUN apt-get update &&\
    apt-get install -y \
        sudo time git-core subversion build-essential g++ bash make \
        libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk \
        flex gettext wget unzip xz-utils python python-distutils-extra \
        python3 python3-distutils-extra python3-setuptools swig rsync curl \
        libsnmp-dev liblzma-dev libpam0g-dev cpio rsync gcc-multilib && \
    apt-get clean && \
    useradd -m user && \
    echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

# set system wide dummy git config
RUN git config --system user.name "user" && git config --system user.email "user@example.com"

USER user
WORKDIR /home/user
```
为了加快构建速度，使用国内的源，在 `FROM debian:buster` 后面添加一行  
```
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
```
此时 Dockerfile 如下
```
FROM debian:buster
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update &&\
    apt-get install -y \
        sudo time git-core subversion build-essential g++ bash make \
        libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk \
        flex gettext wget unzip xz-utils python python-distutils-extra \
        python3 python3-distutils-extra python3-setuptools swig rsync curl \
        libsnmp-dev liblzma-dev libpam0g-dev cpio rsync gcc-multilib && \
    apt-get clean && \
    useradd -m user && \
    echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

# set system wide dummy git config
RUN git config --system user.name "user" && git config --system user.email "user@example.com"

USER user
WORKDIR /home/user
```
构建镜像
```
docker build -t openwrt_builder .
```

<img width="1245" height="421" alt="dopb1" src="https://github.com/user-attachments/assets/c6ac3bd4-82fb-450a-afe2-b2dbdd0836a0" />

执行此命令后，我们本地就多出了一个安装好编译依赖的debian镜像
```
docker images | grep openwrt
```
<pre>
root@tignioj:~/docker-openwrt-builder# docker images | grep openwrt
openwrt_builder            latest     0175798f5da9   4 weeks ago     716MB
</pre>
创建编译系统的容器（镜像类似于系统的安装光盘，是固定的，容器类似于安装后的系统，可以开机关机、安装软件）  
```
mkdir ~/mybuild
docker run -v ~/mybuild:/home/user --name openwrt_builder -itd openwrt_builder
```
进入容器
```
docker exec -it openwrt_builder /bin/bash
```
修改当前目录所属用户给user（这个user用户是在Dockerfile中创建的）
```
sudo chown -R user:user .
```


#### 2.2 首次编译
经过上面的步骤，我们进入了一个已经准备好编译环境的系统，此时可以开始跟着官方的步骤开始编译了  
- 官方编译步骤： https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem
下载openwrt源代码：  
```
git clone https://git.openwrt.org/openwrt/openwrt.git
```
进入代码目录
```
cd openwrt
```


##### 2.2.1 选择稳定版本分支
最好使用稳定版 `git checkout` 指定版本，而不是默认使用 `HEAD` 分支，如果你不使用稳定版，会带来某些问题，比如opkg安装程序会报错内核版本不匹配  

```
# Select a specific code revision
git branch -a
git tag  # 查看有哪些分支
```
切换到指定版本  
```
git checkout v23.05.2 # 指定稳定版
```


##### 2.2.2 更新feeds
```
# Update the feeds
./scripts/feeds update -a
./scripts/feeds install -a
```


##### 2.2.3 配置选项
```
# Configure the firmware image
make menuconfig
```

先认识一下界面  
<img width="1120" height="561" alt="dopb2" src="https://github.com/user-attachments/assets/3e53e80f-f57b-4069-9b3e-6b3c68a292d4" />

在这个例子里面，我们暂时使用x86平台，到后面我们再使用指定的路由器平台，所以这些默认不动即可！  

<img width="443" height="91" alt="dopb3" src="https://github.com/user-attachments/assets/db7ff183-3c91-4da4-a151-1aac3766aeae" />

openwrt编译默认不带luci的web界面，你需要手动勾选安装，找到， LuCI-> Collections-> luci，双击使得前面的变成 `*` 符号  

<img width="803" height="158" alt="dopb4" src="https://github.com/user-attachments/assets/1642115f-d8f5-4b8c-9099-ab02c37e9c9b" />

设置web界面为中文， 双击空格使得前面的 `< >` 变成 `<*>` 符号  
```
LuCI->Modules->Translations -> <*> Chinese Simplified (zh_Hans)
```
我们选择x86平台就是为了能在宿主机上运行，为了能docker中运行openwrt，找到target image勾选tar.gz (默认是勾选上的，没有自己勾上)  

<img width="352" height="105" alt="dopb5" src="https://github.com/user-attachments/assets/8ecec9e6-721e-4945-8811-9e6a9e74bac5" />

接着保存配置菜单，移动到Save，回车  

<img width="547" height="92" alt="dopb6" src="https://github.com/user-attachments/assets/a073bd06-fdc7-4765-998b-a78c93a03746" />

选择OK  

<img width="487" height="203" alt="dopb7" src="https://github.com/user-attachments/assets/33c3cc0e-73b8-4cf7-be84-c0de279ff918" />

然后光标移动到EXIT退出菜单  



##### 2.2.4 下载编译所需的库
```
# Build the firmware image
make download -j$(nproc)
```
- `-j$(nproc)`, 其中 `nproc` 会返回你系统的最大线程数量，例如-j8表示7线程编译(会保留一个线程防止系统卡死)
- `V=s`: 打印详细信息


##### 2.2.5 开始编译

编译前，请确保有良好的科学环境，终端输入`curl -I www.google.com` ，检查状态码是否为 `200`，如果卡住了说明网络环境不适合编译  
<pre>
HTTP/1.1 200 OK
Content-Type: text/html; charset=ISO-8859-1
</pre>
第一次编译推荐使用多线程编译，一个小时以内可以完成。单线程编译可能要5小时  
```
make -j$(nproc)
```
如果编译出错了，那么就单线程编译一遍，前面多线程编译过的内容会跳过。通常出问题都是网络问题  
```
make -j1 V=s
```
加上 `V=s` 后可以看到详细的错误信息，例如可能出现的网络问题  

<img width="1177" height="402" alt="dopb8" src="https://github.com/user-attachments/assets/b28afb52-7be3-4703-85c1-71b5a2a15bc5" />

编译成功后，到这里你可以看到在 `bin/target/x86/64` 目录下看到编译的固件  
```
ls -lah bin/target/x86/64
```

<img width="915" height="443" alt="dopb9" src="https://github.com/user-attachments/assets/e1b82037-65fe-4c76-9e33-bfe89683614f" />



## docker中运行自己编译的openwrt镜像


### 1 准备docker镜像
```
mkdir my-openwrt && cd my-openwrt
```
复制编译好的 `openwrt-x86-64-generic-rootfs.tar.gz` 到 `my-openwrt`  
```
cp ~/mybuild/openwrt/bin/targets/x86/64/openwrt-x86-64-generic-rootfs.tar.gz .
```
编写Dockerfile  
从空白镜像创建
```
FROM scratch
ADD openwrt-x86-64-generic-rootfs.tar.gz /
EXPOSE 80 22 443

# 给openwrt设置初始化ip地址
RUN echo "uci set network.lan.ipaddr='192.168.30.99' \
        && uci set network.lan.gateway='192.168.30.1' \
        && uci set network.lan.dns='192.168.30.1' \
        && uci commit" > /etc/uci-defaults/99-custom

ENTRYPOINT ["/sbin/init"]
```
注意这里的ADD使用绝对路径时，是以当前context为根目录，所以你必须把镜像文件复制到当前目录，也就是说，你不能够写成  
`#ADD /root/mybuild/openwrt/bin/targets/x86/64/openwrt-x86-generic-generic-rootfs.tar.gz /`  
创建docker虚拟网卡以便于分配独立的ip  
```
docker network create -d macvlan --subnet=192.168.30.0/24 --gateway=192.168.30.1 -o parent=eno1 macnet
```


#### 1.1 编写docker-compose.yaml
```
vim docker-compose.yaml
```
内容如下
```
version: '3'

services:
  openwrt:
    build: .
    container_name: my-openwrt
    privileged: true
    restart: always
    networks:
      macnet:
        ipv4_address: 192.168.30.99  # 从虚拟网卡macnet中分配ip

networks:
  macnet:  # 虚拟网卡1
    external: true  # 使用已有的虚拟网卡
```
当然，也可以在docker-compose里面编写虚拟网卡参数，当执行 `docker compose up -d` 时，会自动创建虚拟网卡，需要注意的是，同一个网卡只能创建一个虚拟网络  

例如，开头我们已经为eno1创建了192.168.30.0/24的网络，名称为macnet，此时则不能继续用eno1作为上游网卡  
<pre>
Error response from daemon: network dm-204e4605b2fe is already using parent interface eno1
</pre>
所以如果你打算把创建虚拟网络的命令放进docker compose里面，则需要先删掉已有的虚拟网卡  
```
docker network rm macnet
```
此时docker-compose.yaml就写成
```
version: '3'

services:
  openwrt:
    #image: piaoyizy/openwrt-x86
    build: .
    container_name: my-openwrt
    privileged: true
    restart: always
    networks:
      macnet:
        ipv4_address: 192.168.30.99

networks:
  macnet: # 虚拟网卡2
    driver: macvlan
    driver_opts:
      parent: eno1 # 对应桥接的网卡
    ipam:
      config:
        - subnet: 192.168.30.0/24
          gateway: 192.168.30.1
```
注意，这里虚拟网卡分配的ip地址是指容器获取的ip地址，并不会直接应用到openwrt镜像的 `/etc/config/network` 里面，如果我们需要修改 `/etc/config/network` 的配置，请在Dockerfile中使用 `uci set network.lan.ipaddr='xxx'` 方式修改  


#### 1.2 启动openwrt容器
```
docker compose up -d
```
进入容器
```
docker compose exec openwrt ash
```
编辑网络
```
vi /etc/config/network
```
设置静态ip和dns以及gateway，注意，只有配置了dns和网关你才能让openwrt上网  

注意，由于我们在Dockerfile中已经使用了 `uci set network.ipaddr` 等命令设置了网络，因此这里实际上已经是修改后的了，此时你通过浏览器可以直接访问192.168.30.99进入后台  
```
config device
        option name 'br-lan'
        option type 'bridge'
        list ports 'eth0'
                            
config interface 'lan'
        option device 'br-lan'
        option proto 'static'
        option ipaddr '192.168.30.99'
        option dns '192.168.30.1'
        option gateway '192.168.30.1'
        option netmask '255.255.255.0'
        option ip6assign '60'
```
编辑完成后，不要使用 `/etc/init.d/network restart`，这样做很有可能卡住然后返回 `Request timeout`, 原因可能是路由表不正确，设置路由表还会报错，因此只能使用reboot或者退出容器重启改容器  
```
exit
docker compose restart openwrt
```


### 2 安装ipk
如果你使用的是稳定的发行版，而不是master，那么你可以直接通过opkg update获取官方的安装包  
```
opkg update
```
比如安装 `iperf3`
```
opkg install iperf3
```
或者安装 `wol`
```
opkg install luci-app-wol
opkg install luci-i18n-wol-zh-cn
```


### 3 可能遇到的错误


#### 3.1 在ip地址正确设置的情况下，web界面无法打开
猜测是你的镜像有问题，进入容器，查看一下网络监听状态，有没有80和443，如果没监听 0.0.0.0:80，那么就说明镜像可能有问题  
```
netstat -antp
```
发现压根没有监听80端口  

<img width="856" height="294" alt="dopb11" src="https://github.com/user-attachments/assets/a47eab95-ff4c-41f3-8a84-8ba74567ec2b" />

但是samba和ssh都可以连接，所以可以确定是web服务没有开启  
https://forum.openwrt.org/t/cant-access-openwrt-web-gui-luci/27914/12  
手动开启一下  
```
/usr/sbin/uhttpd -f -h /www -r 192.168.30.101 -x /cgi-bin -t 60 -T 30 -k 20 -A 1 -n 3 -N 100 -R -p 0.0.0.0:80
```
这下后台可以访问了，但是这显然不是正确的做法，目前进一步想办法解决  


### 4 解决web无法访问的问题

#### 4.1 openwrt 无法访问web
原因是编译镜像的时候没有勾选luci，请勾选Luci->luci后重新编译！  

<img width="875" height="165" alt="dopb12" src="https://github.com/user-attachments/assets/6381fa6c-d43e-4a91-8381-4a2871e1db55" />

#### 4.2 lede无法访问web的解决办法：
- https://forum.openwrt.org/t/luci-uhttpd-channel-3-open-failed-connect-failed/91646/2
- https://forum.openwrt.org/t/luci-not-available-anymore-ssh-works/22418/10
这是因为lede默认开启了https的访问，但是编译菜单没有勾选openssl，因此要么编译时候勾选openssl，要么关掉https  


#### 4.3 关掉https
```
uci set uhttpd.main.listen_https=''
uci commit
```
重启uhttpd
```
service uhttpd restart
```
```
service dockerd restart; sleep 5; logread -l 20
```


### 5 解决内核版本错误问题
- https://openwrt.org/faq/cannot_satisfy_dependencies
编译的时候选择稳定版本的分支



#### 2.3 选择插件编译进固件
经过第一次编译后，后面再次编译速度就会快很多，这时候我们就可以选择自己需要的插件编译进固件里面，例如 samba4  
```
make menuconfig
```
找到 LuCI->Applications->luci-app-samba4, 双击空格使得前面的 `<>` 变成 `<*>`，其中 `*` 表示集成进固件里面, `M`表示作为ipk包  


##### 2.3.1 网络共享samba4

<img width="813" height="99" alt="dopb13" src="https://github.com/user-attachments/assets/37062951-e37d-4d92-9e0c-1e043ede8919" />

光标移动到save，保存.config，然后再次编译，发现速度会快很多  


##### 2.3.2 docker
<pre>
<*> luci-app-dockerman.................. LuCI Support for docker
</pre>

提醒：仅针对x86平台，如果编译 `luci-app-dockerman`，则需要自己手动勾选依赖 `dockerd`，否则docker无法正常启动  

在Utilities下找到，把前面的设置成 `<*>`  
<pre>
<*> dockerd............ Docker Community Edition Daemon  --->
</pre>


##### 2.3.3 usb打印服务器
<pre>
 <*> luci-app-p910nd........... p910nd - Printer server module
</pre>
找到内核 `Kernal Modules` -> `USB Support`  
<pre>
 <*> kmod-usb-printer...... ........ Support for printers
</pre>


##### 2.3.4 usb挂载
`Base System` 中选中 `block-mount`  


##### 2.3.5 usb存储支持
<pre>
-*- kmod-usb-storage............................. USB Storage support
<*> kmod-usb-storage-extras............ Extra drivers for usb-storage
<*> kmod-usb-storage-uas............... USB Attached SCSI (UASP) support
</pre>

提醒：dnsmasq和dnsmasq-full不能同时勾选。例如选中passwall第三方插件时，可能会出现这种情况，请到Base System中取消调dnsmasq的勾选  


##### 2.3.6 二次编译
```
make -j$(nproc) download
make -j$(nproc)
```


#### 2.4 集成第三方插件
经过上面的的步骤，你已经学会了基本的编译，此时可以尝试添加第三方的软件包  
https://github.com/kenzok8/openwrt-packages  


##### 2.4.1 添加软件源
执行
```
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
git pull
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
```
找到LuCI->Applications，勾选需要的软件，依赖会自动勾选  


##### 2.4.2 插件集成到固件里面
按下空格选中 `M` 表示作为ipk包编译  
<pre>
<M> luci-app-alist............ LuCI support for alist
</pre>
再次按下空格，出现*表示集成到固件里面
<pre>
<*> luci-app-alist............ LuCI support for alist
</pre>
然后开始编译
```
make -j$(nproc) download
make -j$(nproc)
```


##### 2.4.3 插件不集成到固件里面，而是单独作为ipk包
- 参考： https://3mile.github.io/archives/2019/0813123100/ 按下空格选中 `M` 表示作为ipk包编译
<pre>
<M> luci-app-alist............ LuCI support for alist
</pre>
开始编译
```
make package/luci-app-alist/compile V=s
```
ipk生成路径，可以使用find命令查找
```
find bin/  -name "*alist*"   
```
<pre>
user@c6ba0d0ab225:~/openwrt$ find bin/  -name "*alist*"                                                                                       
bin/packages/aarch64_cortex-a53/kenzo/luci-i18n-alist-zh-cn_1.0.11-1_all.ipk
bin/packages/aarch64_cortex-a53/kenzo/alist_3.30.0-2_aarch64_cortex-a53.ipk
bin/packages/aarch64_cortex-a53/kenzo/luci-app-alist_1.0.11-1_all.ipk
user@c6ba0d0ab225:~/lede$ 
</pre>
然后把这些ipk上传到路由器上执行即可
```
opkg install luci-i18n-alist-zh-cn_1.0.11-1_all.ipk
opkg install alist_3.30.0-2_aarch64_cortex-a53.ipk
opkg install luci-app-alist_1.0.11-1_all.ipk
```
或者在web界面上传安装


##### 2.4.4 第三方插件源可能出现的问题
- 2.4.4.1 ERROR: package/feeds/kenzo/alist failed to build

解决方案参考： https://github.com/kenzok8/openwrt-packages/issues/363#issuecomment-1426531811 添加依赖即可  
```
sudo apt install libfuse-dev
```

- 2.4.4.2 ERROR: package/feeds/small/v2ray-plugin failed to build.

参考 https://github.com/fw876/helloworld/issues/836 原因是勾选passwall2的时候，自动勾选了v2ray-plugin，要么取消调v2raya-plugin，要么升级go版本  

<img width="1260" height="596" alt="dopb14" src="https://github.com/user-attachments/assets/174d0332-94f4-4649-938a-0090a03a26f1" />


#### 2.5 调整ROOT大小
- 参考 https://github.com/danshui-git/shuoming/blob/master/overlay.md

注意：对于官方openwrt的固件，修改root分区大小后，如果刷到路由器里面，需要重新刷GPT和uboot，否则可能不生效  

找到 `Target Images -> (102) Root filesystem partition size (in MiB)`， 把102改为自己想要的大小  


#### 2.6 自定义配置文件

- 参考1： https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem#custom_files
- 参考2： https://openwrt.org/docs/guide-developer/uci-defaults 我们可以在编译根目录下创建files目录，相当于路由器的根目录。然后往里面新建etc/uci-defaults文件夹，这里面可以写自己定义的uci命令

```
mkdir -p files/etc/uci-defaults
```
往 `files/etc/uci-defaults/` 添加脚本，等同于往路由器的/etc/uci-defaults/中添加脚本  
```
vim files/etc/uci-defaults/99-custom
```
在99-custom添加自定义ip地址、dns和网关命令
```
uci -q batch << EOI
set network.lan.ipaddr='192.168.30.99'
set network.lan.dns='192.168.30.1'
set network.lan.gateway='192.168.30.1'
EOI
```
然后编译出来的固件，就会使用你的自定义配置  
该目录中的所有脚本都会由boot服务自动执行，且仅在全新安装后的首次启动时执行  
- 如果它们以代码 0 退出，则它们随后将被删除  
- 以非零退出代码退出的脚本不会被删除，并将在下次启动时重新执行，直到它们也成功退出


#### 2.7 注意事项

如果你选择了自定义路由器平台，官方openwrt编译出来的是 `.itb` 格式的固件，需要用到tftp刷机方式，不兼容常见的第三方uboot刷入方式。可参考教程：

- 官网： https://openwrt.org/docs/guide-user/installation/generic.flashing.tftp
- 恩山： https://www.right.com.cn/forum/thread-8338290-1-1.html


#### 2.8 差异配置

暂时不清楚有什么优点
- 参考： https://openwrt.org/docs/guide-developer/uci-defaults
- uci命令： https://openwrt.org/docs/techref/uci



### 3 docker编译lede
- 简介：lede是openwrt的一个分支，默认使用中文，集成了一些基本的插件。

- 编译方法：类似openwrt，其实就是仿造 https://github.com/mwarning/docker-openwrt-build-env 这个编写了一个linux环境，然后在这个环境里面执行编译

- 这次我们不下载他们Dockerfile，而是自己仿造一个

```
FROM debian:buster
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt-get update &&\
    apt-get install -y \
        sudo time git-core subversion build-essential g++ bash make \
        libssl-dev patch libncurses5 libncurses5-dev zlib1g-dev gawk \
        flex gettext wget unzip xz-utils python python-distutils-extra \
        python3 python3-distutils-extra python3-setuptools swig rsync curl \
        libsnmp-dev liblzma-dev libpam0g-dev cpio rsync gcc-multilib && \
    apt-get clean && \
    useradd -m user && \
    echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

# set system wide dummy git config
RUN git config --system user.name "user" && git config --system user.email "user@example.com"

USER user
WORKDIR /home/user
```
构建镜像
```
docker build -t lede_builder .
```
运行镜像
```
docker run  -v ~/lede_mybild:/home/user lede_builder /bin/bash
```


#### 3.1 首次编译
```
git clone https://github.com/coolsnowwolf/lede
cd lede
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig
```
第一次编译建议不要勾选任何插件，因为第一次编译包含了很多基础包的编译，过程比较持久，如果加上了插件造成报错可能会感到困惑：到底是插件的问题，还是我系统没配置好？因此第一次仅仅勾选你的路由器平台即可。这里拿RAX3000M举例，首先选择平台，接着是芯片，第三项是具体型号  

<img width="548" height="83" alt="dopb15" src="https://github.com/user-attachments/assets/6e104e08-921a-449c-8345-766019c7304e" />


#### 3.2 自定义配置
默认情况下，openwrt和lede后台地址都是192.168.1.1，有没有办法在编译的时候自定义呢？当然可以，只需要在编译的根目录下创建文件夹files，然后往里面添加初始化脚本即可。files相当于路由器的根目录  
```
mkdir -p files/etc/uci-defaults
```
假设我们要自定义ip地址
```
vim files/etc/uci-defaults/99-custom
```
往里面添加内容
```
uci -q batch << EOI
set network.lan.ipaddr='192.168.30.101'
set network.lan.dns='192.168.30.1'
set network.lan.gateway='192.168.30.1'
delete uhttpd.main.listen_https
EOI
```
- 注意到我这里删掉了uhttpd的https监听地址，原因是lede默认没有安装luci-app-openssl，如果不关闭https监听会无法启动web界面（仅x86）

开始编译固件 （-j 后面是线程数）  
```
make download -j8
make -j$(nproc)
```
如果发现编译出错，那么可以使用单线程编译，并输出详细信息。大部分情况下的首次编译出现错误都是网络问题  
```
make -j1 V=s
```
编译完成后，可以在bin/target/平台目录下看到自己编译后的包，其中 `xxx-squashfs-sysupgrade.bin` 就是我们要的固件  

<img width="1043" height="254" alt="dopb16" src="https://github.com/user-attachments/assets/cbfb9f3c-8b46-442a-977a-a12dcd564fcc" />


#### 3.3 集成插件编译
经过前面的首次编译后，一些基础的包都已经编译完成，再次编译时候会跳过他们。此时选择自己需要的插件编译速度，就取决于插件本身  
```
make menuconfig
```
选择自己的插件后
```
make download -j$(nproc)
make -j$(nproc)
```
注意，勾选luci应用后，依赖会自动勾选上，此时再次取消勾选luci，依赖不会取消，如果需要重新配置，请删掉`.config`  
```
rm -rf .config
make menuconfig
make -j$(nproc)
```
或者再选择插件前，先备份一下 `.config`  
```
cp .config .config.backup
```


#### 3.4 拓展包

一些发行版会添加自己的拓展包，例如lede和immortalWRT的代码中都有automount和autosamba，但是这些官方openwrt是没有的  


##### 3.4.1 ipv6支持

默认情况下lede的代码没有勾选ipv6-helper，请到 Extra pckages勾选ipv6-helper


##### 3.4.2 自动挂载

Extra packages -> automount


##### 3.4.3 自动网络共享

Extra packages -> autosamb

注意：这个脚本有BUG，在RAX3000M-emmc勾选了此拓展包会导致无线网络消失。删除后才能恢复，因此不建议使用此拓展包。详细信息： https://github.com/immortalwrt/immortalwrt/issues/1201  

- 参考： https://github.com/coolsnowwolf/lede


#### 3.5 添加第三方插件源
与openwrt的相同，请参考上面



### 4 docker编译immortalwrt
- 地址： https://github.com/immortalwrt/immortalwrt
- 简介： immortalwrt甚至集成了很多第三方的软件包，无需额外添加软件源，感觉更方便，编译步骤和lede一样，过程不再赘述


#### 4.1 构建镜像


##### 4.1.1 准备Dockerfile文件
Dockerfile文件，根据官网描述，建议基于ubuntu20.04-LTS，那么第一行的FROM就要改了  
```
FROM ubuntu:20.04
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive  apt install -y \
  sudo ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
  bzip2 ccache clang cmake cpio curl device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib \
  g++-multilib git gnutls-dev gperf haveged help2man intltool lib32gcc-s1 libc6-dev-i386 libelf-dev \
  libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5 \
  libncursesw5-dev libpython3-dev libreadline-dev libssl-dev libtool lld llvm lrzsz mkisofs msmtp \
  nano ninja-build p7zip p7zip-full patch pkgconf python2.7 python3 python3-pip python3-ply \
  python3-docutils python3-pyelftools qemu-utils re2c rsync scons squashfs-tools subversion swig \
  texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev 

RUN apt-get clean && \
    useradd -m user && \
    echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

# set system wide dummy git config
RUN git config --system user.name "user" && git config --system user.email "user@example.com"

USER user
WORKDIR /home/user
```
注意到这里还加了一行 `DEBIAN_FRONTEND=noninteractive`，防止创建镜像的过程出现交互行为  
```
docker build -t immortalwrt_builder .
```


##### 4.1.2 创建容器
```
docker run -itd --name iwt_builder -v ~/iwt_builder:/home/user immortalwrt_builder
```


##### 4.1.3 进入容器
```
docker exec -it iwt_builder bash
```
注意，docker里面的ubuntu系统需要修改用户目录权限给user才能下载源代码
```
sudo chown -R user:user .
```


#### 4.2 首次编译
下载源代码
```
git clone -b openwrt-23.05 --single-branch --filter=blob:none https://github.com/immortalwrt/immortalwrt
cd immortalwrt
```
- 选择哪个分区可以在这里找 https://github.com/immortalwrt/immortalwrt/branches/active

安装feeds
```
./scripts/feeds update -a
./scripts/feeds install -a
```

编译菜单，同样，先别选择插件，仅选择你的平台即可！
```
make menuconfig
```
首次编译
```
make -j$(nproc)
```
选择插件后再次编译
```
make menuconfig
make -j$(nproc)
```


### 5 编译的一些技巧

#### 5.1 make选项

##### 5.1.1 当多线程编译失败时，可以使用以下命令单线程编译，仅关注错误信息
<pre>
make V=s 2>&1 | tee build.log | grep -i -E "^make.*(error|[12345]...Entering dir)"
</pre>

另一种方法是检查相应的 `logs` 文件夹，如 `make[3] -C package/kernel/mac80211 compile`，那么可以转到`<buildroot>/logs/package/kernel/mac80211` 查看 `compile.txt`  


##### 5.1.2 报错时发出声音
```
make ...; echo -e '\a'
```


##### 5.1.3 忽视某个包的错误，继续编译其他包
加入某个包编译错误了
<pre>
# Ignore compilation errors
IGNORE_ERRORS=1 make ...
 
# Ignore all errors including firmware assembly stage
make -i ...
</pre>


#### 5.2 tmux多窗口

- 如果是远程ssh连接服务器编译，最好使用 `tmux`，可以多窗口，且ssh断掉后进程不会中断，再次ssh进入服务器可以回到tmux会话。 创建一个名称为openwrt的session

```
tmux new -s openwrt
```

面板垂直分割，键盘按下快捷键。以下 `<prefix>` 表示同时按下 `Ctrl + B`  
- 例如下面这个命令，表示同时按下 `Ctrl + B` 后，松开键盘，再按下 `%`

```
<prefix> + %
```

面板水平分割
```
<prefix> + "
```

退出tmux，但不退出tmux的进程
```
<prefix>  + Q
```

回到tmux
```
tmux attach
```

### tmux小技巧

#### 1 常用操作

##### 1.1 tmux会话操作

- 创建会话 `tmux new -t <session_name>`
- 退出会话 `Ctrl + B` 然后按下 `D`
- 回到会话 `tmux attach`

##### 1.2 tmux窗口操作

- 创建窗口 `Ctrl + B` 然后按下 `C`
- 窗口列表 `Ctrl + B`, `W`
- 切换下一个窗口 `Ctrl + B`, 然后按下 `N`
- 切换上一个窗口 `Ctrl + B`, 然后按下 `P`

##### 1.3 tmux 面板操作

- 垂直分割 `Ctrl + B`, `%`
- 水平分割 `Ctrl + B`, `"`
- 切换布局 `Ctrl + B`, `<space>`
- 调整窗口大小 `Ctrl + B` 按住不松手同时按下 `<上|下|左|右>`
- 关掉面板 `Ctrl + B`, `X`
- 当前面板全屏 `Ctrl + B`, `Z`, 再次使用 `Ctrl + B`, `Z` 则退出全屏模式

##### 1.4 tmux滚动 `Ctrl + B`, `[`

#### 2 配置文件

##### 2.1 tmux复制粘贴
如果要复制粘贴，则把要复制的那个窗口调整成全屏模式 `Ctrl + B + Z` 然后复制，接着退出全屏模式即可。后面的可以不用看了，改配置是最麻烦且容易出错的  

tmux默认的复制粘贴有点反人类，用鼠标直接复制的格式是错误的。添加下面的配置到 `~/.tmux.conf` 开启vi复制模式  

https://unix.stackexchange.com/questions/318281/how-to-copy-and-paste-with-a-mouse-with-tmux  

```
# Linux only
set -g mouse on
bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
bind -n WheelDownPane select-pane -t= \; send-keys -M
bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

# To copy, left click and drag to highlight text in yellow, 
# once you release left click yellow text will disappear and will automatically be available in clibboard
# # Use vim keybindings in copy mode
setw -g mode-keys vi
# Update default binding of `Enter` to also use copy-pipe
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection c"
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
```
使得配置生效
```
tmux source-file ~/.tmux.conf
```
然后回到session，按下 `shift`，左键选择文本复制即可


##### 2.1.1 方法二：复制插件 tmux-yank

首先安装插件管理 tpm
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
使得插件管理生效，添加以下代码到~/.tmux.conf
```
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'github_username/plugin_name#branch'
# set -g @plugin 'git@github.com:user/plugin'
# set -g @plugin 'git@bitbucket.com:user/plugin'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```
使得tpm生效
```
tmux source ~/.tmux.conf
```
接下来安装tmux-yank，网~/.tmux.conf中间添加
```
set -g @plugin 'tmux-plugins/tmux-yank'
```
打开tmux，输入 `Ctrl + B` 然后按下 `I`，开始安装插件  

##### 2.1.2 怎么复制？
添加两行
```
setw -g mode-keys vi
set -g mouse on
```
按下 `Ctr + B` 再按下  


#### 2.2 tmux 设置开启用鼠标设置窗口大小
```
set -g mouse on
```








