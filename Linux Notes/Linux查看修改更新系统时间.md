# Linux查看修改更新系统时间

### 使用timedatectl命令管理时间同步
检查时间同步状态：
```bash
timedatectl
```
启用时间同步：
```bash
sudo timedatectl set-ntp true
```
禁用时间同步：
```bash
sudo timedatectl set-ntp false
```
检查时间同步服务的状态:
```bash
systemctl status systemd-timesyncd
```
如果服务未运行，可以尝试启动它：
```bash
sudo systemctl start systemd-timesyncd
```
设置开机自启动：
```bash
sudo systemctl enable systemd-timesyncd
```
如果服务已启动但时间仍未同步，可以尝试重启服务：
```bash
sudo systemctl restart systemd-timesyncd
```


### 手动修改系统时间
执行 `date` 命令可以查看当前系统的时间：
```bash
date
```
执行如下命令可以设置一个新的系统时间：
```bash
date -s "20190712 18:30:50"
```
设置完后还要执行如下命令保存一下设置：
```bash
hwclock --systohc
```
当然我们也可以将上面两个操作合二为一：
```bash
date -s "20190712 18:30:50" && hwclock --systohc
```


### 通过网络同步时间
首先安装 ntpdate 命令：  
- Ubuntu系统：
```bash
apt install -y ntpdate
```
- Centos系统
```bash
yum install -y ntpdate
```
配置启动和开机自启动：
```bash
systemctl start ntpd
systemctl enable ntpd
```
查看ntp服务状态：
```bash
systemctl status ntpd
```
接着执行如下命令开始同步：
```bash
ntpdate cn.pool.ntp.org
```
若上面的时间服务器不可用，也可以改用如下服务器进行同步：
```
time.nist.gov
time.nuri.net
ntp.aliyun.com
0.asia.pool.ntp.org
1.asia.pool.ntp.org
2.asia.pool.ntp.org
3.asia.pool.ntp.org
```
最后执行如下命令将系统时间同步到硬件，防止系统重启后时间被还原
```bash
hwclock --systohc
```
