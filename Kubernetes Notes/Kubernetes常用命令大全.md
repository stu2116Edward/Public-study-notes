# Kubernetes常用命令大全

### 基本命令
#### create
根据文件或标准输入（stdin）创建资源  
创建资源：
```bash
kubectl create -f ./nginx.yaml
```
创建当前目录下的所有yaml资源：
```bash
kubectl create -f .
```
使用多个文件创建资源：
```bash
kubectl create -f ./nginx1.yaml -f ./mysql2.yaml
```
使用目录下的所有清单文件来创建资源：
```bash
kubectl create -f ./dir
```
使用 url 来创建资源：
```bash
kubectl create -f xxx.git.io/example.yaml
```

#### run
在集群中运行特定镜像  
创建带有终端的pod：
```bash
kubectl run -i --tty busybox --image=busybox
```
启动一个 nginx 实例：
```bash
kubectl run nginx --image=nginx
```
启动多个pod实例：
```bash
kubectl run mybusybox --image=busybox --replicas=5
```

#### explain
获取资源的文档  
获取 `pod` 和 `svc` 的文档：
```bash
kubectl explain pods,svc
```

#### get
获取所有的`resources`，包括`node`、`pod`、`namespace`、`service`、`deployment`等，可以展示一个或者多个资源  
查看nodes节点：
```bash
kubectl get nodes
```
通过yaml文件查询资源：
```bash
kubectl get -f xxx.yaml
```
查询资源：
```bash
kubectl get resourcequota
```
查询endpoints：
```bash
kubectl get endpoints
```
查看pods  
查看指定空间kube-system的pods：
```bash
kubectl get po -n kube-system
```
查看所有空间的pods的详细信息：
```bash
kubectl get pods -o wide --all-namespaces
```
查看指定空间`kube-system`的pods的详细信息：
```bash
kubectl get pod -o wide --namespace=kube-system
```
获取指定namespace信息:
```bash
kubectl get namespaces
```
<pre>
# 获取指定namespace的yaml格式和json格式信息
kubectl get namespaces kube-system -o yaml 
kubectl get namespaces kube-system -o json
</pre>

获取service(svc)  
查看所有命令空间的service：
```bash
kubectl get svc --all-namespaces
```
查看所有命令空间的service的其他写法：
```bash
kubectl get services --all-namespaces
```
<pre>
# 通过 yaml 方式导出所有 service
kubectl get service -o yaml > backup.yaml

# 通过 yaml 方式导出单个 service
kubectl get service serviceName -o yaml > backup.yaml
</pre>

查询事件(Event)：
```bash
kubectl get events --all-namespaces
```

查看某个命名空间下的事件：
```bash
kubectl get events -n kube-system
```

查看某个命名空间下的事件，并根据关键字过滤：
```bash
kubectl get events -n kube-system | grep “name”
```

通过lable查询：
```bash
kubectl get pods -l app=nginx -o yaml|grep podIP
```
<pre>
# 查看所有pod对于指定标签的key是否有value，有则显示，没有则空白
kubectl get pods -L apps,run

# 获取含有指定标签key的pod
kubectl get pods -l apps --show-labels

# 获取含有指定标签key=value的pod
kubectl get pods -l release=stable --show-labels
</pre>

#### edit
在服务端编辑资源  
编辑名为 `docker-registry` 的 `service`：
```bash
kubectl edit svc/docker-registry
```

#### delete
根据文件、标准输入（stdin）、资源名或者资源标签删除资源  
删除 pod.json 文件中定义的类型和名称的pod：
```bash
kubectl delete -f ./pod.json
```
删除名为“baz”的 pod 和名为“foo”的 service：
```bash
kubectl delete pod,service baz foo
```
删除具有 name=myLabel 标签的 pod 和 serivce：
```bash
kubectl delete pods,services -l name=myLabel
```
删除具有 name=myLabel 标签的 pod 和 service，包括尚未初始化的：
```bash
kubectl delete pods,services -l name=myLabel --include-uninitialized
```
删除 my-ns 命名空间下的所有 pod 和 serivce，包括尚未初始化的：
```bash
kubectl -n my-ns delete po,svc --all
```
强制删除pod(如，prometheus-7fcfcb9f89-qkkf7)：
```bash
kubectl delete pods prometheus-7fcfcb9f89-qkkf7 --grace-period=0 --force
```

#### cp
容器内与宿主机之间进行文件拷贝
<pre>
# 拷贝容器内的文件或目录到本地
kubectl cp default/venus-registry-web-8cd94fc99-fws4b:demo.txt demo.txt
kubectl cp default/venus-registry-web-8cd94fc99-fws4b:/home/xxx /home/yyy

# 拷贝本地文件或目录到容器内
kubectl cp demo.txt default/venus-registry-web-8cd94fc99-fws4b:demo.txt
kubectl cp /home/yyy default/venus-registry-web-8cd94fc99-fws4b:/home/xxx
</pre>


### 部署命令
#### rollout
查看修订版本（revison）的历史记录：
```bash
kubectl rollout history deployment nginx-deployment
```
回退到指定的某个版本  
如果不加–to-revision=版本号，默认情况下，回退到上一个版本：
```bash
kubectl rollout undo deployment nginx-deployment --to-revision=1
```

#### scale
程序在负载加重或缩小时副本进行扩容或缩小  
扩展副本数到`4`:
```bash
kubectl scale rc rc-nginx-3 —replicas=4
```
重新缩减副本数到`2`：
```bash
kubectl scale rc rc-nginx-3 —replicas=2
```

#### autoscale
scale虽然能够很方便的对副本数进行扩展或缩小，但是仍然需要人工介入，不能实时自动的根据系统负载对副本数进行扩、缩容  

autoscale命令提供了自动根据pod负载对其副本进行扩缩的功能  

autoscale命令会给一个rc指定一个副本数的范围，在实际运行中根据pod中运行的程序的负载自动在指定的范围内对pod进行扩容或缩容  

如前面创建的nginx，可以用如下命令指定副本范围在`1~4`：
```bash
kubectl autoscale rc rc-nginx-3 —min=1 —max=4
```


### 集群管理命令
#### cluster-info
查看集群信息：
```bash
kubectl cluster-info
```
查看更详细的集群信息：
```bash
kubectl cluster-info dump
```

#### top
显示CPU、内存、存储资源的使用情况  
显示节点（k8s-node）资源的使用情况：
```bash
kubectl top node k8s-node
```
显示集群所有节点的资源的使用情况：
```bash
kubectl top node
```
显示指定命名空间（如，logging）的pod的资源的使用情况：
```bash
kubectl top pod -n logging
```

#### cordon
标记节点不可调度  
标记k8s-node节点不可调度：
```bash
kubectl cordon k8s-node
```

#### uncordon
标记节点可调度  
标记k8s-node节点可调度：
```bash
kubectl uncordon k8s-node
```

#### drain
排除某节点，准备进行维护  
排除k8s-node节点，准备进行维护：
```bash
kubectl drain k8s-node
```


### 故障排查和诊断命令
#### describe
显示特定资源或资源组的详细信息  
当我们发现一个pod迟迟无法创建时，展示一个pod的描述：
```bash
kubectl describe pod xxx
```
显示集群节点资源（CPU/GPU/内存）的使用情况：
```bash
kubectl describe nodes
```
显示集群具体某个节点（如，node-work-2）资源的使用情况：
```bash
kubectl describe node node-work-2
```

#### logs
打印Pod中一个容器的日志  
查看指定Pod的日志：
```bash
kubectl logs -f kube-dns-699984412-vz1q6 -n kube-system
```
查看指定pod的最后10行日志：
```bash
kubectl logs --tail=10 nginx
```
指定Pod的其中一个容器查看日志：
```bash
kubectl logs kube-dns-699984412-n5zkz -c kubedns --namespace=kube-system
```
查看指定Pod指定容器的最后10行的滚动日志：
```bash
kubectl logs -f --tail=10 kube-dns-699984412-vz1q6 -c manager -n kube-system
```

#### exec
exec命令同样类似于docker的exec命令，为在一个已经运行的容器中执行一条shell命令，如果一个pod容器中，有多个容器，需要使用-c选项指定容器  
进入容器：
```bash
kubectl exec -it codeleak-github-cron-1567581840-zsqpc /bin/bash
```
在指定命名空间(如，ns)已存在的容器中执行命令（只有一个容器的情况下）：
```bash
kubectl exec nginx-pod -n ns – ls /
```
在已存在的容器中执行命令（pod 中有多个容器的情况下，需要指定具体那个容器）：
```bash
kubectl exec nginx-pod -c my-container – ls /
```
***注意： shell命令前，要加--号，不然shell命令中的参数，不能识别***


### 高级命令
#### apply
按文件名或标准输入（stdin）将配置应用于资源  
更新资源：
```bash
kubectl apply -f rc-nginx.yaml
```
将控制台输入的JSON配置应用到Pod：
```bash
cat pod.json | kubectl apply -f -
```

### 设置命令
#### label
更新（增加、修改或删除）资源上的标签  

如果–overwrite 为 true，则可以覆盖已有的 label，否则尝试覆盖 label 将会报错  

如果指定了–resource-version，则更新将使用此资源版本，否则将使用现有的资源版本  

Label命名规范：  
label 必须以字母或数字开头，可以使用字母、数字、连字符、点和下划线，最长63个字符  

#### 操作节点标签：
```bash
# 查看所有节点和lable
kubectl get nodes --show-labels

# 为某个节点增加lable
kubectl label nodes 10.126.72.31 points=test

# 给节点node01添加disk标签
kubectl label nodes node01 disk=ssd      

# 修改节点node01的标签
kubectl label nodes node01 disk=sss –overwrite   

# 删除节点node01的disk标签
kubectl label nodes node01 disk-        
```

#### 操作pod标签：
```bash
# 给名为 tomcat 的 Pod 添加 label app=tomcat。
kubectl label pods tomca app=tomcat

# 把名为 tomcat 的Pod修改label 为 app=tomcat1，且覆盖现有的value
kubectl label --overwrite pods tomcat app=tomcat1

# 把 namespace 中的所有 pod 添加 label
kubectl label pods --all test=test

# 删除名为“app”的 label 。（使用“ - ”减号相连）
kubectl label pods tomcat app-
```

#### annotate
更新资源的Annotations信息  
更新pod(如，foo)，设置其注解'description'的值为'my frontend'  
```bash
kubectl annotate pods foo description='my frontend'
```
***注：如果同一个注解被赋值了多次，只保存最后一次设置的值***  


### 其他命令
#### version
查看客户端和服务端的版本信息  
```bash
kubectl version
```
#### api-versions
以“组/版本”的格式输出服务端支持的API版本：
```bash
kubectl api-versions
```
#### api-resources
输出服务端API支持的资源类型：
```bash
kubectl api-resources
```
