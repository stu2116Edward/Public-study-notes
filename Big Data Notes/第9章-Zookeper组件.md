## 实验一：ZooKeeper组件部署

### Master节点

集群模式部署ZooKeeper  
解压安装ZooKeeper
```bash
tar -zxvf /opt/software/zookeeper-3.4.8.tar.gz -C /usr/local/src/
```
```bash
mv /usr/local/src/zookeeper-3.4.8/ /usr/local/src/zookeeper
```
修改配置文件  
Zookeeper 的配置文件放置在 conf 下，提供 zoo_sample.cfg 样例，可重命名 zoo.cfg后在此基础上修改  
```bash
cd /usr/local/src/zookeeper/conf/
```
```bash
mv zoo_sample.cfg /usr/local/src/zookeeper/conf/zoo.cfg
```
```bash
vim /usr/local/src/zookeeper/conf/zoo.cfg
```
添加以下配置：
```
tickTime=2000
initLimit=10
syncLimit=5
clientPort=2181
dataDir=/usr/local/src/zookeeper/data
dataLogDir=/usr/local/src/zookeeper/logs
server.1=master:2888:3888
server.2=slave1:2888:3888
server.3=slave2:2888:3888
```
创建数据和日志目录
```bash
mkdir -p /usr/local/src/zookeeper/data
```
```bash
mkdir -p /usr/local/src/zookeeper/logs
```
配置myid文件
```bash
vim /usr/local/src/zookeeper/data/myid
```
```
1
```
输入1，表示master节点的ID  
配置ZooKeeper环境变量
```
vim /etc/profile
```
添加以下配置：
```
#zookeeper environment
export ZK_HOME=/usr/local/src/zookeeper
export PATH=$PATH:$ZK_HOME/bin
```
文件分发  
将 master 主节点已经配置好 ZooKeepr 文件分发给集群从节点
```bash
scp -r /usr/local/src/zookeeper root@slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/zookeeper root@slave2:/usr/local/src/
```
```bash
scp /etc/profile root@slave1:/etc/
```
```bash
scp /etc/profile root@slave2:/etc/
```
### Slave1、Slave2节点
Slave1修改myid文件
```bash
vim /usr/local/src/zookeeper/data/myid
```
修改为如下内容：
```
2
```
Slave2修改myid文件
```bash
vim /usr/local/src/zookeeper/data/myid
```
修改为如下内容：
```
3
```

### Master、Slave1、Slave2节点
修改ZooKeeper安装目录的归属用户为hadoop用户
```bash
chown -R hadoop:hadoop /usr/local/src/zookeeper
```
启动ZooKeeper  
关闭防火墙
```bash
systemctl stop firewalld.service
```
关闭防火墙自启
```bash
systemctl disable firewalld.service
```
```bash
su - hadoop
```
```bash
source /etc/profile
```
```bash
./zkServer.sh start
```
```bash
./zkServer.sh status
```

## 实验二 ZooKeeper shell 操作

### Master节点
连接 zookeeper 服务
```bash
zkCli.sh -server localhost:2181
```
ls 命令  
语法：`ls [path]`  
跟 Linux 命令语法一致，在 ZooKeeper 中查看该节点下某一路径下目录列表
```bash
ls /
```
```bash
ls /zookeeper
```
```bash
ls /zookeeper/quota
```
stat 命令  
语法：`stat [path]`  
显示节点的详细信息
```bash
stat /
```
ls2 命令  
语法：`ls2 [path]`  
相当于 ls + stat。显示当前目录与详细信息
```bash
ls2 /
```
create 创建节点  
语法：`create [-s] [-e] [path]<node_name> <data>`  
创建节点，本实验在根目录下创建 zknode1 节点，元数据为字符串 node1_data。也可以在节点下创建子节点。[-s]表示顺序创建，[-e]表示创建的是临时节点  
```bash
create /zknode1 "node1_data"
```
```bash
create /zknode1/node1 "data"
```
get 命令  
语法：`get [path]<node_name>`  
获取当前的目录（节点）的数据信息
```bash
get /zknode1
```
set 命令  
语法：`set [path]<node_name> <data>`  
修改节点的元数据。本实验元数据修改为"zknode1_data"，get 查看后 dataVersion 加 1，数据的长度也发生了变化  
```bash
set /zknode1 "zknode1_data"
```
```bash
get /zknode1
```
删除节点  
语法：`delete [path]<node_name>`  
删除节点要求该节点下没有子节点
```bash
delete /zknode1
```
```bash
delete /zknode1/node1
```
```bash
delete /zknode1
```