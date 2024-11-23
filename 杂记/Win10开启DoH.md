# Win10 操作系统开启 DoH（DNS over HTTPS）加密DNS

Win11 已原生支持 DoH 加密 DNS，就不多赘述了，因为缙哥哥讨厌圆角，以及繁琐的右键，所以回滚到 Windows 10 操作系统，结果发现 Win10 系统不支持加密 DNS 的设置，经过网上查询资料结合自己的实际操作，特此记录一下，以便自己查询同时供小伙伴们参考  
本文 Win10 配置加密 DNS 使用 Cloudflared 实现。版本低于 Windows 10 build 19628 的均可使用  

使用的项目: https://github.com/cloudflare/cloudflared  
从 https://github.com/cloudflare/cloudflared/releases 下载对应的系统版本  
我下载的是 cloudflared-windows-amd64.exe  
进入存放 `cloudflared-windows-amd64.exe` 的目录，`管理员权限`开启 `powershell`
扩展阅读[《在 Windows 上安装 PowerShell》](https://learn.microsoft.com/zh-cn/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.4#winget)  
运行：  
```
.\cloudflared-windows-amd64.exe service install
```
新建一个配置文件`D:\dujin\config.yml`（任意位置都可以），内容如下：
```
proxy-dns: true
proxy-dns-upstream:
  - https://223.5.5.5/dns-query
  - https://doh.pub/dns-query
  - https://1.1.1.1/dns-query
  - https://doh.opendns.com/dns-query
  - https://dns.google/dns-query
```
修改注册表，注册表路径`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Cloudflared`  
在 `ImagePath` 后面添加 yml 文件位置，如(注意这里有个空格)  
```
 --config D:\dujin\config.yml
```

以管理员权限运行 powershell，执行
```
Start-Service Cloudflared
```
运行之后，将网络的 DNS 改为127.0.0.1即可

**验证**：
网卡抓取本地环回地址，过滤DNS协议，验证DNS解析到本地cloudfared服务：  



**DoH服务器列表**
国内DoH服务器列表：
```
https://223.5.5.5/dns-query
https://223.6.6.6/dns-query
https://dns.alidns.com/dns-query
https://doh.pub/dns-query
https://doh.360.cn/dns-query
```
国外DoH服务器列表：
```
https://dns.google/dns-query
https://dns.quad9.net/dns-query
https://doh.opendns.com/dns-query
https://1.1.1.1/dns-query
https://1.0.0.1/dns-query
https://cloudflare-dns.com/dns-query
https://dns.adguard.com/dns-query
```