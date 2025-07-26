# wrk压测

## 一键部署
### http压测:
```bash
curl -L -o wrk.lua https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/About%20cybersecurity/%E5%8E%8B%E6%B5%8B/wrk.lua
docker run --rm \
--name wrk \
--user root \
--network host \
--cpuset-cpus="0" \
-v "$PWD/wrk.lua":/scripts/wrk.lua \
haydenjeune/wrk2 \
-H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" \
-t1 -c100 -R100000 -d10m -s /scripts/wrk.lua http://127.0.0.1:80
```

### https压测:
```bash
curl -L -o wrk.lua https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/About%20cybersecurity/%E5%8E%8B%E6%B5%8B/wrk.lua
docker run --rm \
--name wrk \
--user root \
--network host \
--cpuset-cpus="0" \
-v "$PWD/wrk.lua":/scripts/wrk.lua \
haydenjeune/wrk2 \
-H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" \
-t1 -c100 -R100 -d10m -s /scripts/wrk.lua https://example.com
```

## 部署细节

http：
```bash
docker run --rm \
--name wrk \
--user root \
--network host \
--cpuset-cpus="0" \
williamyeh/wrk \
-t1 -c100 -d30s http://127.0.0.1:80
```
参数说明：  
- `-t1`：发起 1 条线程。
- `-c100`：维持 100 个并发 TCP 连接。
- `-d30s`：压测持续 30 秒。

https:
```bash
docker run --rm --name wrk --user root --network host --cpuset-cpus="0" williamyeh/wrk -H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" -t1 -c100 -d10s https://example.com
```

获取wrk.lua
```bash
curl -L -o wrk.lua https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/About%20cybersecurity/%E5%8E%8B%E6%B5%8B/wrk.lua
```

使用wrk.lua脚本执行https测压
```bash
docker run --rm --name wrk --user root --network host -v "$PWD/wrk.lua":/scripts/wrk.lua williamyeh/wrk -H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" -t2 -c100 -d120s -s /scripts/wrk.lua https://example.com
```

wrk2:  
获取ddos.lua
```
curl -L -o ddos.lua https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/About%20cybersecurity/%E5%8E%8B%E6%B5%8B/ddos.lua
```
执行持续测压
```bash
docker run --rm --name wrk --network host --cpuset-cpus="0" -v $(pwd):/scripts:z --user root haydenjeune/wrk2 -t1 -c100 -R10000 -d10m -s /scripts/ddos.lua https://example.com
```
参数说明：  
- `-t1`：发起 1 条线程。
- `-c100`：维持 100 个并发 TCP 连接。
- `-R10000`：目标吞吐量为 10000 RPS（Requests Per Second）,wrk2 会尝试把请求速率稳定在这一水平。
- `-d10m`：压测持续 10 分钟（10 minutes）。
- `-s /scripts/ddos.lua`：加载 Lua 脚本 /scripts/ddos.lua
- `https://example.com`：压测目标站点  
