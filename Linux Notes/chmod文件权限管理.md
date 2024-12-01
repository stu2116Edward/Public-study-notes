# chmod文件权限管理

![file-permissions-rwx](https://github.com/user-attachments/assets/d37ff0df-afe3-4369-b2fa-7d7c5dc6fc77)  
![rwx-standard-unix-permission-bits](https://github.com/user-attachments/assets/e88795b4-c720-4938-b794-0deba810df4d)  

## 符号模式
| 标识符 | 用户类型 | 说明         |
|--------|----------|------------|
| u      | user     | 文件所有者   |
| g      | group    | 文件所有者所在组 |
| o      | others   | 所有其他用户   |
| a      | all      | 所有用户, 相当于 ugo |


| Operator | 说明                             |
|----------|----------------------------------|
| +        | 为指定的用户类型增加权限           |
| -        | 去除指定用户类型的权限           |
| =        | 设置指定用户权限的设置，即将用户类型的所有权限重新设置 |

| 模式 | 名字   | 说明                                                         |
|------|--------|--------------------------------------------------------------|
| r    | 读     | 设置为可读权限                                               |
| w    | 写     | 设置为可写权限                                               |
| x    | 执行权限 | 设置为可执行权限                                             |
| X    | 特殊执行权限 | 只有当文件为目录文件，或者其他类型的用户有可执行权限时，才将文件权限设置可执行 |
| s    | setuid/gid | 当文件被执行时，根据who参数指定的用户类型设置文件的setuid或者setgid权限 |
| t    | 粘贴位 | 设置粘贴位，只有超级用户可以设置该位，只有文件所有者u可以使用该位   |

## 数字表示
| # | 权限       | rwx | 二进制 |
|---|------------|-----|-------|
| 7 | 读 + 写 + 执行 | rwx | 111   |
| 6 | 读 + 写     | rw- | 110   |
| 5 | 读 + 执行   | r-x | 101   |
| 4 | 只读       | r-- | 100   |
| 3 | 写 + 执行   | -wx | 011   |
| 2 | 只写       | -w- | 010   |
| 1 | 只执行     | --x | 001   |
| 0 | 无         | --- | 000   |


# 常用示例
| 权限设置                                   | 符号模式命令                           | 数字模式命令    |
|-------------------------------------------|---------------------------------------|--------------|
| 设置所有者可读写执行，组和其他用户可读执行 | `chmod u=rwx,g=rx,o=rx file.txt`       | `chmod 755 file.txt` |
| 设置所有者可读写，组和其他用户可读         | `chmod u=rw,g=r,o=r file.txt`         | `chmod 644 file.txt` |
| 给文件所有者增加读权限                     | `chmod u+r file.txt`                  | `chmod 400 file.txt` (增加读权限后) |
| 给目录的所属组增加写权限                   | `chmod g+w directory`                 | `chmod 774 directory` |
| 给其他用户增加对文件的执行权限               | `chmod o+x file.txt`                  | `chmod 755 file.txt` |
| 移除所有用户对文件的读、写和执行权限         | `chmod a-rwx file.txt`                | `chmod 000 file.txt` |
| 设置文件所有者具有读、写和执行权限           | `chmod u=rwx file.txt`                | `chmod 700 file.txt` |
| 设置文件的所属组只有读权限                 | `chmod g=r file.txt`                  | `chmod 640 file.txt` |
| 移除其他用户对文件的所有权限                 | `chmod o= file.txt`                   | `chmod 750 file.txt` (移除后) |
