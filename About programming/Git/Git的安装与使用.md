# Git的安装与使用

## Git的安装
**Windows中安装Git**：
https://blog.csdn.net/mukes/article/details/115693833  

**Ubuntu中安装Git**:
```
sudo apt-get install git
```

**CentOS中安装Git**:
1. 使用包管理器安装 Git
步骤 1：更新系统包  
在安装 Git 之前，建议先更新系统包：
```bash
sudo yum update
```
步骤 2：安装 Git  
在 CentOS 7 中，使用 `yum` 安装 Git：
```bash
sudo yum install git
```
在 CentOS 8 中，建议使用 `dnf`（`dnf` 是 `yum` 的替代品，性能更好）：  
```bash
sudo dnf install git
```
步骤 3：验证安装  
安装完成后，验证 Git 是否安装成功：
```bash
git --version
```
如果安装成功，你会看到类似以下的输出：
```
git version 2.24.3 (CentOS 8)
```

2. 从源码编译安装 Git
如果系统自带的 Git 版本较旧，或者你需要安装最新版本的 Git，可以使用源码编译的方式安装  
步骤 1：安装编译依赖  
在编译 Git 之前，需要安装一些必要的开发工具和库：
```bash
sudo yum groupinstall "Development Tools"
sudo yum install zlib-devel openssl-devel perl-ExtUtils-MakeMaker asciidoc xmlto docbook2X
```
步骤 2：下载 Git 源码  
从 Git 的官方网站下载最新版本的源码。例如，下载 Git 2.41.0：
```bash
wget https://www.kernel.org/pub/software/scm/git/git-2.41.0.tar.gz
```
步骤 3：解压并编译  
解压下载的文件，并进入解压后的目录：
```bash
tar -zxvf git-2.41.0.tar.gz
cd git-2.41.0
```
编译并安装 Git：
```bash
make configure
./configure --prefix=/usr/local
make all
sudo make install
```
步骤 4：验证安装  
安装完成后，验证 Git 是否安装成功：
```bash
git --version
```
如果安装成功，你会看到类似以下的输出：
```
git version 2.41.0
```

3. 配置 Git
安装完成后，建议配置 Git 的全局用户名和邮箱。这将用于提交时的标识：
```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

4. 卸载 Git
如果需要卸载 Git，可以使用以下命令：  
卸载通过包管理器安装的 Git
```bash
sudo yum remove git
```

卸载通过源码编译安装的 Git  
如果 Git 是通过源码编译安装的，需要手动删除相关文件：
```bash
sudo rm /usr/local/bin/git
sudo rm -rf /usr/local/libexec/git-core
```

## Git命令的使用教程
### Git 仓库的创建
初始化一个新的 Git 仓库
```
git init
```
克隆一个远程仓库到本地
```
git clone <url>
```
查看仓库配置
```
git config --list
```
查看仓库信息
```
git remote -v
```

### Git 基本命令
设置全局用户名
```
git config --global user.name '用户名'
```
设置全局邮箱
```
git config --global user.email '邮箱'
```
将文件添加到暂存区
```
git add <file>
```
查看文件状态
```
git status
```
查看文件的具体差异
```
git diff
```
提交暂存区文件到仓库
```
git commit -m "提交信息"
```
取消暂存区文件的暂存状态
```
git reset HEAD <file>
```
删除文件
```
git rm <file>
```
移动或重命名文件
```
git mv <old_name> <new_name>
```
查看暂存区文件
```
git diff --cached
```
查看所有变更（包括未暂存的文件）
```
git diff HEAD
```
提交时指定作者信息
```
git commit --author="Author Name <email@example.com>" -m "提交信息"
```


### Git 分支管理
查看本地分支，或创建新分支
```
git branch
```
列出所有远程分支
```
git branch -r
```
列出所有分支（包括远程分支）
```
git branch -a
```
切换到指定分支
```
git checkout <branch>
```
创建新分支并切换到该分支
```
git checkout -b <branch>
```
将指定分支合并到当前分支
```
git merge <branch>
```
将指定分支合并到当前分支，禁用快进合并
```
git merge <branch> --no-ff
```
删除分支
```
git branch -d <branch>
```
合并分支时的冲突解决
```
git add <resolved_file>
git commit
```
或者使用 --continue 标志完成合并
```
git merge --continue
```

### Git 查看提交历史
查看提交历史
```
git log
```
查看某个文件的提交历史
```
git log -- <file>
```
简洁形式查看提交历史
```
git log --oneline
```
查看分支和合并的历史
```
git log --graph
```
查找指定作者的提交日志
```
git log --author <author>
```

### Git 标签
创建带注解的标签
```
git tag -a <tagname> -m "标签信息"
```
删除标签
```
git tag -d <tagname>
```
推送标签到远程仓库
```
git push <alias> <tagname>
```
或者推送所有标签
```
git push <alias> --tags
```
查看所有标签
```
git tag
```
创建带PGP签名的标签
```
git tag -s <tagname> -m "标签信息"
```

### Git 远程仓库
添加远程仓库
```
git remote add <alias> <url>
```
查看远程仓库
```
git remote
```
从远程仓库获取数据
```
git fetch <alias>
```
从远程仓库拉取数据并合并
```
git pull <alias> <branch>
```
推送数据到远程仓库
```
git push <alias> <branch>
```
删除远程仓库
```
git remote rm <alias>
```
更改远程仓库的 URL
```
git remote set-url <alias> <new_url>
```
从远程仓库拉取特定分支
```
git fetch <alias> <branch>:<local_branch>
```

### 其他常用命令
查看 Git 版本
```
git --version
```
检查 Git 仓库的完整性
```
git fsck-objects --full
```
临时保存当前工作进度
```
git stash
```
恢复最近的 stash
```
git stash pop
```
查看所有 stash
```
git stash list
```
将 HEAD、索引和工作目录都回退到某次提交
```
git reset --hard <commit>
```
清除未跟踪的文件
```
git clean
```
查看所有引用的日志
```
git reflog
```
解决合并冲突
```
git mergetool
```
