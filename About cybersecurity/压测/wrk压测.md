# wrk压测

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

https:
```bash
docker run --rm --name wrk --user root --network host --cpuset-cpus="0" williamyeh/wrk -H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" -t1 -c100 -d10s https://example.com
```

```bash
docker run --rm --name wrk --user root --network host -v "$PWD/wrk.lua":/scripts/wrk.lua williamyeh/wrk -H "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" -t2 -c100 -d120s -s /scripts/wrk.lua https://example.com
```

wrk2:
```bash
docker run --rm --name wrk --network host --cpuset-cpus="0" -v $(pwd):/scripts:z --user root haydenjeune/wrk2 -t1 -c100 -R10000 -d10m -s /scripts/ddos.lua https://example.com
```
http:
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
-t1 -c100 -R100000 -d10s -s /scripts/wrk.lua http://127.0.0.1:80
```
https:
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
-t1 -c100 -R100 -d10s -s /scripts/wrk.lua https://example.com
```
