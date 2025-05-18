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
ORANGE='\033[38;5;208m'
NC='\033[0m' # No Color


# 确认函数(回车默认为y)
confirm() {
    while true; do
        read -p "$1 [Y/n]: " response
        case "$response" in
            [yY][eE][sS]|[yY]|"")
                return 0  # 包括空输入(直接回车)的情况
                ;;
            [nN][oO]|[nN])
                return 1
                ;;
            *)
                echo -e "${RED}无效输入，请输入 Y 或 N。${NC}"
                ;;
        esac
    done
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


# 定义Docker镜像源列表
DOCKER_MIRRORS=(
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
       [ -f /usr/local/bin/docker ]; then
        return 0
    else
        return 1
    fi
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


# Docker安装核心逻辑
install_docker_core() {
    local specific_version=$1

    # 检查是否已安装 Docker
    if check_docker_installed; then
        echo -e "${YELLOW}Docker 已安装在系统中。${NC}"
        if command -v docker &> /dev/null; then
            docker --version
        fi
        if ! confirm "是否需要卸载现有 Docker 并重新安装？"; then
            echo -e "${GREEN}用户选择保留现有Docker环境。${NC}"
            return 1
        fi

        # 用户确认重新安装，先执行卸载操作
        echo -e "${YELLOW}开始卸载现有 Docker 环境...${NC}"
        uninstall_docker_core
        # 卸载后刷新命令缓存，防止后续检测到残留
        hash -r
        # 重新检测，确保卸载后环境已清理
        if check_docker_installed; then
            echo -e "${RED}Docker卸载失败，请检查系统环境。${NC}"
            return 1
        fi
        echo -e "${GREEN}现有 Docker 环境已成功卸载。${NC}"

        # 卸载后提示用户是否继续安装
        if ! confirm "是否继续安装 Docker？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}未检测到 Docker 环境。${NC}"
        if ! confirm "是否需要安装 Docker？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return 1
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
    local download_url=""

    if [ -z "$specific_version" ]; then
        # 获取最新版本
        for mirror in "${DOCKER_MIRRORS[@]}"; do
            local full_url="$mirror/$arch_suffix"
            echo -e "${YELLOW}尝试从镜像源获取版本: $full_url${NC}"
            package_name=$(wget -qO- "$full_url" | grep -oP 'docker-\d+\.\d+\.\d+\.tgz' | sort -Vr | head -n 1)
            if [ -n "$package_name" ]; then
                working_mirror="$full_url"
                download_url="$working_mirror/$package_name"
                echo -e "${GREEN}找到最新版本: $package_name${NC}"
                break
            fi
            echo -e "${YELLOW}镜像源 $full_url 无可用版本，尝试下一个...${NC}"
        done
    else
        # 检查本地是否存在指定版本的安装包
        package_name="docker-$specific_version.tgz"
        if [ -f "$package_name" ]; then
            echo -e "${GREEN}在本地找到指定版本的安装包: $package_name${NC}"
        else
            # 获取指定版本
            for mirror in "${DOCKER_MIRRORS[@]}"; do
                local full_url="$mirror/$arch_suffix"
                echo -e "${YELLOW}尝试从镜像源获取版本: $full_url${NC}"
                if wget --spider "$full_url/$package_name" 2>/dev/null; then
                    working_mirror="$full_url"
                    download_url="$working_mirror/$package_name"
                    echo -e "${GREEN}找到指定版本: $package_name${NC}"
                    break
                fi
                echo -e "${YELLOW}镜像源 $full_url 无可用版本，尝试下一个...${NC}"
            done
        fi
    fi

    if [ -z "$package_name" ]; then
        echo -e "${RED}无法获取Docker版本，请检查网络或手动下载。${NC}"
        return 1
    fi

    # 下载Docker安装包（如果本地不存在）
    if [ ! -f "$package_name" ]; then
        echo -e "${YELLOW}正在下载 $package_name ...${NC}"
        if ! wget "$download_url"; then
            echo -e "${RED}下载失败，请检查网络连接。${NC}"
            return 1
        fi
        echo -e "${GREEN}安装包下载成功: $package_name${NC}"
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


# Docker卸载核心逻辑
uninstall_docker_core() {
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
        return 1
    fi

    echo -e "${GREEN}检测到系统已安装Docker。${NC}"
    if command -v docker &> /dev/null; then
        docker --version
    fi

    if ! confirm "确定要卸载Docker吗"; then
        echo -e "${GREEN}已取消卸载操作。${NC}"
        return 1
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

    # 清除 shell 的命令缓存
    echo -e "${YELLOW}清除命令缓存...${NC}"
    hash -r
    
    # 询问是否删除Docker数据目录
    if confirm "是否要删除Docker数据目录(/var/lib/docker)？这将删除所有镜像、容器和卷数据"; then
        echo -e "${YELLOW}删除Docker数据目录...${NC}"
        rm -rf /var/lib/docker
    else
        echo -e "${GREEN}保留Docker数据目录(/var/lib/docker)${NC}"
    fi
    
    echo -e "${GREEN}Docker卸载完成!${NC}"
    return 0
}


# 检查Docker Compose是否安装
check_docker_compose_installed() {
    if command -v docker-compose &> /dev/null || \
       [ -f /usr/bin/docker-compose ] || \
       [ -f /usr/local/bin/docker-compose ]; then
        return 0
    else
        return 1
    fi
}


# 获取所有的Docker Compose版本
get_all_docker_compose_versions() {
    local latest_version=$(curl -s https://api.github.com/repos/docker/compose/releases | grep 'tag_name' | cut -d\" -f4 | sort -Vr)
    if [ -z "$latest_version" ]; then
        echo -e "${RED}无法获取版本号列表${NC}" >&2
        return 1
    fi
    echo "$latest_version"
}


# 获取最新的Docker Compose版本
get_latest_docker_compose_version() {
    local latest_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    if [ -z "$latest_version" ]; then
        echo -e "${RED}无法获取最新版本号${NC}" >&2
        return 1
    fi
    echo "${latest_version}"
}


# 检查/usr/local/bin是否在PATH中并添加
check_and_add_to_path() {
    if ! echo "$PATH" | grep -q "/usr/local/bin"; then
        echo -e "${YELLOW}/usr/local/bin 不在 PATH 环境变量中${NC}"
        if confirm "是否要将 /usr/local/bin 添加到 PATH 环境变量中？"; then
            local shell_rc=""
            if [ -f "$HOME/.bashrc" ]; then
                shell_rc="$HOME/.bashrc"
            elif [ -f "$HOME/.zshrc" ]; then
                shell_rc="$HOME/.zshrc"
            elif [ -f "$HOME/.bash_profile" ]; then
                shell_rc="$HOME/.bash_profile"
            elif [ -f "$HOME/.profile" ]; then
                shell_rc="$HOME/.profile"
            fi

            if [ -n "$shell_rc" ]; then
                echo -e "${YELLOW}添加 /usr/local/bin 到 PATH (在 $shell_rc 中)${NC}"
                echo 'export PATH="$PATH:/usr/local/bin"' >> "$shell_rc"
                source "$shell_rc"
                echo -e "${GREEN}PATH 已更新，需要重新打开终端或运行 'source $shell_rc' 使更改生效${NC}"
            else
                echo -e "${RED}未找到 .bashrc 或 .zshrc 文件，请手动添加:${NC}"
                echo -e "${BLUE}export PATH=\$PATH:/usr/local/bin${NC}"
                echo -e "${YELLOW}或执行以下命令临时生效:${NC}"
                echo -e "${BLUE}export PATH=\$PATH:/usr/local/bin${NC}"
            fi
        fi
    fi
}


# 通过包管理器安装Docker Compose
install_with_package_manager() {
    echo -e "${YELLOW}尝试通过系统包管理器安装Docker Compose...${NC}"
    
    if command -v apt &> /dev/null; then
        echo -e "${BLUE}检测到APT包管理器${NC}"
        apt update
        apt install -y docker-compose
    elif command -v yum &> /dev/null || command -v dnf &> /dev/null; then
        echo -e "${BLUE}检测到YUM/DNF包管理器${NC}"
        
        # 对于CentOS/RHEL，优先尝试从EPEL仓库安装
        if ! yum repolist | grep -q "epel"; then
            echo -e "${YELLOW}EPEL仓库未启用，尝试启用EPEL仓库...${NC}"
            yum install -y epel-release || dnf install -y epel-release
        fi
        
        # 尝试安装docker-compose
        yum install -y docker-compose || dnf install -y docker-compose
        
        # 检查是否安装成功
        if ! command -v docker-compose &> /dev/null; then
            echo -e "${YELLOW}从EPEL仓库安装失败，尝试从官方仓库安装...${NC}"
            yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
            yum install -y docker-compose-plugin
            ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/docker-compose
        fi
    elif command -v zypper &> /dev/null; then
        echo -e "${BLUE}检测到ZYPPER包管理器${NC}"
        zypper refresh
        zypper install -y docker-compose
    elif command -v pacman &> /dev/null; then
        echo -e "${BLUE}检测到PACMAN包管理器${NC}"
        pacman -Sy --noconfirm docker-compose
    else
        echo -e "${RED}未检测到支持的包管理器${NC}"
        return 1
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}通过包管理器安装Docker Compose成功${NC}"
        docker-compose --version
        # 验证 PATH 是否包含 /usr/local/bin
        check_and_add_to_path
        return 0
    else
        echo -e "${RED}通过包管理器安装Docker Compose失败${NC}"
        return 1
    fi
}


# 通过二进制文件安装Docker Compose
install_with_binary() {
    echo -e "${YELLOW}准备通过二进制文件安装Docker Compose...${NC}"
    
    # 获取指定版本号
    local compose_version=""
    if [ -n "$1" ]; then
        compose_version=$1
    else
        # 获取最新版本号
        compose_version=$(get_latest_docker_compose_version)
        if [ $? -ne 0 ]; then
            echo -e "${RED}无法获取最新版本号${NC}"
            return 1
        fi
        echo -e "${YELLOW}将安装最新版本: $compose_version${NC}"
    fi
    
    # 获取系统架构
    arch_suffix=$(get_system_arch)
    if [ $? -ne 0 ]; then
        echo -e "${RED}无法确定适合您系统的Docker Compose版本。${NC}"
        return 1
    fi
    
    echo -e "${BLUE}检测到系统架构: $(uname -m)${NC}"
    
    # 检查当前目录下是否已存在二进制文件
    binary_filename="docker-compose-linux-${arch_suffix}"
    if [ -f "./$binary_filename" ]; then
        echo -e "${YELLOW}检测到当前目录下已存在 $binary_filename，将优先使用本地文件。${NC}"
        
        # 检查是否存在对应的哈希校验文件
        sha256_filename="${binary_filename}.sha256"
        if [ -f "./$sha256_filename" ]; then
            echo -e "${BLUE}检测到哈希校验文件 $sha256_filename，将进行完整性校验。${NC}"
            if sha256sum -c "./$sha256_filename" 2>/dev/null | grep -q ': OK$'; then
                echo -e "${GREEN}文件完整性验证通过${NC}"
            else
                echo -e "${RED}文件完整性验证失败${NC}"
                if ! confirm "文件可能损坏，是否继续安装？"; then
                    rm -f "./$binary_filename" "./$sha256_filename"
                    return 1
                fi
            fi
        else
            echo -e "${YELLOW}当前目录下未找到 $sha256_filename 哈希校验文件。${NC}"
            if ! confirm "是否继续安装而不进行完整性校验？"; then
                echo -e "${RED}用户选择放弃安装。${NC}"
                return 1
            fi
        fi
        
        # 安装二进制文件
        echo -e "${YELLOW}安装Docker Compose...${NC}"
        mv "./$binary_filename" /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        
        # 验证安装
        docker-compose --version
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Docker Compose安装成功${NC}"
            
            # 检查并添加PATH
            check_and_add_to_path
            
            return 0
        else
            echo -e "${RED}Docker Compose安装失败${NC}"
            return 1
        fi
    else
        # 定义下载URL
        binary_url="https://github.com/docker/compose/releases/download/${compose_version}/${binary_filename}"
        sha256_url="${binary_url}.sha256"
        
        # 下载二进制文件
        echo -e "${YELLOW}正在下载 Docker Compose ${compose_version}...${NC}"
        if ! wget "$binary_url" -O "$binary_filename"; then
            echo -e "${RED}下载二进制文件失败，请检查网络连接或稍后重试${NC}"
            return 1
        fi
        
        # 下载sha256校验文件
        echo -e "${YELLOW}正在下载校验文件...${NC}"
        if ! wget "$sha256_url" -O "${binary_filename}.sha256"; then
            echo -e "${YELLOW}下载校验文件失败，无法验证完整性。${NC}"
            if ! confirm "是否继续安装而不进行完整性校验？"; then
                rm -f "./$binary_filename"
                return 1
            fi
        else
            echo -e "${YELLOW}验证文件完整性...${NC}"
            if sha256sum -c "${binary_filename}.sha256" 2>/dev/null | grep -q ': OK$'; then
                echo -e "${GREEN}文件完整性验证通过${NC}"
            else
                echo -e "${RED}文件完整性验证失败${NC}"
                if ! confirm "文件可能损坏，是否继续安装？"; then
                    rm -f "./$binary_filename" "./${binary_filename}.sha256"
                    return 1
                fi
            fi
        fi
        
        # 安装二进制文件
        echo -e "${YELLOW}安装Docker Compose...${NC}"
        mv "./$binary_filename" /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        
        # 验证安装
        docker-compose --version
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Docker Compose安装成功${NC}"
            
            # 检查并添加PATH
            check_and_add_to_path
            
            # 删除校验文件
            if [ -f "./${binary_filename}.sha256" ]; then
                rm -f "./${binary_filename}.sha256"
                echo -e "${GREEN}已删除校验文件 ${binary_filename}.sha256${NC}"
            fi
            
            return 0
        else
            echo -e "${RED}Docker Compose安装失败${NC}"
            return 1
        fi
    fi
}


# Docker Compose安装核心逻辑
install_docker_compose_core() {
    # 检查是否已安装 Docker Compose
    if check_docker_compose_installed; then
        echo -e "${YELLOW}Docker Compose 已安装在系统中。${NC}"
        docker-compose --version
        if ! confirm "是否需要卸载现有 Docker Compose 并重新安装？"; then
            echo -e "${GREEN}选择保留现有Docker Compose环境。${NC}"
            return 1
        fi

        # 用户确认重新安装，先执行卸载操作
        echo -e "${YELLOW}开始卸载现有 Docker Compose...${NC}"
        uninstall_docker_compose_core
        if [ $? -ne 0 ]; then
            echo -e "${GREEN}选择保留现有Docker Compose环境。${NC}"
            return 1
        fi
        echo -e "${GREEN}现有 Docker Compose 已成功卸载，继续进行安装。${NC}"

        # 卸载后提示用户是否继续安装
        if ! confirm "是否继续安装 Docker Compose？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}未检测到 Docker Compose 环境。${NC}"
        if ! confirm "是否需要安装 Docker Compose？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return 1
        fi
    fi

    local install_method=""
    while true; do
        echo -e "${GREEN}请选择安装方式:${NC}"
        echo "1. 使用系统包管理器安装 (apt/yum等)"
        echo "2. 使用二进制文件安装 (离线安装)"
        read -p "请选择安装方式 (1/2): " install_method

        case "$install_method" in
            1)
                install_with_package_manager
                break
                ;;
            2)
                install_with_binary
                break
                ;;
            "")
                echo -e "${BLUE}默认选择使用系统包管理器安装${NC}"
                install_with_package_manager
                break
                ;;
            *)
                echo -e "${RED}无效的选择，请重新输入。${NC}"
                ;;
        esac
    done
}


# Docker Compose卸载核心逻辑
uninstall_docker_compose_core() {
    echo -e "${GREEN}"
    echo "=============================================="
    echo "       Docker Compose 卸载警告"
    echo "=============================================="
    echo -e "${NC}此操作将执行以下步骤："
    echo "1. 删除Docker Compose可执行文件"
    echo ""
    echo -e "${GREEN}=============================================="
    echo -e "${NC}"

    if ! check_docker_compose_installed; then
        echo -e "${RED}未检测到Docker Compose安装，无需卸载。${NC}"
        return
    fi

    echo -e "${GREEN}检测到系统已安装Docker Compose。${NC}"
    docker-compose --version

    if ! confirm "确定要卸载Docker Compose吗"; then
        echo -e "${GREEN}已取消卸载操作。${NC}"
        return 1
    fi

    echo -e "${GREEN}开始卸载Docker Compose...${NC}"
    
    # 检测安装方式并执行相应卸载步骤
    if [ -f "/usr/bin/docker-compose" ]; then
        echo -e "${BLUE}检测到Docker Compose是通过包管理器安装的。${NC}"
        if command -v apt &> /dev/null; then
            echo -e "${BLUE}使用APT包管理器卸载Docker Compose...${NC}"
            apt remove -y docker-compose
        elif command -v yum &> /dev/null; then
            echo -e "${BLUE}使用YUM包管理器卸载Docker Compose...${NC}"
            yum remove -y docker-compose
        elif command -v dnf &> /dev/null; then
            echo -e "${BLUE}使用DNF包管理器卸载Docker Compose...${NC}"
            dnf remove -y docker-compose
        elif command -v zypper &> /dev/null; then
            echo -e "${BLUE}使用ZYPPER包管理器卸载Docker Compose...${NC}"
            zypper remove -y docker-compose
        elif command -v pacman &> /dev/null; then
            echo -e "${BLUE}使用PACMAN包管理器卸载Docker Compose...${NC}"
            pacman -R --noconfirm docker-compose
        else
            echo -e "${RED}未检测到支持的包管理器，无法卸载包管理器安装的Docker Compose。${NC}"
            return 1
        fi
    elif [ -f "/usr/local/bin/docker-compose" ]; then
        echo -e "${BLUE}检测到Docker Compose是通过离线二进制文件安装的。${NC}"
        echo -e "${BLUE}删除Docker Compose可执行文件...${NC}"
        rm -f "/usr/local/bin/docker-compose"
    else
        echo -e "${RED}无法确定Docker Compose的安装方式，无法进行卸载。${NC}"
        return 1
    fi

    echo -e "${GREEN}Docker Compose卸载完成!${NC}"
    read -p "按回车键重启脚本..."
    # 如果脚本不是在子shell中运行，则重启脚本
    if [ "$BASH_SUBSHELL" -eq 0 ]; then
        echo -e "${BLUE}正在重启脚本...${NC}"
        exec "$0"
    fi
}


# 安装指定版本的Docker Compose
install_specific_docker_compose() {
    # 检查是否已安装 Docker Compose
    if check_docker_compose_installed; then
        echo -e "${YELLOW}Docker Compose 已安装在系统中。${NC}"
        docker-compose --version
        if ! confirm "是否需要卸载现有 Docker Compose 并重新安装？"; then
            echo -e "${GREEN}用户选择保留现有Docker Compose环境。${NC}"
            return 1
        fi

        # 用户确认重新安装，先执行卸载操作
        echo -e "${YELLOW}开始卸载现有 Docker Compose...${NC}"
        uninstall_docker_compose_core
        if [ $? -ne 0 ]; then
            return 1
        fi
        echo -e "${GREEN}现有 Docker Compose 已成功卸载。${NC}"

        # 卸载后提示用户是否继续安装
        if ! confirm "是否继续安装 Docker Compose？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}未检测到 Docker Compose 环境。${NC}"
        if ! confirm "是否需要安装 Docker Compose？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return 1
        fi
    fi

    echo -e "${GREEN}开始安装 Docker Compose...${NC}"

    # 获取所有可用的Docker Compose版本
    versions=($(get_all_docker_compose_versions))
    if [ ${#versions[@]} -eq 0 ]; then
        echo -e "${RED}无法获取可用版本，请检查网络。${NC}"
        return 1
    fi

    echo -e "${GREEN}可用版本列表:${NC}"
    display_versions_in_columns "${versions[@]}"

    read -p "请输入要安装的版本编号: " version_choice
    if [[ "$version_choice" =~ ^[0-9]+$ ]] && [ "$version_choice" -ge 1 ] && [ "$version_choice" -le ${#versions[@]} ]; then
        selected_version="${versions[$((version_choice - 1))]}"
        install_with_binary "$selected_version"
    else
        echo -e "${RED}无效的选择。${NC}"
        return 1
    fi
}


# 安装指定版本Docker
install_specific_docker() {
    echo -e "${YELLOW}获取所有可用版本...${NC}"
    arch_suffix=$(get_system_arch)
    if [ $? -ne 0 ]; then
        echo -e "${RED}无法确定系统架构。${NC}"
        return 1
    fi

    versions=()
    for mirror in "${DOCKER_MIRRORS[@]}"; do
        versions+=($(get_all_docker_versions "$mirror/$arch_suffix"))
        if [ ${#versions[@]} -gt 0 ]; then
            break
        fi
    done

    if [ ${#versions[@]} -eq 0 ]; then
        echo -e "${RED}无法获取可用版本，请检查网络。${NC}"
        return 1
    fi

    echo -e "${GREEN}可用版本列表:${NC}"
    display_versions_in_columns "${versions[@]}"

    read -p "请输入要安装的版本编号: " version_choice
    if [[ "$version_choice" =~ ^[0-9]+$ ]] && [ "$version_choice" -ge 1 ] && [ "$version_choice" -le ${#versions[@]} ]; then
        selected_version="${versions[$((version_choice - 1))]}"
        install_docker_core "$selected_version"
    else
        echo -e "${RED}无效的选择。${NC}"
    fi
}


# 新增函数：显示简要Docker状态
show_brief_status() {
    if ! check_docker_installed; then
        echo -e "${YELLOW}未检测到Docker环境，跳过状态显示。${NC}"
        return
    fi

    # 获取统计信息
    container_count=$(docker ps -aq 2>/dev/null | wc -l | tr -d ' ')
    image_count=$(docker images -q 2>/dev/null | wc -l | tr -d ' ')
    network_count=$(docker network ls -q 2>/dev/null | wc -l | tr -d ' ')
    volume_count=$(docker volume ls -q 2>/dev/null | wc -l | tr -d ' ')

    echo -e " ${NC}Docker环境状态:  ${YELLOW}容器:${container_count}  镜像:${image_count}  网络:${network_count}  卷:${volume_count}${NC}"
}


# 新增函数：显示完整状态
show_full_status() {
    clear
    if ! check_docker_installed; then
        echo -e "${RED}Docker未安装${NC}"
        return
    fi

    echo -e "${GREEN}===================== Docker全局状态 =====================${NC}"
    
    # Docker版本
    echo -e "${YELLOW}[Docker版本信息]${NC}"
    docker --version 2>/dev/null || echo "无法获取版本"
    
    # Compose状态
    echo -e "\n${YELLOW}[Compose版本信息]${NC}"
    if check_docker_compose_installed; then
        docker-compose --version
    else
        echo "未安装"
    fi

    # 详细列表
    echo -e "\n${YELLOW}[镜像列表]${NC}"
    docker images 2>/dev/null || echo "无镜像"
    
    echo -e "\n${YELLOW}[容器列表]${NC}"
    docker ps -a 2>/dev/null || echo "无容器"
    
    echo -e "\n${YELLOW}[卷列表]${NC}"
    docker volume ls 2>/dev/null || echo "无卷"
    
    echo -e "\n${YELLOW}[网络列表]${NC}"
    docker network ls 2>/dev/null || echo "无网络"
    
    echo -e "${GREEN}========================================================${NC}"
}


# Docker 容器管理
docker_container_manage() {
    while true; do
        clear
        echo -e "${GREEN}Docker容器列表:${NC}"
        docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        echo "容器操作"
        echo "------------------------"
        echo "1. 创建新的容器"
        echo "2. 启动指定容器         6. 启动所有容器"
        echo "3. 停止指定容器         7. 停止所有容器"
        echo "4. 删除指定容器         8. 删除所有容器"
        echo "5. 重启指定容器         9. 重启所有容器"
        echo "------------------------"
        echo "11. 进入指定容器        12. 查看容器日志"
        echo "13. 查看容器网络        14. 查看容器占用"
        echo "------------------------"
        echo "0. 返回上一级菜单"
        echo "------------------------"
        read -p "请输入你的选择: " sub_choice
        case $sub_choice in
            1)
                read -p "请输入docker run命令: " run_cmd
                eval "$run_cmd"
                ;;
            2)
                read -p "请输入容器名/ID（多个用空格分隔）: " names
                docker start $names
                ;;
            3)
                read -p "请输入容器名/ID（多个用空格分隔）: " names
                docker stop $names
                ;;
            4)
                read -p "请输入容器名/ID（多个用空格分隔）: " names
                docker rm -f $names
                ;;
            5)
                read -p "请输入容器名/ID（多个用空格分隔）: " names
                docker restart $names
                ;;
            6)
                docker start $(docker ps -a -q)
                ;;
            7)
                docker stop $(docker ps -q)
                ;;
            8)
                read -p "确定删除所有容器吗？(Y/N): " choice
                [[ "$choice" =~ [Yy] ]] && docker rm -f $(docker ps -a -q)
                ;;
            9)
                docker restart $(docker ps -q)
                ;;
            11)
                read -p "请输入容器名/ID: " name
                docker exec -it $name /bin/sh
                ;;
            12)
                read -p "请输入容器名/ID: " name
                # 兼容日志查看，支持分页
                if command -v less &>/dev/null; then
                    docker logs $name | less
                else
                    docker logs $name
                fi
                ;;
            13)
                # 参考 kejilion.sh 的实现，显示所有容器的网络和IP
                echo ""
                container_ids=$(docker ps -q)
                echo "------------------------------------------------------------"
                printf "%-25s %-25s %-25s\n" "容器名称" "网络名称" "IP地址"
                for container_id in $container_ids; do
                    docker inspect --format '{{.Name}} {{range $k,$v := .NetworkSettings.Networks}}{{$k}} {{$v.IPAddress}}{{end}}' "$container_id" | \
                    awk '{cname=$1; for(i=2;i<=NF;i+=2) printf "%-25s %-25s %-25s\n", cname, $(i), $(i+1)}'
                done
                echo "------------------------------------------------------------"
                read -p "按回车键继续..."
                ;;
            14)
                # 参考 kejilion.sh 的实现，显示容器资源占用
                docker stats --no-stream
                read -p "按回车键继续..."
                ;;
            0)
                break
                ;;
            *)
                echo "无效的选项，请重新输入。"
                read -p "按回车键继续..."
                ;;
        esac
    done
}

# Docker 镜像管理
docker_image_manage() {
    while true; do
        clear
        echo -e "${GREEN}Docker镜像列表:${NC}"
        docker image ls
        echo ""
        echo "镜像操作"
        echo "------------------------"
        echo "1. 获取指定镜像         3. 删除指定镜像"
        echo "2. 更新指定镜像         4. 删除所有镜像"
        echo "------------------------"
        echo "0. 返回上一级菜单"
        echo "------------------------"
        read -p "请输入你的选择: " sub_choice
        case $sub_choice in
            1)
                read -p "请输入镜像名（多个用空格分隔）: " names
                for name in $names; do
                    docker pull $name
                done
                read -p "按回车键继续..."
                ;;
            2)
                read -p "请输入镜像名（多个用空格分隔）: " names
                for name in $names; do
                    docker pull $name
                done
                read -p "按回车键继续..."
                ;;
            3)
                read -p "请输入镜像名（多个用空格分隔）: " names
                for name in $names; do
                    docker rmi -f $name
                done
                read -p "按回车键继续..."
                ;;
            4)
                read -p "确定删除所有镜像吗？(Y/N): " choice
                [[ "$choice" =~ [Yy] ]] && docker rmi -f $(docker images -q)
                read -p "按回车键继续..."
                ;;
            0)
                break
                ;;
            *)
                echo "无效的选项，请重新输入。"
                read -p "按回车键继续..."
                ;;
        esac
    done
}

# Docker 网络管理
docker_network_manage() {
    while true; do
        clear
        echo -e "${GREEN}Docker网络列表:${NC}"
        docker network ls
        echo ""
        # 显示所有容器的网络与IP地址
        echo "------------------------------------------------------------"
        printf "%-25s %-20s %-20s\n" "容器名称" "网络名称" "IP地址"
        for cid in $(docker ps -q); do
            cname=$(docker inspect --format '{{.Name}}' $cid)
            docker inspect --format '{{range $k,$v := .NetworkSettings.Networks}}{{printf "%-25s %-20s %-20s\n" "'"$cname"'" $k $v.IPAddress}}{{end}}' $cid
        done
        echo "------------------------------------------------------------"
        echo "1. 创建网络"
        echo "2. 加入网络"
        echo "3. 退出网络"
        echo "4. 删除网络"
        echo "0. 返回上一级菜单"
        echo "------------------------"
        read -p "请输入你的选择: " sub_choice
        case $sub_choice in
            1)
                read -p "设置新网络名: " netname
                docker network create $netname
                ;;
            2)
                read -p "加入网络名: " netname
                read -p "容器名/ID（多个用空格分隔）: " names
                for n in $names; do
                    docker network connect $netname $n
                done
                ;;
            3)
                read -p "退出网络名: " netname
                read -p "容器名/ID（多个用空格分隔）: " names
                for n in $names; do
                    docker network disconnect $netname $n
                done
                ;;
            4)
                read -p "请输入要删除的网络名: " netname
                docker network rm $netname
                ;;
            0)
                break
                ;;
            *)
                echo "无效的选项，请重新输入。"
                read -p "按回车键继续..."
                ;;
        esac
    done
}


# Docker 卷管理
docker_volume_manage() {
    while true; do
        clear
        echo -e "${GREEN}Docker卷列表:${NC}"
        docker volume ls
        echo ""
        echo "卷操作"
        echo "------------------------"
        echo "1. 创建新卷"
        echo "2. 删除指定卷"
        echo "3. 删除所有卷"
        echo "------------------------"
        echo "0. 返回上一级菜单"
        echo "------------------------"
        read -p "请输入你的选择: " sub_choice
        case $sub_choice in
            1)
                read -p "设置新卷名: " vname
                docker volume create $vname
                ;;
            2)
                read -p "输入删除卷名（多个用空格分隔）: " vnames
                for v in $vnames; do
                    docker volume rm $v
                done
                ;;
            3)
                read -p "确定删除所有卷吗？(Y/N): " choice
                if [[ "$choice" =~ [Yy] ]]; then
                    docker volume rm $(docker volume ls -q)
                fi
                ;;
            0)
                break
                ;;
            *)
                echo "无效的选项，请重新输入。"
                read -p "按回车键继续..."
                ;;
        esac
    done
}


show_menu() {
    clear
    echo -e "${GREEN}========================================================${NC}"
    echo -e "${ORANGE}           	   Docker 管理工具箱${NC}"
    echo -e "${GREEN}========================================================${NC}"
    show_brief_status  # 状态显示
    echo -e "${GREEN}1. 安装 Docker${NC}"
    echo -e "${GREEN}2. 卸载 Docker${NC}"
    echo -e "${GREEN}3. 安装指定版本 Docker${NC}"
    echo -e "${GREEN}4. 安装 Docker Compose${NC}"
    echo -e "${GREEN}5. 卸载 Docker Compose${NC}"
    echo -e "${GREEN}6. 安装指定版本 Docker Compose${NC}"
    echo -e "${GREEN}7. 查看Docker全局状态 ★${NC}"
    echo -e "${GREEN}8. Docker容器管理${NC}"
    echo -e "${GREEN}9. Docker镜像管理${NC}"
    echo -e "${GREEN}10. Docker网络管理${NC}"
    echo -e "${GREEN}11. Docker卷管理${NC}"
    echo -e "${GREEN}0. 退出脚本${NC}"
    echo -e "${GREEN}========================================================${NC}"
    echo -e "${NC}"
}



main() {
    while true; do
        show_menu
        stty erase ^H
        read -p "请输入选项编号 (0-11): " choice
        case "$choice" in
            1) install_docker_core ;;
            2) uninstall_docker_core ;;
            3) install_specific_docker ;;
            4) install_docker_compose_core ;;
            5) uninstall_docker_compose_core ;;
            6) install_specific_docker_compose ;;
            7)
                clear
                show_full_status
                read -p "按回车键返回主菜单..."
                continue
                ;;
            8) docker_container_manage ;;
            9) docker_image_manage ;;
            10) docker_network_manage ;;
            11) docker_volume_manage ;;
            0)
                echo -e "${GREEN}已退出脚本。${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}无效的选项，请重新输入!${NC}"
                read -p "按回车键返回主菜单..."
                ;;
        esac
    done   
}

# 执行主程序
main
