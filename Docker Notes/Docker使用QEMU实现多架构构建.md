# Docker使用QEMU实现多架构构建

1. 注册 QEMU 二进制格式处理器（宿主机内核层面）
```
docker run --privileged --rm tonistiigi/binfmt --install all
```

2. 验证 QEMU 生效
```
docker run --rm --platform linux/arm64 alpine uname -m
```
预期输出：`aarch64`

3. 如果之前已有旧的 multiarch builder，先删除
```
docker buildx rm multiarch 2>/dev/null || true
```

4. 创建全新的 builder
```
docker buildx create --name multiarch --driver docker-container --use
```

5. 启动 builder
```
docker buildx inspect --bootstrap
```

6. 单平台本地构建测试（可选，用于验证）
```
docker buildx build --platform linux/amd64 -t 镜像名称:amd64 --load .
```
```
docker buildx build --platform linux/arm64 -t 镜像名称:arm64 --load .
```

7. 多平台构建并推送到仓库
```
docker buildx build --platform linux/amd64,linux/arm64 -t 仓库名称/镜像名称:标签 --push .
```

构建失败写入日志分析（以arm64架构举例）
```
docker buildx build --platform linux/arm64 -t 镜像名称:arm64 --load . 2>&1 | tee build.log
```
```
docker buildx build --no-cache --progress=plain --platform linux/arm64 -t 镜像名称:arm64 --load . 2>&1 | tee build.log
```


**参数说明**：

- `--no-cache`				完全不用缓存重新构建
- `--progress=plain`			输出纯文本日志，适合 tee 保存
- `--platform linux/arm64`		目标平台为 arm64
- `-t ripgrep-webui:arm64`		打标签，加载后镜像名为 ripgrep-webui:arm64
- `--load`					构建结果加载到本地 Docker 镜像库
	- `.`						构建上下文为当前目录
- `--push`					构建结果推送到 Docker Hub 镜像库
- `2>&1 | tee build.log`		合并 stderr/stdout，同时输出到终端和 build.log
