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
