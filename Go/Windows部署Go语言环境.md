# Windows部署Go语言环境


## 环境配置

### 下载Go环境
在GoLang官网下载所需版本：https://golang.google.cn/dl/  
放到自己自定义的目录，然后解压  


### 配置环境变量
得到完整的 Go 环境之后，需要配置 Go 的环境变量，右击`此电脑`–>`属性`–>`高级系统设置`–>`环境变量`，打开环境变量设置窗口  


**需要新建两个环境变量配置**  

- 一个是 `GOROOT` ，这个就是 Go 环境所在目录的配置
- 另一个是 `GOPATH` ，这个是 Go 项目的工作目录

注：从 Go 1.11 开始引入了 Go Modules（模块管理）启用 Go Modules 后：你的项目可以放在硬盘任何位置  

1. 新建GOROOT，在变量名一栏输入 `GOROOT`
2. 在变量值一栏输入Go 环境所在目录位置 `E:\ProgramData\go` 点击确定


3. 新建GOPATH，在变量名一栏输入 `GOPATH`
4. 在变量值一栏输入任意一个目录 `E:\ProgramData\go\gopath` 点击确定


5. 将新建的GOROOT配置到 `Path` 这个环境变量中去，在`系统变量`中找到 `Path`，点击`编辑`->`新建`，输入`%GOROOT%\bin`，点击确定



### 校验是否配置成功
Win+R 输入 cmd 打开终端  
查看Go版本  
```
go version
```
查看Go环境变量
```
go env
```


### 配置 GO111MODULE、GOPROXY、GOSUMDB
开启mod模式
```
go env -w GO111MODULE=on
```
配置镜像源
```
go env -w GOPROXY=https://proxy.golang.com.cn,direct
```
关闭包的MD5校验
```
go env -w GOSUMDB=off
```
查看环境变量
```
go env
```

### 查看配置的环境变量
可以在cmd终端查看
```
echo %GOPATH%
echo %GOROOT%
```


## VSCode 配置 Go 开发环境

### 安装 Go 扩展
打开 VSCode，按下 `Ctrl+Shift+X` 打开扩展面板，搜索 Go（由 Google 官方开发），点击 “安装”。这个扩展是 VSCode 支持 Go 开发的核心，提供语法高亮、代码提示、调试等功能  

### 配置 settings.json
VSCode 的 settings.json 是配置核心，分为 “全局设置”（所有项目 生效）和 “工作区设置”（仅当前项目生效）。通过以下配置，可优化 Go 开发体验  

打开 settings.json 的方式：
- 全局设置：按下 `Ctrl+,` 打开设置面板，点击右上角的 `打开设置json` 图标，进入 JSON 配置模式
一般位于`C:\Users\Admin\AppData\Roaming\Code\User\settings.json`
- 工作区设置：在项目根目录创建 `.vscode/settings.json` 配置仅对当前项目生效

#### 核心配置
```
{
  // 启用 Go 语言服务器（gopls）
  "go.useLanguageServer": true,
 
  // 配置代码格式化工具
  "go.formatTool": "goimports",

  // 保存时自动格式化代码（建议开启，配合 goimports）
  "editor.formatOnSave": true,
  
  // 静态检查工具
  "go.lintTool": "staticcheck",
  // 大项目用 package，小项目用 workspace
  "go.lintOnSave": "package",

 
  // 启用代码提示时的占位符
  "gopls": {
    "usePlaceholders": true,		// 代码提示时显示参数占位符
    "completeUnimported": true // 提示未导入的包
  },

  // 调试时显示变量类型信息
  "go.delveConfig": {
    "showGlobalVariables": true
  }
}
```

#### 个性化配置
```
{
  // 自定义 GOPATH（若与系统环境变量不同）
  "go.gopath": "/path/to/your/gopath",
 
  // 自定义 GOROOT（多版本 Go 时需配置）
  "go.goroot": "/usr/local/go",
 
  // 调试时显示变量类型信息
  "go.delveConfig": {
    "showGlobalVariables": true
  },
 
  // 静态检查工具（如 staticcheck）的配置
  "go.lintTool": "staticcheck",
  "go.lintOnSave": "package" // 保存时对当前包进行 lint 检查
}
```

### 必备开发工具

最小化开发工具必要集合
```
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
```

1. 语言服务器与代码补全
- `gopls`(必要)
```
go install golang.org/x/tools/gopls@latest
```
作用：Go 官方语言服务器，提供代码补全、定义跳转、重构等核心功能，是 VSCode Go 扩展的 “大脑”  

2. 代码格式化与导入管理
- `goimports`(必要)
```
go install golang.org/x/tools/cmd/goimports@latest
```
作用：自动格式化代码，并管理 import 语句（添加缺失的包、删除未使用的包），比原生 gofmt 更强大，是 settings.json 中推荐的格式化工具  

- `gofumpt`(可选)
```
go install mvdan.cc/gofumpt@latest
```
作用：比 goimports 更严格的格式化工具，强制统一代码风格（如空格、换行），适合团队协作项目  

3. 调试工具
- `delve`(必要)
```
go install github.com/go-delve/delve/cmd/dlv@latest
```
作用：Go 官方调试器，与 VSCode 集成后支持断点调试、变量监视、调用栈查看等功能，是排查代码问题的必备工具  

4. 静态代码检查
- `staticcheck`(必要)
```
go install honnef.co/go/tools/cmd/staticcheck@latest
```
作用：检测代码中的潜在问题，如未使用的变量、错误处理遗漏、性能隐患等，是 Go 社区公认的优秀静态检查工具  

- `golangci-lint`(推荐)
```
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```
作用：集成了代码检查工具（包括 staticcheck、gocyclo 等），可自定义检查规则，适合大型项目的代码质量管控  

5. 测试与覆盖率工具
-`gotests`(推荐)
```
go install github.com/cweill/gotests/gotests@latest
```
作用：自动生成测试代码模板，支持为函数、结构体批量生成测试，节省编写测试的时间  


6. 代码生成工具
- `stringer`(推荐)
```
go install golang.org/x/tools/cmd/stringer@latest
```
作用：为枚举类型（const iota）自动生成 String() 方法，避免手动编写重复代码  

- `mockery`(推荐)
```
go install github.com/vektra/mockery/v2@latest
```
作用：为接口生成 mock 实现，方便单元测试时模拟依赖（如数据库、网络请求）

7.  Protobuf 工具（用于 gRPC 开发）
如果涉及 gRPC 或 Protobuf，需安装以下工具：  
- `protoc-gen-go`(按需)
```
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
```
- `protoc-gen-go-grpc`(按需)
```
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```


### 创建测试项目
1. 创建项目目录：
```
mkdir test
cd test
```

2. 初始化Go模块：
```
go mod init test
```

3. 创建main.go：
```
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}
```

4. 运行程序：
```
go run main.go
```

### 常用快捷键

- `F5`: 开始调试
- `Ctrl+F5`: 运行不调试
- `Shift+F5`: 停止调试
- `F9`: 设置/取消断点
- `F10`: 单步跳过
- `F11`: 单步进入
- `Shift+F11`: 单步跳出
- `Ctrl+Space`: 触发建议
- `Alt+Shift+F`: 格式化代码