# wrk压测

**免责声明**  
本脚本及示例命令仅供学习、教育或合法授权测试之用。使用者须确保对目标系统拥有完整所有权或已事先取得书面测试授权。任何未经授权的公网压测均可能触犯《刑法》第 285、286 条及/或其他地区法律，由此产生的一切法律责任由使用者自行承担。长压或大流量测试请提前告知相关运维团队，因未提前沟通而导致的云厂商 DDoS 防护、告警或其他后果，概与作者无关。  

## 一键部署
### http压测:
获取压测脚本
```bash
curl -L -o ddos.lua https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/About%20cybersecurity/%E5%8E%8B%E6%B5%8B/ddos.lua
```
执行压测
```bash
docker run --rm \
--name wrk \
--user root \
--network host \
--cpuset-cpus="0" \
-v "$PWD/ddos.lua":/scripts/ddos.lua \
haydenjeune/wrk2 \
-H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" \
-t1 -c100 -R100000 -d10m -s /scripts/ddos.lua http://127.0.0.1:80
```

### https压测:
获取压测脚本
```bash
curl -L -o ddos.lua https://raw.githubusercontent.com/stu2116Edward/Public-study-notes/refs/heads/main/About%20cybersecurity/%E5%8E%8B%E6%B5%8B/ddos.lua
```
执行压测
```bash
docker run --rm \
--name wrk \
--user root \
--network host \
--cpuset-cpus="0" \
-v "$PWD/ddos.lua":/scripts/ddos.lua \
haydenjeune/wrk2 \
-H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" \
-t1 -c100 -R10000 -d10m -s /scripts/ddos.lua https://example.com
```

参数说明：  
- `-t1`：发起 1 条线程。
- `-c100`：维持 100 个并发 TCP 连接。
- `-R10000`：目标吞吐量为 10000 RPS（Requests Per Second）,wrk2 会尝试把请求速率稳定在这一水平。
- `-d10m`：压测持续 10 分钟（10 minutes）。
- `-s /scripts/ddos.lua`：加载映射在容器内部的 Lua 脚本 /scripts/ddos.lua
- `https://example.com`：压测目标站点  


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
