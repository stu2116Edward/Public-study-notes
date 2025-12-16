# go-stress-testing go语言实现的压测工具

## 介绍
go-stress-testing 是go语言实现的简单压测工具，源码开源、支持二次开发，可以压测http、webSocket请求、私有rpc调用，使用协程模拟单个用户，可以更高效的利用CPU资源。  

项目地址：https://github.com/link1st/go-stress-testing

## 用法
[go-stress-testing](https://github.com/link1st/go-stress-testing/releases) 下载地址

clone 项目源码运行的时候，需要将项目 clone 到 $GOPATH 目录下  
用 go 环境安装  
安装最新版本 `go install github.com/link1st/go-stress-testing@latest`  
安装路径在 `echo $GOBIN` 目录下，配置了 `export PATH=$PATH:$GOROOT/bin:$GOBIN` 可以在任意目录下执行  
查看帮助信息 `go-stress-testing --help`  
支持参数：
<pre>
Usage of ./go-stress-testing-mac:
  -c uint
      并发数 (default 1)
  -n uint
      请求数(单个并发/协程) (default 1)
  -u string
      压测地址
  -d string
      调试模式 (default "false")
  -http2
    	是否开http2.0
  -k	是否开启长连接
  -m int
    	单个host最大连接数 (default 1)
  -H value
      自定义头信息传递给服务器 示例:-H 'Content-Type: application/json'
  -data string
      HTTP POST方式传送数据
  -v string
      验证方法 http 支持:statusCode、json webSocket支持:json
  -p string
      curl文件路径
</pre>
`-n` 是单个用户请求的次数，请求总次数 = `-c`* `-n`， 这里考虑的是模拟用户行为，所以这个是每个用户请求的次数  
下载以后执行下面命令即可压测  
使用示例:  
```
# 查看用法
./go-stress-testing-linux

# 使用请求百度页面
./go-stress-testing-linux -c 1 -n 100 -u https://www.baidu.com/

# 使用debug模式请求百度页面
./go-stress-testing-linux -c 1 -n 1 -d true -u https://www.baidu.com/

# 使用 curl文件(文件在curl目录下) 的方式请求
./go-stress-testing-linux -c 1 -n 1 -p curl/baidu.curl.txt

# 压测webSocket连接
./go-stress-testing-linux -c 10 -n 10 -u ws://127.0.0.1:8089/acc
```

完整压测命令示例：
```
# 更多参数 支持 header、post body
go run main.go -c 1 -n 1 -d true -u 'https://page.aliyun.com/delivery/plan/list' \
  -H 'authority: page.aliyun.com' \
  -H 'accept: application/json, text/plain, */*' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'origin: https://cn.aliyun.com' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-dest: empty' \
  -H 'referer: https://cn.aliyun.com/' \
  -H 'accept-language: zh-CN,zh;q=0.9' \
  -H 'cookie: aliyun_choice=CN; JSESSIONID=J8866281-CKCFJ4BUZ7GDO9V89YBW1-KJ3J5V9K-GYUW7; maliyun_temporary_console0=1AbLByOMHeZe3G41KYd5WWZvrM%2BGErkaLcWfBbgveKA9ifboArprPASvFUUfhwHtt44qsDwVqMk8Wkdr1F5LccYk2mPCZJiXb0q%2Bllj5u3SQGQurtyPqnG489y%2FkoA%2FEvOwsXJTvXTFQPK%2BGJD4FJg%3D%3D; cna=L3Q5F8cHDGgCAXL3r8fEZtdU; isg=BFNThsmSCcgX-sUcc5Jo2s2T4tF9COfKYi8g9wVwr3KphHMmjdh3GrHFvPTqJD_C; l=eBaceXLnQGBjstRJBOfwPurza77OSIRAguPzaNbMiT5POw1B5WAlWZbqyNY6C3GVh6lwR37EODnaBeYBc3K-nxvOu9eFfGMmn' \
  -data 'adPlanQueryParam=%7B%22adZone%22%3A%7B%22positionList%22%3A%5B%7B%22positionId%22%3A83%7D%5D%7D%2C%22requestId%22%3A%2217958651-f205-44c7-ad5d-f8af92a6217a%22%7D'
```

## 使用 curl文件进行压测
curl是Linux在命令行下的工作的文件传输工具，是一款很强大的http命令行工具。  

使用curl文件可以压测使用非GET的请求，支持设置http请求的 method、cookies、header、body等参数  

I: chrome 浏览器生成 curl文件，打开开发者模式(快捷键F12)，如图所示，生成 curl 在终端执行命令  
<img width="810" height="542" alt="copy cURL" src="https://github.com/user-attachments/assets/49082fd9-ae5c-4b16-baf6-8543bd9a5ed1" />  

II: postman 生成 curl 命令  
<img width="1141" height="850" alt="postman cURL" src="https://github.com/user-attachments/assets/98edd8f0-1af4-4883-b7ae-ec5405297dba" />  

生成内容粘贴到项目目录下的curl/example.curl.txt文件中，执行下面命令就可以从curl.txt文件中读取需要压测的内容进行压测了
```
# 使用 curl文件(文件在curl目录下) 的方式请求
go run main.go -c 1 -n 1 -p curl/example.curl.txt
```

## grpc压测
启动Server
```
# 进入 grpc server 目录
cd tests/grpc

# 启动 grpc server
go run main.go
```
对 grpc server 协议进行压测
```
# 回到项目根目录
go run main.go -c 300 -n 1000 -u grpc://127.0.0.1:8099 -data world

开始启动  并发数:300 请求数:1000 请求参数:
request:
 form:grpc
 url:grpc://127.0.0.1:8099
 method:POST
 headers:map[Content-Type:application/x-www-form-urlencoded; charset=utf-8]
 data:world
 verify:
 timeout:30s
 debug:false

─────┬───────┬───────┬───────┬────────┬────────┬────────┬────────┬────────┬────────┬────────
 耗时 │ 并发数 │ 成功数 │ 失败数 │   qps  │最长耗时  │最短耗时 │平均耗时  │下载字节 │字节每秒  │ 错误码
─────┼───────┼───────┼───────┼────────┼────────┼────────┼────────┼────────┼────────┼────────
   1s│    186│  14086│      0│34177.69│   22.40│    0.63│    8.78│        │        │200:14086
   2s│    265│  30408│      0│26005.09│   32.68│    0.63│   11.54│        │        │200:30408
   3s│    300│  46747│      0│21890.46│   40.84│    0.63│   13.70│        │        │200:46747
   4s│    300│  62837│      0│20057.06│   45.81│    0.63│   14.96│        │        │200:62837
   5s│    300│  79119│      0│19134.52│   45.81│    0.63│   15.68│        │        │200:79119
```

### 压测过程中查看系统状态
```bash
ps      # 查看进程内存、CPU使用情况
iostat  # 查看系统IO情况
nload   # 查看网络流量情况
/proc/pid/status # 查看进程状态
```

## Windows
```
go-stress-testing-win.exe -c 1 -n 100 -u https://example.com
```

参数说明:  
- `-c` 表示并发数
- `-n` 每个并发执行请求的次数，总请求的次数 = 并发数 * 每个并发执行请求的次数
- `-u` 需要压测的地址

**压测结果展示**  
执行以后，终端每秒钟都会输出一次结果，压测完成以后输出执行的压测结果  

## Linux
```
./go-stress-testing-linux -c 1 -n 100 -u https://example.com
```

## Mac
```
./go-stress-testing-mac -c 1 -n 100 -u https://example.com
```

## Docker
可以使用Dockerfile构建一个容器镜像，假设容器镜像名称为`gostress:latest`
```bash
docker build -t gostress:latest .
```
启动一个名称为`go-stress`的容器
```bash
docker run -d --name=go-stress gostress:latest
```
开始压测 
```bash
docker exec -it go-stress -c 10 -n 10 -u www.example.com
```
<pre>
─────┬───────┬───────┬───────┬────────┬────────┬────────┬────────┬────────
 耗时│ 并发数 │ 成功数│ 失败数 │   qps  │最长耗时 │最短耗时│平均耗时 │ 错误码
─────┼───────┼───────┼───────┼────────┼────────┼────────┼────────┼────────
   1s│      1│      8│      0│    8.09│  133.16│  110.98│  123.56│200:8
   2s│      1│     15│      0│    8.02│  138.74│  110.98│  124.61│200:15
   3s│      1│     23│      0│    7.80│  220.43│  110.98│  128.18│200:23
   4s│      1│     31│      0│    7.83│  220.43│  110.23│  127.67│200:31
   5s│      1│     39│      0│    7.81│  220.43│  110.23│  128.03│200:39
   6s│      1│     46│      0│    7.72│  220.43│  110.23│  129.59│200:46
   7s│      1│     54│      0│    7.79│  220.43│  110.23│  128.42│200:54
   8s│      1│     62│      0│    7.81│  220.43│  110.23│  128.09│200:62
   9s│      1│     70│      0│    7.79│  220.43│  110.23│  128.33│200:70
  10s│      1│     78│      0│    7.82│  220.43│  106.47│  127.85│200:78
  11s│      1│     84│      0│    7.64│  371.02│  106.47│  130.96│200:84
  12s│      1│     91│      0│    7.63│  371.02│  106.47│  131.02│200:91
  13s│      1│     99│      0│    7.66│  371.02│  106.47│  130.54│200:99
  13s│      1│    100│      0│    7.66│  371.02│  106.47│  130.52│200:100


*************************  结果 stat  ****************************
处理协程数量: 1
请求总数: 100 总请求时间: 13.055 秒 successNum: 100 failureNum: 0
*************************  结果 end   ****************************
</pre>

参数解释:
- `耗时`: 程序运行耗时。程序每秒钟输出一次压测结果
- `并发数`: 并发数，启动的协程数
- `成功数`: 压测中，请求成功的数量
- `失败数`: 压测中，请求失败的数量
- `qps`: 当前压测的 QPS (每秒钟处理请求数量)
- `最长耗时`: 压测中，单个请求最长的响应时长
- `最短耗时`: 压测中，单个请求最短的响应时长
- `平均耗时`: 压测中，单个请求平均的响应时长
- `错误码`: 压测中，接口返回的 code 码:返回次数的集合

