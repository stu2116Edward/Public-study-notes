# Node.js使用教程

**前言**
Node.js 是一个基于 Chrome V8 引擎构建的 JavaScript 运行时环境，它能够使 JavaScript 在服务器端运行。它拥有强大的包管理器 npm，使开发者能够轻松管理和共享 JavaScript 代码包  
传统的来说JavaScript是运行在浏览器中的网页上的脚本语言，以前这是前端开发人员才用的。实际工作中往往很难做到前后端完全分离，很多前端开发人员也要会写点后端代码，方便自己测试页面功能使用  
以前开发后端程序都需要用到另外的一门编程语言，后来有人就想了，既然JavaScript可以用来编程，可以被浏览器内核解释执行，那直接拿这个来编写后端程序也可以。这样对于web开发人员来说不管前端还是后端都只要会JavaScript就行。最后这就成为了现在流行的 Node.js  
Node.js最先是用来开发后端程序用的，现在它的功能已经不仅仅如此了，还被用在其它很多地方，比如用来开发跨平台的桌面应用程序等  


## Node.js下载与安装
Node.js官网： https://nodejs.org/  
Node.js中文网： http://nodejs.cn/  
镜像下载地址: https://registry.npmmirror.com/binary.html?path=node/  
下载完成后直接点击安装即可  
下载安装没有太多好说的，通常来说使用长期维护版（LTS）版就行  
安装完成后可以在终端中使用 `node -v` 或是 `node --version` 来查看当前nodejs版本：  
![node1](https://github.com/user-attachments/assets/aebaf8c0-c2cc-493f-916b-e0f8f01ec4c7)  

Tips: 若有使用多版本 nodejs 需求, 可以了解下 nvm 工具,用于管理多 nodejs 版本, 并且方便完成不同版本的 nodejs 切换  
nvm 工具项目地址为：https://github.com/nvm-sh/nvm  
nvm 工具也有类似的window版本的：https://github.com/coreybutler/nvm-windows  


npm 国内镜像源配置
```
# 设置国内源
npm config set registry https://registry.npmmirror.com

# 查看当前源地址
npm get registry
```

另外再说下Linux中安装Node.js，主要方式就是通过包管理器、二进制文件、源码三种方式，三种方式都可以在官网上找到说明  
![node2](https://github.com/user-attachments/assets/52c558a1-9104-45ba-8697-bb1b1db88b04)  

需要注意的是如果是基于 Debian 和 Ubuntu 这类的Linux，在使用包管理器安装时需要先设置下版本，比如在Ubuntu或者树莓派上可以使用下面方式安装最新的LTS版本：  
```
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
```

## 入门使用
### 运行JavaScript代码
安装了Node.js后就可以使用它来运行JavaScript代码了，我们可以在终端中输入 node 来进入REPL（交互式解释器），可以在这里键入并运行js代码：  
![node3](https://github.com/user-attachments/assets/e7ba11c3-f5a6-403b-bde1-c86dc112761b)  

当然大多数时候我们都是直接用node来运行js文件， `node filmename` ：  
![node4](https://github.com/user-attachments/assets/8d86393d-cbbd-48e3-9fdd-16bb182947df)  


### 简单的web服务器示例
下面是官方的简单示例：  
```
const http = require('http') // 引入http模块

const hostname = '127.0.0.1'
const port = 3000

// 创建web服务器
const server = http.createServer((req, res) => {
    // req为来自客户端的请求
    // res为服务应答
    res.statusCode = 200 // 设置状态码
    res.setHeader('Content-Type', 'text/plain') // 设置响应头字段
    res.end('Hello World\n') // 发送消息并结束本次连接
})

// 启动服务器
server.listen(port, hostname, () => {
    console.log(`Server running at http://${hostname}:${port}/`) // 启动成功后输出信息
})
```
![node5](https://github.com/user-attachments/assets/9aae6adc-a7c8-4fd6-9d3c-e676f7d2a5e1)  


上面是个最简单的例子，可以在终端中按键盘上ctrl+c终止程序。对于web服务器来说最主要的就是处理来自客户端的请求 request ，然后根据请求内容向客户端返回响应 response ，两者分别就是上面的 req 和 res 两个对象  
通常情况下一个web前端应用会访问很多不同的接口，所以对于web服务器而言也需要对不同的接口提供不同的操作，比如下面例子：  
```
const http = require('http')

const server = http.createServer((req, res) => {
    console.log(req.method)
    console.log(req.url)
    if ((req.method == 'GET')&&(req.url == '/a')) { // 以GET方法访问链接/a
        res.statusCode = 200
        res.end('url a\n')
        return
    }
    if ((req.method == 'GET')&&(req.url == '/b')) { // 以GET方法访问链接/b
        res.statusCode = 200 
        res.end('url b\n')
        return
    }
    // 对于未指定的链接返回404
    res.statusCode = 404 
    res.end('not found\n')
})

server.listen(3000, '127.0.0.1', () => {
    console.log(`Server running at http://127.0.0.1:3000/`)
})
```
![node6](https://github.com/user-attachments/assets/d2d9b26e-3589-4787-8d9a-1ca184708456)  

如果只是简单应用的话在上面的基础上稍微再加工下就可以当作一般的web使用的。当然实际项目中你也可以使用现成的库，比如 `koa` 、 `Fastify` 等第三方库  

### 内置功能
上面演示中使用 `const http = require('http')` 方式用到了Node.js内置的 http 模块。Node.js内置了很多的模块、对象、方法、变量等，这里稍微列举下一些常用的：  

- 全局变量：  
__filename 当前运行的脚本文件名；  
__dirname 当前运行的脚本所在的目录；  

- 全局方法：  
setTimeout() 设定时间后执行一次回调函数；  
setInterval() 以设定的时间间隔反复执行回调函数；  

- 全局对象：  
global Node.js全局对象，有点类似与浏览器中的window对象；  
process 程序所处的主进程，比如在程序中可以使用 process.exit(0) 来退出程序， 0 表示正常退出，其它值（比如 1）表示非正常退出；   
console 提供终端输入输出功能；  

- 内置模块：  
http 提供HTTP客户端和服务器功能；  
fs 与文件系统交互；  
path 处理路径；  
until 提供很多实用工具，增强JavaScript的体验；  

上面只是简单列举了下常用的内置功能，更多内容与详细介绍可以参考官方API文档：  
https://nodejs.org/en/docs/  


**调试代码**
Node.js程序开发的时候调试和其它很多语言都差不多，依赖于日志输出，比如多打印 console.log() ，如果工具好的话还可以打断点调试，比如在VS Code中就可以用下面的方式打断点调试：  
![node7](https://github.com/user-attachments/assets/e35f8cba-587a-42be-939b-6a7c3a68d915)  


### 异步操作与事件循环
***为什么需要异步操作***  
默认情况下JavaScript代码是单线程运行的，CPU在执行程序的时候只能一步步进行，这种方式有个比较大的问题，比如下面代码：  
```
function tast1() {
    f = readfile() // 读写文件通常都是耗时操作
    if(f) {
		f.fun() // 读取文件成功后再进一步处理
	}
}

function tast2() { }

tast1()
tast2()
```

上面代码中 tast1() 中执行了一个耗时操作， tast2() 必须等到 tast1() 执行完后才会执行。但事实上面 读文件 这个工作本身并不需要CPU参与多少，更多的是再等待IO口完成文件操作，这个等待的过程完全可以让CPU干点别的，比如执行 tast2()  
大多数语言中上面情况多是通过多线程编程来实现的， tast1() 和 tast2() 分别放到两个线程中执行。而在Node.js中因为历史原因一开始主要是单线程的，所以对于上面的问题大多数时候都是依赖异步操作（asynchronous operation）来处理的。比如上面的文件读取在Node.js通常用下面方式操作：  
```
const fs = require('fs'); // 引入fs模块

fs.readFile('/naisu.txt', function (err, data) {
    if (err == null) {
        console.log('读取成功')
    }
    else {
        console.log('读取失败');
    }
});
```
Node.js中fs模块的 readFile 方法是异步的（fs模块也有同步读取文件的方法，比如readFileSync），在Node.js中通常规定 异步方法的最后一个参数为回调函数，该回调函数的第一个参数为异步操作过程中的错误对象，如果没有发生错误则该对象为 `null`  
我们可以在上面代码的下面再加一条输出语句做测试：  
![node8](https://github.com/user-attachments/assets/ca9bb26d-8539-45cd-a47d-98cdd4157bbd)  

可以看到上面测试中先输出了后面的语句，后输出前面的语句。Node.js中很多方法都是异步的，并且不会显式的声明（反而同步的方法会有sync词缀），这在编程时需要特别注意  
实现自己的异步操作  
除了各种库中的异步操作用户也可以自己实现异步操作，主要可用的方式如下：  
`process.nextTick()`  
process是Node.js中的主进程，其 nextTick() 方法可以设置在当前一阶段工作完成后立刻执行回调函数，用法如下：  
```
process.nextTick(() => {
  // TODO
})
```

`setImmediate()`  
这个和前面的方法功能上差不多，响应速度上稍微慢一步，用法如下：  
```
const immediateObj = setImmediate(() => {
  // TODO
})

clearImmediate(immediateObj); // 取消已设置的任务
```

`setTimeout()` 和 `setInterval()`  
这两个就是一般所说的定时器了，在浏览器中的JavaScript代码也有这两个方法，，因为比较好用所以Node.js也提供了这两个方法。用法主要如下：  
```
const timeoutObj = setTimeout(() => {
  // TODO
}, 1000)  // 设置1000ms后执行一次

clearTimeout(timeoutObj); // 取消已设置的任务

const intervalObj = setInterval(() => {
  // TODO
}, 1000)  // 设置每隔1000ms执行一次

clearInterval(intervalObj); // 取消已设置的任务
```

上面是一些最基本的异步操作实现方式，但上面的方式在某些时候并不好用，所以后面又出现了一些新的方式，主要是下面两种：  
`Promise`  
Promise是稍微新一点的处理异步操作的机制，这个功能很强大，这里稍微提下最简单的使用方式：  
```
let done = true

const isItDoneYet = new Promise((resolve, reject) => {
    // 开始异步动作，并返回
    if (done) {
        resolve('workDone')
    } else {
        reject('err')
    }
})

isItDoneYet.then((data) => { // 操作成功回调，这里传入的data就是resolve中传入的数据
    console.log(data);
}).catch((data) => { // 操作失败回调，这里传入的data就是reject中传入的数据
    console.log(data); 
});
```

`Async/Await`  
Async/Await 是比 Promise 更新一点的异步操作机制，更多的算是 Promise 的语法糖。下面是个基本的使用方式：  
```
const fnPromise = new Promise((resolve, reject) => {
    if (true) {
        resolve('data');
    } else {
        reject('err');
    }
})

const fnAsync = async () => {
    try {
        let data = await fnPromise;
        console.log(data);
    } catch (err) {
        console.log(err);
    }
}

fnAsync()
```

### 事件循环
从前面知道JavaScript主要是单线程运行的，但Node.js中又用了很多异步操作，那它是怎么来调度这些工作的呢，Node.js主要依靠事件循环（Event Loop）的机制来处理这个问题  
事件循环简单点讲就是把当前一个阶段立即要执行的任务列出来一个个执行，执行完成后再看看那些异步操作的回调函数，执行下已经就绪的回调。再接着就是开启新一轮的循环，依此往复  
前面小节中的几种异步操作的方法最大的一个区别就是在事件循环中回调函数执行顺序不同。通常来说在同一层级中 **process.nextTick()** 拥有最快的响应，接着是 **Promise** 和 **Async/Await** ，再接着是 **setImmediate()** ，最后是 **setTimeout()** 和 **setInterval()** 。需要注意的一点是 **setImmediate()** 和 **setTimeout(()=>{}, 0)** 两者的先后有时候有时并不完全固定的  
用下面代码进行测试：  
```
const fnPromise = new Promise((resolve, reject) => {
    resolve('Promise');
})

const fnAsync = async () => {
    let data = await fnPromise;
    console.log('Async > ' + data);
}

const fnImmediatePromise = new Promise((resolve, reject) => {
    setImmediate(() => { 
        resolve('ImmediatePromise');
    });
})

const fnImmediateAsync = async () => {
    let data = await fnImmediatePromise;
    console.log('Async > ' + data);
}

// 下面开始打印输出

console.log('start');


setTimeout(() => {
    console.log('setTimeout()');
}, 0);

setImmediate(() => {
    console.log('setImmediate()');
});

process.nextTick(() => {
    console.log('process.nextTick()');
});

fnPromise.then((data)=>{
    console.log(data);
});

fnAsync();

fnImmediateAsync();

console.log('end');
```
![node9](https://github.com/user-attachments/assets/5e9ba663-ad3b-4dbd-a32a-febd3c6ef396)  

上面代码可以随意改变打印输出的先后顺序，多测试几次，基本上除了 setImmediate() 和 setTimeout(()=>{}, 0) 的问题，其它部分输出顺序基本都是不会变的  

更多内容可以参考下面文章：  
[!《setTimeout和setImmediate到底谁先执行，本文让你彻底理解Event Loop》](https://blog.csdn.net/dennis_jiang/article/details/105044361)  

## 总结
Node.js最基础的一些内容就是上面这些了，除此之外还有 npm 工具和 CommonJS 规范也是比较重要的内容，会在接下来的文章中进行说明。更多内容可以参考官方文档：  
https://nodejs.dev/learn  
https://nodejs.org/en/docs/  
