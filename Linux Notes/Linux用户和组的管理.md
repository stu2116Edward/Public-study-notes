# Linux用户和组管理学习笔记


## Linux操作系统简介
Linux是一个多用户、多任务的操作系统，它支持多个用户同时登录系统并使用系统资源。在Linux系统中，用户账户分为两种类型：普通用户账户和超级管理员用户账户（root）。普通用户仅能进行普通工作，且只能操作自己拥有或有权限执行的文件。而超级管理员用户则能够对普通用户和整个系统进行管理，拥有绝对的控制权  
在安装操作系统时，除了创建root用户外，通常还会创建至少一个普通用户账户  

## 用户和组的基本概念
以下是Linux系统中用户和组的一些基本概念：  

- **用户名**：用来识别用户的名称，可以包含字母、数字，并且区分大小写。
- **密码**：用于验证用户身份的特殊验证码。
- **用户标识（UID）**：用来表示用户的数字标识符。
- **用户主目录**：用户的私人目录，也是用户登录系统后默认所在的目录。
- **登录Shell**：用户登录后默认使用的Shell程序，默认通常是`/bin/bash`。
- **组**：具有相同属性的用户属于同一个组。
- **组标识（GID）**：用来表示组的数字标识符。

## UID和GID的范围
在不同的Linux发行版中，UID和GID的分配范围可能有所不同：  

- **CentOS 7**：UID范围是0-60000，其中0是超级管理员，1-999是程序用户，1000-60000是普通用户。如果不指定UID，默认从1000开始编号。
- **CentOS 6**：UID范围也是0-60000，其中0是超级管理员，1-499是程序用户，500-60000是普通用户。


## 理解用户账户文件和组文件

### 用户账户文件

- **`/etc/passwd`**：存放用户信息，每行代表一个用户，包含`7个字段`，用冒号(`:`)分隔。

| 字段 | 描述 |
| --- | --- |
| 用户名 | 用户的登录名 |
| 加密口令 | 加密后的密码，通常为`x`表示密码存在`/etc/shadow`中 |
| UID | 用户标识号 |
| GID | 用户所属组的标识号 |
| 用户描述信息 | 用户的描述信息，通常为全名 |
| 主目录 | 用户的主目录路径 |
| 命令解释器 | 用户登录后默认使用的Shell程序 |

<pre>
用户名:加密口令:UID:GID:用户描述信息：主目录：命令解释器
</pre>
示例：
<pre>
root:x:0:0:root:/root:/bin/bash
</pre>
- **`/etc/shadow`**：存放用户加密后的密码，只对root用户可读，包含`9个字段`，字段之间用冒号(`:`)分隔。  

| 字段 | 描述 |
| --- | --- |
| 登录名 | 用户的登录名 |
| 加密口令 | 加密后的密码，`*`表示用户不能登录，`!!`或`!`表示密码锁定 |
| 最后一次修改时间 | 从1970年1月1日起至密码最后一次修改的天数 |
| 最小时间间隔 | 用户修改密码的最小时间间隔 |
| 最大时间间隔 | 密码的最大有效天数 |
| 警告时间 | 密码过期前警告用户的天数 |
| 不活动时间 | 密码过期后账户被禁用前的天数 |
| 失效时间 | 账户失效的绝对时间（从1970年1月1日起的天数） |
| 标志 | 保留字段，用于未来扩展 |

<pre>
登录名:加密口令:最后一次修改时间:最小时间间隔:最大时间间隔:警告时间:不活动时间:失效时间:标志
</pre>
示例：
<pre>
root:$6$416.9S5...:17399:0:99999:7::: 
</pre>

### 组文件

- **`/etc/group`**：存放组账户信息，每行分为`4个段`，用冒号(`:`)分隔。

| 字段 | 描述 |
| --- | --- |
| 组名称 | 组的名称 |
| 组口令 | 组的加密密码，通常为空或`x` |
| GID | 组的标识号 |
| 成员列表 | 属于该组的用户列表，多个用户用逗号分隔 |

<pre>
组名称：组口令(一般为空，用x占位)：GID：组成员列表
</pre>
示例：
<pre>
root:x:0:
</pre>

- **`/etc/gshadow`**：存放组的加密口令、组管理员等信息，只对root用户可读。每条记录包含`4个字段`，字段之间用冒号(`:`)分隔。  

| 字段 | 描述 |
| --- | --- |
| 组名称 | 组的名称 |
| 加密后的组口令 | 加密后的组密码，没有则为`!` |
| 组的管理员 | 可以管理该组的用户列表 |
| 成员列表 | 属于该组的用户列表 |

<pre>
组名称：加密后的组口令(没有就!)：组的管理员：组成员列表
</pre>
示例：
<pre>
root:::
</pre>

## 管理用户账户

### 新建用户`useradd`
语法：
```bash
useradd [选项] 用户名
```
创建新用户时，useradd命令会根据提供的选项自动建立一个同名的基本组，并在/home下自动创建一个同名的家目录  
- 基本组：每个用户必须有一个基本组，只能有一个
- 附加组：用户可以有多个附加组，如果没有指定，则用户只有基本组

- 选项及解释：

| 选项 | 解释 |
| --- | --- |
| `-u` | 指定用户UID |
| `-s` | 指定的登录shell类型 |
| `-M` | 不建立主目录 |
| `-d` | 指定主目录位置，可以是不存在的目录 |
| `-e` | 格式为`YYYY-MM-DD`，禁用账户的日期 |
| `-g` | 指定基本组 |
| `-p` | 设置密码 |
| `-G` | 指定附加组 |
| `-r` | 随机生成一个UID 1-999的用户，并且不建立家目录 |
| `-c` | 添加备注信息 |

示例操作:  
#### -u 指定用户UID
在Linux系统中，每个用户账户都被分配了一个唯一的用户标识符（UID），这是一个数字。使用 useradd 命令创建新用户时，可以通过 -u 选项指定这个UID  

创建用户 user1（默认UID）：  
不加选项会默认从1000编号  
```bash
useradd user1
tail -1 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
```
创建用户 user2 并指定UID为1010
```bash
useradd -u 1010 user2
tail -2 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
user2:x:1010:1010::/home/user2:/bin/bash
```

#### -s 指定登录shell类型
在Linux系统中，每个用户都可以有一个默认的登录Shell，这是一个用户用来与系统交互的命令行解释器。使用 useradd 命令创建新用户时，可以通过 -s 选项指定用户的登录Shell  

创建用户 user1（默认Shell）
```bash
useradd user1
tail -1 /etc/passwd
```
输出：  
默认是/bin/bash
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
```
创建用户 user2 并指定登录Shell为 /bin/false
```bash
useradd -s /bin/false user2
tail -2 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
user2:x:1002:1002::/home/user2:/bin/false
```

#### -M 不建立主目录
当使用 useradd 命令创建新用户时，如果不加 -M 选项，系统会自动为新用户创建一个与其用户名相同的主目录，在 /home 下  
查看 /home 目录下的文件：  
```bash
ls /home
```
输出：
```plaintext
custom
```
创建用户 user1（自动创建主目录）：
```bash
useradd user1
tail -1 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
```
再次查看 /home 目录下的文件：
```bash
ls /home
```
输出：
```plaintext
custom  user1
```
创建用户 user2 并使用 -M 选项（不创建主目录）：
```bash
useradd -M user2
tail -2 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
user2:x:1002:1002::/home/user2:/bin/bash
```
查看 /home 目录下的文件：
```bash
ls /home
```
输出：
```plaintext
custom  user1
```

#### -d 指定主目录位置
在使用 useradd 命令创建新用户时，-d 选项允许您指定用户的主目录位置。这可以是一个已存在的目录，也可以是一个您希望为用户创建的新目录  
创建用户 user1（默认主目录）  
```bash
useradd user1
tail -1 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
```
默认情况下，user1 的主目录被创建在 /home/user1  
创建用户 user2 并指定主目录为 /home/Linux：  
```bash
useradd -d /home/Linux user2
tail -2 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
user2:x:1002:1002::/home/Linux:/bin/bash
```
再次查看 /home 目录下的文件：
```bash
ls /home
```
输出：
```plaintext
Linux custom user1
```

#### -e 格式为YYYY-MM-DD，禁用账户的日期
在Linux系统中，可以通过useradd命令的-e选项来设置账户的过期日期。这个选项允许系统管理员指定一个日期，账户将在该日期之后被禁用  

创建用户 user1
```bash
useradd user1
tail -1 /etc/shadow
```
输出：
```plaintext
user1:!!:19820:0:99999:7:::
```
默认情况下，账户没有设置过期日期  
创建用户 user2 并设置账户在2024-04-20后禁用  
```bash
useradd -e 2024-04-20 user2
tail -2 /etc/shadow
```
输出：
```plaintext
user1:!!:19820:0:99999:7:::
user2:!!:19820:0:99999:7::19833:
```
user2 的账户被设置为在2024-04-20之后禁用，这是通过计算从1970-01-01起的天数（19833天）来实现的  
计算日期  
从1970-01-01起算，过19833天后确实是2024-04-20  

#### -g 指定基本组
在Linux系统中，每个用户都必须属于至少一个组，这个组被称为基本组或主组。使用 useradd 命令创建用户时，可以通过 -g 选项指定用户的基本组  
查看已存在的组  
```bash
tail -1 /etc/group
```
输出:
```plaintext
group1:x:3001:
```
这里显示了一个已存在的组 group1，其组标识符（GID）为3001  
创建用户 user1（默认基本组）：  
```bash
useradd user1
tail -1 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
```
组ID，默认按顺序是1001  
不加 -g 选项时，系统会自动为用户分配一个基本组，组ID通常与用户的UID相同  
创建用户 user2 并指定基本组为 group1（GID 3001）：  
```bash
useradd -g 3001 user2
tail -2 /etc/passwd
```
输出：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
user2:x:1002:3001::/home/user2:/bin/bash
```


### 删除用户userdel
在Linux系统中，userdel 命令用于删除用户账户。默认情况下，删除用户账户时不会删除用户的家目录和邮件目录，只会从系统账户文件中移除用户记录  
语法：  
```
userdel [选项] 用户名 
```
`-r`：连同用户的家目录一起删除  
查看 /home 目录下的文件  
```bash
ls /home
```
输出：
```plaintext
custom user1 user2 user3
```
此时，/home 下有 user1、user2 和 user3 的主目录  
删除用户 user3（不加选项）:  
```bash
userdel user3
ls /home
```
输出：
```plaintext
custom user1 user2 user3
```
不加 -r 选项时，user3 的家目录仍然保留在 /home 下  
删除用户 user2 并同时删除其家目录：  
```bash
userdel -r user2
ls /home
```
输出：
```plaintext
custom user1 user3
```
使用 `-r` 选项后，user2 的家目录被一并删除,此时 `/home` 下已经没有 user2 的主目录了  


### 设置用户账户口令
**passwd命令**

| 选项 | 说明 |
| --- | --- |
| `-l` | 锁定用户账户 |
| `-u` | 口令解锁 |
| `-d` | 将用户口令设置为空（可以登录系统），与未设置口令不同（无法登录系统） |

设置用户密码  
在Linux系统中，可以使用 useradd 命令配合 -p 选项来设置新用户的初始密码。以下是具体操作  
```bash
useradd -p 123456 user1   # 设置密码123456的用户user1
```
更改用户密码
```bash
passwd user1    # root用户更改user1的密码
```
也可以使用sudo passwd <username>  
系统会提示输入新的密码，并要求再次输入以确认

锁定用户账户  
要锁定用户账户，禁止用户登录，可以使用 passwd 命令配合 -l 选项：  
```bash
passwd -l user1
```
输出结果表明用户密码已被锁定：
<pre>
锁定用户 user1 的密码
passwd: 操作成功
</pre>
解锁用户账户  
要解锁用户账户，允许用户登录，可以使用 passwd 命令配合 -u 选项：  
```bash
passwd -uf user1
```
输出结果表明用户密码解锁成功：
<pre>
解锁用户 user1 的密码
passwd: 操作成功
</pre>


#### 修改用户账户
语法：
```
usermod [选项] 用户名
```
创建用户 user1 和 user2
```bash
useradd user1
useradd user2
```
查看创建的用户  
查看 /etc/passwd 文件的最后两行，确认用户已被创建：  
```bash
tail -2 /etc/passwd
```
输出结果：
```plaintext
user1:x:1001:1001::/home/user1:/bin/bash
user2:x:1002:1002::/home/user2:/bin/bash
```
创建组 group1 并指定组ID为3001：
```bash
groupadd group1 -g 3001
```
查看创建的组：  
查看 /etc/group 文件的最后三行，确认组已被创建：
```bash
tail -3 /etc/group
```
输出结果：
```plaintext
user1:x:1001:
user2:x:1002:
group1:x:3001:
```

#### -g 变更所属用户组(基本组)
使用 usermod 命令变更用户的基本组（GID）
```bash
usermod -g 1002 user1
```
查看 /etc/passwd 文件确认变更
```bash
tail -2 /etc/passwd
```
输出结果：
```plaintext
user1:x:1001:1002::/home/user1:/bin/bash
user2:x:1002:1002::/home/user2:/bin/bash
```

#### -G 变更附加组
使用 usermod 命令将用户添加到附加组
```bash
usermod -G group1 user1
```
查看 /etc/group 文件确认变更：
```bash
tail -3 /etc/group
```
输出结果：
```plaintext
user1:x:1001:
user2:x:1002:
group1:x:3001:user1
```
使用 id 命令查看用户所属组：
```bash
id user1
```
输出结果：
```plaintext
uid=1001(user1) gid=1001(user1) 组=1001(user1),3001(group1)
```

#### -u 指定UID
使用 usermod 命令指定用户的UID
```bash
usermod -u 1011 user1
```
查看 /etc/passwd 文件确认变更：
```bash
tail -2 /etc/passwd
```
输出结果：
```plaintext
user1:x:1011:1001::/home/user1:/bin/bash
user2:x:1002:1002::/home/user2:/bin/bash
```

#### -s 指定登录的shell类型
使用 usermod 命令指定用户的登录Shell
```bash
usermod -s /sbin/nologin user1
```
查看 /etc/passwd 文件确认变更：
```bash
tail -2 /etc/passwd
```
输出结果：
```plaintext
user1:x:1011:1001::/home/user1:/sbin/nologin
user2:x:1002:1002::/home/user2:/bin/bash
```

#### 锁定和解锁用户
`-L锁定用户`,`-U解锁用户`(用户要有密码)可先通过`usermod -p 12345678 user1`设置密码  
锁定用户  
```bash
usermod -L user1
```
使用 passwd 命令查看用户是否被锁定：
```bash
passwd -S user1
```
输出结果：
```plaintext
user1 LK 2024-04-07 0 99999 7 -1 (密码已被锁定。)
```
解锁用户
```bash
usermod -U user1
```
使用 passwd 命令查看用户是否已解锁：
```bash
passwd -S user1
```
输出结果：
```plaintext
user1 PS 2024-04-07 0 99999 7 -1 (更改当前使用的认证方案。)
```


## 管理组
### 创建组
使用 groupadd 命令创建新组  
语法：
```
groupadd [选项] 组名
```
- -g 指定组ID

创建组 group1（自动分配组ID）：
```bash
groupadd group1
tail -1 /etc/group
```
输出：
```plaintext
group1:x:1001:
```
创建组 group2 并指定组ID为1999：
```bash
groupadd -g 1999 group2
tail -2 /etc/group
```
输出：
```plaintext
group1:x:1001:
group2:x:1999:
```

### 删除组
使用 groupdel 命令删除已存在的组  
语法：
```
groupdel 组名
```
删除组 group2：
```bash
groupdel group2
tail -2 /etc/group
```
输出：
```plaintext
custom:x:1000:custom
group1:x:1001:
```

### 修改组
使用 groupmod 命令修改组属性  
语法：
```
groupmod [选项] 组名
```
- -g：修改组ID。
- -n：修改组名称。
- -o：强制修改，即使组不存在

修改组ID
```bash
groupmod -g <新组ID> <组名>
```
查看修改前的组ID：
```bash
tail -1 /etc/group
```
输出：
```plaintext
group1:x:1001:
```
修改组ID为1010：
```bash
groupmod -g 1010 group1
```
查看修改后的组ID：
```bash
tail -1 /etc/group
```
输出：
```plaintext
group1:x:1010:
```
修改组名称
```bash
groupmod -n <新组名称> <组名>
```
查看修改前的组名称：
```bash
tail -1 /etc/group
```
输出：
```plaintext
group1:x:1010:
```
修改组名称为GROUP1：
```bash
groupmod -n GROUP1 group1
```
查看修改后的组名称：
```bash
tail -1 /etc/group
```
输出：
```plaintext
GROUP1:x:1010:
```
强制修改组
```bash
groupmod -o <组名>
```
此选项用于在组不存在时仍然进行修改，但通常需要配合其他选项使用


### 为组添加用户
`gpasswd` 命令用于管理组密码和组用户  
- -a：将用户添加到组中
- -d：将用户从组中删除

将用户添加到组中
```bash
gpasswd -a <用户名> <组名>
```
查看添加前的用户组信息：
```bash
tail -2 /etc/group
```
输出：
```plaintext
GROUP1:x:1010:
user1:x:1001:
```
将 user1 添加到 GROUP1：
```bash
gpasswd -a user1 GROUP1
```
查看添加后的用户组信息：
```bash
tail -2 /etc/group
```
输出：
```plaintext
GROUP1:x:1010:user1
user1:x:1001:
```
将用户从组中删除
```bash
gpasswd -d <用户名> <组名>
```
查看删除前的用户组信息：
```bash
tail -2 /etc/group
```
输出：
```plaintext
GROUP1:x:1010:user1
user1:x:1001:
```
将 user1 从 GROUP1 删除：
```bash
gpasswd -d user1 GROUP1
```
查看删除后的用户组信息：
```bash
tail -2 /etc/group
```
输出：
```plaintext
GROUP1:x:1010:
user1:x:1001:
```
注意事项:  
- usermod 和 gpasswd 都可以用于将用户添加到组中或从组中删除用户
- usermod 是操作用户，像是把用户推到组中去
- gpasswd 是操作组，像是把用户拉到组中来
