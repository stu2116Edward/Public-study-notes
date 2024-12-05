## 实验一：HBase分布式部署

### Master节点
安装部署 hadoop ha 分布式环境  
解压安装文件
```bash
cd /opt/software/
```
```bash
tar -zxvf hbase-1.2.1-bin.tar.gz -C /usr/local/src/
```
```bash
cd
```
```bash
mv /usr/local/src/hbase-1.2.1 /usr/local/src/hbase
```

### Master、Slave1、Slave2节点
编辑/etc/profile文件
```bash
vim /etc/profile
```
将以下配置信息添加到/etc/profile 文件的末尾
```
export HBASE_HOME=/usr/local/src/hbase
export PATH=$PATH:$HBASE_HOME/bin
```
执行 source /etc/profile 命令，使配置的环境变量在系统全局范围生效
```bash
source /etc/profile
```

## 修改HBase配置文件

### Master 节点
conf 下文件修改
```bash
cd /usr/local/src/hbase/conf
```
```bash
vim hbase-env.sh
```
设置JAVA_HOME、HADOOP_HOME等环境变量
```
export JAVA_HOME=/usr/local/src/java
export HADOOP_HOME=/usr/local/src/hadoop
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HBASE_MANAGES_ZK=false
export HBASE_LOG_DIR=${HBASE_HOME}/logs
export HBASE_PID_DIR=${HBASE_HOME}/pid
```
修改配置文件 hbase-site.xml，添加相关信息
```bash
vim hbase-site.xml
```
配置HBase存储目录、ZK端口等参数
```xml
<property>
    <name>hbase.rootdir</name>
    <value>hdfs://master:8020/hbase</value>
</property>
<property>
    <name>hbase.master.info.port</name>
    <value>16010</value>
</property>
<property>
    <name>hbase.zookeeper.property.clientPort</name>
    <value>2181</value>
</property>
<property>
    <name>hbase.tmp.dir</name>
    <value>/usr/local/src/hbase/tmp</value>
</property>
<property>
    <name>zookeeper.session.timeout</name>
    <value>120000</value>
</property>
<property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
</property>
<property>
    <name>hbase.zookeeper.quorum</name>
    <value>master,slave1,slave2</value>
</property>
<property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>/usr/local/src/hbase/tmp/zookeeper-hbase</value>
</property>
```
修改 regionservers 文件，删除 localhost，添加以下内容
```bash
vim regionservers
```
```
slave1
slave2
```
将 core-site.xml 和 hdfs-site.xml 两个文件拷贝到 `$HBASE_HOME/conf/` 目录下
```bash
cp /usr/local/src/hadoop/etc/hadoop/core-site.xml /usr/local/src/hbase/conf/
```
```bash
cp /usr/local/src/hadoop/etc/hadoop/hdfs-site.xml /usr/local/src/hbase/conf/
```
将 master 节点配置好的 HBase 安装包分发给 slave1，slave2 节点
```bash
cd
```
```bash
scp -r /usr/local/src/hbase root@slave1:/usr/local/src
```
```bash
scp -r /usr/local/src/hbase root@slave2:/usr/local/src
```
### Master、Slave1、Slave2节点
修改目录所有者
```bash
chown -R hadoop:hadoop /usr/local/src/hbase
```
```bash
su - hadoop
```
```bash
source /etc/profile
```
### Master、Slave1、Slave2节点
HBase 集群启动  
在 master 主节点，使用 hadoop 用户切换到`/usr/local/src/hbase/bin` 目录下。使用`./start-hbase.sh` 命令启动
```bash
zkServer.sh start
```

### Master节点
```bash
start-all.sh
```
```bash
cd /usr/local/src/hbase/bin
```
```bash
./start-hbase.sh
```
用 webUI 查看集群，特别强调 `hbase2.0 的端口是 16010`

## 实验二 HBase 库操作与表操作
HBase 库操作  
HBase 集群启动(上一个实验已经启动)  
HBase 依赖 hdfs 服务，通过相互之间的依赖关系得到启动顺序为：Zookeeper > hadoop > HBase  
在所有节点上执行启动 Zookeeper  
### Master、Slave1、Slave2节点
```bash
./zkServer.sh start
```
### Master节点
Zookeeper 选举机制会自动选择 Leader 节点，在 master 节点启动 hadoop 服务
```bash
./start-all.sh
```
hadoop 从节点会自行启动。最后启动 HBase（master 节点）
```bash
./start-hbase.sh
```
```bash
jps
```

HBase 动态删除节点
```bash
cd /usr/local/src/hbase/bin
```
```bash
graceful_stop.sh slave2
```
在 hdfs-site.xml 中添加配置。需要新建 exclude 文件，该文件写入删除节点名称  
```bash
vim /usr/local/src/hadoop/etc/hadoop/exclude
```
添加如下内容
```
slave2
```
在 hdfs-site.xml 中添加配置
```bash
vim /usr/local/src/hadoop/etc/hadoop/hdfs-site.xml
```
```xml
<property>
    <name>dfs.hosts.exclude</name>
    <value>/usr/local/src/hadoop/etc/hadoop/exclude</value>
</property>
```
dfs.hosts.exclude:表示需要删除 exclude 中的节点  
刷新配置生效
```bash
cd
```
```bash
hadoop dfsadmin -refreshNodes
```
节点下线后需要将 slaves 与 exclude 文件中 slave2 删除，刷新 hadoop 命令，此时全部结束  

### Slave2节点
HBase 动态增加节点  
在新的节点上启动服务。切换到新增节点上，使用以下命令
```bash
cd /usr/local/src/hbase/bin
```
```bash
./hbase-daemon.sh start regionserver
```
### Master节点
HBase 表管理  
建立表，两个列簇：name 和 num 打开浏览器，输入 DataEngine 安装完成后提供的 URL，初始账号密码为 admin/admin  
进入 HBase 命令行
```bash
hbase shell
```
建立表 student，两个列簇：name 和 num  
hbase(main):001:0>
```bash
create 'student',{NAME=>'name'},{NAME=>'num'}
```
语法：`create <table>, {NAME => <family>, VERSIONS => <VERSIONS>}`  
查看所有表与详细信息  
hbase(main):002:0>
```bash
list
```
查看建表详细信息  
hbase(main):003:0>
```bash
describe 'student'
```
语法：`describe <table>`  
修改表  
hbase(main):004:0>
```bash
alter 'student' ,{NAME=>'tel'}
```
新增加新的列 tel，alter 也可以对列删除，对属性进行修改  
hbase(main):005:0>
```bash
alter 'student' ,{'NAME'=>'name',VERSIONS=>'2'}
```
hbase(main):006:0>
```bash
alter 'student',{NAME=>'tel',METHOD=>'delete'}
```
修改原 name 列的 VERSIONS 属性为 2。删除刚增加的 tel 列

删除表  
hbase(main):007:0>
```bash
disable 'student'
```
hbase(main):009:0>
```bash
drop 'student'
```
最后可查看数据库状态，包括正在运行的节点，死亡节点等信息  
hbase(main) :025 :0>
```bash
status
```

## HBase 数据操作
插入数据和修改  
建立表 student，两个列簇：name 和 num
```bash
create 'student',{NAME=>'name'},{NAME=>'num'}
```
```bash
list
```
插入两条数据：
```bash
put 'student','rk1','name','Tom'
```
```bash
put 'student','rk1','num','123456'
```
```bash
put 'student','rk2','name','Sun'
```
```bash
put 'student','rk2','num','123456'
```
```bash
put 'student','rk3','name:cha','wangyu'
```
读取指定行、指定行中的列的信息
```bash
get 'student','rk1'
```
```bash
get 'student','rk1','name'
```
scan 命令扫描全表  
语法：`scan <table>, {COLUMNS => [ <family:column>,.... ], LIMIT => num}`  
注：数据导入时，要注意数据的格式，否则显示为十六进制
```bash
scan 'student'
```
删除指定行中的列、指定行，清空表
```bash
delete 'student','rk2','name'
```
```bash
deleteall 'student','rk2'
```
```bash
truncate 'student'
```
语法：`delete <table>, <rowkey>, <family:column> , <timestamp>`,必须指定列名，这里需要注意，如果该列保存有多个版本的数据，将一并被删除  
使用 deleteall 命令，删除 table_name 表中 rowkey002 这行数据  
语法：`deleteall <table>, <rowkey>, <family:column> , <timestamp>`，可以不指定列名，删除整行数据  
使用 truncate 命令，删除 table_name 表中的所有数据  
语法：`truncate <table> 其具体过程是：disable table -> drop table -> create table`

模糊查询  
限制查询  
<pre>
hbase(main):003:0> put 'student','rk1','name','Tom'
hbase(main):004:0> put 'student','rk1','num','123456'
hbase(main):005:0> put 'student','rk2','name','Sun'
hbase(main):006:0> put 'student','rk2','num','123456'
hbase(main):007:0> put 'student','rk3','name:cha','wangyu'
hbase(main):014:0> scan 'student',{COLUMNS=>'name'}
hbase(main):002:0> scan 'student',{COLUMNS=>['name','num'],LIMIT=>2}
count 'student'
</pre>
语法：`scan <table> ,{COLUMNS=>' column '}`  
语法：`count <table>, {INTERVAL => intervalNum, CACHE => cacheNum}`  
限制时间范围  
```bash
scan 'student', {TIMERANGE => [1595397845355,1595397925166]}
```
时间戳是 1970 年 01 月 01 日 00 时 00 分 00 秒起至当下的总秒数。通常表示提供一份电子证据，以证明用户的某些数据的产生时间  

PrefixFilter:rowKey 前缀过滤
```bash
scan 'student',{FILTER=>"PrefixFilter('rk')"}
```
同时也有 QualifierFilter:列名过滤器、TimestampsFilter:时间戳过滤器等，支持“且”操作。ValueFilter:值确定查询（value=Tom）与模糊查询（value 包含 m）  
```bash
scan 'student',FILTER=>"ValueFilter(=,'binary:Tom')"
```
```bash
scan 'student',FILTER=>"ValueFilter(=,'substring:m')"
```

批量导入/导出  
ImportTsv 工具  
命令：`bin/hbase org.apache.hadoop.hbase.mapreduce.ImportTsv`  
Usage: `importtsv -Dimporttsv.columns=a,b,c <tablename> <inputdir>`  
首先数据存入到.csv 文件，上传至 hdfs 服务器中。hbase 调用 MapReduce 服务,当数据量较大时需等待  
```bash
hdfs dfs -put /opt/software/student.csv /input
```
```bash
hbase org.apache.hadoop.hbase.mapreduce.ImportTsv -Dimporttsv.separator="," -Dimporttsv columns=HBASE_ROW_KEY,name,num student /input/student.csv
```
Export 数据导出  
命令：`bin/hbase org.apache.hadoop.hbase.mapreduce.Export`  
Usage: `<tablename> <hdfsdir>`  
```bash
cd /usr/local/src/hbase/bin
```
```bash
hbase org.apache.hadoop.hbase.mapreduce.Export student /output/hbase-data-back
```
