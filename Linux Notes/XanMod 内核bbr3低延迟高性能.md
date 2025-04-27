# 谷歌 BBR v3 加速一键脚本代码

***目前只支持 Debian 和 Ubuntu 系统，CentOS 目前暂不支持目前仅支持X86_64架构的CPU***  

内容转自[科技 Lion](https://www.vpsquery.com/archives/4171)  

BBR 对于提升 VPS 访问速度和跑满带宽有非常好的效果，所以现在主流的 Linux 系统都集成了 BBR 谷歌目前已经将 BBR v3 提交到 Linux 内核上游，将 v1 算法升级到 v3，谷歌经过测试发现降低 12% 的数据包重传率  

### 使用一键脚本安装
**Debian/Ubuntu**  
更新并安装必要组件：
```bash
apt update -y  && apt install -y curl
```
一键安装脚本：
```bash
curl -sS -O https://raw.githubusercontent.com/kejilion/sh/main/kejilion.sh && chmod +x kejilion.sh && ./kejilion.sh
```
安装顺序：  
1. 选择**系统工具**输入：`13`
2. 选择**开启BBR3加速**输入：`16`
3. 输入：`y`
4. 等待系统重启
5. 重启后输入`./kejilion.sh`
6. 输入：`1` 查看是否启用了bbr拥塞算法

[linux官方内核](https://www.kernel.org/)  

卸载顺序同理参考上面的操作  

### 手动安装

目前仅支持X86架构的CPU  
目前仅支持Debian/Ubuntu 为避免失联建议先用通用DD脚本重装系统后再尝试进行Linux内核安装 因为每个厂商原生系统存在差异 问题比较多  

0. 通用DD脚本重装系统  
适合绝大部分VPS使用  
- DD成功：`oci  aws  az  vultr  layerstack`
- DD失败：`cc  ibmlinuxone rn`

SSH连接VPS输入重装命令即可  
```bash
bash <(wget --no-check-certificate -qO- 'https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh') -u 20.04 -v 64 -p 123456 -port 22
```
系统参数  
- Ubuntu  
<pre>
-u 20.04  【14.04、16.04、18.04、20.04】
</pre>
- Debian  
<pre>
-d 10  【7、8、9、10，11】
</pre>
密码参数，可以改成别的
<pre>
-p 12345
</pre>
端口参数
<pre>
port 22
</pre>
安装完成后VPS会重启安装，等待10分钟左右，尝试重新连接  
用户名为root  
密码是你设置的  
更新安装基础系统环境  
```bash
apt update -y && apt install -y curl && apt install -y socat && apt install wget -y
```
BBR一键安装脚本
```bash
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
```

**手动安装**：  
1. 安装系统组件：
```bash
apt update -y && apt install -y wget gnupg
```
2. 注册PGP密钥：
```bash
wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /usr/share/keyrings/xanmod-archive-keyring.gpg --yes
```
3. 添加存储库：
```bash
echo 'deb [signed-by=/usr/share/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | tee /etc/apt/sources.list.d/xanmod-release.list
```
查看是否插入成功：
```bash
vim /etc/apt/sources.list.d/xanmod-release.list
```
退出`Shift + Z + Z`  

4. 查看当前VPS适合的版本
```bash
wget -q https://dl.xanmod.org/check_x86-64_psabi.sh && chmod +x check_x86-64_psabi.sh && ./check_x86-64_psabi.sh
```
5. 更新并安装指定内核版本：  
- 大众机型且DD过系统的
```bash
apt update -y && apt install -y linux-xanmod-x64v3
```
- 新机型莱卡云，谷歌云，微软云，甲骨文云，V.PS，Vultr，do，linode等
```bash
apt update -y && apt install -y linux-xanmod-x64v4
```
老机型如CC，搬瓦工，RN
```bash
apt update -y && apt install -y linux-xanmod-x64v2
```
- 更老的机型如大西洋 
```bash
apt update -y && apt install -y linux-xanmod-x64v1
```


6. 开启BBR3：
```bash
cat > /etc/sysctl.conf << EOF

net.core.default_qdisc=fq_pie

net.ipv4.tcp_congestion_control=bbr

EOF

sysctl -p
```
7. 重启系统：
```bash
reboot
```
8. 查看BBR3状态：
```bash
modinfo tcp_bbr
```
由于版本差异，在运行 modinfo tcp_bbr 时看到 "modinfo: ERROR: Module tcp_bbr not found" 错误，这可能是因为 BBR 不再作为一个单独的内核模块存在，而是直接编译进内核了。无法单独查看信息。但事实上已经是BBRv3了！  
