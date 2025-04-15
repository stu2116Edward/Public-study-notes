# 我的Node.js学习笔记

### Node.js 安装配置
Node.js 安装包及源码下载地址为：https://nodejs.org/en/download  
Node.js 历史版本下载地址：https://nodejs.org/dist/  
详细安装参考：https://www.runoob.com/nodejs/nodejs-install-setup.html  

#### Windows 上安装 Node.js

Windows 安装包(.msi)  

安装步骤：

1、双击下载后的安装包，如下所示：  

2、点击以上的 Next 按钮，将出现如下界面：  

3、勾选接受协议选项，点击 Next 按钮 :  

4、Node.js默认安装目录为 "C:\Program Files\nodejs\" , 你可以修改目录，并点击 Next 按钮：  

5、点击 Install（安装） 开始安装 Node.js，你也可以点击 Back（返回）来修改先前的配置：  

安装过程：  

点击 Finish（完成）按钮退出安装向导  

安装完成后，我们可以在命令行或 Windows Powershell 中执行以下命令来测试：  
```
node -v
npm -v
```

#### Linux 上安装 Node.js
1、使用官方提供的安装脚本  
本例以 fnm 安装包管理器位说明（也可以使用 nvm等），命令如下：  
```bash
# Download and install fnm:
curl -o- https://fnm.vercel.app/install | bash

# Download and install Node.js:
fnm install 22

# Verify the Node.js version:
node -v # Should print "v22.14.0".

# Verify npm version:
npm -v # Should print "10.9.2".
```

### 创建 Node.js 应用
**步骤一、使用 require 指令来加载和引入模块**  
语法格式如下：  
```js
const module = require('module-name');
```
其中，module-name 可以是一个文件路径（相对或绝对路径），也可以是一个模块名称，如果是一个模块名称，Node.js 会自动从 node_modules 目录中查找该模块。

require 指令会返回被加载的模块的导出对象，可以通过该对象来访问模块中定义的属性和方法，如果模块中有多个导出对象，则可以使用解构赋值的方式来获取它们。

我们使用 require 指令来载入 http 模块，并将实例化的 HTTP 赋值给变量 http，实例如下:  
```js
var http = require("http");
```

**步骤二、创建服务器**  
接下来我们使用 http.createServer() 方法创建服务器，并使用 listen 方法绑定 8888 端口。 函数通过 request, response 参数来接收和响应数据。

实例如下，在你项目的根目录下创建一个叫 server.js 的文件，并写入以下代码：  
```js
var http = require('http');

http.createServer(function (request, response) {

        // 发送 HTTP 头部 
        // HTTP 状态值: 200 : OK
        // 内容类型: text/plain
        response.writeHead(200, {'Content-Type': 'text/plain'});

        // 发送响应数据 "Hello World"
        response.end('Hello World\n');
}).listen(8888);

// 终端打印如下信息
console.log('Server running at http://127.0.0.1:8888/');
```
以上代码我们完成了一个可以工作的 HTTP 服务器  

使用 node 命令执行以上的代码：
```
node server.js
```
<pre>
Server running at http://127.0.0.1:8888/
</pre>
接下来，打开浏览器访问 http://127.0.0.1:8888/，你会看到一个写着 "Hello World"的网页  

分析Node.js 的 HTTP 服务器：

`const http = require('http');`：导入 Node.js 内置的 http 模块。  
`http.createServer((req, res) => { ... });`：创建一个新的 HTTP 服务器，每次有请求时都会执行回调函数。  
`res.writeHead(200, { 'Content-Type': 'text/plain' });`：设置响应状态码和内容类型。  
`res.end('Hello World\n');`：结束响应并发送数据。  
`server.listen(PORT, () => { ... });`：监听指定端口并在服务器启动后输出信息。  
