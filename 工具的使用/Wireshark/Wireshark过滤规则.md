# Wireshark过滤规则

## 针对ip的过滤
### 对源地址进行过滤
```
ip.src == 192.168.10.1
```
### 对目的地址进行过滤
```
ip.dst == 192.168.10.1
```
### 对源地址或者目的地址进行过滤
```
ip.addr == 192.168.10.1
```

## 针对协议的过滤
### 获某种协议的数据包，表达式很简单仅仅需要把协议的名字输入即可
```
http
```
### 捕获多种协议的数据包
```
http or telnet
```
### 排除某种协议的数据包
```
not arp
```
或
```
!tcp
```

## 针对端口的过滤（视传输协议而定）
### 捕获某一端口的数据包（以tcp协议为例）
```
tcp.port == 80
```
### 捕获多端口的数据包
可以使用and来连接，下面是捕获高于某端口的表达式（以udp协议为例） 
```
udp.port >= 20000
```

## 针对长度和内容的过滤
针对长度的过虑（这里的长度指定的是`数据段的长度`）
```
udp.length < 20
```
```
http.content_length <=30
```

## 针对uri 内容的过滤
(请求的uri中包含“user”关键字的)  
!!! `matches` 后的关键字是`不区分大小写`的！`contains` 后的关键字是`区分大小`写的 !!!
```
http.request.uri matches "user"
```
针对http请求的一些过滤实例。过滤出请求地址中包含“Login”的请求，不包括域名
```
http.request.uri contains "Login"
```

## 针对http请求的一些过滤实例

### 过滤出请求地址中包含“user”的请求，不包括域名
```
http.request.uri contains "User"
```
### 精确过滤域名
```
http.host==baidu.com
```
### 模糊过滤域名
```
http.host contains "baidu"
```
### 过滤请求的content_type类型
```
http.content_type =="text/html"
```
### 过滤http请求方法
```
http.request.method=="POST"
```
### 过滤tcp端口
```
tcp.port==80
```
```
http && tcp.port==80 or tcp.port==5566
```
### 过滤http响应状态码
```
http.response.code==302
```
### 过滤含有指定cookie的http数据包
```
http.cookie contains "userid"
```

## 进阶操作
### 筛选Client Hello且SIN是某个域名
```
_ws.col.info == "Client Hello (SNI=tls-ech.dev)"
```
### 精确地显示包含 SNI 的 TLS 客户端握手（Client Hello）数据包
```
tls.handshake.extensions_server_name
```
### 只显示包含 SNI 的 Client Hello：1表示是 TLS 客户端握手 后面是包含 SNI 扩展字段
```
tls.handshake.type == 1 && tls.handshake.extensions_server_name
```
### 只显示包含 SNI 的 Client Hello：1表示是 TLS 客户端握手 后面是包含 SNI 扩展字段且模糊匹配指定域名
```
tls.handshake.type == 1 && tls.handshake.extensions_server_name && frame contains "tls-ech"
```
