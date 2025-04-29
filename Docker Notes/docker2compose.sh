#!/bin/bash
# 增强交互式容器转docker-compose脚本（支持0退出）

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 显示帮助信息
show_help() {
    echo -e "${YELLOW}使用方法:${NC}"
    echo "  直接运行脚本会进入交互模式"
    echo "  或者使用命令行参数:"
    echo "  $0 -c <容器名或ID> [-o 输出文件]"
    echo -e "${YELLOW}选项:${NC}"
    echo "  -c, --container   指定容器名称或ID"
    echo "  -o, --output      指定输出文件(默认为docker-compose.yml)"
    echo "  -h, --help        显示帮助信息"
    echo -e "${YELLOW}交互模式下输入0可以随时退出${NC}"
}

# 检查依赖
check_dependencies() {
    local missing=0
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: Docker未安装!${NC}"
        missing=1
    fi
    
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}错误: jq未安装! 请先安装jq(JSON处理器)。${NC}"
        echo "在Ubuntu/Debian上可以使用: sudo apt-get install jq"
        echo "在CentOS/RHEL上可以使用: sudo yum install jq"
        missing=1
    fi
    
    if [ $missing -ne 0 ]; then
        exit 1
    fi
}

# 安全退出函数
safe_exit() {
    echo -e "${BLUE}用户请求退出脚本。${NC}"
    exit 0
}

# 用户确认提示
confirm_action() {
    local prompt="$1"
    while true; do
        echo -en "${YELLOW}${prompt} [y/N/0(退出)]: ${NC}"
        read -r answer
        case "$answer" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            0 ) safe_exit;;
            * ) echo -e "${RED}请输入 y, n 或 0 退出${NC}";;
        esac
    done
}

# 选择容器
select_container() {
    while true; do
        echo -e "${YELLOW}正在获取容器列表...${NC}"
        local containers=$(docker ps --format "{{.ID}}:{{.Names}}:{{.Image}}")
        
        if [ -z "$containers" ]; then
            echo -e "${RED}没有找到运行中的容器!${NC}"
            if confirm_action "是否重试?"; then
                continue
            else
                safe_exit
            fi
        fi
        
        echo -e "${GREEN}请选择要转换的容器(输入0退出):${NC}"
        local i=1
        local options=()
        
        echo -e "${BLUE}编号 | 容器ID       | 容器名称       | 镜像${NC}"
        echo "--------------------------------------------"
        while IFS=':' read -r id name image; do
            printf "%-4s | %-12s | %-14s | %s\n" "$i" "${id:0:12}" "$name" "$image"
            options+=("$id")
            ((i++))
        done <<< "$containers"
        
        while true; do
            echo -en "${YELLOW}请输入容器编号(1-$((i-1)) 或容器ID/名称，或0退出): ${NC}"
            read -r choice
            
            # 检查是否请求退出
            if [ "$choice" = "0" ]; then
                safe_exit
            fi
            
            # 如果用户输入的是数字
            if [[ "$choice" =~ ^[0-9]+$ ]]; then
                if [ "$choice" -ge 1 ] && [ "$choice" -lt "$i" ]; then
                    SELECTED_CONTAINER="${options[$((choice-1))]}"
                    echo -e "${GREEN}已选择容器: ${SELECTED_CONTAINER}${NC}"
                    return 0
                else
                    echo -e "${RED}无效编号，请选择1-$((i-1))或0退出${NC}"
                fi
            # 如果用户直接输入容器ID或名称
            elif docker inspect "$choice" &>/dev/null; then
                SELECTED_CONTAINER="$choice"
                echo -e "${GREEN}已选择容器: ${SELECTED_CONTAINER}${NC}"
                return 0
            else
                echo -e "${RED}无效选择，请重试或输入0退出!${NC}"
            fi
        done
    done
}

# 获取输出文件名
get_output_filename() {
    local default_output="docker-compose.yml"
    
    while true; do
        echo -en "${YELLOW}请输入输出文件名(默认为 ${default_output})或0退出: ${NC}"
        read -r output
        
        if [ "$output" = "0" ]; then
            safe_exit
        elif [ -z "$output" ]; then
            OUTPUT_FILE="$default_output"
            break
        elif [[ "$output" == *.yml ]] || [[ "$output" == *.yaml ]]; then
            OUTPUT_FILE="$output"
            break
        else
            echo -e "${RED}文件名必须以.yml或.yaml结尾!${NC}"
        fi
    done
    
    # 检查文件是否已存在
    if [ -f "$OUTPUT_FILE" ]; then
        if ! confirm_action "文件 ${OUTPUT_FILE} 已存在，要覆盖吗?"; then
            safe_exit
        fi
    fi
}

# 生成docker-compose文件
generate_compose() {
    local container=$1
    local output=$2
    
    echo -e "${YELLOW}正在获取容器 ${container} 的配置...${NC}"
    
    # 获取容器配置
    IMAGE=$(docker inspect --format '{{.Config.Image}}' "$container")
    NAME=$(docker inspect --format '{{.Name}}' "$container" | sed 's/^\///')
    CMD=$(docker inspect --format '{{json .Config.Cmd}}' "$container")
    ENTRYPOINT=$(docker inspect --format '{{json .Config.Entrypoint}}' "$container")
    ENV=$(docker inspect --format '{{range .Config.Env}}{{.}}{{"\n"}}{{end}}' "$container")
    PORTS=$(docker inspect --format '{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{range $i, $v := $conf}}{{$p}} {{$v.HostPort}} {{$v.HostIp}}{{"\n"}}{{end}}{{end}}{{end}}' "$container")
    VOLUMES=$(docker inspect --format '{{range .Mounts}}{{.Type}} {{.Source}} {{.Destination}} {{.RW}} {{.Propagation}}{{"\n"}}{{end}}' "$container")
    NETWORK=$(docker inspect --format '{{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{$v.Aliases}}{{"\n"}}{{end}}' "$container")
    RESTART=$(docker inspect --format '{{.HostConfig.RestartPolicy.Name}}' "$container")
    CPUS=$(docker inspect --format '{{.HostConfig.NanoCpus}}' "$container")
    MEMORY=$(docker inspect --format '{{.HostConfig.Memory}}' "$container")
    HEALTHCHECK=$(docker inspect --format '{{json .Config.Healthcheck}}' "$container")
    LABELS=$(docker inspect --format '{{json .Config.Labels}}' "$container")

    # 生成docker-compose.yml
    echo -e "${YELLOW}正在生成 ${output} 文件...${NC}"
    
    cat <<EOF > "$output"
version: '3.8'
services:
  ${NAME}:
    image: ${IMAGE}
    container_name: ${NAME}
EOF

    # 添加重启策略
    if [ "$RESTART" != "no" ]; then
        echo "    restart: ${RESTART}" >> "$output"
    fi

    # 添加命令和入口点
    [ "$CMD" != "null" ] && echo "    command: ${CMD}" >> "$output"
    [ "$ENTRYPOINT" != "null" ] && echo "    entrypoint: ${ENTRYPOINT}" >> "$output"

    # 添加环境变量
    if [ -n "$ENV" ]; then
        echo "    environment:" >> "$output"
        echo "$ENV" | while read -r line; do
            [ -n "$line" ] && echo "      - $line" >> "$output"
        done
    fi

    # 添加端口
    if [ -n "$PORTS" ]; then
        echo "    ports:" >> "$output"
        echo "$PORTS" | while read -r container_port host_port host_ip; do
            if [ -z "$host_ip" ] || [ "$host_ip" = "0.0.0.0" ]; then
                echo "      - \"${host_port}:${container_port}\"" >> "$output"
            else
                echo "      - \"${host_ip}:${host_port}:${container_port}\"" >> "$output"
            fi
        done
    fi

    # 添加卷
    if [ -n "$VOLUMES" ]; then
        echo "    volumes:" >> "$output"
        echo "$VOLUMES" | while read -r type source destination rw propagation; do
            options=""
            [ "$rw" = "false" ] && options="${options},ro"
            [ "$propagation" != "" ] && options="${options},propagation=${propagation}"
            options=$(echo "$options" | sed 's/^,//')
            
            if [ "$type" = "volume" ]; then
                [ -n "$options" ] && options=":${options}"
                echo "      - ${source}:${destination}${options}" >> "$output"
            elif [ "$type" = "bind" ]; then
                [ -n "$options" ] && options=":${options}"
                echo "      - ${source}:${destination}${options}" >> "$output"
            elif [ "$type" = "tmpfs" ]; then
                echo "      - ${destination}:tmpfs${options}" >> "$output"
            fi
        done
    fi

    # 添加资源限制
    if [ -n "$CPUS" ] || [ -n "$MEMORY" ]; then
        echo "    deploy:" >> "$output"
        echo "      resources:" >> "$output"
        echo "        limits:" >> "$output"
        [ -n "$CPUS" ] && echo "          cpus: '$(echo "scale=2; ${CPUS}/1000000000" | bc)'" >> "$output"
        [ -n "$MEMORY" ] && echo "          memory: ${MEMORY}" >> "$output"
    fi

    # 添加健康检查
    if [ "$HEALTHCHECK" != "null" ]; then
        echo "    healthcheck:" >> "$output"
        echo "$HEALTHCHECK" | jq -r '. | to_entries[] | "      \(.key): \(.value)"' >> "$output"
    fi

    # 添加标签
    if [ "$LABELS" != "null" ]; then
        echo "    labels:" >> "$output"
        echo "$LABELS" | jq -r 'to_entries[] | "      \(.key): \(.value)"' >> "$output"
    fi

    # 添加网络
    if [ -n "$NETWORK" ]; then
        echo "    networks:" >> "$output"
        echo "$NETWORK" | while read -r network aliases; do
            echo "      - ${network}" >> "$output"
        done
        
        echo -e "\nnetworks:" >> "$output"
        echo "$NETWORK" | while read -r network aliases; do
            echo "  ${network}:" >> "$output"
            echo "    external: true" >> "$output"
        done
    fi

    echo -e "${GREEN}成功! Docker Compose 文件已生成: ${output}${NC}"
}

# 主函数
main() {
    check_dependencies
    
    # 解析命令行参数
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -c|--container)
                CONTAINER="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                echo -e "${RED}未知选项: $1${NC}"
                show_help
                exit 1
                ;;
        esac
    done
    
    # 交互模式
    if [ -z "$CONTAINER" ]; then
        echo -e "${GREEN}=== 交互式Docker容器转Compose工具 ===${NC}"
        echo -e "${BLUE}提示: 在任何输入提示处输入0可以退出脚本${NC}"
        select_container
    else
        SELECTED_CONTAINER="$CONTAINER"
        if ! docker inspect "$SELECTED_CONTAINER" &>/dev/null; then
            echo -e "${RED}错误: 容器 '$SELECTED_CONTAINER' 不存在!${NC}"
            exit 1
        fi
    fi
    
    if [ -z "$OUTPUT" ]; then
        get_output_filename
    else
        OUTPUT_FILE="$OUTPUT"
    fi
    
    generate_compose "$SELECTED_CONTAINER" "$OUTPUT_FILE"
}

main "$@"
