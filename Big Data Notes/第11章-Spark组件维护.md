## 实验一：Scala的安装

### Master节点
解压 Scala 压缩文件并重命名
```bash
tar -zxvf /opt/software/scala-2.11.8.tgz -C /usr/local/src/
```
```bash
mv /usr/local/src/scala-2.11.8/ /usr/local/src/scala
```
分发 Scala 到子节点
```bash
scp -r /usr/local/src/scala/ root@slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/scala/ root@slave2:/usr/local/src/
```


### Master、Slave1、Slave2节点
修改 Scala 目录的用户权限
```bash
chown -R hadoop:hadoop /usr/local/src/scala
```
配置环境变量
```bash
vim /etc/profile
```
然后在键盘输入字母“i”或者“o”进入编辑模式添加以下内容:
```
export SCALA_HOME=/usr/local/src/scala
export PATH=$PATH:$SCALA_HOME/bin
```
然后在键盘按“Esc”键退出编辑模式，并键盘输入“:wq”进行内容保存并退出，最后将该“.bashrc”文件生效即可完成 scala 的环境配置  
```bash
su hadoop
```
```bash
source /etc/profile
```

验证 Scala 安装是否成功
### Master节点
```bash
cd /usr/local/scr/scala/bin
```
输入 scala 进入 scala shell 交互编程界面：
```bash
scala
```
然后退出 scala shell 的命令为:
```
quit
```

## 实验二：安装 Spark

### Master节点
```bash
su root
```
```bash
cd
```
```bash
tar -zxvf /opt/software/spark-2.0.0-bin-hadoop2.6.tgz -C /usr/local/src/
```
重命名 Spark 目录
```bash
mv /usr/local/src/spark-2.0.0-bin-hadoop2.6/ /usr/local/src/spark
```
修改 Spark 目录的用户权限
```bash
chown -R hadoop:hadoop /usr/local/src/spark
```
配置环境变量
```bash
vim /etc/profile
```
添加以下内容:
```
export SPARK_HOME=/usr/local/src/spark
export PATH=$PATH:$SPARK_HOME/bin:$PATH
```
```bash
su hadoop
```
```bash
source /etc/profile
```
修改 Spark 参数  
修改 spark-env.sh
```bash
cd /usr/local/src/spark/conf/
```
将已有的文件“spark-env.sh.template”复制出来并命名为 spark-evn.sh
```bash
cp /usr/local/src/spark/conf/spark-env.sh.template /usr/local/src/spark/conf/spark-env.sh
```
进入 spark 配置文件“spark-env.sh”，命令为：
```bash
vim /usr/local/src/spark/conf/spark-env.sh
```
然后将下面所示内容加入到文件“spark-env.sh”中：
```
export JAVA_HOME=/usr/local/src/java
export HADOOP_HOME=/usr/local/src/hadoop
export SCALA_HOME=/usr/local/src/scala
export SPARK_MASTER_IP=master
export SPARK_MASTER_PORT=7077
export SPARK_DIST_CLASSPATH=$(/usr/local/src/hadoop/bin/hadoop classpath)
export HADOOP_CONF_DIR=/usr/local/src/hadoop/etc/hadoop
export SPARK_YARN_USER_ENV="CLASSPATH=/usr/local/src/hadoop/etc/hadoop"
export YARN_CONF_DIR=/usr/local/src/hadoop/etc/hadoop
```
配置 slaves 文件
```bash
cp /usr/local/src/spark/conf/slaves.template /usr/local/src/spark/conf/slaves
```
vim编辑器进入 slaves 文件
```bash
vim slaves
```
修改为以下内容：
```
master
slave1
slave2
```
在两个 slaves 从节点上安装 Spark  
将 master 主节点上的 Spark 安装目录和.bashrc 环境变量复制到两个 slaves 从节点上
```bash
su root
```
```bash
scp -r /usr/local/src/spark/ root@slave1:/usr/local/src/
```
```bash
scp -r /usr/local/src/spark/ root@slave2:/usr/local/src/
```
```bash
scp /etc/profile root@slave1:/etc/
```
```bash
scp /etc/profile root@slave2:/etc/
```
### slave1、slave2 节点
在 slave1、slave2 节点上分别安装 Spark
```bash
chown -R hadoop:hadoop /usr/local/src/spark/
```
```bash
su hadoop
```
```bash
source /etc/profile
```

运行示例  
启动 Hadoop 集群  
在三个节点启动 zookeeper
### Master 节点
```bash
su hadoop
```
```bash
cd /usr/local/src/zookeeper/bin/
```
```bash
./zkServer.sh start
```
### slave1、slave2 节点
```bash
cd /usr/local/src/zookeeper/bin/
```
```bash
./zkServer.sh start
```
### Master 节点
在 master 节点启动 hadoop 集群
```bash
cd /usr/local/src/hadoop/sbin/
```
```bash
./start-all.sh
```
以集群模式运行 SparkPi 实例程序  
在 master 节点上启动 SparkPi 实例程序
```bash
cd /usr/local/src/spark/
```
```bash
./bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode client --driver-memory 512M --executor-memory 512M --executor-cores 1 examples/jars/spark-examples_2.11-2.0.0.jar 40
```
在运行结果中间可以找到我们需要的 pi 值，如下所示
<pre>
20/07/04 05:48:48 INFO scheduler.DAGScheduler: Job 0 finished: reduce at SparkPi.scala:38, 
took 3.866892 s
Pi is roughly 3.141053785263446
</pre>
在 master 节点上打开浏览器，访问`http://master:8088`显示 yarn 的信息
```
http://master:8088
```

## Spark shell 编程  
在 Yarn 集群管理器上运行 spark-shell  
首先启动集群：三个节点启动 zookeeper
### Master、slave1、slave2 节点
```bash
cd /usr/local/src/zookeeper/bin/
```
```bash
./zkServer.sh start
```
### Master节点
在 master 节点启动 hadoop 集群
```bash
cd /usr/local/src/hadoop/sbin/
```
```bash
./start-all.sh
```
再在 Yarn 集群管理器上启动 spark-shell
```bash
cd /usr/local/src/spark/bin/
```
```bash
./spark-shell --master yarn --deploy-mode client
```
在 spark-shell 上运行一个 WordCount 案例  
通过加载文件新建一个 RDD
```bash
cd /usr/local/src/spark
```
```bash
hadoop fs -put README.md /
```
通过加载 README.md 文件新建一个 RDD：
<pre>
scala> val textFile=sc.textFile("/README.md")
</pre>
对 RDD 进行 actions 和 transformations 操作  
下面我们就来演示 actions 动作操作中的 first()和 count()两个操作，如下所示
<pre>
下面我们就来演示 actions 动作操作中的 first()和 count()两个操作，如下所示
scala> textFile.first() #查看 textFile 中的第一条数据
scala> textFile.count() #统计 textFile 中的单词总数
接着演示 transformations 转换操作，运行代码如下所示：
scala> val 
wordcount=textFile.flatMap(line=>line.split(",")).map(word=>(word,1)).reduceByKey(_+_)
其中，reduceByKey(_+_)是 reduceByKey((x,y)=>x+y)的简化写法，同样是寻找相同
key 的数据，当找到这样的两条记录时会对其 value 求和，只是不指定将两个 value 存入 x
和 y 中，同样只保留求和之后的数据作为 value。反复执行这个操作直至每个 key 只留下
一条记录。以上四种方式等价。然后通过 collect 操作将远程数据通过网络传输到本地进行
词频统计：
scala> wordcount.collect()
collect()方法得到的结果是一个 list，然后可以通过 foreach()方法遍历 list 中的每一个
元组数据并返回其结果，如下所示：
scala> wordcount.collect().foreach(println)
注意：在 spark shell 交互式编程环境下，如果代码一行放不下，可以在圆点后回车，
在下一行继续输入
结束之后退出 spark-shell
scala>:q
</pre>
