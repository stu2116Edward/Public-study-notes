# Git命令的使用教程

Git的安装Windows：https://blog.csdn.net/mukes/article/details/115693833
Ubuntu安装Git:
```
sudo apt-get install git
```

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
