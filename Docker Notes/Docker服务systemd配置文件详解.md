# Docker服务systemd配置文件详解
**目录**
一、Docker服务systemd配置文件  
二、注释  
三、其他  

## 一、Docker服务systemd配置文件
systemd是一个系统和服务管理器，它可以启动、停止和重启系统服务，并监控它们的运行状态。在Linux系统中，Docker服务的systemd配置文件通常位于`/etc/systemd/system/docker.service`  
配置文件示例：  
```
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
After=network-online.target firewalld.service
Wants=network-online.target

[Service]
Type=notify
ExecStart=/usr/bin/dockerd
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process
Restart=on-failure
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
```
<pre>
[Unit]部分用于描述服务的基本信息，包括服务的名称、描述、文档地址、依赖关系等。

Description：描述服务的作用。
Documentation：文档地址。
After：在哪些服务之后启动，多个服务之间用空格隔开。
Wants：如果该服务启动，则需要哪些服务启动，多个服务之间用空格隔开。
[Service]部分用于描述服务的启动命令、进程管理、重启策略等。

Type：指定进程类型，可选值为simple、forking、oneshot、dbus、notify和idle。
ExecStart：启动命令。
ExecReload：重新加载命令。
LimitNOFILE：文件描述符限制。
LimitNPROC：进程数限制。
LimitCORE：core文件大小限制。
Delegate：允许systemd不重置docker容器的cgroup。
KillMode：指定进程被杀死的方式，可选值为control-group、process和mixed。
Restart：当服务异常退出时，自动重启服务。
StartLimitBurst：在StartLimitInterval时间内，最多重启多少次。
StartLimitInterval：重启时间间隔。
[Install]部分用于描述服务的安装信息，包括服务的启动级别、启动顺序等。

WantedBy：当哪个服务启动时，自动启动该服务。
</pre>

## 二、注释
<pre>
[Unit]  # 单元区块，定义服务的描述、依赖关系等
Description=Docker Application Container Engine  # 描述：Docker应用程序容器引擎
Documentation=https://docs.docker.com  # Docker官方文档链接
After=network-online.target firewalld.service  # 启动顺序：在网络完全联通和服务firewalld启动之后再启动本服务
Wants=network-online.target  # 需求：希望network-online.target已经激活，但不强制等待它

[Service]  # 服务区块，定义如何启动、重启以及服务的行为
Type=notify  # 服务类型：notify，表示服务会主动通知systemd其状态变化
ExecStart=/usr/bin/dockerd  # 启动命令：执行/usr/bin/dockerd来启动Docker守护进程
ExecReload=/bin/kill -s HUP $MAINPID  # 重载命令：向主进程发送HUP信号来重载配置
LimitNOFILE=infinity  # 最大打开文件数：不限制
LimitNPROC=infinity  # 最大进程数：不限制
LimitCORE=infinity  # 最大core文件大小：不限制
Delegate=yes  # 委托：允许服务管理自己的cgroup子系统
KillMode=process  # 终止模式：仅终止服务的主进程
Restart=on-failure  # 重启策略：服务因错误退出时自动重启
StartLimitBurst=3  # 重启限制次数：在StartLimitInterval内最大重启次数
StartLimitInterval=60s  # 重启限制时间间隔：限制重启次数的时间窗口

[Install]  # 安装区块，定义如何安装或启用该服务
WantedBy=multi-user.target  # 需要被包含在：当进入多用户目标时，应该启动此服务
</pre>


## 三、其他
<pre>
EnvironmentFile：指定环境变量文件路径，可以在启动命令中使用这些环境变量。
User：指定服务运行的用户。
Group：指定服务运行的用户组。
WorkingDirectory：指定服务的工作目录。
ExecStartPre：在启动命令之前执行的命令。
ExecStartPost：在启动命令之后执行的命令。
ExecStop：停止命令。
ExecStopPost：在停止命令之后执行的命令。
TimeoutStartSec：启动超时时间。
TimeoutStopSec：停止超时时间。
</pre>

在配置完Docker服务的systemd配置文件后，需要使用以下命令重新加载systemd配置文件并重启Docker服务：
```
sudo systemctl daemon-reload
sudo systemctl restart docker.service
```