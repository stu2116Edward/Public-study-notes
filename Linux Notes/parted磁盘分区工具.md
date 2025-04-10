# parted磁盘分区工具
内容转自：https://blog.csdn.net/u013007181/article/details/138039114  

parted命令是由GNU组织开发的一款功能强大的磁盘分区和分区大小调整工具，与fdisk命令不同，它能够调整分区的大小，并且它可以处理最常见的分区格式，包括：ext2、ext3、fat16、fat32、NTFS、ReiserFS、JFS、XFS、UFS、HFS以及Linux交换分区等。

需要特别注意的是parted的操作是即刻生效的，所以操作前要认真想好  

### parted命令格式
<pre>
用法格式：parted  [选项]  [设备]  [指令]
</pre>
parted命令有交互式模式和非交互式模式两种运行模式， 如果没有给出“指令”，则以交互模式运行  
常用选项如下表所示：  
| 选项 | 作用 |
| :---: | :---: |
| -h | 显示帮助信息 |
| -l | 显示分区表信息 |
| -m | 显示机器可读的分区表信息 |
| -s | 不提示用户 |
| -v | 显示版本信息 |

在指令中，常用的子命令如下：
| 子命令         | 含义                                                                 |
|----------------|----------------------------------------------------------------------|
| align-check    | 检查分区N是否为(最小=min|最佳=opt)对齐类型                           |
| help           | 打印帮助信息，或关于某个命令的帮助信息                               |
| mklabel/mktable| 创建新的磁盘标签(分区表)                                             |
| mkpart         | 创建一个分区                                                         |
| name           | 给指定的分区命名                                                     |
| print          | 打印分区表，或者分区                                                 |
| quit           | 退出程序                                                             |
| rescue         | 修复丢失的分区                                                       |
| resizepart     | 调整分区大小                                                         |
| rm             | 删除分区                                                             |
| select         | 选择要编辑的设备                                                     |
| set            | 更改分区的旗标                                                       |
| toggle         | 设置或取消分区的旗标                                                 |
| unit           | 设置默认的单位                                                       |
| version        | 显示版本信息                                                         |

### parted交互模式分区管理

#### 1、parted交互模式分区管理
与fdisk类似，parted可以使用命令【parted 设备名】进入交互模式。进入交互模式后，可以通过上表中的各种子命令对磁盘分区进行管理  

以下以两个新磁盘`/dev/sdb`和`/dev/sdc`为操作对象  
1. 创建分区表  
mklabel或者mktable子命令用于创建或更改磁盘标签（分区表类型）。以下以mktable子命令为例进行介绍  
语法格式：  
```bash
mklabel LABEL-TYPE
```
利用【help mklabel】命令可以查看到LABEL-TYPE 支持的类型，其中最常用的就是gpt和msdos（也就是MBR）  

mklabel命令通常不会破坏磁盘数据，`但有可能让数据变得不可读`。这是就需要用到`rescue子命令来恢复分区`，详见后面的rescue子命令  

用法示例1：创建MBR磁盘分区表, 以新磁盘`/dev/sdb`为例  
<pre>
[root@node1 ~]# parted /dev/sdb        #对磁盘/dev/sdb进行分区
GNU Parted 3.5
使用 /dev/sdb
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted)       #此处可连续按两次Tab键查看可用的命令                                                               
对齐检查     disk_set     help         mkpart       name         quit         resize       rm           set          unit         
align-check  disk_toggle  mklabel      mktable      print        rescue       resizepart   select       toggle       version
(parted) help mklabel       #查看mklable命令的用法及支持的分区表类型                                                  
  mklabel,mktable LABEL-TYPE               创建新的磁盘卷标 (分区表)
 
	“卷标类型”是以下任意一项：aix, amiga, bsd, dvh, gpt_sync_mbr, gpt, mac, msdos, pc98, sun, atari, loop
(parted) mklabel msdos    #创建msdos分区表,或更改分区表类型 
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos    #分区表类型为msdos
磁盘标志：
 
编号  起始点  结束点  大小    类型      文件系统  标志
</pre>

用法示例2：创建GPT磁盘分区表，以新磁盘`/dev/sdc`为例  
<pre>
[root@node1 ~]# parted /dev/sdc        #对磁盘/dev/sdc进行分区
GNU Parted 3.5
使用 /dev/sdc
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) mklabel gpt      #创建gpt分区表 
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt    #分区表类型为gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志                                               
</pre>

#### 2、创建磁盘分区
利用mklabel子命令创建新的分区标签并没有创建任何分区，还需要使用mkpart子命令创建新的分区  
语法格式：
```bash
mkpart 分区类型 [文件系统类型] 起始点 结束点
```
利用`help mkpart`命令可以查看到支持的分区类型和支持的文件系统类型  
其中：分区类型包括primary（主分区）、logical（逻辑分区）和extended（扩展分区）三种。扩展分区和逻辑分区只对msdos和dvh分区表有效  
文件系统包括ext2、ext3、ext4、xfs、fat32和ntfs等数十种类型  
起始点和结束点分别指定分区的开始和结束位置，比如2048s、0%或者2GB等值，负值表示磁盘的末尾数起。例如，-1s 表示最后一个扇区。通常第一个分区的起始点为0%或者2048s，第二分区的起始点为第一个分区的结束点。结束点与起始点的差就是该磁盘分区的大小  

**创建MBR分区**  
MBR分区表中有主分区、扩展分区和逻辑分区之分。主分区和扩展分区的编号为1-4，逻辑分区的编号从5开始编号  
- 创建MBR主分区示例  
<pre>
[root@node1 ~]# parted /dev/sdb        #对磁盘/dev/sdb进行分区
GNU Parted 3.5
使用 /dev/sdb
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) print            #查看分区信息                                               
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos        #分区表类型为msdos
磁盘标志：
 
编号  起始点  结束点  大小  类型  文件系统  标志
 
(parted) mkpart      #新建分区                                                         
分区类型？  primary/主分区/extended/扩展? primary    #选择分区类型                     
文件系统类型？  [ext2]? ext4      #指定文件系统类型                                        
起始点？ 2048s        #指定分区起始位置                                                        
结束点？ 2GB          #指定分区结束位置                                                    
(parted) print       #查看分区信息                                                     
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：
 
编号  起始点  结束点  大小    类型     文件系统  标志
 1    1049kB  2000MB  1999MB  primary  ext4      lba
</pre>

- 创建MBR扩展分区和逻辑分区示例
**要建立逻辑分区必须先建立扩展分区，逻辑分区是在扩展分区中创建的**  
<pre>
[root@node1 ~]# parted /dev/sdb                                           
GNU Parted 3.5
使用 /dev/sdb
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) mkpart                                                           
分区类型？  primary/主分区/extended/扩展? extended       #创建扩展分区                 
起始点？ 2GB         #指定起始位置                                                     
结束点？ 100%        #100%表示剩余空间全部用作扩展分区                                                         
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：
 
编号  起始点  结束点  大小    类型      文件系统  标志
 1    1049kB  2000MB  1999MB  primary
 2    2000MB  10.7GB  8738MB  extended            lba
 
(parted) mkpart                                                        
分区类型？  primary/主分区/logical/逻辑? logical      #创建逻辑分区                    
文件系统类型？  [ext2]? xfs                                               
起始点？ 2GB                                                              
结束点？ 4GB                                                              
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：
 
编号  起始点  结束点  大小    类型      文件系统  标志
 1    1049kB  2000MB  1999MB  primary
 2    2000MB  10.7GB  8738MB  extended            lba
 5    2001MB  4000MB  2000MB  logical   xfs       lba
</pre>

**创建GPT分区**  
GPT分区表下的所有分区都是主分区，分区编号从1开始顺序编号，创建GPT分区示例如下：  
<pre>
[root@node1 ~]# parted /dev/sdc        #对磁盘/dev/sdc进行分区
GNU Parted 3.5
使用 /dev/sdc
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt    #分区表类型为gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志   #此处可以看到还没有分区  
 
(parted) mkpart           #创建分区                                                           
分区名称？  []? pdata      #指定分区名称
文件系统类型？  [ext2]? ext4     #指定分区文件系统类型                                         
起始点？ 0%                     #指定起始位置，0%表示从最磁盘最前面开始，与2048s是同一个起点                                          
结束点？ 2GB                                                              
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB            
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  2000MB  1999MB  ext4      pdata
</pre>

**设置默认的单位**  
从前面的示例中可以看到，系统默认使用的单位是MB来显示磁盘分区容量，使用unit子命令可以指定默认单位  
语法格式：
```bash
unit 单位
```
利用【help unit】子命令，或者在unit子命令后连续两次Tab键，可以查看支持的单位，主要单位及其简要介绍如下：  
- s：扇区(n个字节，取决于扇区大小，通常为512字节)
- B：字节
- KiB：千字节(1024字节)
- MiB：兆字节(1048576字节)
- GiB：gibibyte(1073741824字节)
- TiB：tebibyte(1099511627776字节)
- kB：千字节(1000字节)
- MB：兆字节(1000000字节)
- GB:千兆字节(1000000000字节)
- TB：兆字节(1000000000000字节)
- %：设备的百分比(0到100之间)
- cyI：柱面(与BIOS CHS几何相关)
- chs：柱面，磁头，扇区寻址(与BIOS CHS几何相关)
- compact：这是一个特殊的单位，默认输入为兆字节，并且选择一个单位，以紧凑的可读格式表示输出

用法示例：
<pre>
(parted) print     #查看当前分区单位                                                       
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB        #此处显示单位为GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1.05MB  2000MB  1999MB  ext4      pdata        #分区大小单位为MB
 
(parted) unit                                                             
单位？  [MB]?     #连按两次Tab键可以查看支持的单位
%        B        chs      compact  cyl      GB       GiB      kB       kiB      MB       MiB      s        TB       TiB      
单位？  [MB]? GiB     #指定单位为GiB
(parted) print        #查看分区信息                                                    
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.0GiB    #单位变成GiB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点   结束点   大小     文件系统  名称   标志
 1    0.00GiB  1.86GiB  1.86GiB  ext4      pdata        #此处的显示单位也为GiB
</pre>

#### 3、命名分区名称
可以利用name子命令命名或更改分区名称，但只支持GPT, Mac, MIPS 和PC98 格式的分区  
语法格式：
```bash
name 分区编号 分区名称 
```
示例如下：
<pre>
[root@node1 ~]# parted /dev/sdc
GNU Parted 3.5
使用 /dev/sdc
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  2000MB  1999MB            pdata        #更改前，分区名称为pdata
 
(parted) name         #命名分区                                                    
分区编号？ 1           #指定要命名的分区编号                                                   
分区名称？  [pdata]? data   #设置分区新的名称                                         
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  2000MB  1999MB  ext4      data        #更改后，分区名称为data
</pre>

#### 4、设置分区旗标
利用set子命令可以设置分区的旗标（flag）及其状态  
语法格式：
```bash
set 分区编号 旗标 状态
```
利用【help set】子命令可以查看set子命令的用法和支持的旗标类型  
旗标的状态有两种：on（生效）和off（失效）  
常见的旗标类型及其简介如下：  
- boot：设置该旗标类型的状态为on表示从该分区引导系统。
- lba：用于MS-DOS分区表，该旗标告诉系统使用LBA（Logic Block Addressing）模式。
- swap：如果某分区是Linux系统的交换分区，那么就要对该分区启用这个标记。
- hidden：启用这个标记能使一个分区‘隐藏’起来。 
- raid：启用这个标记能够告诉Linux系统这是一个软RAID磁盘阵列。 
- LVM：启用这个标记能够告诉Linux系统这是一个LVM逻辑卷。

用法示例：
<pre>
[root@node1 ~]# parted /dev/sdc
GNU Parted 3.5
使用 /dev/sdc
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志
 1    1049kB  2000MB  1999MB            data        #此处可看到标志(flag)为空
 
(parted) set        #设置旗标                                                      
分区编号？ 1         #选择分区编号                                                         
要反转的标志？       #此处按两次Tab键可查看支持的旗标类型                                                     
交换             隐藏             bios_grub        chromeos_kernel  hidden           irst             lvm              prep             
旧版启动         诊断             bls_boot         diag             hp-服务          legacy_boot      msftdata         raid             
启动             atvrecv          boot             esp              hp-service       linux-home       msftres          swap             
要反转的标志？ lvm        #输入要设置的旗标类型
新状态？  [开]/on/关/off? on       #设置旗标的状态                                       
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志
 1    1049kB  2000MB  1999MB            data  lvm        #此处可看到旗标为lvm
</pre>

#### 5、切换分区旗标状态
利用toggle子命令可以切换分区旗标的状态  
语法格式：
<pre>
toggle 分区编号 旗标
</pre>
用法示例：
<pre>
[root@node1 ~]# parted /dev/sdc                                           
GNU Parted 3.5
使用 /dev/sdc
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志
 1    1049kB  2000MB  1999MB            data  lvm    #此处可看到旗标为lvm及其状态为on
 
(parted) toggle        #切换旗标状态                                                   
分区编号？ 1            #指定分区编号                                                  
要反转的标志？          #按两次Tab键可查看旗标的类型                                                  
交换             隐藏             bios_grub        chromeos_kernel  hidden           irst             lvm              prep             
旧版启动         诊断             bls_boot         diag             hp-服务          legacy_boot      msftdata         raid             
启动             atvrecv          boot             esp              hp-service       linux-home       msftres          swap             
要反转的标志？ lvm    #指定要切换状态的旗标
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志
 1    1049kB  2000MB  1999MB            data        #此处可看到旗标状态为off
</pre>

#### 6、调整分区大小
利用resizepart子命令可以调整分区的大小。但尽量不要对分区大小进行缩减，缩减磁盘分区大小可能会丢失数据，若确要调整建议要先备份好数据  
语法格式：
```bash
resizepart 磁盘分区编号 结束点
```
用法示例：
<pre>
[root@node1 ~]# parted /dev/sdb
GNU Parted 3.5
使用 /dev/sdb
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：
 
编号  起始点  结束点  大小    类型      文件系统  标志
 1    1049kB  2000MB  1999MB  primary
 2    2000MB  10.7GB  8738MB  extended            lba
 5    2001MB  4000MB  2000MB  logical             #此处可看到该分区的结束点在4GB，磁盘分区大小为2GB
 
(parted) resizepart        #调整磁盘分区                                               
分区编号？ 5               #指定要调整的分区编号                                               
结束点？  [4000MB]? 5GB    #将磁盘分区结束点位置调整到5GB（扩大1GB）                                               
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：
 
编号  起始点  结束点  大小    类型      文件系统  标志
 1    1049kB  2000MB  1999MB  primary
 2    2000MB  10.7GB  8738MB  extended            lba
 5    2001MB  5000MB  2999MB  logical             #可看到磁盘分区大小变为3GB
</pre>

#### 7、删除磁盘分区
利用rm子命令可以删除指定的磁盘分区  
语法格式：
```bash
rm 磁盘分区编号
```
用法示例：
<pre>
[root@node1 ~]# parted /dev/sdc
GNU Parted 3.5
使用 /dev/sdc
欢迎使用 GNU Parted！输入 'help' 来查看命令列表。
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志
 1    1049kB  2000MB  1999MB            data        #有一个分区
 
(parted) rm     #删除磁盘分区                                                         
分区编号？ 1     #指定要删除的磁盘分区编号
警告: 分区 /dev/sdc1 正被使用。你确定要继续吗?
是/Yes/否/No? yes  
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小  文件系统  名称  标志   #成功删除分区
</pre>

#### 8、rescue恢复磁盘分区
若用parted的rm子命令误删除了一个分区，就可以使用rescue子命令恢复误删除的磁盘分区  
语法格式：
```bash
rescue 起始点 结束点
```
用法示例：上一个示例中已经删除了磁盘分区，现在通过rescue子命令将其恢复
<pre>
(parted) rescue     #恢复磁盘分区
起始点？ 0%          #指定起始点                                                     
结束点？ 2GB         #指定结束点                                                     
正在搜索文件系统... 1%  (剩余时间 01:17)信息: 在 1049kB -> 2000MB 处找到一个 ext4 primary 分区。您希望将其添加到分区表中吗？
是/Yes/否/No/放弃/Cancel? Yes                                             
(parted) print                                                            
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志
 1    1049kB  2000MB  1999MB  ext4
</pre>
***注：经测试，未格式化的磁盘分区被删除后不能成功恢复***  

### 非交互式parted分区管理
非交互模式就是把要操作的命令完整地写出来，对parted命令比较熟悉后就可以采用这种模式  

#### 1、查看磁盘分区
语法格式：
```bash
parted 磁盘名称 print
```
用法示例：
<pre>
[root@node1 ~]# parted /dev/sdb print
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdb：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：msdos
磁盘标志：
 
编号  起始点  结束点  大小    类型      文件系统  标志
 1    1049kB  2000MB  1999MB  primary
 2    2000MB  10.7GB  8738MB  extended            lba
 5    2001MB  5000MB  2999MB  logical
</pre>

#### 2、创建GPT分区表
语法格式：
```bash
parted 磁盘名称 mklabel 分区表类型
```
用法示例：
<pre>
[root@node1 ~]# parted /dev/sdc mklabel gpt
警告: 现有 /dev/sdc 上的磁盘卷标将被销毁，而所有在这个磁盘上的数据将会丢失。您要继续吗？
是/Yes/否/No? yes                                                         
信息: 你可能需要 /etc/fstab。
</pre>

#### 3、创建磁盘分区
语法格式： 
```bash
parted 磁盘名称 mkpart 磁盘分区名称 起始点 结束点
```
用法示例：
<pre>
[root@node1 ~]# parted /dev/sdc mkpart data1 0% 2GB
信息: 你可能需要 /etc/fstab。
[root@node1 ~]# parted /dev/sdc print
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  2000MB  1999MB  ext4      data1
</pre>

#### 4、更改显示单位
语法格式： 
```bash
parted 磁盘名称 unit 单位 print
```
用法示例：从上面的例子中可以看到显示单位为compact，以下命令更改为用GiB显示  
<pre>
[root@node1 ~]# parted /dev/sdc unit GiB print
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.0GiB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点   结束点   大小     文件系统  名称   标志
 1    0.00GiB  1.86GiB  1.86GiB  ext4      data1
</pre>

#### 5、命名分区名称
语法格式： 
```bash
parted 磁盘名称 name 分区编号 分区名称 
```
用法示例：在上面的例子中可以看到分区1的名称为data1， 以下命令将其更改为data2  
<pre>
[root@node1 ~]# parted /dev/sdc name 1 data2
[root@node1 ~]# parted /dev/sdc print
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  2000MB  1999MB  ext4      data2
</pre>

#### 6、设置分区旗标
语法格式： 
```bash
parted 磁盘名称 set 分区编号 旗标类型 旗标状态
```
用法示例：在上面的例子中可以看到标志为空，且为off状态  
<pre>
[root@node1 ~]# parted /dev/sdc set 1 lvm on
信息: 你可能需要 /etc/fstab。
 
[root@node1 ~]# parted /dev/sdc print
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  2000MB  1999MB  ext4      data2  lvm
</pre>

#### 7、切换分区旗标状态
语法格式： 
```bash
parted 磁盘名称 toggle 分区编号 旗标类型
```
用法示例：在上面的例子中，分区1的lvm旗标是on状态，以下命令将其切换为off状态  
<pre>
[root@node1 ~]# parted /dev/sdc toggle 1 lvm
信息: 你可能需要 /etc/fstab。
 
[root@node1 ~]# parted /dev/sdc print                              
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  2000MB  1999MB  ext4      data2
</pre>

#### 8、调整分区大小
语法格式： 
```bash
parted 磁盘名称 resizepart 分区编号 结束点
```
用法示例：在上面的例子中可以看到分区1的大小为2GB，以下命令将其调整到3GB  
<pre>
[root@node1 ~]# parted /dev/sdc resizepart 1 3GB
信息: 你可能需要 /etc/fstab。
 
[root@node1 ~]# parted /dev/sdc print
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称   标志
 1    1049kB  3000MB  2999MB  ext4      data2
</pre>

#### 9、删除磁盘分区
语法格式： 
```bash
parted 磁盘名称 rm 分区编号
```
用法示例：在上面的示例中可以看有一个磁盘分区，以下命令将删除该分区  
<pre>
[root@node1 ~]# parted /dev/sdc rm 1
信息: 你可能需要 /etc/fstab。
 
[root@node1 ~]# parted /dev/sdc print                                   
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小  文件系统  名称  标志
</pre>

#### 10、恢复磁盘分区
语法格式： 
```bash
parted 磁盘名称 rescue 起始点 结束点
```
用法示例：在上面两个示例中分别可以磁盘分区的起始点和结束点，并成功地删除了该分区，以下命令将恢复该分区（该分区在删除前要求格式化）  
<pre>
[root@node1 ~]# parted /dev/sdc rescue 1049kB 3000MB
信息: 在 1049kB -> 3000MB 处找到一个 ext4 primary 分区。您希望将其添加到分区表中吗？
是/Yes/否/No/放弃/Cancel? Yes                                             
信息: 你可能需要 /etc/fstab。
 
[root@node1 ~]# parted /dev/sdc print
型号：VMware, VMware Virtual S (scsi)
磁盘 /dev/sdc：10.7GB
扇区大小 (逻辑/物理)：512B/512B
分区表：gpt
磁盘标志：
 
编号  起始点  结束点  大小    文件系统  名称  标志
 1    1049kB  3000MB  2999MB  ext4
</pre>
