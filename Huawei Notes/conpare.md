# 思科和华为的命令比较

## 基本命令
| 描述                   | 思科命令             | 华为命令             |
|------------------------|----------------------|----------------------|
| 显示当前配置           | show run             | display current-configuration |
| 包含                   | include              | include              |
| 退出当前模式           | exit                 | quit                 |
| 结束配置模式           | end                  | return               |
| 进入配置终端模式       | configure terminal   | system-view          |
| 关闭接口               | shutdown             | shutdown             |
| 启动接口               | no shutdown          | undo shutdown        |
| 撤销关闭接口           | undo shutdown        | no undo shutdown     |
| 清除                   | clear                | clear                |
| 重置                   | reset                | debugging            |
| 显示运行配置           | show running-config   | display current-configuration |
| 显示启动配置           | show startup-config   | display saved-configuration |
| 显示版本信息           | show version         | show version         |
| 显示技术支持信息       | show tech-support    | display diagnostic-information |
| 清除计数器             | clear counters       | clear counters       |
| 重置计数器             | reset counters       | reset counters       |
| 清除行                 | clear line           | terminal length      |
| 禁用屏幕长度限制       | screen-length disable | screen-length disable |
| 设置终端宽度           | terminal width       | terminal width       |
| 终端监控               | terminal monitor     | terminal monitor     |
| 禁用终端监控           | terminal monitor disable | undo terminal monitor |
| 显示时钟               | show clock           | show clock           |
| 显示CPU进程使用率       | show processes cpu    | display cpu-usage    |
| 显示当前进程           | show logging         | show logging         |
| 显示日志缓冲区         | show logbuffer       | ping                 |
| 测试连通性             | ping                 | ping                 |
| 路由追踪               | traceroute           | traceroute           |
| Windows路由追踪       | tracert               | show ip interface     |
| 显示接口信息           | show ip interface     | display ip interface |
| 显示IP路由表           | show ip route        | display ip route      |
| 显示路由表             | display routing-table | show ip route static |
| 显示静态路由表         | show ip route static  | display ip routing-table protocol static |
| 显示IP协议信息         | show ip protocols    | show ipv6 route       |
| 显示IPv6路由表         | show ipv6 route       | display ipv6 routing-table |
| 简要显示接口信息       | show interface brief  | show interface be    |
| 显示聚合接口信息       | display interface Eth-trunkX | monitor interface |
| 重启设备               | reload               | reboot               |
| 显示当前用户           | show users           | show users           |
| 显示诊断信息/硬件清单   | show diag / show inventory | show diag / show inventory |
| 显示历史命令           | show history         | display history-command |
| 显示目录               | dir                  | dir                  |
| 显示环境信息           | show environment     | show environment     |
| 显示内存摘要           | show memory summary  | show memory-usage    |
| 显示平台信息           | show platform        | show platform        |
| 显示设备接口状态       | display device pic-status | show controllers |
| 显示控制器信息         | show controllers      | show controller      |
| 显示IP访问控制列表   | show ip access-lists | display acl          |
| 显示策略图接口         | display qos policy interface | show policy-map interface |
| 显示SNMP统计信息       | show snmp-agent statistics | show snmp            |
| 写入并擦除配置       | write erase           | reset saved-configuration |
| 复制运行配置到启动配置 | copy running-config  | copy run start (write mem) |
| 保存配置到启动配置   | save                 | save safely          |
| 配置AAA               | aaa                  | aaa                  |
| 配置HW TACACS方案     | hw tacacs scheme      | hw tacacs scheme     |
| 显示当前配置           | show configuration    | show configuration    |
| 显示候选配置           | display configuration candidate | display configuration candidate |

## OSPF
| 描述                               | 思科命令                   | 华为命令                   |
|------------------------------------|----------------------------|----------------------------|
| 启用路由器的OSPF进程               | router ospf                 | ospf                       |
| 显示OSPF邻居信息                   | show ip ospf neighbor       | display ospf neighbor       |
| 显示OSPF下一跳信息                 | display ospf nexthop        | show ip ospf nexthop        |
| 显示OSPF数据库                     | show ip ospf database       | display ospf database       |
| 显示OSPF链路状态数据库（LSDB）     | display ospf lsdb           | show ip ospf lsdb           |
| 显示接口上的OSPF配置               | show ip ospf interface       | display ospf interface       |
| 显示OSPF路由信息                   | display ospf interface      | show ip route ospf           |
| 显示OSPF协议的路由表               | show ip routing-table protocol ospf | display ip routing-table protocol ospf |

## ISIS
| 描述                     | 思科命令                   | 华为命令                   |
|--------------------------|---------------------------|---------------------------|
| 显示IS-IS邻居信息         | show clns neighbor         | display isis peer          |
| 显示IS-IS数据库           | show isis database         | display isis database      |
| 显示IS-IS链路状态数据库   | show isis lsdb             | display isis lsdb          |
| 显示IS-IS路由信息         | show isis route            | display isis route         |
| 显示IS-IS拓扑信息         | show isis topology         | display isis topology      |
| 显示接口上的IS-IS配置     | show isis interface        | display isis interface      |
| 显示IS-IS路由表           | show ip route ospf         | display ip routing-table protocol ospf |

## BGP
| 描述                             | 思科命令                       | 华为命令                             |
|---------------------------------|-------------------------------|--------------------------------------|
| 启用BGP进程                       | router bgp                     | bgp                                  |
| 显示BGP路由表                     | show ip bgp                     | display bgp routing-table              |
| 显示BGP概要信息                   | show ip bgp summary             | display bgp all summary               |
| 显示BGP对等体信息                 | display bgp peer                | display bgp peer                      |
| 显示BGP邻居信息                   | show ip bgp neighbors           | display bgp peer                      |
| 显示特定BGP邻居信息               | show ip bgp neighbor            | display bgp peer                      |
| 显示BGP邻居广告路由               | show ip bgp neighbor advertised-routes | display bgp peer advertising-routes |
| 显示BGP邻居接收路由               | display bgp routing-table peeradvertised-routes | display bgp peer received-routes |
| 显示BGP邻居路由                   | show ip bgp neighborroutes       | display bgp routing-table peerreceived-routes |
| 显示BGP IPv6单播概要信息           | show bgp ipv6 unicast summary    | display bgp ipv6 unicast summary       |
| 显示BGP IPv6单播邻居广告路由       | show bgp ipv6 unicast neighadvertised-routes | display bgp ipv6 unicast neighbor-routes |
| 显示BGP IPv6单播邻居接收路由       | display bgp ipv6 routing-table peeradvertised-routes | display bgp ipv6 routing-table peerreceived-routes |
| 显示符合正则表达式的BGP路由       | show ip bgp regexp               | display bgp multicast routing-table regular-expression |
| 显示符合正则表达式的BGP路由表     | show bgp routing-table regular-expression | display bgp routing-table regular-expression |
| 显示通过BGP学习到的路由           | show ip route bgp               | display ip routing-table protocol bgp  |

## MPLS
| 描述                             | 思科命令                         | 华为命令                        |
|---------------------------------|---------------------------------|--------------------------------|
| 显示MPLS LDP概要信息               | show mpls ldp summary            | display mpls ldp summary        |
| 显示MPLS LDP详细信息               | display mpls ldp all             |                                 |
| 显示MPLS接口信息                   | show mpls interface              | display mpls interface          |
| 显示MPLS LDP邻居简要信息           | show mpls ldp neighbor brief     | display mpls ldp neighbor brief |
| 显示MPLS LDP对等体信息             | show mpls ldp peer               | display mpls ldp peer           |
| 显示MPLS LDP邻居广告路由           | show mpls ldp neighbor advertised-routes | display mpls ldp peer advertising-routes |
| 显示MPLS LDP邻居接收路由           | display mpls ldp routing-table peeradvertised-routes | display mpls ldp peer received-routes |
| 显示MPLS LDP邻居路由               | show mpls ldp neighborroutes      | display mpls ldp routing-table peerreceived-routes |
| 显示BGP IPv6单播概要信息           | show bgp ipv6 unicast summary     | display bgp ipv6 unicast summary |
| 显示MPLS LDP对等体信息             | display bgp peer                 | display mpls ldp peer           |
| 显示BGP IPv6单播邻居广告路由       | show bgp ipv6 unicast neighadvertised-routes | display bgp ipv6 unicast neighbor-routes |
| 显示BGP IPv6单播邻居接收路由       | display bgp ipv6 routing-table peeradvertised-routes | display bgp ipv6 routing-table peerreceived-routes |
| 显示符合正则表达式的BGP路由       | show ip bgp regexp               | display bgp multicast routing-table regular-expression |
| 显示符合正则表达式的BGP路由表     | show bgp routing-table regular-expression | display bgp routing-table regular-expression |
| 显示通过BGP学习到的路由           | show ip route bgp               | display ip routing-table protocol bgp |

## MULTICAST
| 描述                             | 思科命令                         | 华为命令                        |
|---------------------------------|---------------------------------|--------------------------------|
| 显示多播路由表                   | show mfib/mrib route              | display multicast routing-table  |
| 显示PIM接口配置                   | show ip pim interface             | display pim interface            |
| 显示PIM邻居信息                   | show ip pim neighbor              | display pim neighbor            |
| 显示IGMP接口配置                   | show ip igmp interface            | display igmp interface           |