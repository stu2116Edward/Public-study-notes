#!/bin/bash

# 清理缓存
hash -r

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

# 显示菜单
show_menu() {
    echo -e "${GREEN}"
    echo "=============================================="
    echo "       Docker Compose 管理脚本"
    echo "=============================================="
    echo "1. 安装 Docker Compose"
    echo "2. 卸载 Docker Compose"
    echo "3. 安装指定版本的 Docker Compose"
    echo "0. 退出"
    echo "=============================================="
    echo -e "${NC}"
}

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
        armv7l)
            echo "armv7"
            ;;
        armv6l)
            echo "armv6"
            ;;
        ppc64le)
            echo "ppc64le"
            ;;
        riscv64)
            echo "riscv64"
            ;;
        s390x)
            echo "s390x"
            ;;
        *)
            echo -e "${RED}不支持的架构: $arch${NC}" >&2
            return 1
            ;;
    esac
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

# 卸载Docker Compose
uninstall_docker_compose() {
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
        uninstall_docker_compose
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

# 安装Docker Compose
install_docker_compose() {
    # 检查是否已安装 Docker Compose
    if check_docker_compose_installed; then
        echo -e "${YELLOW}Docker Compose 已安装在系统中。${NC}"
        docker-compose --version
        if ! confirm "是否需要重新安装 Docker Compose？"; then
            echo -e "${GREEN}选择保留现有Docker Compose环境。${NC}"
            return
        fi

        # 用户确认重新安装，先执行卸载操作
        echo -e "${YELLOW}开始卸载现有 Docker Compose...${NC}"
        uninstall_docker_compose
        if [ $? -ne 0 ]; then
            echo -e "${GREEN}选择保留现有Docker Compose环境。${NC}"
            return 1
        fi
        echo -e "${GREEN}现有 Docker Compose 已成功卸载，继续进行安装。${NC}"
    else
        echo -e "${YELLOW}未检测到 Docker Compose 环境。${NC}"
        if ! confirm "是否需要安装 Docker Compose？"; then
            echo -e "${GREEN}用户选择跳过安装。${NC}"
            return
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

# 主程序
main() {
    # 设置退出时执行的清理操作
    trap 'if ! command -v docker-compose &> /dev/null; then echo -e "${GREEN}如果 ${YELLOW} docker-compose -v ${GREEN} 未成功加载，请在终端运行 ${YELLOW} hash -r ${GREEN} 来清理缓存${NC}"; fi' EXIT

    while true; do
        show_menu
		stty erase ^H
        read -p "请选择操作 (1安装/2卸载/3安装指定版本/0退出): " choice
        
        case "$choice" in
            1)
                install_docker_compose
                ;;
            2)
                uninstall_docker_compose
                ;;
            3)
                install_specific_docker_compose
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

# 执行主程序
main
