# warp-cli 命令速查表

## 核心操作
| 命令 | 说明 |
|------|------|
| `warp-cli connect` | 保持连接 |
| `warp-cli disconnect` | 断开连接 |
| `warp-cli status` | 查看连接状态 |
| `warp-cli registration new` | 注册客户端（首次使用） |
| `warp-cli registration show` | 查看注册信息 |
| `warp-cli registration delete` | 删除注册 |

## 模式设置
| 命令 | 说明 |
|------|------|
| `warp-cli mode` | 设置运行模式 |
| `warp-cli proxy port <端口>` | 设置代理端口 |

## DNS 相关
| 命令 | 说明 |
|------|------|
| `warp-cli dns fallback` | 配置备用域名 |
| `warp-cli dns families` | 设置家庭模式（仅个人版） |
| `warp-cli dns log` | 开启/关闭 DNS 日志 |
| `warp-cli dns stats` | 查看 DNS 统计 |

## 隧道设置
| 命令 | 说明 |
|------|------|
| `warp-cli tunnel ip` | 配置 IP 分流 |
| `warp-cli tunnel host` | 配置主机分流 |
| `warp-cli tunnel dump` | 查看分流路由 |
| `warp-cli tunnel stats` | 查看隧道统计 |
| `warp-cli tunnel rotate-keys` | 更换密钥对 |

## 调试与诊断
| 命令 | 说明 |
|------|------|
| `warp-cli debug network` | 显示网络信息 |
| `warp-cli debug speed-test` | 运行测速 |
| `warp-cli stats enhanced` | 显示详细统计 |
| `warp-cli certs` | 打印证书 |

## 其他
| 命令 | 说明 |
|------|------|
| `warp-cli settings list` | 查看应用设置 |
| `warp-cli trusted ssid` | 配置信任 Wi-Fi（个人版） |
| `warp-cli vnet` | 查看/指定虚拟网络 |
| `warp-cli override unlock` | 临时覆盖策略 |

## 全局选项
| 选项 | 说明 |
|------|------|
| `-v, --verbose` | 详细输出 |
| `-j, --json` | JSON 格式输出 |
| `-h, --help` | 查看帮助 |