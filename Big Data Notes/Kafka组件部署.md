## Kafka组件部署

### 一、需安装 Zookeeper 组件具体要求同 Zookeeper 任务要求，并与 Kafka 环境适配，启动 Zookeeper 并截图保存结果
**master、slave1、slave2节点**  
1、启动三台机器zookeeper  
`[root@master1 ~]#`
```bash
cd /usr/local/src/zookeeper/
```
```bash
bin/zkServer.sh start
```
<pre>
[root@master1 ~]# cd /usr/local/src/zookeeper/
[root@master1 zookeeper]# bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@slave1 ~]# cd /usr/local/src/zookeeper/
[root@slave1 zookeeper]# bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
[root@slave2 ~]# cd /usr/local/src/zookeeper/
[root@slave2 zookeeper]# bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED

[root@master1 zookeeper]# bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: follower
[root@master1 zookeeper]# jps
92817 QuorumPeerMain
71602 JournalNode
92888 Jps
71773 NameNode
71885 DataNode
72204 DFSZKFailoverController

[root@slave1 zookeeper]# bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: leader
[root@slave1 zookeeper]# jps
3074 DataNode
2884 JournalNode
2966 NameNode
9270 Jps
3223 DFSZKFailoverController
9175 QuorumPeerMain
3323 NodeManager

[root@slave2 zookeeper]# bin/zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /usr/local/src/zookeeper/bin/../conf/zoo.cfg
Mode: follower
[root@slave2 zookeeper]# jps
14384 QuorumPeerMain
11542 Worker
14455 Jps
10905 JournalNode
11134 NodeManager
</pre>


### 二、解压 Kafka 安装包到“/usr/local/src”路径，并修改解压后文件夹名为 kafka，截图并保存结果
**master节点**  
1、进入/h3cu目录找到kafka  
`[root@master1 ~]#`
```bash
cd /h3cu/
```
2、解压kafka  
`[root@master1 h3cu]#`
```bash
tar -zxvf kafka1.0.0.tgz  -C /usr/local/src/
```
3、重命名kafka
```bash
cd /usr/local/src/
```
```bash
mv kafka_2.11-1.0.0/ kafka
```


### 三、设置 Kafka 环境变量，并使环境变量只对当前 root 用户生效，截图并保存结果
**master节点**  
1、添加环境变量  
`[root@master1 ~]#`
```bash
vim /root/.bashrc 
```
添加环境变量
```
export KAFKA_HOME=/usr/local/src/kafka
export PATH=$PATH:$KAFKA_HOME/bin
```
2、使环境变量立即生效
```bash
source /root/.bashrc
```


### 四、修改 Kafka 相应文件，截图并保存结果
**master节点**  
1、进入kafka/config目录下
```bash
cd /usr/local/src/kafka/config/
```
2、修改 server.properties文件
```bash
vim server.properties
```
在`zookeeper.connect`后面修改为：
```
zookeeper.connect=master1:2181,slave1:2181,slave2:2181
```
在`log.dirs`后面修改为：
```
log.dirs=/usr/local/src/kafka/logs
```
最后添加：
```
host.name=master1
delete.topic.enable=true
```
3、创建logs目录
```bash
mkdir /usr/local/src/kafka/logs
```
4、集群分发
```bash
scp -r /usr/local/src/kafka/ slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/kafka/ slave2:/usr/local/src/
```
5、分别修改`slave1`和`slave2`的`server.properties`文件  
**slave1节点**  
`[root@slave1 ~]#`
```bash
vim /usr/local/src/kafka/config/server.properties
```
修改
```
broker.id=1
host.name=slave1
```
**slave2节点**  
`[root@slave2 ~]#`
```bash
vim /usr/local/src/kafka/config/server.properties
```
修改
```
broker.id=2
host.name=slave2
```


### 五、启动 Kafka 并保存命令输出结果，截图并保存结果
1、进入kafka安装目录,启动kafka  
`[root@master1 ~]#`
```bash
cd /usr/local/src/kafka/
```
```bash
bin/kafka-server-start.sh -daemon ./config/server.properties &
```
`[root@slave1 ~]#`
```bash
cd /usr/local/src/kafka/
```
```bash
bin/kafka-server-start.sh -daemon ./config/server.properties &
```
`[root@slave2 ~]#`
```bash
cd /usr/local/src/kafka/
```
```bash
bin/kafka-server-start.sh -daemon ./config/server.properties &
```
<pre>
[root@master1 ~]# cd /usr/local/src/kafka/
[root@master1 kafka]# bin/kafka-server-start.sh -daemon ./config/server.properties &
[root@slave1 ~]# cd /usr/local/src/kafka/
[root@slave1 kafka]#  bin/kafka-server-start.sh -daemon ./config/server.properties &
[root@slave2 ~]# cd /usr/local/src/kafka/
[root@slave2 kafka]#  bin/kafka-server-start.sh -daemon ./config/server.properties &

[root@master1 kafka]# jps
92817 QuorumPeerMain
97648 Jps
71602 JournalNode
97620 Kafka
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
12652 Jps
[root@slave2 ~]# jps
14384 QuorumPeerMain
16370 Jps
10905 JournalNode
16285 Kafka
</pre>


### 六、创建指定 topic，并截图并保存结果
1、在master上创建topic-test  
`[root@master1 kafka]#`
```bash
./bin/kafka-topics.sh --create --zookeeper master1:2181,slave1:2181,slave2:2181 --replication-factor 3 --partitions 3 --topic test
```
<pre>
[root@master1 kafka]# ./bin/kafka-topics.sh --create --zookeeper master1:2181,slave1:2181,slave2:2181 --replication-factor 3 --partitions 3 --topic test
Created topic "test".
[root@master1 kafka]# 
</pre>


### 七、查看所有的 topic 信息，并截图并保存结果
1、查看所有topic信息  
`[root@master1 kafka]#`
```bash
./bin/kafka-topics.sh --list --zookeeper master1:2181
```
`[root@slave1 kafka]#`
```bash
./bin/kafka-topics.sh --list --zookeeper slave1:2181
```
`[root@slave2 kafka]#`
```bash
./bin/kafka-topics.sh --list --zookeeper slave2:2181
```
<pre>
[root@master1 kafka]# ./bin/kafka-topics.sh --list --zookeeper master1:2181
test
[root@slave1 kafka]# ./bin/kafka-topics.sh --list --zookeeper slave1:2181
test
[root@slave2 kafka]# ./bin/kafka-topics.sh --list --zookeeper slave2:2181
test
</pre>


### 八、启动指定生产者（producer），并截图并保存结果
1、在master上启动生产者  
`[root@master1 kafka]#`
```bash
./bin/kafka-console-producer.sh --broker-list master1:9092,slave1:9092,slave2:9092 --topic test
```


### 九、启动消费者（consumer），并截图并保存结果
1、在slave启动消费者  
`[root@slave1 kafka]#`
```bash
./bin/kafka-console-consumer.sh --bootstrap-server master1:9092,slave1:9092,slave2:9092 --from-beginning --topic test
```
`[root@slave2 kafka]#`
```bash
./bin/kafka-console-consumer.sh --bootstrap-server master1:9092,slave1:9092,slave2:9092 --from-beginning --topic test
```
<pre>
[root@slave1 kafka]# ./bin/kafka-console-consumer.sh --bootstrap-server master1:9092,slave1:9092,slave2:9092 --from-beginning --topic test
[root@slave2 kafka]# ./bin/kafka-console-consumer.sh --bootstrap-server master1:9092,slave1:9092,slave2:9092 --from-beginning --topic test
</pre>


### 十、测试生产者（producer），并截图并保存结果
***注： 在生产者随便输入一些内容***
```bash
./bin/kafka-console-producer.sh --broker-list master1:9092,slave1:9092,slave2:9092 --topic test
```
<pre>
[root@master1 kafka]# ./bin/kafka-console-producer.sh --broker-list master1:9092,slave1:9092,slave2:9092 --topic test
>2237966451
>yxt
>love
>
</pre>


### 十一、测试消费者（consumer），并截图并保存结果
***注：消费者将会自动打印生产者输入的内容***
```bash
./bin/kafka-console-consumer.sh --bootstrap-server master1:9092,slave1:9092,slave2:9092 --from-beginning --topic test
```
<pre>
[root@slave1 kafka]# ./bin/kafka-console-consumer.sh --bootstrap-server master1:9092,slave1:9092,slave2:9092 --from-beginning --topic test
2237966451
yxt
love
[root@slave2 kafka]# ./bin/kafka-console-consumer.sh --bootstrap-server master1:9092,slave1:9092,slave2:9092 --from-beginning --topic test
2237966451
yxt
love
</pre>
