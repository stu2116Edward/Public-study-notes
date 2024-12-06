## Storm 组件安装部署

### 一、前置安装 Zookeeper 集群，截图并保存结果
<pre>
[root@master1 ~]# cd /usr/local/src/zookeeper/
[root@master1 zookeeper]# bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: follower
[root@slave1 ~]# cd /usr/local/src/zookeeper/
[root@slave1 zookeeper]# bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: leader
[root@slave2 ~]# cd /usr/local/src/zookeeper/
[root@slave2 zookeeper]# bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: follower

[root@master1 zookeeper]# jps
92817 QuorumPeerMain
100035 Kafka
71602 JournalNode
103364 Jps
71773 NameNode
71885 DataNode
72204 DFSZKFailoverController
[root@slave1 ~]# jps
3074 DataNode
12531 Kafka
2884 JournalNode
2966 NameNode
3223 DFSZKFailoverController
9175 QuorumPeerMain
16058 Jps
[root@slave2 zookeeper]# jps
14384 QuorumPeerMain
18866 Jps
10905 JournalNode
16285 Kafka
</pre>


### 二、解压 Storm 安装包到“/usr/local/src”路径，并修改解压后文件夹名为 storm，截图并保存结果
1、进入/h3cu目录找到storm,并解压
<pre>
[root@master1 ~]# cd /h3cu/
[root@master1 h3cu]# tar -zxvf apache-storm-1.2.4.tar.gz -C /usr/local/src/
</pre>
2、重命名storm
<pre>
[root@master1 h3cu]# cd /usr/local/src/
[root@master1 src]# mv apache-storm-1.2.4/ storm
</pre>

### 三、配置“conf/storm.yaml”文件，截图并保存结果  
### 四、传送配置好的“conf/storm.yaml”文件，截图并保存结果  
### 五、配置 nimbus.seeds 文件，截图并保存结果  
### 六、配置 supervisor.slots.ports，截图并保存结果  
<pre>
[root@master1 ~]# cd /usr/local/src/storm/conf/
[root@master1 conf]# vim storm.yaml 
 storm.zookeeper.servers:
     - "master1"
     - "slave1"
     - "slave2"
 nimbus.seeds: ["master1", "slave1"]
 storm.local.dir: "/usr/local/src/storm/data"
 supervisor.slots.ports:
     - 6700
     - 6701
 nimbus.host: "master1"
 ui.port: 9999
</pre>
***注：文件内容的格式一定要注意，冒号后有空格，格式错误，进程是启动不了的***


### 七、拷贝主节点 Storm 包到从节点，截图并保存结果
1、集群分发
<pre>
[root@master1 storm]# scp -r /usr/local/src/storm/ slave1:/usr/local/src/
[root@master1 storm]# scp -r /usr/local/src/storm/ slave2:/usr/local/src/
</pre>


### 八、设置 Storm 环境变量，并使环境变量只对当前 root 用户生效，截图并保存结果
1、添加环境变量
<pre>
[root@master1 storm]# vim /root/.bashrc 
export STORM_HOME=/usr/local/src/storm
export PATH=$PATH:$STORM_HOME/bin
</pre>
2、使环境变量立即生效
<pre>
[root@master1 storm]# source /root/.bashrc 
</pre>


### 九、在主节点和从节点启动，并截图保存(要求截到 url 和状态)
**master主节点**  
1、进入storm/bin目录下
<pre>
[root@master1 storm]# cd /usr/local/src/storm/bin/
</pre>
2、启动以下：  
①启动master和slave1的主节点 nimbus服务  
②启动从节点 supervisor服务  
③启动UI界面 ui  
④启动日志查看服务 logviewer  

***启动时可能需要等待一下会***
<pre>
[root@master1 bin]# nohup sh storm nimbus &
[1] 103714
[root@master1 bin]# nohup: ignoring input and appending output to ‘nohup.out’

[root@master1 bin]# nohup sh storm supervisor &
[2] 103831
[root@master1 bin]# nohup: ignoring input and appending output to ‘nohup.out’

[root@master1 bin]# nohup sh storm ui &
[3] 103869
[root@master1 bin]# nohup: ignoring input and appending output to ‘nohup.out’

[root@master1 bin]# nohup sh storm logviewer &
[4] 103908
[root@master1 bin]# nohup: ignoring input and appending output to ‘nohup.out’
</pre>
**slave从节点（两台slave从节点都需要做）**  
1、进入storm/bin目录下
<pre>
[root@slave1 ~]# cd /usr/local/src/storm/bin/
</pre>
2、启动以下：  
①启动从节点 supervisor  
②启动日志查看服务 logviewer  
<pre>
[root@slave1 bin]# nohup sh storm supervisor &
[1] 16534
[root@slave1 bin]# nohup: ignoring input and appending output to ‘nohup.out’

[root@slave1 bin]# nohup sh storm logviewer &
[2] 16573
[root@slave1 bin]# nohup: ignoring input and appending output to ‘nohup.out’
</pre>
浏览器输入master1-1:9999查看集群状态:


<pre>
[root@master1 conf]# jps
92817 QuorumPeerMain
105696 Supervisor
71602 JournalNode
106134 core
105978 logviewer
106586 Jps
71885 DataNode
72204 DFSZKFailoverController
104687 nimbus
[root@slave1 ~]# jps
3074 DataNode
12531 Kafka
17251 Jps
2884 JournalNode
2966 NameNode
16534 Supervisor
3223 DFSZKFailoverController
9175 QuorumPeerMain
16573 logviewer
[root@slave2 bin]# jps
14384 QuorumPeerMain
19555 logviewer
10905 JournalNode
16285 Kafka
19517 Supervisor
19727 Jps
</pre>