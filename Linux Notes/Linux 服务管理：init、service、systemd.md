# Linux 服务管理：init、service、systemd

## 概述

Linux 系统中服务管理是确保系统稳定性和效率的关键环节。从传统的 `init` 到 `service`，再到现代的 `systemd` 和 `systemctl`，服务管理工具不断演进，以适应更高效的系统需求。

## init

### 命令简介

- **定义**：`init` 是 Linux 系统中的第一个进程（PID 1），负责启动和管理后续所有进程。
- **工作方式**：通过 `/etc/init.d` 目录下的脚本管理服务，这些脚本控制服务的启动和停止。
- **命令示例**：
  ```bash
  sudo /etc/init.d/nginx start
  ```
- **缺点**：
  - 串行启动服务，导致系统启动时间长。
  - 脚本复杂度高，需要处理多种启动情况。

### 命令表格

<table border="1" cellspacing="0" cellpadding="5">
    <tr>
        <th>命令</th>
        <th>参数</th>
        <th>描述</th>
    </tr>
    <tr>
        <td rowspan="7">init</td>
        <td>0</td>
        <td>关机</td>
    </tr>
    <tr>
        <td>1</td>
        <td>单用户模式</td>
    </tr>
    <tr>
        <td>2</td>
        <td>多用户模式</td>
    </tr>
    <tr>
        <td>3</td>
        <td>完全多用户模式</td>
    </tr>
    <tr>
        <td>4</td>
        <td>无功能</td>
    </tr>
    <tr>
        <td>5</td>
        <td>图形界面</td>
    </tr>
    <tr>
        <td>6</td>
        <td>重启</td>
    </tr>
    <tr>
        <td>--help</td>
        <td>显示帮助信息</td>
    </tr>
</table>

### 服务管理：
启动服务：
```bash
sudo /etc/init.d/<service_name> start
```
停止服务：
```bash
sudo /etc/init.d/<service_name> stop
```
重启服务：
```bash
sudo /etc/init.d/<service_name> restart
```
查看服务状态：
```bash
sudo /etc/init.d/<service_name> status
```
设置服务开机自启（使用 `update-rc.d`）：
```bash
sudo update-rc.d <service_name> enable
```
取消服务开机自启（使用 `update-rc.d`）：
```bash
sudo update-rc.d <service_name> disable
```


## service

### 命令简介

- `service` 命令是 Linux 系统中用于管理服务的工具，它通过调用位于 `/etc/init.d/` 目录下的服务脚本，来执行启动、停止、重启、查询状态等操作。
- `service` 命令是一个便捷的 shell 脚本，简化了对服务脚本的直接调用。
- 随着 `systemd` 的普及，新版的 Linux 发行版可能不再包含 `service` 命令，而是使用 `systemctl` 命令来管理服务。

### 命令参数

`service [选项] [service_name] [command]`

- **选项**：
  - `-h` 或 `--help`：显示帮助信息。
  - `-v` 或 `--version`：显示版本信息。

- **service_name**：表示服务的名称，通常是 `/etc/init.d/` 目录下的脚本文件名。

- **command**：
  - `start`：启动服务。
  - `stop`：停止服务。
  - `restart`：重启服务。
  - `reload`：重新加载服务的配置文件。
  - `status`：查看服务的当前状态。
  - `condrestart`：如果服务正在运行，则重启服务。
  - `enable`：设置服务开机自启。
  - `disable`：禁止服务开机自启。

### 定义及关系

- **定义**：`service` 命令是 `System V init` 的一个接口，用于管理 `/etc/init.d` 目录下的服务脚本。
- **关系**：`service` 命令实际上是对 `/etc/init.d/` 脚本的封装。
- **缺点**：功能有限，不支持 `systemd` 的高级特性，如并行启动和依赖管理。

### 命令表格

<table border="1" cellspacing="0" cellpadding="5">
    <tr>
        <th>命令</th>
        <th>参数</th>
        <th>描述</th>
    </tr>
    <tr>
        <td>service</td>
        <td>restart 服务名称</td>
        <td>重启指定的服务</td>
    </tr>
    <tr>
        <td>service</td>
        <td>stop 服务名称</td>
        <td>关闭指定的服务</td>
    </tr>
    <tr>
        <td>service</td>
        <td>start 服务名称</td>
        <td>启动指定的服务</td>
    </tr>
    <tr>
        <td>service</td>
        <td>-h</td>
        <td>显示帮助信息</td>
    </tr>
    <tr>
        <td>service</td>
        <td>status 服务名称</td>
        <td>查看指定服务的状态</td>
    </tr>
    <tr>
        <td>service</td>
        <td>--status-all</td>
        <td>显示所有服务状态</td>
    </tr>
    <tr>
        <td>service</td>
        <td>enable 服务名称</td>
        <td>设置服务开机自启</td>
    </tr>
    <tr>
        <td>service</td>
        <td>disable 服务名称</td>
        <td>取消服务开机自启</td>
    </tr>
</table>


### 服务管理命令

启动服务：
```bash
sudo service <服务名称> start
```
停止服务：
```bash
sudo service <服务名称> stop
```
重启服务：
```bash
sudo service <服务名称> restart
```
查看服务状态：
```bash
sudo service <服务名称> status
```
显示所有服务状态：
```bash
sudo service --status-all
```
设置服务开机自启：
```bash
sudo service <服务名称> enable
```
取消服务开机自启：
```bash
sudo service <服务名称> disable
```
显示帮助信息：
```bash
sudo service -h
```


## systemd

### 命令简介

- **定义**：`systemd` 是现代 Linux 系统中的初始化系统，旨在替代传统的 `System V init`。
- **特点**：
  - 支持服务的并行启动，显著减少系统启动时间。
  - 提供强大的服务依赖管理和控制。
- **主命令**：`systemctl`，用于管理系统和服务。

### systemctl

- **功能**：`systemctl` 是 `systemd` 的命令行工具，用于控制服务单元（Unit）。
- **高级特性**：
  - 服务依赖管理，确保服务按正确顺序启动。
  - 管理套接字、挂载点和定时任务。

### 命令表格

<table border="1" cellspacing="0" cellpadding="5">
    <tr>
        <th>命令</th>
        <th>参数/动作</th>
        <th>描述</th>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-a</td>
        <td>显示所有单位</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-q</td>
        <td>静默执行模式</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-f</td>
        <td>覆盖任何冲突的符号链接</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-r</td>
        <td>显示本地容器的单位</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-H</td>
        <td>设置要连接的主机名</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-s</td>
        <td>设置要发送的进程信号</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-M</td>
        <td>设置要连接的容器名</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-t</td>
        <td>设置单元类型</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-n</td>
        <td>设置要显示的日志行数</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>--help</td>
        <td>显示帮助信息</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>-o</td>
        <td>设置要显示的日志格式</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>--version</td>
        <td>显示版本信息</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>start 服务名</td>
        <td>启动服务</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>disable 服务名</td>
        <td>取消服务开机自启</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>stop 服务名</td>
        <td>停止服务</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>status 服务名</td>
        <td>查看服务状态</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>restart 服务名</td>
        <td>重启服务</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>reload 服务名</td>
        <td>重新加载服务配置</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>list</td>
        <td>显示所有已启动服务</td>
    </tr>
    <tr>
        <td>systemctl</td>
        <td>enable 服务名</td>
        <td>设置服务开机自启</td>
    </tr>
    <tr>
        <td>journalctl</td>
        <td>-u 服务名</td>
        <td>查看和管理日志</td>
    </tr>
</table>


## 服务管理

### 启动、停止、重启服务
- 启动服务：
```bash
sudo systemctl start <service_name>
```
- 停止服务：
```bash
sudo systemctl stop <service_name>
```
- 重启服务：
```bash
sudo systemctl restart <service_name>
```

### 查看服务状态
- 查看服务状态：
```bash
sudo systemctl status <service_name>
```

### 开机自启设置
- 设置服务开机自启：
```bash
sudo systemctl enable <service_name>
```
- 取消服务开机自启：
```bash
sudo systemctl disable <service_name>
```

### 重新加载服务配置
- 重新加载服务配置：
```bash
sudo systemctl reload <service_name>
```

### 列出服务
- 列出所有已启用的服务：
```bash
sudo systemctl list-unit-files --type=service --state=enabled
```
- 列出所有服务：
```bash
sudo systemctl list-units --type=service
```

### 添加和移除服务链接
- 添加一个自定义的服务链接：
```bash
sudo systemctl link /path/to/服务单位文件
```
- 移除一个服务的链接：
```bash
sudo systemctl unlink /path/to/服务单位文件
```

### 重新加载 systemd 配置
- 重新加载 systemd 配置：
```bash
sudo systemctl daemon-reload
```

### 查看服务是否已启用或正在运行
- 查看服务是否已启用：
```bash
sudo systemctl is-enabled <service_name>
```
- 查看服务是否正在运行：
```bash
sudo systemctl is-active <service_name>
```

### 定制服务配置
- 编辑一个服务的配置文件：
```bash
sudo systemctl edit <service_name>
```

## 依赖关系管理

### 查看服务依赖
- 查看服务的依赖关系：
```bash
sudo systemctl show <service_name> --property=Requires
sudo systemctl show <service_name> --property=Wants
```
- 查看服务的依赖树：
```bash
sudo systemctl list-dependencies <service_name>
```

### 解决依赖问题
- 启用服务并解决依赖问题：
```bash
sudo systemctl enable --now <service_name>
```
- 禁用服务并忽略依赖：
```bash
sudo systemctl disable --ignore-dependencies <service_name>
```

### 配置服务启动顺序
- 使用Before和After配置服务启动顺序：
```ini
[Unit]
Before=服务1.service
After=服务2.service
```

## 日志管理

### 查看服务日志
- 查看服务日志：
```bash
sudo journalctl -u <service_name>
```

### 实时查看日志
- 实时查看服务日志：
```bash
sudo journalctl -fu <service_name>
```

### 查看特定时间的日志
- 查看特定时间的日志：
```bash
sudo journalctl --since "YYYY-MM-DD" -u <service_name>
```

### 设置日志级别和存储位置
- 编辑 `/etc/systemd/journald.conf` 文件来设置日志级别和存储位置：
```bash
sudo systemctl edit --full systemd-journald.service
```


## 总结

- `init` 是基本的进程管理方式，但功能有限。
- `service` 是 `init` 的简化实现，但不支持现代服务管理需求。
- `systemd` 和 `systemctl` 提供了一种现代、高效且功能丰富的服务管理方式，特别适合现代 Linux 系统。
