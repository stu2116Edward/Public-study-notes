# linux解决编码问题

***解决有些编码会导致无法在linux中运行bash脚本的解决方案***

查看文件的编码格式：
```bash
file -i 文件名称
```

linux GBK编码转UTF-8：
- 不覆盖源文件
```bash
iconv -f GBK -t UTF-8 文件名称 -o 新文件名称
```
- 覆盖源文件
```bash
iconv -f GBK -t UTF-8 文件名称 -o 文件名称
```

dos2unix:
- 在 Debian/Ubuntu 系统上：
```bash
sudo apt install dos2unix
```
- 在 CentOS/RHEL 系统上：
```bash
sudo yum install dos2unix
```
- 不覆盖源文件
```bash
dos2unix 文件名称 新文件名称
```
- 覆盖源文件
```bash
dos2unix 文件名称
```
