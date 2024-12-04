## 实验一：高可用集群启动

### Master节点
启动journalnode守护进程
```bash
hadoop-daemons.sh start journalnode
```
初始化namenode
```bash
hdfs namenode -format
```
注册ZNode
```bash
hdfs zkfc -formatZK
```
启动hdfs
```bash
start-dfs.sh
```
启动yarn
```bash
start-yarn.sh
```
同步master数据到其他节点
```bash
scp -r /usr/local/src/hadoop/tmp/hdfs/nn/* slave1:/usr/local/src/hadoop/tmp/hdfs/nn/
```
```bash
scp -r /usr/local/src/hadoop/tmp/hdfs/nn/* slave2:/usr/local/src/hadoop/tmp/hdfs/nn/
```
### Slave1节点
在slave1上启动resourcemanager和namenode进程
```bash
yarn-daemon.sh start resourcemanager
```
```bash
hadoop-daemon.sh start namenode
```
### Master节点
启动 MapReduce 任务历史服务器
```bash
yarn-daemon.sh start proxyserver
```
```bash
mr-jobhistory-daemon.sh start historyserver
```
### Master、Slave1、Slave2节点 
查看端口和进程
```bash
jps
```
查看 web 服务端
<pre>
master:50070
slave1:50070
master:8088
</pre>


## 实验二：HA的测试

### Master节点
创建一个测试文件
```bash
vim a.txt
```
内容如下：
```
Hello World
Hello Hadoop
```
在hdfs创建文件夹
```bash
hadoop fs -mkdir /input
```
将a.txt传输到input上
```bash
hadoop fs -put ~/a.txt /input
```
进入到jar包测试文件目录下
```bash
cd /usr/local/src/hadoop/share/hadoop/mapreduce/
```
测试mapreduce
```bash
hadoop jar hadoop-mapreduce-examples-2.7.1.jar wordcount /input/a.txt /output
```
查看hdfs下的传输结果
```bash
hadoop fs -lsr /output
```
查看文件测试的结果
```bash
hadoop fs -cat /output/part-r-00000
```

## 实验三：高可用性验证

### Master节点
自动切换服务状态
```bash
cd
```
```bash
hdfs haadmin -failover --forcefence --forceactive slave1 master
```
```bash
hdfs haadmin -getServiceState slave1
```
```bash
hdfs haadmin -getServiceState master
```
手动切换服务状态  
在 maste 停止并启动 namenode
```bash
hadoop-daemon.sh stop namenode
```
```bash
hdfs haadmin -getServiceState master
```
```bash
hdfs haadmin -getServiceState slave1
```
```bash
hadoop-daemon.sh start namenode
```
```bash
hdfs haadmin -getServiceState slave1
```
```bash
hdfs haadmin -getServiceState master
```
查看 web 服务端
<pre>
master:50070
slave1:50070
</pre>