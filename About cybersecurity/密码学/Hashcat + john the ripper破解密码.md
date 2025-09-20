# Hashcat + john the ripper破解密码

## 针对**RAR**密码的命令：
1. 获取hash值
```
rar2john.exe xxx.rar
```
2. 使用掩码攻击破解
```
hashcat.exe -m 13000 -w 4 -a 3 -o password.txt $rar5$16$a072ecbd885426feb1b3167b16c3cbb0$15$0ca39f35e5466619c29ec3ad57790562$8$a86b7ce20e2b6fd6 ?a?a?a?a
```

参数说明：  
- `-m` 指定要破解的hash类型，如果不指定类型，默认是MD5
- `-a` 指定攻击模式编号，其值参考下面对参数
  - `0` 字典攻击
  - `1` 组合攻击
  - `3` 掩码攻击
- `?a?a?a?a` 表示破解 4 位密码，每位可以是任意字符, 掩码规则如下：
  - `?a` 表示任何字符（大小写字母 + 数字 + 特殊符号）
  - `?l` 小写字母
  - `?u` 大写字母
  - `?d` 数字
  - `?s` 特殊符号
- `-o` 指定破解成功后的hash及所对应的明文密码的存放位置
- `-w` 表示使用最高强度的资源配置，以加快破解速度
  - `1` Low
  - `2` Medium
  - `3` High
  - `4` Nightmare（极高负载）


tips: 可以在(hashcat官网)[https://hashcat.net/wiki/doku.php?id=example_hashes]查询hash类型


## 针对**Zip**密码的命令：  
1. 获取zip加密文件的Hash指令：
```
zip2john.exe test.zip
```
所得Hash返回结果
<pre>
test.zip/test.txt:$pkzip2$1*1*2*0*15*9*4aac42f3*0*26*0*15*4aac*470b*6fa72c2bc69e5738181cb7f406187f8084ce07cf5f*$/pkzip2$:test.txt:test.zip::test.zip
</pre>

2. Hashcat 字典攻击破解对应hash
```
hashcat -a 0 -m 17210 $pkzip2$1*1*2*0*15*9*4aac42f3*0*26*0*15*4aac*470b*6fa72c2bc69e5738181cb7f406187f8084ce07cf5f*$/pkzip2$ password.txt --force
```
`password.txt`中存放用于暴力破解的密码字典


## 针对**Word**密码的命令：  
获取word加密文件的Hash指令(此处需要安装python并配置环境变量)
```
python office2john.py test.docx                 
```
所得 Hash 返回结果：
<pre>
test.docx:$office$*2013*100000*256*16*561f4dcaaac333e7c06d150f9ea5aea2*ef4e7b026217124561ecb865b324eac4*e9ef4a859f2c81581db0e27d9ce48e6451b82cd1641941e8adc10dc5600969cb
</pre>
Hashcat 破解对应hash：
```
hashcat.exe -m 9600 -a 3 $office$*2013*100000*256*16*561f4dcaaac333e7c06d150f9ea5aea2*ef4e7b026217124561ecb865b324eac4*e9ef4a859f2c81581db0e27d9ce48e6451b82cd1641941e8adc10dc5600969cb ?d?d?d?d -o out.txt
```


## 针对**PDF**密码的命令：  
获取pdf加密文件的Hash指令(此处需要安装perl并配置环境变量)
```
perl pdf2john.pl test.pdf
```
所得 Hash 返回结果
<pre>
test.pdf:$pdf$4*4*128*-3904*0*16*55f913d20e34724fd70d3004f5e43166*32*7a29310ea5dc0276d34c1bef24595d61984a08eb759eaba56bd4887a260bbcce*32*de0c200bbe6887a980dc429edbdabc40f39a368841d804afefa726b2bd7c7b24
</pre>
Hashcat 破解对应hash，此处?l对应一个小写字母：
```
hashcat.exe -m 10500 -a 3 $pdf$4*4*128*-3904*0*16*55f913d20e34724fd70d3004f5e43166*32*7a29310ea5dc0276d34c1bef24595d61984a08eb759eaba56bd4887a260bbcce*32*de0c200bbe6887a980dc429edbdabc40f39a368841d804afefa726b2bd7c7b24 ?l?l?l?l?l?l -o out.txt
```


提醒：运行John the Ripper需要安装python和perl环境变量，如果命令出错，请自行下载安装python和perl  

perl：http://www.activestate.com/activeperl  
python：https://www.python.org
