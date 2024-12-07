## 一、 Hadoop HA 部署
### 一、解压 JDK 安装包到“/usr/local/src”路径，并配置环境变量；并配置环境变量；截取环境变量配置文件截图 
**master节点**  
1、三台机器全部都要关闭防火墙 和 自启  
```bash
systemctl  stop firewalld
```
```bash
systemctl  disable firewalld
```
2、卸载自带的jdk  
```bash
rpm -qa | grep jdk
rpm -e --nodeps java-1.7.0-openjdk
rpm -e --nodeps java-1.7.0-openjdk-headless
rpm -e --nodeps java-1.8.0-openjdk
rpm -e --nodeps java-1.8.0-openjdk-headless
```
3、进入 /h3cu/ 目录  
```bash
cd /h3cu/
```
```bash
ls
```
4、解压 jdk 到 /usr/local/src  
```bash
tar -zxvf jdk-8u144-linux-x64.tar.gz -C /usr/local/src/
```
5、配置环境变量
```bash
cd /usr/local/src/jdk1.8.0_144/
```
```bash
pwd
```
***复制当前路径***
```bash
vim /etc/profile
```
添加至最后一行
```
export JAVA_HOME=/usr/local/src/jdk1.8.0_144
export PATH=$PATH:$JAVA_HOME/bin
```
生效环境变量
```bash
source /etc/profile
```
查看一下jdk版本是否一致
```bash
java -version
```


### 二、在指定目录下安装ssh服务，查看ssh进程并截图
**master节点**   
1、查看是否已安装ssh服务
```bash
rpm -qa | grep ssh
```
2、使用yum进行安装ssh服务
```bash
yum -y install openssh openssh-server
```
3、查看ssh进程
```bash
ps -ef | grep ssh
```


### 三、创建 ssh 密钥，实现主节点与从节点的无密码登录；截取主节点登录其中一个从节点的结果
1、在指定目录下生成密钥对  
**只在master节点生成** 
```bash
ssh-keygen -t rsa
```
***依次回车，生成密钥对***
2、分发公匙文件
`每个`主机都需要分发公钥，并且需要输入各个主机的密码  
**master节点**
```bash
ssh-copy-id 192.168.66.114
```
```bash
ssh-copy-id 192.168.66.115
```
```bash
ssh-copy-id 192.168.66.116
```
3、主节点免密登录从节点  
**master节点**
```bash
ssh 192.168.66.115
```
```bash
exit
```
```bash
ssh 192.168.66.116
```
```bash
exit
```


### 四、 根据要求修改每台主机 host 文件，截取“/etc/hosts”文件截图
***三台机器的hosts文件全部都要修改***  
**master、slave1、slave2节点**
```bash
vim /etc/hosts
```
添加以下内容
```
192.168.66.114 master1
192.168.66.115 slave1
192.168.66.116 slave2
```


### 五、修改每台主机hostname文件配置IP与主机名映射关系；截取/etc/hostname文件截图
**master节点**
```bash
hostnamectl set-hostname master1
bash
```
**slave1节点**
```bash
hostnamectl set-hostname slave1
bash
```
**slave2节点**
```bash
hostnamectl set-hostname slave2
bash
```


### 六、在主节点和从节点修改 Hadoop 环境变量，并截取修改内容
**master、slave1、slave2节点**  
1、修改Hadoop环境变量
```bash
vim /etc/profile
```
添加或者修改为如下内容
```
export HADOOP_HOME=/usr/local/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```


### 七、需安装 Zookeeper 组件具体要求同 Zookeeper 任务要求，并与 Hadoop HA 环境适配
**master节点**  
1、解压zookeeper
```bash
tar -zxvf /h3cu/zookeeper-3.4.8.tar.gz -C /usr/local/src/
```
2、重命名
```bash
mv /usr/local/src/zookeeper-3.4.8/ /usr/local/src/zookeeper
```
3、进入zookeeper/conf目录下
```bash
cd /usr/local/src/zookeeper/conf/
```
4、重命名zoo_sample.cfg为zoo.cfg
```bash
mv zoo_sample.cfg zoo.cfg
```
5、修改zoo.cfg配置文件
```bash
vim zoo.cfg
```
添加或者修改为如下内容
```
tickTime=2000
syncLimit=5
dataDir=/usr/local/src/zookeeper/data
dataLogDir=/usr/local/src/zookeeper/logs
clientPort=2181
server.1=master1:2888:3888
server.2=slave1:2888:3888
server.3=slave2:2888:3888
```
6、创建ZooKeeper 的数据存储与日志存储目录
```bash
mkdir /usr/local/src/zookeeper/data
mkdir /usr/local/src/zookeeper/logs
```
7、创建myid文件并写入内容：1
```bash
vim /usr/local/src/zookeeper/data/myid
```
添加或者修改为如下内容
```
1
```
8、添加zookeeper环境变量
```bash
vim /etc/profile
```
添加或者修改为如下内容
```
export ZK_HOME=/usr/local/src/zookeeper
export PATH=$PATH:ZK_HOME/bin
```
9、集群分发
```bash
scp -r /etc/profile slave1:/etc/profile
```
```bash
scp -r /etc/profile slave2:/etc/profile
```
都输入`yes`  
```bash
scp -r /usr/local/src/zookeeper/ slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/zookeeper/ slave2:/usr/local/src/
```
10、修改`slave1-1` 和 `slave1-2`的myid文件分别为2 ，3  
**slave1节点**
```bash
vim /usr/local/src/zookeeper/data/myid
```
添加或者修改为如下内容
```
2
```
**slave2节点**
```bash
vim /usr/local/src/zookeeper/data/myid
```
添加或者修改为如下内容
```
3
```


### 八、修改 namenode、datanode、journalnode 等存放数据的公共目录为 /usr/local/hadoop/tmp
**master节点**  
1、解压安装Hadoop
```bash
tar -zxvf /h3cu/hadoop-2.7.1.tar.gz  -C /usr/local/
```
2、重命名Hadoop
```bash
mv /usr/local/hadoop-2.7.1/ /usr/local/hadoop
```
3、进入hadoop配置文件目录
```bash
cd /usr/local/hadoop/etc/hadoop/
```
4、配置hadoop-env.sh文件(修改)
```bash
vim hadoop-env.sh
```
添加或者修改为如下内容
```
export JAVA_HOME=/usr/local/src/jdk1.8.0_144/
```
5、配置core-site.xml文件
```bash
vim core-site.xml
```
添加或者修改为如下内容
```xml
<configuration>
<!-- 指定 hdfs 的 nameservice 为 mycluster -->
 <property>
        <name>fs.defaultFS</name>
        <value>hdfs://mycluster</value>
 </property>
 <property>
        <name>hadoop.tmp.dir</name>
        <value>/usr/local/hadoop/tmp</value>
 </property>
 <!-- 指定 zookeeper 地址 -->
 <property>
        <name>ha.zookeeper.quorum</name>
        <value>master1:2181,slave1:2181,slave2:2181</value>
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
</configuration>
```
6、配置hdfs-site.xml文件
```bash
vim hdfs-site.xml
```
添加或者修改为如下内容
```xml
<configuration>
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
        <value>master1,slave1</value>
    </property>
    <!-- master 的 RPC 通信地址 -->
    <property>
        <name>dfs.namenode.rpc-address.mycluster.master1</name>
        <value>master1:9000</value>
    </property>
    <!-- slave1 的 RPC 通信地址 -->
    <property>
        <name>dfs.namenode.rpc-address.mycluster.slave1</name>
        <value>slave1:9000</value>
    </property>
    <!-- master 的 http 通信地址 -->
    <property>
        <name>dfs.namenode.http-address.mycluster.master1</name>
        <value>master1:50070</value>
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
        <value>qjournal://master1:8485;slave1:8485;slave2:8485/mycluster</value>
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
        <value>/usr/local/hadoop/tmp/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/usr/local/hadoop/tmp/data</value>
    </property>
    <!-- 指定 JournalNode 在本地磁盘存放数据的位置 -->
    <property>
        <name>dfs.journalnode.edits.dir</name>
        <value>/usr/local/hadoop/tmp/journal</value>
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
</configuration>
```
7、配置mapred-site.xml文件  
拷贝mapred-site.xml.template重命名为mapred-site.xml,并编辑文件
```bash
cp mapred-site.xml.template  mapred-site.xml
```
```bash
vim mapred-site.xml
```
添加或者修改为如下内容
```xml
<configuration>
<!-- 指定 mr 框架为 yarn 方式 -->
 <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
</property>
 <!-- 指定 mapreduce jobhistory 地址 -->
 <property>
        <name>mapreduce.jobhistory.address</name>
        <value>master1:10020</value>
 </property>
 <!-- 任务历史服务器的 web 地址 -->
 <property>
        <name>mapreduce.jobhistory.webapp.address</name>
        <value>master1:19888</value>
 </property>
</configuration>
```
8、配置yarn-site.xml文件
```bash
vim yarn-site.xml
```
添加或者修改为如下内容
```xml
<configuration>

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
        <value>master1</value>
 </property>
 <property>
        <name>yarn.resourcemanager.hostname.rm2</name>
        <value>slave1</value>
 </property>
 <!-- 指定 zk 集群地址 -->
 <property>
        <name>yarn.resourcemanager.zk-address</name>
        <value>master1:2181,slave1:2181,slave1:2181</value>
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
</configuration>
```
9、创建tmp , logs, tmp/下创建name,data,journal目录
```bash
mkdir /usr/local/hadoop/tmp
mkdir /usr/local/hadoop/logs
mkdir /usr/local/hadoop/tmp/journal
mkdir /usr/local/hadoop/tmp/data
mkdir /usr/local/hadoop/tmp/name
```
10、配置hadoop/etc/hadoop/slaves文件
```bash
vim slaves
```
添加或者修改为如下内容
```
master1
slave1
slave2
```
11、分发jdk和hadoop文件
```bash
scp -r /usr/local/src/jdk1.8.0_144/ slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/jdk1.8.0_144/ slave2:/usr/local/src/
```
```bash
scp -r /usr/local/hadoop/ slave1:/usr/local/
```
```bash
scp -r /usr/local/hadoop/ slave2:/usr/local/
```
12、确保3台机器的环境变量已经生效  
**master、slave1、slave2节点都执行下面的代码**  
```bash
source /etc/profile
```

## 九、根据要求修改 Hadoop 相关文件，并初始化 Hadoop，截图初始化结果
1、启动zookeeper集群并查看状态  
**master节点**
进入zookeeper安装目录下
```bash
cd /usr/local/src/zookeeper/
```
```bash
bin/zkServer.sh start
```
<pre>
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
</pre>
```bash
bin/zkServer.sh status
```
<pre>
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: follower
</pre>
**slave1节点**
```bash
cd /usr/local/src/zookeeper/
```
```bash
bin/zkServer.sh start
```
```bash
bin/zkServer.sh status
```
<pre>
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: leader
</pre>
**slave2节点**
```bash
cd /usr/local/src/zookeeper/
```
```bash
bin/zkServer.sh start
```
```bash
bin/zkServer.sh status
```
<pre>
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: follower
</pre>
2、初始化HA在zookeeper中的状态  
**master节点**
```bash
cd /usr/local/hadoop/
```
```bash
bin/hdfs zkfc -formatZK
```
3、启动全部机器的 journalnode 服务  
进入/usr/local/hadoop安装目录下  
`[root@master1 hadoop]#`
```bash
sbin/hadoop-daemon.sh start journalnode
```
**slave1节点**  
`[root@slave1 zookeeper]#`
```bash
cd /usr/local/hadoop/
```
`[root@slave1 hadoop]#`
```bash
sbin/hadoop-daemon.sh start journalnode
```
**slave2节点**  
`[root@slave2 zookeeper]#`
```bash
cd /usr/local/hadoop/
```
`[root@slave2 hadoop]#`
```bash
sbin/hadoop-daemon.sh start journalnode
```
4、初始化namenode  
进入hadoop/bin目录下  
```bash
cd bin
```
`[root@master1 bin]#`
```bash
hdfs namenode -format
```
***注意slave1节点也需要格式化***
```bash
cd bin
```
```bash
hdfs namenode -format
```
最终状态为`0`才是正确的
<pre>
22/08/03 19:26:29 INFO namenode.NNStorageRetentionManager: Going to retain 1 images with txid >= 0
22/08/03 19:26:29 INFO util.ExitUtil: Exiting with status 0
22/08/03 19:26:29 INFO namenode.NameNode: SHUTDOWN_MSG: 
/************************************************************
SHUTDOWN_MSG: Shutting down NameNode at master1/192.168.160.110
************************************************************/
</pre>
**观察是否有报错信息，status是否为0，0即为初始化成功，1则报错，检查配置文件是否有误**


## 十、启动 Hadoop，使用相关命令查看所有节点 Hadoop 进程并截图
**master节点**  
启动hadoop所有进程  
进入hadoop安装目录下  
**可能会出现卡住，输入回车或者yes或者重新启动**  
`[root@master1 bin]#`
```bash
cd ..
```
`[root@master1 hadoop]#`
```bash
sbin/start-all.sh
```


## 十一、本题要求配置完成后在 Hadoop 平台上运行查看进程命令，要求运行结果的截屏保存
**master、slave1、slave2节点**
<pre>
[root@master1 hadoop]# jps
7424 ResourceManager
5973 QuorumPeerMain
8517 Jps
8407 NodeManager
7928 DataNode
6892 JournalNode
8236 DFSZKFailoverController
7823 NameNode

[root@slave1 hadoop]# jps
7073 Jps
6324 JournalNode
5861 QuorumPeerMain
6695 DFSZKFailoverController
6575 DataNode
6767 NodeManager

[root@slave2 hadoop]# jps
6884 NodeManager
6118 QuorumPeerMain
6759 DataNode
7095 Jps
6606 JournalNode
</pre>


## 十二、格式化主从节点
1、复制 namenode 元数据到其它节点  
`[root@slave2 hadoop]#`  
```bash
scp -r /usr/local/hadoop/tmp/* slave1:/usr/local/hadoop/tmp/
```
`[root@slave2 hadoop]#`
```bash
scp -r /usr/local/hadoop/tmp/* slave2:/usr/local/hadoop/tmp/
```
`注：由于之前namenode,datanode,journalnode的数据全部存放在hadoop/tmp目录下，所以直接复制 tmp 目录至从节点`  


## 十三、启动两个 resourcemanager 和 namenode
1、在slave1-1节点启动namenode和resourcemanager进程  
进入hadoop安装目录  
`[root@slave1 hadoop]#`
```bash
sbin/hadoop-daemon.sh start namenode
```
`[root@slave1 hadoop]#`
```bash
sbin/hadoop-daemon.sh start resourcemanager
```


## 十四、使用查看进程命令查看进程,并截图(要求截取主机名称),访问两个 namenode 和 resourcemanager web 界面.并截图保存(要求截到 url 状态)
<pre>
[root@slave1 hadoop]# jps
7184 ResourceManager
6324 JournalNode
5861 QuorumPeerMain
6695 DFSZKFailoverController
7612 Jps
7534 NameNode
6575 DataNode
6767 NodeManager
</pre>
网页访问步骤：  
1、配置windows中的hosts文件  
- 进入`C:\Windows\System32\drivers\etc`目录下找到hosts文件  
- 使用记事本打开hosts文件的属性，使其可以修改内容，在最后一行加入一下内容  
```
192.168.66.114 master1 master1.centos.com
192.168.66.115 slave1 slave1.centos.com
192.168.66.116 slave2 slave2.centos.com
```
2、在浏览访问两个 namenode 和 resourcemanager web 界面  
地址栏输入 `master1:50070`  
![HA1](https://github.com/user-attachments/assets/eb974aff-2295-4f51-8f7d-a5303557c2d4)  

地址栏输入 `slave1:50070`  
![HA2](https://github.com/user-attachments/assets/476fda09-4981-41b1-ac76-b0d3a4b53698)  

地址栏输入 `master1:8088`  
![HA3](https://github.com/user-attachments/assets/9c265527-58b5-4311-9edf-d5e3adc5beb8)  

**点击左方Nodes可以看到当前存在的节点**


## 十五、终止 active 的 namenode 进程,并使用 Jps 查看各个节点进程,(截上主机名称),访问两个 namenode 和 resourcemanager web 界面.并截图保存 (要求截到 url 和状态)
1、终止活跃状态的namenode
<pre>
[root@master1 name]# jps
7424 ResourceManager
5973 QuorumPeerMain
8407 NodeManager
7928 DataNode
6892 JournalNode
8236 DFSZKFailoverController
8814 Jps
7823 NameNode
[root@master1 name]# kill -9 7823        //(namenode进程号）
[root@master1 name]# jps
7424 ResourceManager
8834 Jps
5973 QuorumPeerMain
8407 NodeManager
7928 DataNode
6892 JournalNode
8236 DFSZKFailoverController

[root@slave1 hadoop]# jps
7184 ResourceManager
6324 JournalNode
5861 QuorumPeerMain
6695 DFSZKFailoverController
7866 Jps
7534 NameNode
6575 DataNode
6767 NodeManager

[root@slave2 hadoop]# jps
6884 NodeManager
6118 QuorumPeerMain
6759 DataNode
7383 Jps
6606 JournalNode
</pre>
实现上一步骤就会发现，杀死master1的namenode进程，master就不能访问了，slave1会自动转化换active状态  
![HA4](https://github.com/user-attachments/assets/3c9c5af8-9e6f-400c-90dd-dc2090d70c2e)  
![HA5](https://github.com/user-attachments/assets/ff222b4a-9bd8-4d3f-ab55-2c7da0fb09f1)  


## 十六、重启刚才终止的 namenode,并查看 jps 进程,截图访问两个 namenode 的 web 界面,并截图保存
`[root@master1 hadoop]#`
```bash
sbin/hadoop-daemon.sh start namenode
```
<pre>
starting namenode, logging to /usr/local/hadoop/logs/hadoop-root-namenode-master1.out
</pre>
`[root@master1 hadoop]#`
```bash
jps
```
<pre>
[root@master1 hadoop]# jps
7424 ResourceManager
5973 QuorumPeerMain
8934 NameNode
8407 NodeManager
7928 DataNode
6892 JournalNode
8236 DFSZKFailoverController
9007 Jps
</pre>
再次启动master的namenode节点后，发现状态转变为standby状态，slave1仍然为active状态，两者之间进行了转换  
![HA6](https://github.com/user-attachments/assets/d6d66d87-61e2-4196-a83f-9333e767bdac)  
![HA7](https://github.com/user-attachments/assets/6cc0c284-d4ba-47db-b6b0-06d824a7bd90)  
