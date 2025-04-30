#!/bin/bash

# 检查是否为root用户
if [ "$(id -u)" != "0" ]; then
   echo "此脚本必须以root权限运行" 1>&2
   exit 1
fi

# 定义颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查Docker是否安装
check_docker_installed() {
    if command -v docker &> /dev/null || \
       [ -f /usr/bin/docker ] || \
       [ -f /usr/local/bin/docker ] || \
       systemctl list-unit-files | grep -q docker.service; then
        return 0
    else
        return 1
    fi
}

# 显示菜单
show_menu() {
    echo -e "${GREEN}"
    echo "=============================================="
    echo "           Docker 管理脚本"
    echo "=============================================="
    echo "1. 安装 Docker"
    echo "2. 卸载 Docker"
    echo "0. 退出"
    echo "=============================================="
    echo -e "${NC}"
}

# 确认函数(回车默认为y)
confirm() {
    read -p "$1 [Y/n]: " response
    case "$response" in
        [nN][oO]|[nN]) 
            return 1
            ;;
        *)
            return 0  # 包括空输入(直接回车)的情况
            ;;
    esac
}

# 获取系统架构和对应的Docker下载URL
get_docker_url() {
    # 获取系统架构
    local arch=$(uname -m)
    local mirrors=(
        "https://download.docker.com/linux/static/stable"
        "https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/static/stable"
        "https://mirrors.pku.edu.cn/docker-ce/linux/static/stable"
    )
    
    # 映射架构到Docker的架构命名
    case "$arch" in
        x86_64)
            arch_suffix="x86_64"
            ;;
        aarch64|arm64)
            arch_suffix="aarch64"
            ;;
        armv7l|armhf)
            arch_suffix="armhf"
            ;;
        armv6l)
            arch_suffix="armel"
            ;;
        s390x)
            arch_suffix="s390x"
            ;;
        ppc64le)
            arch_suffix="ppc64le"
            ;;
        *)
            echo -e "${RED}不支持的架构: $arch${NC}" >&2
            return 1
            ;;
    esac
    
    # 检查镜像源可用性并返回第一个可用的URL
    for mirror in "${mirrors[@]}"; do
        local url="$mirror/$arch_suffix"
        if curl --output /dev/null --silent --head --fail "$url"; then
            echo "$url"
            return 0
        fi
    done
    
    echo -e "${RED}所有镜像源均不可用，请检查网络连接。${NC}" >&2
    return 1
}

# 安装Docker
install_docker() {
    # 检查是否已安装 Docker
    if check_docker_installed; then
        echo -e "${YELLOW}Docker 已安装在系统中。${NC}"
        docker --version
        if ! confirm "是否需要重新安装 Docker？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return
        fi
    else
        echo -e "${YELLOW}未检测到 Docker 环境。${NC}"
        if ! confirm "是否需要安装 Docker？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return
        fi
    fi

    echo -e "${GREEN}开始安装 Docker...${NC}"

    # 获取适合当前系统的Docker下载URL
    base_url=$(get_docker_url)
    if [ $? -ne 0 ]; then
        echo -e "${RED}无法确定适合您系统的Docker版本。${NC}"
        return 1
    fi

    echo -e "${BLUE}检测到系统架构: $(uname -m)${NC}"
    echo -e "${BLUE}使用Docker镜像源: $base_url${NC}"

    # 获取最新的Docker版本
    echo -e "${YELLOW}获取最新的Docker版本...${NC}"
    package_name=$(wget -qO- "$base_url" | grep -oP '(?<=href=")docker-\d+\.\d+\.\d+\.tgz' | sort -V | tail -n 1)
    
    if [ -z "$package_name" ]; then
        echo -e "${RED}无法获取最新的Docker版本，请检查网络连接或手动下载。${NC}"
        return 1
    fi

    download_url="$base_url/$package_name"
    echo -e "${GREEN}最新版本的Docker安装包为: $package_name${NC}"

    # 检查当前目录下是否存在安装包
    if [ ! -f "$package_name" ]; then
        echo -e "${YELLOW}安装包 $package_name 不存在，正在下载...${NC}"
        if ! wget "$download_url"; then
            echo -e "${RED}下载失败，请检查网络连接或URL是否正确。${NC}"
            return 1
        fi
        echo -e "${GREEN}安装包 $package_name 下载成功。${NC}"
    else
        echo -e "${GREEN}安装包 $package_name 已存在，跳过下载。${NC}"
    fi

    # 解压Docker安装包
    echo -e "${YELLOW}解压Docker安装包...${NC}"
    tar -zxvf "$package_name"

    # 将Docker可执行文件复制到/usr/bin/
    echo -e "${YELLOW}复制Docker可执行文件...${NC}"
    cp docker/* /usr/bin/

    # 创建并编辑Docker systemd服务文件
    echo -e "${YELLOW}创建Docker服务文件...${NC}"
    cat > /etc/systemd/system/docker.service <<EOF
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP \$MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
EOF

    # 给予执行权限
    chmod 755 /etc/systemd/system/docker.service

    # 重新加载systemd配置
    systemctl daemon-reload

    # 启动Docker服务
    systemctl start docker

    # 设置Docker服务开机启动
    systemctl enable docker

    # 等待Docker服务启动完成
    echo -e "${YELLOW}等待Docker服务启动完成...${NC}"
    timeout 30 bash -c 'while ! systemctl is-active --quiet docker; do sleep 1; done'
    if [ $? -ne 0 ]; then
        echo -e "${RED}Docker服务启动失败，请检查日志。${NC}"
        return 1
    fi

    # 查看Docker版本
    echo -e "${YELLOW}正在检查Docker版本...${NC}"
    docker_version=$(docker -v 2>&1)
    if [ $? -ne 0 ]; then
        echo -e "${RED}无法获取Docker版本信息，请检查Docker服务是否正常运行。${NC}"
        return 1
    fi

    echo -e "${GREEN}Docker安装完成，版本信息如下：${NC}"
    echo "$docker_version"

    # 提示用户是否删除下载的安装包
    if confirm "是否删除当前目录下的安装包 $package_name？"; then
        rm -f "$package_name"
        echo -e "${GREEN}安装包 $package_name 已删除。${NC}"
    else
        echo -e "${GREEN}安装包 $package_name 保留。${NC}"
    fi
}

# 卸载Docker
uninstall_docker() {
    echo -e "${GREEN}"
    echo "=============================================="
    echo "           Docker 卸载警告"
    echo "=============================================="
    echo -e "${NC}此操作将执行以下步骤："
    echo "1. 停止Docker服务"
    echo "2. 禁用Docker开机自启"
    echo "3. 删除Docker相关可执行文件"
    echo "4. 删除Docker配置文件"
    echo "5. 删除Docker systemd服务文件"
    echo ""
    echo -e "${RED}注意：默认情况下不会删除/var/lib/docker目录，这包含所有的镜像、容器和卷数据。${NC}"
    echo -e "${GREEN}=============================================="
    echo -e "${NC}"

    if ! check_docker_installed; then
        echo -e "${RED}未检测到Docker安装，无需卸载。${NC}"
        return
    fi

    echo -e "${GREEN}检测到系统已安装Docker。${NC}"
    docker --version

    if ! confirm "确定要卸载Docker吗"; then
        echo -e "${GREEN}已取消卸载操作。${NC}"
        return
    fi

    echo -e "${GREEN}开始卸载Docker...${NC}"
    
    # 停止Docker服务
    if systemctl is-active --quiet docker; then
        echo -e "${YELLOW}停止Docker服务...${NC}"
        systemctl stop docker
    fi
    
    # 禁用Docker开机自启动
    if systemctl is-enabled --quiet docker; then
        echo -e "${YELLOW}禁用Docker开机自启...${NC}"
        systemctl disable docker
    fi
    
    # 删除systemd服务文件
    local service_files=(
        /etc/systemd/system/docker.service
        /lib/systemd/system/docker.service
        /usr/lib/systemd/system/docker.service
    )
    
    for file in "${service_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${YELLOW}删除Docker服务文件: $file${NC}"
            rm -f "$file"
        fi
    done
    
    # 删除Docker相关可执行文件
    local exec_files=(
        /usr/bin/containerd
        /usr/bin/containerd-shim
        /usr/bin/ctr
        /usr/bin/runc
        /usr/bin/docker
        /usr/bin/dockerd
        /usr/local/bin/docker
        /usr/local/bin/dockerd
    )
    
    for file in "${exec_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${YELLOW}删除可执行文件: $file${NC}"
            rm -f "$file"
        fi
    done
    
    # 删除Docker配置文件
    if [ -d /etc/docker ]; then
        echo -e "${YELLOW}删除Docker配置文件目录...${NC}"
        rm -rf /etc/docker
    fi
    
    # 重新加载systemd
    systemctl daemon-reload
    
    # 询问是否删除Docker数据目录
    if confirm "是否要删除Docker数据目录(/var/lib/docker)？这将删除所有镜像、容器和卷数据"; then
        echo -e "${YELLOW}删除Docker数据目录...${NC}"
        rm -rf /var/lib/docker
    else
        echo -e "${GREEN}保留Docker数据目录(/var/lib/docker)${NC}"
    fi
    
    echo -e "${GREEN}Docker卸载完成!${NC}"
    
    # 直接提示按回车重启脚本
    read -p "按回车键重启脚本..."
    exec "$0" "$@"
}

# 主程序
main() {
    while true; do
        show_menu
        read -p "请选择操作 (1安装/2卸载/0退出): " choice
        
        case "$choice" in
            1)
                install_docker
                ;;
            2)
                uninstall_docker
                ;;
            0|"")
                echo -e "${GREEN}退出脚本。${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入。${NC}"
                ;;
        esac
        
        read -p "按回车键继续..."
    done
}

main