# Windows系统部署CloudFlare WARP

### 什么是CloudFlare WARP

本质上，WARP 是一个以安全与加速为目标的现代智能 VPN，而非单纯的"换 IP"工具。

Cloudflare WARP 会在本地创建虚拟网卡并隐藏真实 IP，但其核心目的并非"伪装"，而是为了优化连接、保障安全。

工作原理：WARP 在本地创建虚拟网卡，拦截设备所有网络流量，通过加密隧道发送至 Cloudflare 全球边缘节点，再由 Cloudflare 骨干网优化路由后转发至目标服务器。

支持协议：

WireGuard：默认协议，高性能、低延迟，适合追求速度的场景

MASQUE：基于 HTTP/3，流量伪装成普通 HTTPS，穿透力强且符合 FIPS 140-2 加密标准

重要限制：WARP 适用于突破网络封锁（如防火墙拦截），但不适用于绕过地理位置封锁（如访问仅限特定国家的流媒体服务），因为目标服务器看到的是 Cloudflare 边缘节点 IP，而该节点可能位于其他国家。



### 注册CloudFlare
官网 https://www.cloudflare-cn.com/  



### 下载CloudFlare WARP客户端

选择Windows端下载：https://developers.cloudflare.com/cloudflare-one/team-and-resources/devices/cloudflare-one-client/download/#windows  

下载并安装完成后先不进行配置



### 在CloudFlare网页控制面板中配置

1. 进入控制面板点击 `ZeroTrust` 再点击右上角的 `Get started`

<img width="2461" height="1389" alt="Win CF WARP1" src="https://github.com/user-attachments/assets/1ec4eff8-18c3-4cbe-986b-f84dc14416e4" />

2. 创建一个自己喜欢的团队名称（唯一的）

3. 选择 `Zero Trust Free` （根据自己的需求决定）

4. 添加付款方式（可不添加直接点击右上角的取消并退出即可）

5. 点击左侧 `ZeroTrust` 点击 `集成` 点击 `服务提供商` 点击最下方的 `添加设备`

6. 选择下载的客户端（已经下载点击下载发布版本后直接继续）

7. 定义注册策略默认是你注册CloudFlare时的邮箱，点击继续

8. 服务模式选择 `流量和DNS（推荐）`，点击继续

9. 默认路由选择 `排除模式`，点击继续

10. 管理拆分隧道默认，点击继续

11. 完成，点击继续



### 连接客户端

1. 打开下载好的Windows客户端  

2. 点击`下一步`，点击`接受`  

3. 点击右下角 `齿轮`，点击 `偏好设置`

4. 点击 `账户`，点击右下角 `使用CloudFlare Zero Trust 登录`

5. 点击 `下一步`，点击`接受`  

6. 输入你创建的团队名称，点击确定

7. 使用你的邮箱进行验证

8. 输入验证码验证成功后打开CloudFlare WARP，点击连接

返回CloudFlare网页端后台会发现有设备已经成功注册了  

注意：在连接CloudFlare WARP时不能有代理状态否则会产生冲突



### 用户管理和网络配置

#### 用户管理

1. 在 `ZeroTrust` 点击左侧 `团队和资源` 下拉菜单中点击 `设备` 点击右侧 `管理`

2. 点击下方 `设备注册`，在设备注册权限右侧点击 `管理`

3. 选择已有策略编辑

或在 `ZeroTrust` 左侧 `访问控制` 下拉菜单中点击 `策略` 编辑对应策略  

4. 点击 '配置' 在添加规则中添加多用户的授权登录邮箱，点击下方 `添加"包括"` 选择对应的认证方式即可添加新用户的登录验证方式



#### 网络配置

1. 在 `ZeroTrust` 点击左侧 `流量策略` 下拉菜单中点击 `流量设置`

2. 在 `流量设置` 中勾选 `允许安全Web网关代理流量` 并勾选全部协议 `UDP`，`ICMP` 协议

3. 回到 `团队和资源` 下拉菜单中点击 `设备` 点击 `设备配置文件`

4. 删除自动生成的配置文件保留默认配置文件

5. 创建新的配置文件
配置如下

<img width="1067" height="2218" alt="Win CF WARP2" src="https://github.com/user-attachments/assets/c88a55bd-c9df-44ba-a148-458d4a3b9372" />

<img width="1051" height="2220" alt="Win CF WARP3" src="https://github.com/user-attachments/assets/4714cf6c-a40e-4f0d-830d-abc0a29b4f3b" />

7. 在配置文件中做网络分流，编辑配置文件，在拆分隧道中点击管理

8. 在管理拆分隧道（排除）中使用IP（如192.168.0.0/16）或域名（*.qq.com）的方式排除对应流量进入隧道即直接使用本地网络直连

<img width="2110" height="1130" alt="Win CF WARP4" src="https://github.com/user-attachments/assets/77f6e0ed-44c0-4efc-8a2d-0108d3b914d3" />


### 遇到的问题
在 `Windows` 系统中同时使用 `cloudflare warp` 隧道和 `ZeroTier` 内网穿透服务可能导致 `ZeroTier` 服务中断  

分析原因：  
在`Windows Internet 网络适配器` 中 `自动跃点数` 就是Windows系统用来判断网络优先级的一种机制，CloudFlare WARP的虚拟网卡优先级高于ZeroTier虚拟网卡的优先级导致内网穿透服务中断  

解决方法：  
在 `Windows Internet 网络适配器` 设置中手动配置 `自动跃点数`（跃点数越小的网络，优先级越高，从 1 开始而非 0）  
数值范围：接口跃点数的有效范围确实是 `1 ~ 9999`

例如，将 ZeroTier 的优先级设置为 20，CloudFlare WARP 的设置为 50  

跃点数修改参考与 https://zhuanlan.zhihu.com/p/1913361130010711003  

`Win + R` 打开 cmd 输入 `ncpa.cpl`
进行如下配置  

<img width="588" height="482" alt="yds1" src="https://github.com/user-attachments/assets/7e28457b-730c-4054-ba13-e586c1c6ea21" />

<img width="733" height="1028" alt="yds2" src="https://github.com/user-attachments/assets/a8c68f39-e1da-4ee1-b5d2-c0c5b3852526" />

<img width="802" height="988" alt="yds3" src="https://github.com/user-attachments/assets/4e16f0b8-2a2a-4cad-8305-69bc73ddc056" />

<img width="806" height="1074" alt="yds4" src="https://github.com/user-attachments/assets/0ec441fc-0bf8-4212-bffe-14be10208b7f" />

cmd 输入 `route print` 查看路由表  

<img width="1344" height="600" alt="yds5" src="https://github.com/user-attachments/assets/35240bad-895a-45af-b0fd-9b845305b781" />
