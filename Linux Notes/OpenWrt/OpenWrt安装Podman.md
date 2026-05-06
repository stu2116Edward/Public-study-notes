# openwrt安装podman

注意软件包扩容到`/overlay`
1. 找到openwrt系统界面的 `[系统]` - `[挂载点]`，找到这个大容量的设备，点击编辑按钮

<img width="2505" height="1305" alt="屏幕截图 2026-05-06 115435" src="https://github.com/user-attachments/assets/725bd6eb-0190-4e5b-98b0-eb5734c5caee" />

2. 在编辑窗口中，勾选`启用`，UUID选择好这个大容量设备，挂载点选/overlay，接着点击保存

<img width="2263" height="592" alt="屏幕截图 2026-05-06 115453" src="https://github.com/user-attachments/assets/73f2ba08-80f4-4ca9-a458-3d8dd58a6e11" />

3. 重启一下路由器

<img width="924" height="1278" alt="屏幕截图 2026-05-06 115522" src="https://github.com/user-attachments/assets/37f97484-e9b8-4915-a208-9b21ec5af176" />

<pre>
[root@Kwrt:11:26 AM ~] # df -h
Filesystem                Size      Used Available Use% Mounted on
/dev/root                52.0M     52.0M         0 100% /rom
tmpfs                   239.5M    512.0K    239.0M   0% /tmp
/dev/mmcblk0p12          55.9G    171.7M     52.8G   0% /overlay
overlayfs:/overlay       55.9G    171.7M     52.8G   0% /
tmpfs                   512.0K         0    512.0K   0% /dev
/dev/mmcblk0p9           56.7M     17.0K     52.2M   0% /mnt/mmcblk0p9
/dev/mmcblk0p10           7.6M      7.6M         0 100% /mnt/mmcblk0p10
/dev/mmcblk0p11           7.6M      7.6M         0 100% /mnt/mmcblk0p11
/dev/mmcblk0p7           14.0M     14.0M         0 100% /mnt/mmcblk0p7
/dev/mmcblk0p8          254.0M     85.4M    168.6M  34% /mnt/mmcblk0p8
</pre>
可以发现 `/` 根目录和 `/overlay` 目录的可使用空间是一样的

### 1. 安装podman
```
opkg update
opkg install podman
```

### 2. 配置存储
```
mkdir -p /overlay/podman/storage
cat > /etc/containers/storage.conf <<EOF
[storage]
driver = "overlay"
runroot = "/overlay/podman/run"
graphroot = "/overlay/podman/storage"
EOF
```

### 3. 测试运行
```
podman run --rm hello-world
```
