# OpenWrt常用命令

## 查看系统信息

查看内核版本
```bash
uname -a
```
查看系统架构
```bash
uname -m
```
查看系统信息
```bash
cat /proc/version
```
查看CPU信息
```bash
cat /proc/cpuinfo
```
查看内存信息
```bash
cat /proc/meminfo
```
查看内存使用情况
```bash
free -m
```
查看磁盘空间
```bash
df -h
```
查看挂载点
```bash
mount
```
检查 WAN 口的 DHCP 信息
```bash
ifstatus wan | grep -A 5 "dns"
```

### 全局应用设置web倒计时
```bash
uci set luci.apply.holdoff='1'
uci commit luci
```

### 修复OpenWrt /overlay挂载错误导致系统只读
```bash
mount -o remount,rw /
```

### 修复识别内存错误导致tmp小于内存
```bash
mount -o remount,size=$(awk '/MemTotal/ {print $2"k"}' /proc/meminfo) /tmp
```

### 查看系统在接受连接时最大允许的连接排队长度 默认4096 最大65535
```bash
sysctl net.core.somaxconn
```
变更命令
```bash
sysctl -w net.core.somaxconn=65535
```

### 查看未完成握手（SYN）的连接请求队列的最大长度 默认128 最大4096
```bash
sysctl net.ipv4.tcp_max_syn_backlog
```
变更命令
```bash
sysctl -w net.ipv4.tcp_max_syn_backlog=4096
```

### 查看TCP 连接在处于 FIN_WAIT2 状态时的超时时间 默认30秒 最小1
```bash
sysctl net.ipv4.tcp_fin_timeout
```
变更命令(**不推荐**)
```bash
sysctl -w net.ipv4.tcp_fin_timeout=1
```

### TCP 读取缓冲区的大小，分别是最小、默认和最大值 默认 4096 131072 6291456
```bash
sysctl net.ipv4.tcp_rmem
```
变更命令
```bash
sysctl -w net.ipv4.tcp_rmem="4096 87380 16777216"
```

### TCP 读取缓冲区的大小，分别是最小、默认和最大值 默认 4096 16384 4194304
```bash
sysctl net.ipv4.tcp_wmem
```
变更命令
```bash
sysctl -w net.ipv4.tcp_wmem="4096 65536 16777216"
```

### 设置终端环境编码UTF-8
```bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

### 查看监听端口 以TCP类型为例
```bash
netstat -tuln | grep tcp
```

### 查看监听端口 以TCP类型 443端口为例
```bash
netstat -tuln | grep ':443'
```
或者
```bash
netstat -lptn
```
查看监听端口 443端口为例
```bash
netstat -lptn | grep ':443'
```

### 查看npu占用
```bash
cat /sys/kernel/debug/qca-nss-drv/stats/cpu_load_ubi
```

### 查看EMMC寿命
```bash
var="$(cat /sys/kernel/debug/mmc0/mmc0\:0001/ext_csd)"
eol=${var:534:2};slc=${var:536:2};mlc=${var:538:2}
echo "EOL:0x$eol SLC:0x$slc MLC:0x$mlc"
```

### 详细的查看内存占用
```bash
free -k | awk 'NR==1{printf "Memory (MB):\n"} NR==2{printf "Total: %.2f MB\nUsed: %.2f MB\nFree: %.2f MB\nShared: %.2f MB\nBuff/Cache: %.2f MB\nAvailable: %.2f MB\n", $2/1024, $3/1024, $4/1024, $5/1024, $6/1024, $7/1024} NR==3{printf "Swap (MB):\nTotal: %.2f MB\nUsed: %.2f MB\nFree: %.2f MB\n", $2/1024, $3/1024, $4/1024}'
```

### 重启wifi 以AX1800Pro举例radio0是5G radio1是2.4G
```bash
cat /etc/config/wireless
```
```bash
uci set wireless.radio0.disabled='1'
uci commit wireless
wifi reload
uci set wireless.radio0.disabled='0'
uci commit wireless
wifi reload
```

### 检查 eBPF 相关的功能是否加载
```bash
lsmod | grep bpf
```

### 查看已加载的 BPF 程序
```bash
bpftool prog show
```

### 查看 BPF maps（共享内存区）
```bash
bpftool map show
```

### 检查 BBR 是否启用
```bash
sysctl net.ipv4.tcp_congestion_control
```
修改拥塞控制算法为`cubic`  
```bash
sysctl -w net.ipv4.tcp_congestion_control=cubic
```
修改拥塞控制算法为`bbr`  
```bash
sysctl -w net.ipv4.tcp_congestion_control=bbr
```

### 验证 CAKE 是否工作
```bash
tc -s qdisc | grep cake
```

### 刷写Uboot
```bash
dd if=/root/u-boot.mbn of=/dev/mmcblk0p13 
dd if=/root/u-boot.mbn of=/dev/mmcblk0p14
```

### 在运行程序时绑定 CPU 核 将程序绑定到 0 号和 2 号 CPU 核运行
```bash
taskset -c 0,2 ./my_program
```

### 修改运行中的进程 给已有的进程设置 CPU 亲和性
```bash
taskset -cp 0 <pid>
```

## 安装Warp
**解决挂载问题**  
### 新建storage分区
```bash
sgdisk -e -n 0:0:0 -c 0:storage -t 0:1B1720DA-A8BB-4B6F-92D2-0A93AB9609CA -p /dev/mmcblk0
```
重启路由器
```bash
reboot
```
格式化storage分区
```bash
mkfs.ext4 $(blkid -t PARTLABEL=storage -o device)
```
重启路由器
```bash
reboot
```
获取Cloudflare ip列表
```bash
{ curl -s https://www.cloudflare.com/ips-v4; echo; curl -s https://www.cloudflare.com/ips-v6; } | tee
```

### 安装Java(Linux X86)
```bash
#!/bin/bash

# 配置参数（按需修改）
INSTALL_DIR="/data/java"  # 安装目录
JAVA_VERSION="21"         # 指定JDK主版本
USE_SUDO="false"           # 是否使用sudo操作

# 自动检测系统架构
ARCH=$(uname -m)
case $ARCH in
    x86_64)  PKG_ARCH="x64" ;;
    aarch64) PKG_ARCH="aarch64" ;;
    *)       echo "不支持的架构: $ARCH"; exit 1 ;;
esac

# 验证下载地址格式
DOWNLOAD_URL="https://download.oracle.com/graalvm/${JAVA_VERSION}/latest/graalvm-jdk-${JAVA_VERSION}_linux-${PKG_ARCH}_bin.tar.gz"
echo "检测到架构: $ARCH => 使用下载地址: $DOWNLOAD_URL"

# 创建安装目录
echo "创建安装目录: $INSTALL_DIR"
if [ "$USE_SUDO" = "true" ]; then
    sudo mkdir -p $INSTALL_DIR || { echo "目录创建失败"; exit 1; }
else
    mkdir -p $INSTALL_DIR || { echo "目录创建失败"; exit 1; }
fi

# 下载安装包
echo "正在下载GraalVM JDK..."
if ! curl -fL -o /tmp/graalvm-jdk.tar.gz \
    --progress-bar \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    "$DOWNLOAD_URL"; then
    echo "下载失败，请检查："
    echo "1. 版本号是否正确（当前配置版本：$JAVA_VERSION）"
    echo "2. 网络连接是否正常"
    exit 1
fi

# 解压安装包
echo "正在解压到 $INSTALL_DIR..."
if [ "$USE_SUDO" = "true" ]; then
    sudo tar -xz -C $INSTALL_DIR -f /tmp/graalvm-jdk.tar.gz
else
    tar -xz -C $INSTALL_DIR -f /tmp/graalvm-jdk.tar.gz
fi
rm /tmp/graalvm-jdk.tar.gz

# 自动查找JDK目录
echo "正在定位JDK目录..."
JAVA_HOME=$(find $INSTALL_DIR -maxdepth 1 -type d -name "*jdk-${JAVA_VERSION}*" | sort -V | tail -n 1)

# 验证安装结果
if [ -z "$JAVA_HOME" ]; then
    echo "错误：未能找到JDK目录，请检查："
    echo "1. 下载文件是否完整"
    echo "2. 解压后的目录结构"
    find $INSTALL_DIR
    exit 1
fi
echo "检测到JAVA_HOME: $JAVA_HOME"

# 设置环境变量
echo "配置系统环境变量..."
ENV_FILE="/etc/profile.d/graalvm.sh"
if [ "$USE_SUDO" = "true" ]; then
    sudo tee $ENV_FILE > /dev/null <<EOF
export JAVA_HOME="$JAVA_HOME"
export PATH="\$JAVA_HOME/bin:\$PATH"
export CLASSPATH=".:\$JAVA_HOME/lib"
EOF
    sudo chmod 644 $ENV_FILE
else
    tee $ENV_FILE > /dev/null <<EOF
export JAVA_HOME="$JAVA_HOME"
export PATH="\$JAVA_HOME/bin:\$PATH"
export CLASSPATH=".:\$JAVA_HOME/lib"
EOF
fi

# 创建软链接
echo "创建Java命令软链接..."
if [ "$USE_SUDO" = "true" ]; then
    sudo ln -sf "$JAVA_HOME/bin/java" /usr/bin/java
    sudo ln -sf "$JAVA_HOME/bin/javac" /usr/bin/javac
else
    mkdir -p $HOME/bin
    ln -sf "$JAVA_HOME/bin/java" $HOME/bin/java
    ln -sf "$JAVA_HOME/bin/javac" $HOME/bin/javac
fi

# 生效环境变量
echo "立即生效环境变量..."
source $ENV_FILE

# 验证安装
echo "安装验证："
java -version 2>&1 | grep "GraalVM" || { echo "版本验证失败"; exit 1; }

echo "安装完成！"
echo "JAVA_HOME 设置为: $JAVA_HOME"
```

### 安装Java(Linux AARCH64)
```bash
mkdir -p /data/java

cd /data/java

wget https://download.oracle.com/graalvm/21/latest/graalvm-jdk-21_linux-aarch64_bin.tar.gz

tar -zxvf graalvm-jdk-21_linux-aarch64_bin.tar.gz -C /data/java

export JAVA_DIR=/data/java
export JAVA_HOME=$(find $JAVA_DIR -maxdepth 1 -type d -name "*jdk-*" | sort -V | tail -n 1)

# 确保找到了 JDK 目录
echo "Detected JAVA_HOME: $JAVA_HOME"

# 如果找不到，手动检查目录
if [ -z "$JAVA_HOME" ]; then
    echo "ERROR: JDK not found in $JAVA_DIR!"
    exit 1
fi

# 追加到 /etc/profile
echo "export JAVA_DIR=$JAVA_DIR" | tee -a /etc/profile
echo "export JAVA_HOME=$JAVA_HOME" | tee -a /etc/profile
echo 'export PATH=$JAVA_HOME/bin:$PATH' | tee -a /etc/profile
echo 'export CLASSPATH=.:$JAVA_HOME/lib' | tee -a /etc/profile

# 软链接 Java 到 /usr/bin/java
ln -sf $JAVA_HOME/bin/java /usr/bin/java

# 重新加载环境变量
source /etc/profile
```

### 安装Golang
```bash
#!/bin/bash

# 安装目标目录
INSTALL_DIR="/data/go"

# 获取最新版本号
LATEST_VER=$(curl -s https://go.dev/VERSION?m=text | head -1)
echo "最新版本: $LATEST_VER"

# 检测系统架构并映射Go版本后缀
ARCH=$(uname -m)
case $ARCH in
    x86_64)  GO_ARCH="amd64" ;;
    aarch64) GO_ARCH="arm64" ;;
    armv7l)  GO_ARCH="armv6l" ;;
    armv6l)  GO_ARCH="armv6l" ;;
    *)       echo "不支持的架构: $ARCH"; exit 1 ;;
esac

echo "检测到架构: $ARCH => 使用Go编译版本: $GO_ARCH"

# 下载地址
DOWNLOAD_URL="https://dl.google.com/go/${LATEST_VER}.linux-${GO_ARCH}.tar.gz"
echo "下载地址: $DOWNLOAD_URL"

# 创建安装目录
mkdir -p $INSTALL_DIR || { echo "创建目录失败"; exit 1; }

# 下载并解压
echo "正在下载并安装..."
curl -OL $DOWNLOAD_URL || { echo "下载失败"; exit 1; }
tar -C $INSTALL_DIR -xzf ${LATEST_VER}.linux-${GO_ARCH}.tar.gz || { echo "解压失败"; exit 1; }

# 整理目录结构（处理自带的go/子目录）
if [ -d "$INSTALL_DIR/go" ]; then
    echo "调整目录结构..."
    mv $INSTALL_DIR/go/* $INSTALL_DIR/
    rmdir $INSTALL_DIR/go
fi

# 设置环境变量
echo "设置环境变量..."
echo "export GOROOT=$INSTALL_DIR" >> /etc/profile
echo "export PATH=\$PATH:$INSTALL_DIR/bin" >> /etc/profile
source /etc/profile

# 验证安装
echo "验证安装:"
go version || { echo "安装验证失败"; exit 1; }

# 清理安装包
rm ${LATEST_VER}.linux-${GO_ARCH}.tar.gz

echo "安装完成！GOROOT 设置为 $INSTALL_DIR"
```

### 实时查看某程序的日志
```bash
tail -f /tmp/youxuan.log
```