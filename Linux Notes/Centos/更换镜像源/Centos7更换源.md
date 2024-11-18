步骤 1：备份原有的 YUM 源文件  
在更换 YUM 源之前，建议先备份系统自带的 YUM 源配置文件，以防需要恢复原配置  
```
sudo cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
```

步骤 2：下载国内源的 YUM 配置文件  
阿里云源:  
```
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```
步骤 3：清理 YUM 缓存  
更换源之后需要清理原有的缓存，以便使用新的源进行软件包更新  
```
sudo yum clean all
sudo yum makecache
```
步骤 4：验证新源是否可用
```
sudo yum repolist
```
步骤 5：测试安装软件包  
最后，可以尝试安装一个软件包来确认新的源是否工作正常  
```
sudo yum install vim -y
```
常见问题  
无法下载或解析失败： 确认你使用的下载链接是正确的，或者网络连接是否正常  
旧源恢复： 如果更换新源后遇到问题，可以使用备份的 .repo.bak 文件来恢复旧的 YUM 配置  