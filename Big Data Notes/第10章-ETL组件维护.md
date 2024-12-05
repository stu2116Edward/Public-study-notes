## 实验一：SQOOP数据导入导出

### Master节点
mysql表中的数据导入到hdfs  
本实验需要进入 mysql，mysql 的密码是:`Password123$`  
进入 mysql shell
```bash
mysql -u root -p
```
创建数据库mysql_hdfs  
使用 create database 命令创建数据库  
```bash
create database mysql_hdfs;
```
使用 show databases 查看数据库是否存在
```bash
show databases;
```
在mysql_hdfs上创建表users  
将默认的数据库指定为 mysql_hdfs
```bash
use mysql_hdfs;
```
创建 users 表指定 id,name,age,sex 字段的类型
```bash
create table users(id varchar(11), name varchar(11), age int, sex varchar(11));
```
在users表中插入数据  
使用 insert into 命令插入数据，每次插入一条数据
```bash
insert into users value('0001', 'jbw', 23, 'man');
```
```bash
insert into users value('0010', 'jbw4', 23, 'man');
```
查看表中数据是否存在
```bash
select * from users;
```
退出mysql
```bash
exit;
```
查看Sqoop版本
```bash
sqoop version
```
启动hadoop，查看进程  
使用 start-all.sh 启动 hadoop 进程
```bash
start-all.sh
```
将mysql中的数据导入到hdfs
```bash
sqoop import --connect jdbc:mysql://master:3306/mysql_hdfs -username root -password Password123$ --table users --columns id,name,age,sex -m 1 --target-dir '/sqoop/users'
```
查看sqoop数据是否导入成功
```bash
hdfs dfs -cat /sqoop/users/*
```


hdfs上的数据导出到mysql表中  
本实验需要进入 mysql，mysql 的密码是:Password123$  
进入 mysql shell  
```bash
mysql -u root -p
```
在mysql_hdfs上创建表：users2  
将默认的数据库指定为 mysql_hdfs
```bash
use mysql_hdfs;
```
创建 users2 表指定 id,name,age,sex 字段的类型
```bash
create table users2(id varchar(11), name varchar(11), age int, sex varchar(11));
```
查看hdfs中数据(在终端内执行不是mysql)
```bash
hdfs dfs -cat /sqoop/users/*
```
导出数据
```bash
sqoop export --connect jdbc:mysql://master:3306/mysql_hdfs --username root --password Password123$ --table users2 --export-dir /sqoop/users/part-m-00000 --input-fields-terminated-by ','
```
查看数据库表中数据
```bash
use mysql_hdfs;
```
```bash
select * from users2;
```

## 实验二：Flume组件常用代理配置

### Master节点
启动hadoop集群
```bash
start-all.sh
```
创建agent代理文件  
```bash
vim /usr/local/src/flume/conf/hdfs_sink.conf
```
添加如下内容
```
#指定 sources 的别名
a1.sources = r1
#指定 sinks 的别名
a1.sinks = k1
#指定 channels 的别名
a1.channels = c1
# Describe/configure the source
#指定 sources 的类型
a1.sources.r1.type = syslogtcp
#指定 sources 的端口
a1.sources.r1.port = 5140
#指定 sources 的主机名
a1.sources.r1.host = localhost
# Describe the sink
#指定 sinks 的类型
a1.sinks.k1.type = hdfs
#指定 sinks 的 hdfs 的路径
a1.sinks.k1.hdfs.path = hdfs://master:8020/user/flume/syslogtcp
#指定 sinks 的 hdfs 的文件名前缀
a1.sinks.k1.hdfs.filePrefix = Syslog
#指定时间戳需要四舍五入
a1.sinks.k1.hdfs.round = true
#四舍五入到小于当前时间的最高倍数
a1.sinks.k1.hdfs.roundValue = 10
# 使用本地时间戳
a1.sinks.k1.hdfs.useLocalTimeStamp=true
#四舍五入值的单位，秒、分钟或小时
a1.sinks.k1.hdfs.roundUnit = minute
# Use a channel which buffers events in memory
#指定 channels 的类型
a1.channels.c1.type = memory
# Bind the source and sink to the channel
#将 sources 和 channels 连接
a1.sources.r1.channels = c1
#将 sinks 和 channels 连接
a1.sinks.k1.channel = c1
```

启动flume进程
```bash
/usr/local/src/flume/bin/flume-ng agent -c /usr/local/src/flume/conf/ -f /usr/local/src/flume/conf/hdfs_sink.conf -n a1 -Dflume.root.logger=DEBUG,console
```
向监听端口发送信息
```bash
telnet localhost 5140
```
编辑任意测试内容回车发送，agent 终端的日志显示成功获取数据并创建 hdfs 文件记录  

在 hdfs 中查看获取数据信息
```bash
hdfs dfs -ls /user/flume/syslogtcp
```

## 实验三：Kafka组件部署

### Master节点
将kafka的tar.gz安装包解压  
将/opt/software/目录下 kafka1.0.0.tgz 的安装包解压到/usr/local/src/.
```bash
cd /usr/local/src
```
```bash
tar -zxvf /opt/software/kafka1.0.0.tgz -C /usr/local/src/
```
将解压好的kafka文件重命名
```bash
mv kafka_2.11-1.0.0/ kafka
```
修改 server.properties
```bash
vim /usr/local/src/kafka/config/server.properties
```
在 server.properties 文件下找到下列配置项，并修改为：
```
broker.id=0
zookeeper.connect=master,slave1,slave2
```
使用 scp 命令把 kafka 发送到各个节点
```bash
scp -r /usr/local/src/kafka/ root@slave1:/usr/local/src/kafka/
```
```bash
scp -r /usr/local/src/kafka/ root@slave2:/usr/local/src/kafka/
```

### Master、Slave1、Slave2节点
```bash
chown -R hadoop:hadoop /usr/local/src/kafka
```
### Slave1、Slave2节点
修改各个节点中的 server.properties  
进入 hadoop 用户,打开文件/usr/local/src/kafka/config/server.properties
```bash
su hadoop
```
```bash
vim /usr/local/src/kafka/config/server.properties
```
在 server.properties 文件下找到 broker.id `分别`修改为  
Slave1：
```
broker.id=1
```
Slave2:
```
broker.id=2
```


### Master、Slave1、Slave2节点
启动ZOOKEEPER集群
```bash
cd
```
```bash
zkServer.sh start
```

在各个节点启动kafka服务
```bash
/usr/local/src/kafka/bin/kafka-server-start.sh /usr/local/src/kafka/config/server.properties
```

Kafka 组件验证部署  
### Master节点
创建一个名为 hello 的 topic  
在 master 打开一个新终端
```bash
/usr/local/src/kafka/bin/kafka-topics.sh --create --zookeeper master:2181,slave1:2181,slave2:2181 --replication-factor 2 --topic hello --partitions 1
```
查看 topic 是否创建成功
```bash
/usr/local/src/kafka/bin/kafka-topics.sh --list --zookeeper master:2181,slave1:2181,slave2:2181
```
在 master 节点中创建一个生产者  
使用 kafka-console-producer.sh 脚本来创建生产者
```bash
/usr/local/src/kafka/bin/kafka-console-producer.sh --broker-list master:9092,slave1:9092,slave2:9092 --topic hello
```
`执行后终端不要关闭`  

### Slave1节点
在 slave1 节点中创建一个消费者
```bash
/usr/local/src/kafka/bin/kafka-console-consumer.sh --zookeeper master:2181,slave1:2181,slave2:2181 --topic hello --from-beginning
```
`执行后终端不要关闭`  
在创建的生产者中输入信息  
在创建的生产者的终端中输出信息  
<pre>
>hello kafka
</pre>
在创建的消费者中查看信息
接受成功，则 kafka 组件验证成功
在创建消费者的终端中可以看到以下输出信息
<pre>
Using the ConsoleConsumer with old consumer is deprecated and will be removed in a future 
major release. Consider using the new consumer by passing [bootstrap-server] instead of 
[zookeeper].
hello kafka
</pre>


## 实验四 Kafka与 Flume组合完成数据收集
### Master节点
Flume 和 Kafka 组件整合配置  
在/usr/local/src/flume/conf /目录下创建 syslog_mem_kafka.conf 文件
```bash
vim /usr/local/src/flume/conf/syslog_mem_kafka.conf
```
配置 syslog_mem_kafka.conf 文件  
添加如下内容：
```
#指定 source 的别名为 src
agent1.sources = src
#指定 channels 的别名为 ch1
agent1.channels = ch1
#指定 sinks 的别名为 des1
agent1.sinks = des1
# Describe/configure the source
#指定 sources 的类型
agent1.sources.src.type =syslogtcp
#指定 sources 的端口
agent1.sources.src.port = 6868
#指定 sources 的主机名
agent1.sources.src.host = master
# Use a channel which buffers events in memory
#指定 channels 的类型
agent1.channels.ch1.type = memory
# Describe the sink
#指定 sinks 的类型
agent1.sinks.des1.type = org.apache.flume.sink.kafka.KafkaSink
#指定 kafka 中多个服务器名称
agent1.sinks.des1.brokerList = master:9092,slave1:9092,slave2:9092
#指定 kafka 中 topic 名称
agent1.sinks.des1.topic = flumekafka
#将 sources 和 channels 连接
agent1.sources.src.channels = ch1
#将 sinks 和 channels 连接
agent1.sinks.des1.channel = ch1
```

创建名为 flumekafka 的 topic
```bash
/usr/local/src/kafka/bin/kafka-topics.sh --create --zookeeper master:2181,slave1:2181,slave2:2181 --replication-factor 2 --topic flumekafka --partitions 1
```
启动 flume 进程
```
/usr/local/src/flume/bin/flume-ng agent -c /usr/local/src/flume/conf/ -f /usr/local/src/flume/conf/syslog_mem_kafka.conf -n agent1 -Dflume.root.logger=DEBUG,console
```
`运行后不要关闭终端`

### Slave1节点
在 slave1 中创建消费者
```bash
/usr/local/src/kafka/bin/kafka-console-consumer.sh --zookeeper master:2181,slave1:2181,slave2:2181 --topic flumekafka --from-beginning
```
`运行后不要关闭终端`  
使用 nc 命令 向 master：6868 发送信息  
如果连接成功，这时候客户端输入文本信息回车就可以发送到服务端，一旦有人连接，第二个会话就连接不上  
`打开新的 master 终端`
```bash
nc master 6868
```
查看 slave1 中的消费者  
在前面 slave1 创建消费者的终端中可以看到输出信息
<pre>
Using the ConsoleConsumer with old consumer is deprecated and will be removed in a future 
major release. Consider using the new consumer by passing [bootstrap-server] instead of 
[zookeeper].
hello flumekafka
</pre>