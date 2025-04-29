# Docker导出docker-compose配置文件

### 手动导出
查看Docker容器id:
```bash
docker ps
```
将输出保存到一个临时文件中，方便查看和编辑：
```bash
docker container inspect <container_name_or_id> > container_info.json
```
从 `container_info.json` 文件中提取以下关键配置信息：  
- 镜像名称
- 端口映射
- 环境变量
- 卷挂载
- 网络设置
- 重启策略等

手动编写 `docker-compose.yml` 文件
```bash
vim docker-compose.yml
```

### 使用docker2compose脚本
使用[docker2compose.sh](https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/Docker%20Notes/docker2compose.sh)脚本的方式自动化生成 `docker-compose.yml` 文件  
使用一键脚本：
```
curl -sS -O https://github.com/stu2116Edward/Public-study-notes/blob/main/Docker%20Notes/docker2compose.sh && chmod +x docker2compose.sh && ./docker2compose.sh
```
运行这个脚本提示所需组件：
```bash
apt install -y jq
```

- 交互模式：
```bash
./docker2compose.sh
```

- 命令行模式：
```bash
./docker2compose.sh -c 容器名或ID -o docker-compose.yml
```

- 显示帮助：
```bash
./docker2compose.sh -h
```
