## chown更改文件所有者和所属组

### 1. Linux chown命令介绍
- `chown`（change owner）命令用于改变文件或目录的所有者和组。
- 每个文件都与一个所有者用户或组相关联，正确配置文件和文件夹权限非常重要。

### 2. 适用的Linux版本
- `chown`命令在所有主流Linux发行版中均可使用，包括但不限于Debian、Ubuntu、Alpine、Arch Linux、Kali Linux、RedHat/CentOS、Fedora和Raspbian。
- 通常预装在系统中，无需额外安装。

### 3. 基本语法
```bash
chown [-cfhvR] [--help] [--version] user[:group] file...
```

### 4. 常用选项或参数说明
| 参数                     | 说明                                                         |
|--------------------------|--------------------------------------------------------------|
| user                     | 新的文件所有者的用户名或用户ID                                 |
| group                    | 新的文件所有者的组名或组ID                                   |
| -c, --changes            | 只有在进行更改时才生成输出                                 |
| -f, --silent, --quiet    | 抑制大多数错误消息                                         |
| -v, --verbose            | 操作成功后生成输出                                         |
| -h, --no-dereference     | 影响符号链接而不是符号链接引用的文件                        |
| --dereference            | 影响每个符号链接而不是符号链接本身                        |
| --from=CURRENT_OWNER:CURRENT_GROUP | 只有当前所有者和/或组匹配时才更改所有者和/或组 |
| --no-preserve-root       | 不对’/'特殊处理（默认）                                   |
| --preserve-root          | 不对’/'进行递归操作                                       |
| --reference=RFILE        | 使用RFILE的所有者和组，而不是指定OWNER:GROUP值            |
| -R, --recursive          | 对目录及其内容进行递归操作                                 |
| --help                   | 显示辅助说明                                               |
| --version                | 显示版本信息                                              |

### 5. 命令实例详解

#### 实例1：改变文件所有者
```bash
chown newuser filename
```
这个命令将文件 `filename` 的所有者更改为 `newuser`。

#### 实例2：改变目录所有者
```bash
chown newuser directoryname
```
这个命令将目录 `directoryname` 的所有者更改为 `newuser`。

#### 实例3：改变文件所有者和组
```bash
chown newuser:newgroup filename
```
这个命令将文件 `filename` 的所有者更改为 `newuser`，并将其组更改为 `newgroup`。

#### 实例4：递归改变目录所有者和组
```bash
chown -R newuser:newgroup directoryname
```
这个命令将目录 `directoryname` 及其所有子目录和文件的所有者更改为 `newuser`，并将其组更改为 `newgroup`。

#### 实例5：改变文件所有者，保持组不变
```bash
chown newuser: filename
```
这个命令将文件的所有者更改为 `newuser`，但保持文件的组不变。

#### 实例6：只改变文件所属的组
```bash
chown :newgroup filename
```
这个命令将文件 `filename` 的组更改为 `newgroup`，但保持文件的所有者不变。

#### 实例7：显示详细操作信息
```bash
chown -v newuser:newgroup filename
```
这个命令将文件 `filename` 的所有者更改为 `newuser`，并将其组更改为 `newgroup`，同时显示执行过程的详细信息。

#### 实例8：若指定组不存在, 终止操作
```bash
chown -e newuser:nonexistentgroup filename
```
这个命令尝试将文件 `filename` 的所有者更改为 `newuser`，并将其组更改为 `nonexistentgroup`。如果指定的组不存在，则不会执行任何操作并显示错误信息。

#### 实例9：忽略无效的用户和组
```bash
chown -f newinvaliduser:newinvalidgroup filename
```
即使 `newinvaliduser` 和 `newinvalidgroup` 可能不存在，这个命令也不会报任何错误，但是，所有者和组的更改不会生效。

#### 实例10：递归改变目录所属的组，保持所有者不变
```bash
chown -R :newgroup directoryname
```
这个命令将目录 `directoryname` 及其所有子目录和文件的组更改为 `newgroup`，但保持文件的所有者不变。

#### 实例11：把所属用户和所属组都改回到文件的创建者
```bash
chown --reference=otherfile filename
```
这个命令将文件 `filename` 的所有者和组改回 `otherfile` 的所有者和组。

#### 实例12：在更改所有者和组时，保留现有的文件模式
```bash
chown --preserve-root newuser:newgroup filename
```
这个命令将文件 `filename` 的所有者更改为 `newuser`，并将其组更改为 `newgroup`，同时，在操作期间保留原有的文件属性和权限。


### 6. 注意事项
- `chown`命令需要超级用户权限来执行。
- 如果收到`bash: chown: command not found`的错误，可能需要使用`sudo`来获取必要的权限。
