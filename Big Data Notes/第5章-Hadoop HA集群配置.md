## 实验一：高可用ZooKeeper集群部署

### Master节点
ZooKeeper安装部署
解压安装 jdk(第 4 章已安装)
```bash
tar -zxvf /opt/software/jdk-8u152-linux-x64.tar.gz -C /usr/local/src
```
更改 jdk 的名称
```bash
mv /usr/local/src/jdk1.8.0_152/ /usr/local/src/java
```
安装 ZooKeeper  
解压并安装 zookeeper 到 apps 下
```bash
tar -zxvf /opt/software/zookeeper-3.4.8.tar.gz -C /usr/local/src/
```
```bash
cd /usr/local/src/
```
```bash
mv zookeeper-3.4.8 zookeeper
```
创建 ZooKeeper 数据目录  
data 是用来传输数据的，logs 是用来记录日志的
```bash
mkdir /usr/local/src/zookeeper/data
```
```bash
mkdir /usr/local/src/zookeeper/logs
```
ZooKeeper文件参数配置  
配置 ZooKeeper 环境变量
```bash
cd ./zookeeper
```
```bash
vim /etc/profile
```
添加ZooKeeper环境变量  
#java environment(已配置)
```
export JAVA_HOME=/usr/local/src/java
export PATH=$PATH:$JAVA_HOME/bin
```
#zookeeper environment
```
export ZK_HOME=/usr/local/src/zookeeper
export PATH=$PATH:$ZK_HOME/bin
```
修改 zoo.cfg 配置文件
```bash
cd conf/
```
```bash
cp zoo_sample.cfg zoo.cfg
```
```bash
vim zoo.cfg
```
添加并更改如下配置：  
修改
<pre>
dataDir=/usr/local/src/zookeeper/data
</pre>
增加
```
dataLogDir=/usr/local/src/zookeeper/logs
server.1=master:2888:3888
server.2=slave1:2888:3888
server.3=slave2:2888:3888
```
上面的 IP 可以换成自己的主机地址，或者换成主机名，一般我们换成主机名  
创建 myid 配置文件
```bash
cd ..
```
```bash
cd data/
```
```bash
echo "1" > myid
```
ZooKeeper集群启动  
分发 ZooKeeper 集群
```bash
scp -r /usr/local/src/zookeeper/ root@slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/zookeeper/ root@slave2:/usr/local/src/
```
分发环境变量并使其生效
```bash
scp /etc/profile root@slave1:/etc/
```
```bash
scp /etc/profile root@slave2:/etc/
```
```bash
source /etc/profile
```
修改 myid 配置
```bash
cat myid
```
修改 ZooKeeper 安装目录的归属用户为 hadoop 用户
```bash
chown -R hadoop:hadoop /usr/local/src/zookeeper
```
关闭防火墙
```bash
systemctl stop firewalld.service
```
```bash
systemctl disable firewalld.service
```
同时启动三个节点的 zookeeper
```bash
su hadoop
```
```bash
cd
```
```bash
source /etc/profile
```
ZooKeeper 启动
```bash
zkServer.sh start
```
查看状态
```bash
zkServer.sh status
```

### Slave1节点
ZooKeeper文件参数配置
```bash
source /etc/profile
```
修改 myid 配置
```bash
cd /usr/local/src/zookeeper/data/
```
```bash
echo "2">myid
```
```bash
cat myid
```
修改 ZooKeeper 安装目录的归属用户为 hadoop 用户
```bash
chown -R hadoop:hadoop /usr/local/src/zookeeper
```
关闭防火墙
```bash
systemctl stop firewalld.service
```
```bash
systemctl disable firewalld.service
```
同时启动三个节点的 zookeeper
```bash
su hadoop
```
```bash
cd
```
```bash
source /etc/profile
```
ZooKeeper 启动
```bash
zkServer.sh start
```
查看状态
```bash
zkServer.sh status
```

### Slave2节点
ZooKeeper文件参数配置
```bash
source /etc/profile
```
修改 myid 配置
```bash
cd /usr/local/src/zookeeper/data/
```
```bash
echo "3">myid
```
```bash
cat myid
```
修改 ZooKeeper 安装目录的归属用户为 hadoop 用户
```bash
chown -R hadoop:hadoop /usr/local/src/zookeeper
```
关闭防火墙
```bash
systemctl stop firewalld.service
```
```bash
systemctl disable firewalld.service
```
同时启动三个节点的 zookeeper
```bash
su hadoop
```
```bash
cd
```
```bash
source /etc/profile
```
ZooKeeper 启动
```bash
zkServer.sh start
```
查看状态
```bash
zkServer.sh status
```

## 实验二：Hadoop HA集群部署

### Master节点
ssh免密配置（第四章已配置）
```bash
su - hadoop
ssh-keygen -t rsa -P ""
cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys
chmod 700 ~/.ssh/authorized_keys
scp ~/.ssh/authorized_keys root@slave1:~/.ssh/
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
scp ~/.ssh/authorized_keys root@slave2:~/.ssh/
```

Hadoop HA文件参数配置  
解压安装 Hadoop
```bash
stop-all.sh
```
```bash
su root
```
删除第 4 章安装的 hadoop  
### Master、Slave1、lave2节点都删除
```bash
rm -r -f /usr/local/src/hadoop
```
### Master节点
```bash
tar -zxvf /opt/software/hadoop-2.7.1.tar.gz -C /usr/local/src/
```
更改 hadoop 文件名
```bash
mv /usr/local/src/hadoop-2.7.1 /usr/local/src/hadoop
```
配置 hadoop 环境变量
```bash
vim /etc/profile
```
进行如下配置(此处需先删除第四章配置的环境变量)
```
#hadoop enviroment
export HADOOP_HOME=/usr/local/src/hadoop #HADOOP_HOME 指向 JAVA 安装目录
export HADOOP_PREFIX=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_OPTS="-
Djava.library.path=$HADOOP_INSTALL/lib:$HADOOP_COMMON_LIB_NATIVE_DIR"
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
#java environment
export JAVA_HOME=/usr/local/src/java #JAVA_HOME 指向 JAVA 安装目录
export PATH=$PATH:$JAVA_HOME/bin #将 JAVA 安装目录加入 PATH 路径
#zookeeper environment
export ZK_HOME=/usr/local/src/zookeeper
export PATH=$PATH:$ZK_HOME/bin
```
配置 hadoop-env.sh 配置文件
```bash
cd /usr/local/src/hadoop/etc/hadoop
```
```bash
vim hadoop-env.sh
```
在最下面添加如下配置：
```
export JAVA_HOME=/usr/local/src/java
```
配置 core-site.xml 配置文件
```bash
vim core-site.xml
```
添加如下配置：
```xml
<!-- 指定 hdfs 的 nameservice 为 mycluster -->
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://mycluster</value>
</property>
<property>
    <name>hadoop.tmp.dir</name>
    <value>file:/usr/local/src/hadoop/tmp</value>
</property>
<!-- 指定 zookeeper 地址 -->
<property>
    <name>ha.zookeeper.quorum</name>
    <value>master:2181,slave1:2181,slave2:2181</value>
</property>
<!-- hadoop 链接 zookeeper 的超时时长设置 -->
<property>
    <name>ha.zookeeper.session-timeout.ms</name>
    <value>30000</value>
    <description>ms</description>
</property>
<property>
    <name>fs.trash.interval</name>
    <value>1440</value>
</property>
```
配置 hdfs-site.xml 配置文件
```bash
vi hdfs-site.xml
```
进行如下配置：
```xml
<!-- journalnode 集群之间通信的超时时间 -->
<property>
    <name>dfs.qjournal.start-segment.timeout.ms</name>
    <value>60000</value>
</property>
<!--指定 hdfs 的 nameservice 为 mycluster，需要和 core-site.xml 中的保持一致 
dfs.ha.namenodes.[nameservice id]为在 nameservice 中的每一个 NameNode 设置唯一标示
符。配置一个逗号分隔的NameNode ID列表。这将是被DataNode识别为所有的NameNode。
如果使用"mycluster"作为 nameservice ID，并且使用"master"和"slave1"作为 NameNodes 标
示符 -->
<property>
    <name>dfs.nameservices</name>
    <value>mycluster</value>
</property>
<!-- mycluster 下面有两个 NameNode，分别是 master，slave1 -->
<property>
    <name>dfs.ha.namenodes.mycluster</name>
    <value>master,slave1</value>
</property>
<!-- master 的 RPC 通信地址 -->
<property>
    <name>dfs.namenode.rpc-address.mycluster.master</name>
    <value>master:8020</value>
</property>
<!-- slave1 的 RPC 通信地址 -->
<property>
    <name>dfs.namenode.rpc-address.mycluster.slave1</name>
    <value>slave1:8020</value>
</property>
<!-- master 的 http 通信地址 -->
<property>
    <name>dfs.namenode.http-address.mycluster.master</name>
    <value>master:50070</value>
</property>
<!-- slave1 的 http 通信地址 -->
<property>
    <name>dfs.namenode.http-address.mycluster.slave1</name>
    <value>slave1:50070</value>
</property>
<!-- 指定 NameNode 的 edits 元数据的共享存储位置。也就是 JournalNode 列表
 该 url 的配置格式：qjournal://host1:port1;host2:port2;host3:port3/journalId
 journalId 推荐使用 nameservice，默认端口号是：8485 -->
<property>
    <name>dfs.namenode.shared.edits.dir</name>
    <value>qjournal://master:8485;slave1:8485;slave2:8485/mycluster</value>
</property>
<!-- 配置失败自动切换实现方式 -->
<property>
    <name>dfs.client.failover.proxy.provider.mycluster</name>
    <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
</property>
<!-- 配置隔离机制方法，多个机制用换行分割，即每个机制暂用一行 -->
<property>
    <name>dfs.ha.fencing.methods</name>
    <value>
 sshfence
 shell(/bin/true)
 </value>
</property>
<property>
    <name>dfs.permissions.enabled</name>
    <value>false</value>
</property>
<property>
    <name>dfs.support.append</name>
    <value>true</value>
</property>
<!-- 使用 sshfence 隔离机制时需要 ssh 免登陆 -->
<property>
    <name>dfs.ha.fencing.ssh.private-key-files</name>
    <value>/root/.ssh/id_rsa</value>
</property>
<!-- 指定副本数 -->
<property>
    <name>dfs.replication</name>
    <value>2</value>
</property>
<property>
    <name>dfs.namenode.name.dir</name>
    <value>/usr/local/src/hadoop/tmp/hdfs/nn</value>
</property>
<property>
    <name>dfs.datanode.data.dir</name>
    <value>/usr/local/src/hadoop/tmp/hdfs/dn</value>
</property>
<!-- 指定 JournalNode 在本地磁盘存放数据的位置 -->
<property>
    <name>dfs.journalnode.edits.dir</name>
    <value>/usr/local/src/hadoop/tmp/hdfs/jn</value>
</property>
<!-- 开启 NameNode 失败自动切换 -->
<property>
    <name>dfs.ha.automatic-failover.enabled</name>
    <value>true</value>
</property>
<!-- 启用 webhdfs -->
<property>
    <name>dfs.webhdfs.enabled</name>
    <value>true</value>
</property>
<!-- 配置 sshfence 隔离机制超时时间 -->
<property>
    <name>dfs.ha.fencing.ssh.connect-timeout</name>
    <value>30000</value>
</property>
<property>
    <name>ha.failover-controller.cli-check.rpc-timeout.ms</name>
    <value>60000</value>
</property>
```
配置 mapred-site.xml 配置文件
```bash
cp mapred-site.xml.template mapred-site.xml
```
```bash
vim mapred-site.xml
```
进行如下配置：
```xml
<!-- 指定 mr 框架为 yarn 方式 -->
<property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
</property>
<!-- 指定 mapreduce jobhistory 地址 -->
<property>
    <name>mapreduce.jobhistory.address</name>
    <value>master:10020</value>
</property>
<!-- 任务历史服务器的 web 地址 -->
<property>
    <name>mapreduce.jobhistory.webapp.address</name>
    <value>master:19888</value>
</property>
```
配置yarn-site.xml文件
```bash
vim yarn-site.xml
```
进行如下配置：
```xml
<!-- Site specific YARN configuration properties -->
<!-- 开启 RM 高可用 -->
<property>
    <name>yarn.resourcemanager.ha.enabled</name>
    <value>true</value>
</property>
<!-- 指定 RM 的 cluster id -->
<property>
    <name>yarn.resourcemanager.cluster-id</name>
    <value>yrc</value>
</property>
<!-- 指定 RM 的名字 -->
<property>
    <name>yarn.resourcemanager.ha.rm-ids</name>
    <value>rm1,rm2</value>
</property>
<!-- 分别指定 RM 的地址 -->
<property>
    <name>yarn.resourcemanager.hostname.rm1</name>
    <value>master</value>
</property>
<property>
    <name>yarn.resourcemanager.hostname.rm2</name>
    <value>slave1</value>
</property>
<!-- 指定 zk 集群地址 -->
<property>
    <name>yarn.resourcemanager.zk-address</name>
    <value>master:2181,slave1:2181,slave2:2181</value>
</property>
<property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
</property>
<property>
    <name>yarn.log-aggregation-enable</name>
    <value>true</value>
</property>
<property>
    <name>yarn.log-aggregation.retain-seconds</name>
    <value>86400</value>
</property>
<!-- 启用自动恢复 -->
<property>
    <name>yarn.resourcemanager.recovery.enabled</name>
    <value>true</value>
</property>
<!-- 制定 resourcemanager 的状态信息存储在 zookeeper 集群上 -->
<property>
    <name>yarn.resourcemanager.store.class</name>
    <value>org.apache.hadoop.yarn.server.resourcemanager.recovery.ZKRMStateStore</value>
</property>
```
配置slaves文件
```bash
vim slaves
```
进行如下配置：
```
master
slave1
slave2
```
解压包到指定目录  
namenode、datanode、journalnode 等存放数据的公共目录为/usr/local/src/hadoop/tmp；在 master 上执行如下：  
```bash
mkdir -p /usr/local/src/hadoop/tmp/hdfs/nn
```
```bash
mkdir -p /usr/local/src/hadoop/tmp/hdfs/dn
```
```bash
mkdir -p /usr/local/src/hadoop/tmp/hdfs/jn
```
```bash
mkdir -p /usr/local/src/hadoop/tmp/logs
```
分发文件
```bash
scp -r /etc/profile root@slave1:/etc/
```
```bash
scp -r /etc/profile root@slave2:/etc/
```
```bash
scp -r /usr/local/src/hadoop root@slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/hadoop root@slave2:/usr/local/src/
```
### Master、Slave1、lave2节点
修改目录所有者和所有者组
```bash
chown -R hadoop:hadoop /usr/local/src/hadoop/
```
生效环境变量
```bash
su hadoop
```
```bash
source /etc/profile
```
