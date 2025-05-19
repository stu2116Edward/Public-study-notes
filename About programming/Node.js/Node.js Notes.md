# 我的Node.js学习笔记

### Node.js 安装配置
Node.js 安装包及源码下载地址为：https://nodejs.org/en/download  
Node.js 历史版本下载地址：https://nodejs.org/dist/  
详细安装参考：https://www.runoob.com/nodejs/nodejs-install-setup.html  

#### Windows 上安装 Node.js
下载安装包：  
![Node jsWind1](https://github.com/user-attachments/assets/27417a79-8a76-44a7-bb04-a8b2292592c9)  
Windows 安装包(.msi)  
![Node jsWind2](https://github.com/user-attachments/assets/b8de7406-7b22-4a05-a619-c51ca7fc7fe2)  

安装步骤：  
1、双击下载后的安装包，如下所示：  
![Node jsWind3](https://github.com/user-attachments/assets/8ed2341d-9f65-47ef-b973-52d4b15d6bb4)

2、点击以上的 Next 按钮，将出现如下界面：  
![Node jsWind4](https://github.com/user-attachments/assets/3fc0ec57-0311-4674-a350-2f0c486f37ac)

3、勾选接受协议选项，点击 Next 按钮:  
![Node jsWind5](https://github.com/user-attachments/assets/f287a8c3-ab3b-4c50-9883-989a6dd76f6c)  

4、Node.js默认安装目录为 "C:\Program Files\nodejs\" , 你可以修改目录，并点击 Next 按钮：  
![Node jsWind6](https://github.com/user-attachments/assets/989fca60-4100-4367-9d38-44f72f28f965)  

5、点击 Install（安装） 开始安装 Node.js，你也可以点击 Back（返回）来修改先前的配置：  
![Node jsWind7](https://github.com/user-attachments/assets/68f18990-0ea1-4e9e-8951-b587799b3656)  

安装过程：  
![Node jsWind8](https://github.com/user-attachments/assets/cb8474b3-2a27-4605-a564-82c7a6e1b5ea)  

点击 Finish（完成）按钮退出安装向导  
![Node jsWind9](https://github.com/user-attachments/assets/b63ed6f2-1e66-482a-945d-86eb87b4b33e)  

安装完成后，我们可以在命令行或 Windows Powershell 中执行以下命令来测试：  
```
node -v
npm -v
```
![Node jsWind10](https://github.com/user-attachments/assets/c8d606ad-4274-473e-bd30-3e2ece21cb30)  


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

## 精简讲解
### Node.js 基本语法
Hello World 示例  
创建一个新的 JavaScript 文件 app.js，并输入以下代码：
```js
console.log("Hello, World!");
```
在终端中运行：
```
node app.js
```
输出结果：
<pre>
Hello, World!
</pre>

#### 变量与数据类型
Node.js 支持 JavaScript 的所有基本数据类型，包括：
- 字符串：`let name = "Node.js";`
- 数字：`let age = 25;`
- 布尔值：`let isNode = true;`
- 数组：`let fruits = ["apple", "banana", "orange"];`
- 对象：`let person = { name: "Alice", age: 30 };`

#### 控制结构
Node.js 支持常见的控制结构，如条件语句和循环:  
**if条件语句**  
```js
let age = 18;
if (age >= 18) {
    console.log("成年人");
} else {
    console.log("未成年人");
}
```
**for循环**  
```js
for (let i = 0; i < 5; i++) {
    console.log(i);
}
```
**while循环**  
```js
let i = 0;
while (i < 5) {
    console.log(i);
    i++;
}
```

#### 模块系统
Node.js 的模块化设计使得代码更易于维护和复用。使用 `require` 导入模块，使用 `module.exports` 导出模块  

**创建模块**  
创建一个名为 math.js 的文件，内容如下：
```js
function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

module.exports = {
    add,
    subtract
};
```

**使用模块**  
在 app.js 中使用刚刚创建的模块：
```js
const math = require('./math');

console.log(math.add(5, 3)); // 输出 8
console.log(math.subtract(5, 3)); // 输出 2
```

#### 异步编程
Node.js 的异步编程模型是其核心特性之一。通过`回调函数`、`Promise` 和 `async/await` 来处理异步操作  

**回调函数**  
```js
const fs = require('fs');

fs.readFile('example.txt', 'utf8', (err, data) => {
    if (err) {
        console.error(err);
        return;
    }
    console.log(data);
});
```

**Promise**  
```js
const fs = require('fs').promises;

fs.readFile('example.txt', 'utf8')
    .then(data => {
        console.log(data);
    })
    .catch(err => {
        console.error(err);
    });
```

**async/await**  
```js
const fs = require('fs').promises;

async function readFile() {
    try {
        const data = await fs.readFile('example.txt', 'utf8');
        console.log(data);
    } catch (err) {
        console.error(err);
    }
}

readFile();
```

#### 创建 Web 服务器
Node.js 可以轻松创建 HTTP 服务器。以下是一个简单的服务器示例：
```js
const http = require('http');

const server = http.createServer((req, res) => {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain');
    res.end('Hello, Node.js!\n');
});

server.listen(3000, () => {
    console.log('服务器运行在 http://localhost:3000/');
});
```
在终端中运行该文件后，打开浏览器访问 `http://localhost:3000/`，你将看到 `Hello, Node.js!` 的输出  

#### 使用 Express 框架
Express 是 Node.js 最流行的 Web 应用框架之一，简化了服务器的创建和路由管理  

**安装 Express**  
使用 npm 安装 Express：
```
npm install express
```

**创建一个简单的 Express 应用**
```js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Hello, Express!');
});

app.listen(3000, () => {
    console.log('Express 服务器运行在 http://localhost:3000/');
});
```

**路由管理**
```js
app.get('/about', (req, res) => {
    res.send('关于页面');
});

app.get('/contact', (req, res) => {
    res.send('联系页面');
});
```

#### 错误处理
在 Node.js 中，错误处理是非常重要的。可以使用 `try...catch` 语句处理同步代码中的错误，对于异步代码，可以在 Promise 中使用 `.catch()` 方法  
```js
async function riskyOperation() {
    try {
        // 可能抛出错误的操作
    } catch (error) {
        console.error("发生错误：", error);
    }
}
```

#### 中间件
在 Express 中，中间件是处理请求和响应的函数。可以用于日志记录、请求解析、身份验证等  

**创建中间件**
```js
app.use((req, res, next) => {
    console.log(`${req.method} ${req.url}`);
    next(); // 调用下一个中间件
});
```

**使用现成的中间件**
可以使用 body-parser 中间件解析请求体：
```
npm install body-parser
```
```js
const bodyParser = require('body-parser');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
```

#### 部署 Node.js 应用
将 Node.js 应用部署到云服务器中  
1. 选择云服务提供商：选择适合的云服务提供商并创建账户
2. 配置服务器：根据提供商的文档配置服务器环境
3. 上传代码：使用 Git 或 TFTP 将代码上传到服务器
4. 安装依赖：在服务器上运行 `npm install` 安装依赖
5. 启动应用：使用 `node app.js` 启动应用，或者使用 PM2 等进程管理工具保持应用运行

## 详细讲解
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


### NPM 使用介绍
NPM（Node Package Manager）是一个 JavaScript 包管理工具，也是 Node.js 的默认包管理器。

NPM 允许开发者轻松地下载、安装、共享、管理项目的依赖库和工具。

NPM 是 Node.js 自带的包管理工具，因此，通常你只需安装 Node.js，NPM 就会自动安装在系统中。

通过输入 npm -v 来测试是否成功安装，出现版本提示表示安装成功:
<pre>
$ npm -v
2.3.0
</pre>
如果你安装的是旧版本的 npm，可以很容易得通过 npm 命令来升级，命令如下：
<pre>
$ sudo npm install npm -g
/usr/local/bin/npm -> /usr/local/lib/node_modules/npm/bin/npm-cli.js
npm@2.14.2 /usr/local/lib/node_modules/npm
</pre>
如果是 Window 系统使用以下命令即可：
```
npm install npm -g
```

#### 使用 npm 命令安装模块
npm 安装 Node.js 模块语法格式如下：
```
npm install <Module Name>
```
以下实例，我们使用 npm 命令安装常用的 Node.js web框架模块 express:
```
npm install express
```
安装好之后，express 包就放在了工程目录下的 node_modules 目录中，因此在代码中只需要通过 `require('express')` 的方式就好，无需指定第三方包路径
```
let express = require('express');
```

#### 全局安装与本地安装
npm 的包安装分为本地安装（local）、全局安装（global）两种，从敲的命令行来看，差别只是有没有 `-g` 参数  

本地安装：将包安装到 `node_modules` 目录，并将信息保存到 `package.json` 的 `dependencies` 中  
```
npm install express  
```

全局安装：用于安装命令行工具或需要在多个项目中使用的包
```
npm install express -g
```
如果出现以下错误：
<pre>
npm err! Error: connect ECONNREFUSED 127.0.0.1:8087 
</pre>
解决办法为：
```
npm config set proxy null
```

| 特性         | 本地安装                                      | 全局安装                                      |
|--------------|-----------------------------------------------|-----------------------------------------------|
| 安装范围     | 仅在当前项目中可用                            | 在系统的全局环境中可用                        |
| 命令使用     | `npm install package-name`                    | `npm install -g package-name`                  |
| 安装位置     | 项目目录下的 `node_modules` 目录              | 系统全局目录（依 OS 而异）                     |
| 使用场景     | 项目依赖（库、框架）                          | CLI 工具、项目生成器                           |
| 访问方式     | 通过 `require()` 或 `import` 使用             | 在命令行中直接使用                             |
| 依赖声明     | 在 `package.json` 中记录                      | 不在 `package.json` 中记录                     |
| 版本控制     | 不同项目中可用不同版本                        | 系统中只保留一个版本                           |
| 权限问题     | 无需特殊权限                                  | 可能需要管理员权限                             |
如果你希望具备两者功能，则需要在两个地方安装它或使用 `npm link`  

#### 查看安装信息
你可以使用以下命令来查看所有全局安装的模块：
```
npm list -g
```
如果要查看某个模块的版本号，可以使用命令如下：
```
npm list <模块名称>
```

#### 卸载模块
我们可以使用以下命令来卸载 Node.js 模块
```
npm uninstall <模块名称>
```
卸载后，你可以到 /node_modules/ 目录下查看包是否还存在，或者使用以下命令查看：
```
npm ls
```

#### 更新模块
我们可以使用以下命令更新模块：
```
npm update <模块名称>
```

#### 搜索模块
使用以下来搜索模块：
```
npm search <模块名称>
```

#### 创建模块
创建模块，**package.json 文件是必不可少的**。我们可以使用 NPM 生成 package.json 文件，生成的文件包含了基本的结果  
<pre>
$ npm init
This utility will walk you through creating a package.json file.
It only covers the most common items, and tries to guess sensible defaults.

See `npm help json` for definitive documentation on these fields
and exactly what they do.

Use `npm install <pkg> --save` afterwards to install a package and
save it as a dependency in the package.json file.

Press ^C at any time to quit.
name: (node_modules) runoob                   # 模块名
version: (1.0.0) 
description: Node.js 测试模块(www.runoob.com)  # 描述
entry point: (index.js) 
test command: make test
git repository: https://github.com/runoob/runoob.git  # Github 地址
keywords: 
author: 
license: (ISC) 
About to write to ……/node_modules/package.json:      # 生成地址

{
  "name": "runoob",
  "version": "1.0.0",
  "description": "Node.js 测试模块(www.runoob.com)",
  ……
}


Is this ok? (yes) yes
</pre>
以上的信息，你需要`根据你自己的情况输入。在最后输入 "yes" 后会生成 package.json 文件`  

接下来我们可以使用以下命令在 npm 资源库中注册用户（使用邮箱注册）：
<pre>
$ npm adduser
Username: mcmohd
Password:
Email: (this IS public) mcmohd@gmail.com
</pre>

接下来我们就用以下命令来发布模块：
```
npm publish
```
如果你以上的步骤都操作正确，你就可以跟其他模块一样使用 npm 来安装  

**版本号**  
MAJOR（主版本）：当你做了不兼容的 API 改动时增加。例如：`2.0.0`  
MINOR（次版本）：当你添加新功能但保持向后兼容时增加。例如：`1.1.0`  
PATCH（补丁版本）：当你修复 bug 而不增加新功能时增加。例如：`1.0.1`  

预发布版本：如 `1.0.0-alpha` 或 `1.0.0-beta.1`，表示该版本仍在测试中  
构建元数据：如 `1.0.0+build.1`，提供有关构建的信息  

安装示例:
- 安装特定版本:
```
npm install package-name@1.2.3
```
- 安装最新的主版本（安装 1.x.x 的最新版本）:
```
npm install package-name@^1.2.3
```

#### NPM 常用命令
NPM 提供了很多命令，可以使用 `npm help` 可查看所有命令  

| 命令 | 说明 |
|------|------|
| `npm init` | 初始化一个新的 `package.json` 文件，交互式输入信息。 |
| `npm init -y` | 快速创建带有默认设置的 `package.json` 文件。 |
| `npm install package-name` | 本地安装指定包。 |
| `npm install -g package-name` | 全局安装指定包，使其在系统范围内可用。 |
| `npm install` | 安装 `package.json` 中列出的所有依赖。 |
| `npm install package-name --save-dev` | 安装包并添加到 `devDependencies`。 |
| `npm update package-name` | 更新指定的依赖包。 |
| `npm uninstall package-name` | 卸载指定的依赖包。 |
| `npm uninstall -g package-name` | 全局卸载指定的包。 |
| `npm list` | 查看当前项目的已安装依赖包列表。 |
| `npm list -g --depth=0` | 查看全局已安装的依赖包列表（不展开依赖树）。 |
| `npm info package-name` | 查看包的详细信息，包括版本和依赖等。 |
| `npm login` | 登录到 NPM 账号。 |
| `npm publish` | 发布当前包到 NPM 注册表。 |
| `npm unpublish package-name` | 从 NPM 注册表中撤销发布的包（一般限 24 小时内）。 |
| `npm cache clean --force` | 清理 NPM 缓存。 |
| `npm audit` | 检查项目依赖中的安全漏洞。 |
| `npm audit fix` | 自动修复已知的漏洞。 |
| `npm run script-name` | 运行 `package.json` 中定义的脚本，例如 `npm run start`。 |
| `npm start` | 运行 `start` 脚本（等同于 `npm run start`）。 |
| `npm test` | 运行 `test` 脚本。 |
| `npm build` | 运行 `build` 脚本。 |
| `npm outdated` | 列出项目中有可更新版本的依赖包。 |
| `npm version patch/minor/major` | 更新 `package.json` 中的版本号，自动更新版本。 |
| `npm ci` | 使用 `package-lock.json` 快速安装依赖，适用于 CI/CD 环境。 |

#### 使用 NPM 镜像
使用registry镜像的方式下载：
```
$ npm install -g cnpm --registry=https://registry.npmmirror.com
```

#### package.json 的说明与使用
package.json 是 Node.js 项目中的一个核心文件，包含了项目的元数据、依赖、脚本等信息  

`package.json` 文件用于描述项目的元数据和依赖关系，它通常位于项目的根目录中，并且`是项目的配置文件`  

package.json 文件是一个 `JSON 格式`的文件，包含以下基本字段：  
- `name`：项目的名称，应该是唯一的，通常使用小写字母和连字符
- `version`：项目的版本号，遵循语义化版本控制（Semantic Versioning）
- `description`：项目的简短描述
- `main`：项目的入口文件，通常是应用程序的启动文件
- `scripts`：定义了一系列的命令行脚本，可以在项目中执行特定的任务
- `dependencies`：列出了项目运行所需的所有依赖包及其版本
- `devDependencies`：列出了只在开发过程中需要的依赖包及其版本
- `peerDependencies`：列出了项目期望其依赖包也依赖的包
- `optionalDependencies`：列出了可选的依赖包
- `engines`：指定了项目兼容的 Node.js 版本
- `repository`：项目的代码仓库信息，如 GitHub 仓库的 URL
- `keywords`：项目的关键词，有助于在 npm 搜索中找到项目
- `author`：项目的作者信息
- `license`：项目的许可证信息

**使用方法**：
1. **初始化项目**：在项目目录中运行 `npm init` 命令，npm 会引导你创建一个 package.json 文件，或者自动生成一个包含默认值的 package.json  
2. **安装依赖**：使用 `npm install <package-name>` 命令安装依赖，npm 会自动将依赖添加到 package.json 文件的 dependencies 或 devDependencies 中，并`创建 package-lock.json 文件以锁定依赖的版本`  
3. **管理脚本**：在 scripts 字段中定义命令，例如 `"start": "node app.js"`，然后可以通过 `npm start` 命令来运行这些脚本  
4. **版本控制**：使用 `npm version` 命令来管理项目的版本号，npm 会自动更新 package.json 中的版本号，并生成一个新的 Git 标签  
5. **发布包**：当项目准备好发布到 npm 时，可以使用 `npm publish` 命令，npm 会读取 package.json 中的信息来发布包  
6. **依赖管理**：`package.json` 和 `package-lock.json` 文件一起工作，**确保项目在不同环境中的依赖版本一致**  

一个典型的 package.json 文件结构如下：
<pre>
{
  "name": "my-project",
  "version": "1.0.0",
  "description": "A simple Node.js project",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "express": "^4.17.1"
  },
  "devDependencies": {
    "nodemon": "^2.0.20"
  },
  "keywords": ["node", "npm", "example"],
  "author": "Your Name",
  "license": "MIT"
}
</pre>
字段说明：  
| 字段 | 说明 |
|------|------|
| `name` | 项目的名称，通常是小写字母和连字符。 |
| `version` | 项目的版本号，遵循[语义化版本规范 (SemVer)](https://semver.org/)。 |
| `description` | 项目的简短描述。 |
| `main` | 项目的入口文件，默认为 `index.js`。 |
| `scripts` | 定义项目可执行的脚本命令，如 `npm start`。 |
| `dependencies` | 项目运行时需要的依赖库，会在安装时加入 `node_modules`。 |
| `devDependencies` | 开发时使用的依赖库，不会在生产环境中安装。 |
| `keywords` | 关键字数组，有助于描述项目并在 NPM 搜索中找到项目。 |
| `author` | 项目的作者信息。 |
| `license` | 项目的许可证类型，如 MIT、ISC。 |

#### 依赖管理
`dependencies`：存储项目运行所需的依赖  
```
"dependencies": {
  "express": "^4.17.1"
}
```
安装依赖时使用：
```
npm install express
```
`devDependencies`：存储项目开发期间需要的依赖
```
"devDependencies": {
  "nodemon": "^2.0.20"
}
```
安装依赖时使用：
```
npm install nodemon --save-dev
```

#### scripts 字段
scripts 字段用于定义可通过 `npm run <script>` 执行的命令。常见的脚本包括：
```
"scripts": {
  "start": "node app.js",
  "test": "jest",
  "build": "webpack --mode production",
  "dev": "nodemon app.js"
}
```
运行脚本示例：  
- 执行 "nodemon app.js":
```
npm run dev 
```
- 等同于 "node app.js"，可以直接用 npm start 运行  
```
npm start
```
**版本号中的符号说明**  
- ^（插入符）：表示安装与当前主版本兼容的最新版本。例如，^4.17.1 会安装 4.x.x 中的最新版本  
- ~（波浪号）：表示安装与当前次版本兼容的最新版本。例如，~4.17.1 会安装 4.17.x 中的最新版本  

**常用命令**  
- 初始化 package.json 文件：
```
npm init
```
使用 `npm init -y` 可以快速生成默认的 package.json 文件  
- 查看项目依赖：
```
npm list --depth=0
```
- 更新依赖：
```
npm update package-name
```

***注意事项***
- 保持 package.json 文件的简洁和准确，避免不必要的字段
- 使用 package-lock.json 来锁定依赖的版本，以确保项目在不同环境中的一致性
- 定期更新依赖，以利用最新的功能和安全修复


### Node.js REPL(交互式解释器)
Node.js 提供了一个内置的 REPL（Read-Eval-Print Loop），这是一个交互式编程环境，可以在终端中运行 JavaScript 代码  

REPL 的名称来源于它的主要操作：读取（Read）、执行（Eval）、打印（Print）和循环（Loop）  

我们可以输入以下命令来启动 Node 的终端：
```
node
```
执行后出现如下内容：
<pre>
# node
Welcome to Node.js v20.1.0.
Type ".help" for more information.
> 
</pre>
这时我们就可以在 > 后输入简单的表达式，并按下回车键来计算结果  

#### 简单的表达式运算
接下来让我们在 Node.js REPL 的命令行窗口中执行简单的数学运算：
<pre>
$ node
> 1 + 4
5
> 5 / 2
2.5
> 3 * 6
18
> 4 - 1
3
> 1 + ( 2 * 3 ) - 4
3
>
</pre>

#### 使用变量
你可以将数据存储在变量中，并在你需要的时候使用它  

变量声明需要使用 let 关键字，如果没有使用 let 关键字变量会直接打印出来  

使用 let 关键字的变量可以使用 console.log() 来输出变量  
<pre>
$ node
> x = 10
10
> let y = 10
undefined
> x + y
20
> console.log("Hello World")
Hello World
undefined
> console.log("www.runoob.com")
www.runoob.com
undefined
</pre>

#### 多行表达式
Node REPL 支持输入多行表达式，这就有点类似 JavaScript。接下来让我们来执行一个 do-while 循环：
<pre>
$ node
> let x = 0
undefined
> do {
... x++;
... console.log("x: " + x);
... } while ( x < 5 );
x: 1
x: 2
x: 3
x: 4
x: 5
undefined
>
</pre>
... 三个点的符号是系统自动生成的，你回车换行后即可。Node 会自动检测是否为连续的表达式  

#### 下划线(_)变量
你可以使用下划线`_`获取上一个表达式的运算结果：
<pre>
$ node
> let x = 10
undefined
> let y = 20
undefined
> x + y
30
> let sum = _
undefined
> console.log(sum)
30
undefined
>
</pre>

#### REPL 命令
Node.js REPL 的常用命令和快捷键汇总表：  
| 命令/快捷键 | 说明 |
|--------------|------|
| `.help` | 显示 REPL 中可用的所有命令及其说明。 |
| `.exit` | 退出 REPL 会话，相当于按 `Ctrl + D`。 |
| `.save <filename>` | 将当前的 REPL 会话保存到指定文件中。 |
| `.load <filename>` | 从指定文件中加载并执行代码到 REPL。 |
| `.break` | 退出多行表达式输入模式，返回到单行输入模式。 |
| `.clear` | 重置 REPL 的上下文，相当于清除所有变量和状态。 |
| `Ctrl + C` | 强制退出当前输入或终止命令。如果按两次，则退出 REPL 会话。 |
| `Ctrl + D` | 结束 REPL 会话，相当于 `.exit`。 |
| `Ctrl + L` | 清除屏幕，类似于在终端中输入 `clear`。 |
| 方向键（↑/↓） | 浏览输入历史记录，查看并重新执行之前输入的命令。 |
| `Tab` | 自动补全输入，显示可能的选项或补全命令。 |
| `_` | 用于访问上一次表达式的结果。 |
| `Ctrl + R` | 进入反向搜索历史，搜索先前输入的命令。 |
| `Ctrl + U` | 删除当前行从光标到行首的所有内容。 |
| `Ctrl + K` | 删除当前行从光标到行尾的所有内容。 |
| `Ctrl + A` | 移动光标到行首。 |
| `Ctrl + E` | 移动光标到行尾。 |
| `Ctrl + B` | 向后移动光标一个字符。 |
| `Ctrl + F` | 向前移动光标一个字符。 |
| `Ctrl + N` | 显示下一条历史记录（与方向键 ↓ 相同）。 |
| `Ctrl + P` | 显示上一条历史记录（与方向键 ↑ 相同）。 |
| `Ctrl + Z` | 挂起 REPL 会话，将其置于后台（在某些系统中可用）。 |

#### 停止 REPL
前面我们已经提到按下两次 ctrl + c 键就能退出 REPL:
<pre>
$ node
>
(^C again to quit)
>
</pre>

#### REPL 进阶功能
- 自动补全：输入一部分代码并按 Tab，REPL 会尝试补全或显示可能的选项
- 结果缓存：REPL 会自动将上次运行的结果保存到特殊变量 _ 中。例如：
<pre>
> 5 + 5
10
> _ * 2
20
</pre>


### Node.js 回调函数
Node.js 是一个基于 Chrome V8 引擎的 JavaScript 运行环境，它使得 JavaScript 可以脱离浏览器运行在服务器端  

Node.js 的核心特性之一是其非阻塞 I/O（输入/输出）模型，这使得 Node.js 非常适合处理高并发的网络应用  

Node.js 异步编程的直接体现就是回调  

**使用场景**  
- 读取文件、写入文件等 I/O 操作
- 处理网络请求
- 数据库查询

例如，我们可以一边读取文件，一边执行其他命令，在文件读取完成后，我们将文件内容作为回调函数的参数返回。这样在执行代码时就没有阻塞或等待文件 I/O 操作。这就大大提高了 Node.js 的性能，可以处理大量的并发请求  
回调函数一般作为函数的最后一个参数出现：
<pre>
function foo1(name, age, callback) { }
function foo2(value, callback1, callback2) { }
</pre>

**实例**
#### 阻塞代码实例
创建一个文件 input.txt ，内容如下：
```
菜鸟教程官网地址：www.runoob.com
```
创建 main.js 文件, 代码如下：
```js
let fs = require("fs");

let data = fs.readFileSync("input.txt");

console.log(data.toString());
console.log("程序执行结束！");

```
以上代码执行结果如下：
<pre>
$ node main.js
菜鸟教程官网地址：www.runoob.com

程序执行结束!
</pre>

#### 非阻塞代码实例
创建一个文件 input.txt ，内容如下：
```
菜鸟教程官网地址：www.runoob.com
```
创建 main.js 文件, 代码如下：
```js
let fs = require("fs");

fs.readFile('input.txt', function(err, data) {
    if (err) return console.error(err);
    console.log(data.toString()); 
});

console.log("程序执行结束！");
```
参数解释：
- `err` 是错误对象，如果读取失败会有值。
- `data` 是读取的文件内容。
以上代码执行结果如下：
<pre>
$ node main.js
程序执行结束!
菜鸟教程官网地址：www.runoob.com
</pre>
以上两个实例我们了解了阻塞与非阻塞调用的不同：
- 第一个实例在文件读取完后才执行程序
- 第二个实例我们不需要等待文件读取完，这样就可以在读取文件时同时执行接下来的代码，大大提高了程序的性能

因此，**阻塞是按顺序执行的**，而**非阻塞是不需要按顺序的**，所以如果需要处理回调函数的参数，我们就需要写在回调函数内  

#### 回调地狱（Callback Hell）
当多个异步操作需要按顺序执行时，回调函数会导致代码嵌套，使得代码难以阅读和维护  
```js
fs.readFile('file1.txt', 'utf8', (err, data1) => {
    if (err) {
        console.error('Error reading file1:', err);
        return;
    }

    fs.readFile('file2.txt', 'utf8', (err, data2) => {
        if (err) {
            console.error('Error reading file2:', err);
            return;
        }

        fs.readFile('file3.txt', 'utf8', (err, data3) => {
            if (err) {
                console.error('Error reading file3:', err);
                return;
            }

            console.log('Data from all files:', data1, data2, data3);
        });
    });
});
```
为了改善代码的可读性和可维护性，可以使用以下几种方法：
##### 1、使用 async/await
async/await 是 ES2017 引入的语法糖，可以让你更方便地处理异步操作，避免回调地狱
```js
const fs = require('fs').promises;

async function readFiles() {
    try {
        const data1 = await fs.readFile('file1.txt', 'utf8');
        const data2 = await fs.readFile('file2.txt', 'utf8');
        const data3 = await fs.readFile('file3.txt', 'utf8');

        console.log('Data from all files:', data1, data2, data3);
    } catch (err) {
        console.error('Error reading files:', err);
    }
}

readFiles();
```
##### 2、使用 Promises
Promises 是另一种处理异步操作的方式，可以链式调用 then 方法，避免嵌套回调
```js
const fs = require('fs').promises;

fs.readFile('file1.txt', 'utf8')
    .then(data1 => {
        console.log('Data from file1:', data1);
        return fs.readFile('file2.txt', 'utf8');
    })
    .then(data2 => {
        console.log('Data from file2:', data2);
        return fs.readFile('file3.txt', 'utf8');
    })
    .then(data3 => {
        console.log('Data from file3:', data3);
    })
    .catch(err => {
        console.error('Error reading files:', err);
    });
```
回调函数是 Node.js 中处理异步操作的一种基本方式，但随着应用复杂性的增加，回调地狱问题会变得越来越明显。通过使用 async/await 或 Promises，可以显著改善代码的可读性和可维护性


### Node.js 事件循环
事件循环是 Node.js 处理非阻塞 I/O 操作的核心机制，使得单线程能够高效处理多个并发请求  
Node.js 是基于单线程的 JavaScript 运行时，利用事件循环来处理异步操作，如文件读取、网络请求和数据库查询  

#### 事件循环的阶段
事件循环分为多个阶段，每个阶段处理特定的任务。关键阶段如下：
- `Timers`：执行 setTimeout() 和 setInterval() 的回调
- `I/O Callbacks`：处理一些延迟的 I/O 回调
- `Idle, prepare`：内部使用，不常见
- `Poll`：检索新的 I/O 事件，执行与 I/O 相关的回调
- `Check`：执行 setImmediate() 回调
- `Close Callbacks`：处理关闭的回调，如 socket.on('close', ...)


#### 事件循环的流程
- 任务进入事件循环队列
- 事件循环按照阶段顺序进行处理，每个阶段有自己的回调队列
- 事件循环会在 poll 阶段等待新的事件到达，如果没有事件，会检查其他阶段的回调
- 如果 setImmediate() 和 setTimeout() 都存在，setImmediate() 在 check 阶段先执行，而 setTimeout() 在 timers 阶段执行
**示例**：
```js
setTimeout(() => {
  console.log('Timeout callback');
}, 0);

setImmediate(() => {
  console.log('Immediate callback');
});

console.log('Main thread execution');
```
输出顺序：
- `Main thread execution` 先打印。
- `setImmediate()` 和 `setTimeout()` 的执行顺序取决于当前事件循环的状态，一般 `setImmediate()` 会先执行

#### 宏任务与微任务
- 宏任务：setTimeout、setInterval、setImmediate、I/O 操作等
- 微任务：process.nextTick、Promise.then
***执行顺序：微任务优先级高于宏任务，会在当前阶段的回调结束后立即执行***
```js
setTimeout(() => {
  console.log('Timeout callback');
}, 0);

Promise.resolve().then(() => {
  console.log('Promise callback');
});

console.log('Main thread execution');
```
执行输出结果：
<pre>
Main thread execution
Promise callback
Timeout callback
</pre>

#### process.nextTick()
process.nextTick() 会在当前操作结束后、下一个阶段开始前执行微任务，优先级高于 Promise  
```js
process.nextTick(() => {
  console.log('Next tick callback');
});

console.log('Main thread execution');
```
输出：
<pre>
Main thread execution
Next tick callback
</pre>

#### 事件驱动程序
在 Node.js 中，事件驱动编程主要通过 EventEmitter 类来实现  
EventEmitter 是一个内置类，位于 events 模块中，通过继承 EventEmitter，你可以创建自己的事件发射器，并注册和触发事件  

**基本概念**：
- **事件**：在程序中发生的动作或状态改变，例如一个文件读取完成或一个 HTTP 请求到达
- **事件触发器**：EventEmitter 是 Node.js 的内置模块，用来发出和监听事件
- **事件处理器**：与事件关联的回调函数，事件发生时被调用

**事件驱动的流程**：
- **注册事件**：在程序中通过 EventEmitter 实例注册事件和对应的处理器
- **触发事件**：当指定的事件发生时，EventEmitter 会触发该事件
- **处理事件**：事件循环会调度相应的回调函数来执行任务

Node.js 有多个内置的事件，我们可以通过引入 events 模块，并通过实例化 EventEmitter 类来绑定和监听事件，如下实例：
```js
// 引入 events 模块
var events = require('events');
// 创建 eventEmitter 对象
var eventEmitter = new events.EventEmitter();
```
以下程序绑定事件处理程序：
```js
// 绑定事件及事件的处理程序
eventEmitter.on('eventName', eventHandler);
```
我们可以通过程序触发事件：
```js
// 触发事件
eventEmitter.emit('eventName');
```
**实例**:  
创建 hello.js 文件，代码如下所示：
```js
const EventEmitter = require('events');
const myEmitter = new EventEmitter();

// 注册事件处理器
myEmitter.on('greet', () => {
  console.log('Hello, world!');
});

// 触发事件
myEmitter.emit('greet');
```
输出：
<pre>
Hello, world!
</pre>
创建 main.js 文件，代码如下所示：
```js
// 引入 events 模块
var events = require('events');
// 创建 eventEmitter 对象
var eventEmitter = new events.EventEmitter();
 
// 创建事件处理程序
var connectHandler = function connected() {
   console.log('连接成功。');
  
   // 触发 data_received 事件 
   eventEmitter.emit('data_received');
}
 
// 绑定 connection 事件处理程序
eventEmitter.on('connection', connectHandler);
 
// 使用匿名函数绑定 data_received 事件
eventEmitter.on('data_received', function(){
   console.log('数据接收成功。');
});
 
// 触发 connection 事件 
eventEmitter.emit('connection');
 
console.log("程序执行完毕。");
```
接下来让我们执行以上代码：
<pre>
$ node main.js
连接成功。
数据接收成功。
程序执行完毕。
</pre>

#### Node 应用程序是如何工作的？
在 Node 应用程序中，执行异步操作的函数将回调函数作为最后一个参数， 回调函数接收错误对象作为第一个参数  
接下来让我们来重新看下前面的实例，创建一个 input.txt ,文件内容如下：
```
菜鸟教程官网地址：www.runoob.com
```
创建 main.js 文件，代码如下：
```js
let fs = require("fs");

fs.readFile('input.txt', function (err, data) {
   if (err){
      console.log(err.stack);
      return;
   }
   console.log(data.toString());
});
console.log("程序执行完毕");
```
以上程序中 fs.readFile() 是异步函数用于读取文件。 如果在读取文件过程中发生错误，错误 err 对象就会输出错误信息  
如果没发生错误，readFile 跳过 err 对象的输出，文件内容就通过回调函数输出  

执行以上代码，执行结果如下：
<pre>
程序执行完毕
菜鸟教程官网地址：www.runoob.com
</pre>
接下来我们删除 input.txt 文件，执行结果如下所示：
<pre>
程序执行完毕
Error: ENOENT, open 'input.txt'
</pre>
因为文件 input.txt 不存在，所以输出了错误信息
