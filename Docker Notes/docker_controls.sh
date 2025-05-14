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

# 定义镜像源列表
MIRRORS=(
    "https://mirrors.aliyun.com/docker-ce/linux/static/stable"
    "https://mirrors.tencent.com/docker-ce/linux/static/stable"
    "https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/static/stable"
    "https://mirrors.ustc.edu.cn/docker-ce/linux/static/stable"
    "https://download.docker.com/linux/static/stable"
    "https://mirrors.pku.edu.cn/docker-ce/linux/static/stable"
)

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
    echo "3. 安装指定版本的 Docker"
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

# 获取系统架构
get_system_arch() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "aarch64"
            ;;
        armv7l|armhf)
            echo "armhf"
            ;;
        armv6l)
            echo "armel"
            ;;
        s390x)
            echo "s390x"
            ;;
        ppc64le)
            echo "ppc64le"
            ;;
        *)
            echo -e "${RED}不支持的架构: $arch${NC}" >&2
            return 1
            ;;
    esac
}

# 获取所有可用的Docker版本并缓存
get_all_docker_versions() {
    local base_url=$1
    wget -qO- "$base_url" | grep -oP 'docker-\d+\.\d+\.\d+\.tgz' | sed 's/docker-\(.*\)\.tgz/\1/' | sort -Vru 2>/dev/null
}

# 按列显示版本信息
display_versions_in_columns() {
    local versions=("$@")
    local columns=5  # 每行显示的列数
    local total=${#versions[@]}
    local rows=$(( (total + columns - 1) / columns ))

    for ((i = 0; i < rows; i++)); do
        for ((j = i; j < total; j += rows)); do
            printf "%-15s" "$((j + 1))) ${versions[j]}"
        done
        echo
    done
}

# 安装Docker（支持安装最新版本或指定版本）
install_docker() {
    local specific_version=$1

    # 检查是否已安装 Docker
    if check_docker_installed; then
        echo -e "${YELLOW}Docker 已安装在系统中。${NC}"
        docker --version
        if ! confirm "是否需要卸载现有 Docker 并重新安装？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return
        fi

        # 用户确认重新安装，先执行卸载操作
        echo -e "${YELLOW}开始卸载现有 Docker 环境...${NC}"
        uninstall_docker
        if [ $? -ne 0 ]; then
            echo -e "${RED}卸载 Docker 失败，请检查错误信息。${NC}"
            return 1
        fi
        echo -e "${GREEN}现有 Docker 环境已成功卸载，继续进行安装。${NC}"
    else
        echo -e "${YELLOW}未检测到 Docker 环境。${NC}"
        if ! confirm "是否需要安装 Docker？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return
        fi
    fi

    echo -e "${GREEN}开始安装 Docker...${NC}"

    # 获取系统架构
    arch_suffix=$(get_system_arch)
    if [ $? -ne 0 ]; then
        echo -e "${RED}无法确定适合您系统的Docker版本。${NC}"
        return 1
    fi

    echo -e "${BLUE}检测到系统架构: $(uname -m)${NC}"

    local package_name=""
    local working_mirror=""

    if [ -z "$specific_version" ]; then
        # 获取最新版本
        for mirror in "${MIRRORS[@]}"; do
            local full_url="$mirror/$arch_suffix"
            echo -e "${YELLOW}尝试从镜像源获取版本: $full_url${NC}"
            package_name=$(wget -qO- "$full_url" | grep -oP 'docker-\d+\.\d+\.\d+\.tgz' | sort -Vr | head -n 1)
            if [ -n "$package_name" ]; then
                working_mirror="$full_url"
                echo -e "${GREEN}找到最新版本: $package_name${NC}"
                break
            fi
            echo -e "${YELLOW}镜像源 $full_url 无可用版本，尝试下一个...${NC}"
        done
    else
        # 获取指定版本
        for mirror in "${MIRRORS[@]}"; do
            local full_url="$mirror/$arch_suffix"
            echo -e "${YELLOW}尝试从镜像源获取版本: $full_url${NC}"
            if wget --spider "$full_url/docker-$specific_version.tgz" 2>/dev/null; then
                package_name="docker-$specific_version.tgz"
                working_mirror="$full_url"
                echo -e "${GREEN}找到指定版本: $package_name${NC}"
                break
            fi
            echo -e "${YELLOW}镜像源 $full_url 无可用版本，尝试下一个...${NC}"
        done
    fi

    if [ -z "$package_name" ]; then
        echo -e "${RED}无法获取Docker版本，请检查网络或手动下载。${NC}"
        return 1
    fi

    # 下载Docker安装包
    local download_url="$working_mirror/$package_name"
    echo -e "${YELLOW}正在下载 $package_name ...${NC}"
    if ! wget "$download_url"; then
        echo -e "${RED}下载失败，请检查网络连接。${NC}"
        return 1
    fi
    echo -e "${GREEN}安装包下载成功: $package_name${NC}"

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
}

# 主程序
main() {
    while true; do
        show_menu
        stty erase ^H  # 修复退格键问题
        read -p "请选择操作 (1安装/2卸载/3安装指定版本/0退出): " choice
        
        case "$choice" in
            1)
                install_docker
                ;;
            2)
                uninstall_docker
                ;;
            3)
                echo -e "${YELLOW}获取所有可用版本...${NC}"
                arch_suffix=$(get_system_arch)
                if [ $? -ne 0 ]; then
                    echo -e "${RED}无法确定系统架构。${NC}"
                    continue
                fi

                versions=()
                for mirror in "${MIRRORS[@]}"; do
                    versions+=($(get_all_docker_versions "$mirror/$arch_suffix"))
                    if [ ${#versions[@]} -gt 0 ]; then
                        break
                    fi
                done

                if [ ${#versions[@]} -eq 0 ]; then
                    echo -e "${RED}无法获取可用版本，请检查网络。${NC}"
                    continue
                fi

                echo -e "${GREEN}可用版本列表:${NC}"
                display_versions_in_columns "${versions[@]}"

                read -p "请输入要安装的版本编号: " version_choice
                if [[ "$version_choice" =~ ^[0-9]+$ ]] && [ "$version_choice" -ge 1 ] && [ "$version_choice" -le ${#versions[@]} ]; then
                    selected_version="${versions[$((version_choice - 1))]}"
                    install_docker "$selected_version"
                else
                    echo -e "${RED}无效的选择。${NC}"
                fi
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
